#!/usr/bin/env python3
"""One-shot prompt injection scanner using ONNX runtime.

Reads text from stdin, classifies it using ProtectAI's DeBERTa model,
and exits with code 1 if injection detected, 0 if clean.

Uses chunked scanning: splits text into overlapping windows so injection
buried beyond the model's 512-token limit is still detected.
"""

import sys

import numpy as np
import onnxruntime as ort
from transformers import AutoTokenizer

MODEL_NAME = "ProtectAI/deberta-v3-small-prompt-injection-v2"
THRESHOLD = 0.5
CHUNK_SIZE = 256
CHUNK_OVERLAP = 25

text = sys.stdin.read().strip()
if not text:
    sys.exit(0)

# Read HF token from SOPS secret (never in env vars)
token = None
try:
    with open("/run/secrets/hf-token-scan-injection") as f:
        token = f.read().strip()
except FileNotFoundError:
    pass

tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME, token=token)

try:
    from huggingface_hub import hf_hub_download

    model_path = hf_hub_download(MODEL_NAME, "onnx/model.onnx", token=token)
except Exception:
    sys.exit(0)

session = ort.InferenceSession(model_path)


def score_text(chunk: str) -> float:
    inputs = tokenizer(chunk, truncation=True, max_length=512, return_tensors="np")
    feeds = {
        "input_ids": inputs["input_ids"].astype(np.int64),
        "attention_mask": inputs["attention_mask"].astype(np.int64),
    }
    outputs = session.run(None, feeds)
    logits = outputs[0][0]
    exp = np.exp(logits - np.max(logits))
    probs = exp / exp.sum()
    return float(probs[1])  # label 1 = INJECTION


# Short text: single pass (no chunking overhead)
if len(text) <= CHUNK_SIZE:
    if score_text(text) >= THRESHOLD:
        sys.exit(1)
    sys.exit(0)

# Long text: sliding window with overlap, take max score
# Also check head+tail to catch injection appended at the end
max_score = 0.0
step = CHUNK_SIZE - CHUNK_OVERLAP

for start in range(0, len(text), step):
    chunk = text[start : start + CHUNK_SIZE]
    if not chunk.strip():
        continue
    score = score_text(chunk)
    max_score = max(max_score, score)
    if max_score >= THRESHOLD:
        sys.exit(1)

# Head+tail check: first 512 chars + last 512 chars
# Catches injection at the very end that chunk boundaries might split
if len(text) > 1024:
    head_tail = text[:512] + " " + text[-512:]
    max_score = max(max_score, score_text(head_tail))

if max_score >= THRESHOLD:
    sys.exit(1)

sys.exit(0)
