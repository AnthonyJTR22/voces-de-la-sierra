---

## 🔧 Technical Specifications

| Component | Details |
|-----------|---------|
| **Base Model** | Google Gemma 4 E2B-it (5.1B params, 4-bit quantized) |
| **Fine-tuning** | QLoRA via Unsloth · r=8, alpha=8, dropout=0 · 14.9M trainable params (0.29%) |
| **Dataset** | 67,288 examples from 20,028 Esp↔Náh pairs (Axolotl + Bible UEDIN corpus) |
| **Training** | 10,000 steps · Google Colab T4 free tier · Checkpoint persistence via Drive |
| **Min Loss** | 0.0368 (step 8,574) · Final avg ~0.20 (last 1,000 steps) |
| **Inference** | llama.cpp server · 100% offline · ~2GB total · Web UI |
| **Export** | LoRA GGUF (23MB) + Base GGUF Q4_K_M (1.8GB) |

---

## 🚀 Quick Start

### Option A: One-Click Windows (recommended for demo)

1. Download [llama.cpp release](https://github.com/ggml-org/llama.cpp/releases) for Windows (CPU version)
2. Copy all `.dll` files from the llama.cpp folder into your working folder
3. Download the [base model GGUF](https://huggingface.co/bartowski/google_gemma-4-E2B-it-GGUF) (~1.8GB)
4. Download the [LoRA adapter](https://drive.google.com/file/d/1OZmlRNr12vuHwJ8uLVuBV_3-PnkTlcGr/view?usp=sharing) (23MB)
5. Place all files in the same folder with `run_server.bat`
6. Double-click **`run_server.bat`**
7. Open **http://localhost:8080** in your browser

### Option B: Command Line

```bash
llama-server -m google_gemma-4-E2B-it-Q4_K_M.gguf \
  --lora voces_sierra_lora_v2.gguf \
  --chat-template gemma \
  --port 8080
```

### Option C: Reproduce Training (Google Colab)

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/18bfAb1piftFa2cS3eLmpgWO2jycBc6C3)

---

## 📦 Models

| File | Size | Description | Download |
|------|------|-------------|----------|
| `google_gemma-4-E2B-it-Q4_K_M.gguf` | ~1.8 GB | Base model (Gemma 4 E2B quantized) | [HuggingFace](https://huggingface.co/bartowski/google_gemma-4-E2B-it-GGUF) |
| `voces_sierra_lora_v2.gguf` | 23 MB | Fine-tuned LoRA adapter (GGUF) | [Google Drive](https://drive.google.com/file/d/1OZmlRNr12vuHwJ8uLVuBV_3-PnkTlcGr/view?usp=sharing) |
| `adapter_model.safetensors` | 46 MB | LoRA adapter (PEFT format, for retraining) | [Google Drive](https://drive.google.com/file/d/1eMsXtk6TdQW2j0FQxqqAwf_1z61iSQ-o/view?usp=sharing) |

---

## 📊 Training Results

Trained for 10,000 steps on Google Colab's free T4 GPU. A checkpoint persistence system saves to Google Drive every 500 steps, enabling training to resume across multiple 5-hour sessions.

| Metric | Value |
|--------|-------|
| Final checkpoint | checkpoint-10004 |
| Steps logged | 10,003 (every 50 steps) |
| Initial loss | 1.1443 (step 1) |
| Min loss | **0.0368** (step 8,574) |
| Final avg loss | ~0.20 (last 1,000 steps) |
| LoRA parameters | 706 total |
| Adapter size | 46.1 MB (safetensors) / 23.1 MB (GGUF) |
| GPU | Tesla T4 (Colab free tier) |
| Training time | ~6 hours across multiple sessions |

![Training Loss Curve](assets/loss_curve.png)

> The spike at step 10,003 (loss 0.65) is a single noisy batch and not representative of model quality.
> The sustained average in the final 2,000 steps is ~0.20, confirming stable convergence.

### Verified Translations (checkpoint-10004)

| Input | Output | Verification |
|-------|--------|--------------|
| "Translate to Náhuatl: water is life" | `inon quipia atl` | ✅ "atl" = water · "quipia" = holds/has |
| "Translate to Spanish: Auh in ye yuhqui" | `Y en verdad que es así` | ✅ Correct translation |
| "How do you say 'family' in Náhuatl?" | `in itechcopa notlajsojcaicnihuan` | ✅ Real Náhuatl morphology |

---

## 🌍 Impact

### Who This Serves

- **Primary:** 1.7M Náhuatl speakers needing Spanish communication (hospitals, markets, government)
- **Secondary:** Bilingual educators in indigenous schools
- **Tertiary:** Linguists, cultural preservation organizations, language learners

### Why Offline Matters

In Mexico's Sierra Norte, Sierra de Oaxaca, and Huasteca regions, internet connectivity ranges from unreliable to nonexistent. Voces de la Sierra runs entirely on-device — **no API calls, no server dependencies, no data leaving the user's hands**. Indigenous communities have historically had their linguistic data extracted without consent. Our system keeps all interactions local.

### Scalability

The pipeline is **language-agnostic**. Mexico alone has **68 indigenous language groups with 364 variants**. Globally, UNESCO estimates **40% of ~6,700 languages are endangered**. Voces de la Sierra provides a replicable template for preserving any of them through accessible AI.

---

## 🛠️ Challenges Solved

| Challenge | Solution |
|-----------|----------|
| Gemma 4 E2B OOM on T4 GPU | Unsloth T4 config: max_seq=1024, r=8, dropout=0 |
| 5-hour Colab session limit | Checkpoint persistence to Google Drive every 500 steps |
| GGUF export fails with bitsandbytes | Custom pipeline: text-only LoRA extraction → tensor renaming → 16-bit base conversion |
| Náhuatl dialectal variation in dataset | Morphological regex validator for -tl, -tzin, -tli morphemes |
| Gemma 4 multimodal tokenizer mismatch | Manual chat template with verified `<start_of_turn>` token strings |
| Unsloth MLX compilation bug | Disabled torch dynamo via `TORCHDYNAMO_DISABLE=1` before any imports |

---

## 🔮 Future Roadmap

1. **Voice Input** — Gemma 4 E2B supports audio natively via USM encoder. When llama.cpp adds audio support, users can speak Náhuatl directly.
2. **Android APK** — Standalone app using llama.cpp Android bindings for direct phone installation on low-end devices.
3. **Expanded Datasets** — Partner with INALI and CIESAS for larger, dialect-labeled corpora.
4. **Multi-language** — Apply the same pipeline to Mixtec, Zapotec, Maya, and other endangered Mexican indigenous languages.

---

## 📁 Repository Structure
