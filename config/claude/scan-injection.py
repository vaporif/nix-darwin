#!/usr/bin/env python3
"""One-shot prompt injection scanner using ONNX runtime.

Reads text from stdin, classifies it using ProtectAI's DeBERTa model,
and exits with code 1 if injection detected, 0 if clean.
"""

import sys

import numpy as np
import onnxruntime as ort
from transformers import AutoTokenizer

MODEL_NAME = "ProtectAI/deberta-v3-small-prompt-injection-v2"
THRESHOLD = 0.5

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
inputs = tokenizer(text, truncation=True, max_length=512, return_tensors="np")

try:
    from huggingface_hub import hf_hub_download

    model_path = hf_hub_download(MODEL_NAME, "onnx/model.onnx", token=token)
except Exception:
    sys.exit(0)

session = ort.InferenceSession(model_path)

feeds = {
    "input_ids": inputs["input_ids"].astype(np.int64),
    "attention_mask": inputs["attention_mask"].astype(np.int64),
}

outputs = session.run(None, feeds)
logits = outputs[0][0]

# softmax
exp = np.exp(logits - np.max(logits))
probs = exp / exp.sum()

# label 1 = INJECTION
injection_score = float(probs[1])

if injection_score >= THRESHOLD:
    sys.exit(1)

sys.exit(0)
