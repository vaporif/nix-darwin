#!/usr/bin/env python3
"""One-shot prompt injection scanner using ONNX runtime.

Reads text from stdin, classifies it using ProtectAI's DeBERTa model,
and exits with code 1 if injection detected, 0 if clean.

Uses ONNX runtime instead of PyTorch for fast cold start (~2-3s).
"""

import sys

from optimum.onnxruntime import ORTModelForSequenceClassification
from transformers import AutoTokenizer, pipeline

MODEL_NAME = "ProtectAI/deberta-v3-small-prompt-injection-v2"
THRESHOLD = 0.5

text = sys.stdin.read().strip()
if not text:
    sys.exit(0)

tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME, subfolder="onnx")
tokenizer.model_input_names = ["input_ids", "attention_mask"]
model = ORTModelForSequenceClassification.from_pretrained(
    MODEL_NAME, export=False, subfolder="onnx"
)

classifier = pipeline(
    "text-classification",
    model=model,
    tokenizer=tokenizer,
    truncation=True,
    max_length=512,
)

result = classifier(text)[0]

if result["label"] == "INJECTION" and result["score"] >= THRESHOLD:
    sys.exit(1)

sys.exit(0)
