<p align="center">
  <h1 align="center">🏔️ Voces de la Sierra</h1>
  <p align="center"><strong>Bridging Languages, Preserving Cultures</strong></p>
  <p align="center">An offline bidirectional translator & cultural teacher for Spanish ↔ Náhuatl</p>
  <p align="center">Powered by Gemma 4 E2B · Fine-tuned with Unsloth · Deployed with llama.cpp</p>
  <p align="center">
    <a href="https://www.kaggle.com/competitions/gemma-4-good-hackathon">Gemma 4 Good Hackathon</a> · Kaggle × Google DeepMind · May 2026
  </p>
  <p align="center">
    <img src="https://img.shields.io/badge/Gemma_4-E2B--it-blue?style=flat-square&logo=google" alt="Gemma 4">
    <img src="https://img.shields.io/badge/Unsloth-QLoRA-green?style=flat-square" alt="Unsloth">
    <img src="https://img.shields.io/badge/llama.cpp-Offline-orange?style=flat-square" alt="llama.cpp">
    <img src="https://img.shields.io/badge/License-Apache_2.0-red?style=flat-square" alt="License">
  </p>
  <p align="center">
    <strong>Tracks:</strong> Digital Equity & Inclusivity · Future of Education
  </p>
</p>

---

## 🎯 The Problem

**1.7 million people speak Náhuatl in Mexico. Zero major translation platforms support their language.**

In the highland markets of Mexico's Sierra Norte, indigenous communities descend daily to interact with a Spanish-speaking world — hospitals, government offices, schools, markets — without any technological bridge for their language. Google Translate, DeepL, and Microsoft Translator do not support Náhuatl.

These communities exist in a technological blind spot: too small a market for commercial interest, too linguistically complex for simple rule-based systems, and too disconnected from the internet for cloud-dependent solutions.

**Voces de la Sierra was built to change that.**

---

## 💡 The Solution

Voces de la Sierra is a **bidirectional translator and cultural teaching assistant** that operates **100% offline** on consumer hardware. It has two modes:

| Mode | What it does | Example |
|------|-------------|---------|
| **🔄 Translator** | Direct, precise translations in both directions | "Traduce al náhuatl: el agua es vida" → `in atl in tlacatl` |
| **📚 Maestro Docente** | Explains vocabulary, grammar, cultural context | "¿Cómo se dice familia?" → Explanation with usage and pronunciation |

The system detects user intent automatically: translation requests get concise answers; learning questions get patient, culturally-aware explanations.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    TRAINING (Cloud)                          │
│                                                             │
│  Axolotl Dataset ──→ Quality Filter ──→ Bidirectional      │
│  (20,028 pairs)      (Náhuatl morph)    Formatting (67,288) │
│                                                             │
│  Gemma 4 E2B-it ──→ QLoRA (r=8) ──→ 10,000 steps ──→ LoRA │
│  (4-bit, Unsloth)    (0.29% params)   (Colab T4 free)      │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                   DEPLOYMENT (Edge)                          │
│                                                             │
│  Gemma 4 E2B      +  LoRA Adapter  →  llama-server         │
│  (Q4_K_M, 1.8GB)     (GGUF, 23MB)     localhost:8080       │
│                                                             │
│  ✅ No internet    ✅ No cloud       ✅ No data leaves     │
│  ✅ < 2GB storage  ✅ Any PC/laptop  ✅ Full privacy       │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 Technical Specifications

| Component | Details |
|-----------|---------|
| **Base Model** | Google Gemma 4 E2B-it (5.1B params, 4-bit quantized) |
| **Fine-tuning** | QLoRA via Unsloth · r=8, alpha=8, dropout=0 · 14.9M trainable params (0.29%) |
| **Dataset** | 67,288 examples from 20,028 Esp↔Náh pairs (Axolotl + Bible UEDIN corpus) |
| **Training** | 10,000 steps · Google Colab T4 free tier · Checkpoint persistence via Drive |
| **Loss** | 1.14 → 0.14 (converged) |
| **Inference** | llama.cpp server · 100% offline · ~2GB total · Web UI |
| **Export** | LoRA GGUF (23MB) + Base GGUF Q4_K_M (1.8GB) |

---

## 🚀 Quick Start

### Option A: One-Click Windows (recommended for demo)

1. Download [llama.cpp release](https://github.com/ggml-org/llama.cpp/releases) for Windows (CPU version)
2. Download the [base model GGUF](https://huggingface.co/bartowski/google_gemma-4-E2B-it-GGUF) (~1.8GB)
3. Download the [LoRA adapter](https://drive.google.com/file/d/1OZmlRNr12vuHwJ8uLVuBV_3-PnkTlcGr/view?usp=sharing) (23MB)
4. Place all files in the same folder with `run_server.bat`
5. Double-click **`run_server.bat`**
6. Open **http://localhost:8080** in your browser
7. Start translating!

### Option B: Command Line

```bash
llama-server -m google_gemma-4-E2B-it-Q4_K_M.gguf \
  --lora voces_sierra_lora_v2.gguf \
  --chat-template gemma \
  --port 8080
```

### Option C: Reproduce Training (Google Colab)

Open the training notebook in Colab and follow the cell-by-cell instructions:

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](notebooks/Voces_de_la_Sierra_Training.ipynb)

---

## 📦 Models

| File | Size | Description | Download |
|------|------|-------------|----------|
| `google_gemma-4-E2B-it-Q4_K_M.gguf` | ~1.8 GB | Base model (Gemma 4 E2B quantized) | [HuggingFace](https://huggingface.co/bartowski/google_gemma-4-E2B-it-GGUF) |
| `voces_sierra_lora_v2.gguf` | 23 MB | Fine-tuned LoRA adapter (GGUF) | [Google Drive](https://drive.google.com/file/d/1OZmlRNr12vuHwJ8uLVuBV_3-PnkTlcGr/view?usp=sharing) |
| `adapter_model.safetensors` | 57 MB | LoRA adapter (PEFT format, for retraining) | [Google Drive](https://drive.google.com/file/d/1eMsXtk6TdQW2j0FQxqqAwf_1z61iSQ-o/view?usp=sharing) |

---

## 📊 Training Results

Trained for 10,000 steps on Google Colab's free T4 GPU with a checkpoint persistence system that saves to Google Drive every 500 steps, enabling multi-session training across 5-hour limits.

### Loss Curve

| Phase | Steps | Loss | Status |
|-------|-------|------|--------|
| Start | 0 | 1.14 | Baseline |
| Warm-up | 0–100 | 1.14 → 0.77 | Rapid initial learning |
| Convergence | 100–5,000 | 0.77 → 0.25 | Core translation patterns acquired |
| Refinement | 5,000–10,000 | 0.25 → 0.14 | Fine-grained morphology |

### Verified Translations (Colab GPU Inference)

| Input | Output | Verification |
|-------|--------|--------------|
| "Traduce al náhuatl: el agua es vida" | `in atl in tlacatl` | ✅ "atl" = water in Náhuatl |
| "Traduce al español: Auh in ye yuhqui" | `Y en verdad` | ✅ Correct partial translation |

---

## 🌍 Impact

### Who This Serves

- **Primary:** 1.7M Náhuatl speakers needing Spanish communication (hospitals, markets, government)
- **Secondary:** Bilingual educators in indigenous schools
- **Tertiary:** Linguists, cultural preservation organizations, language learners

### Why Offline Matters

In Mexico's Sierra Norte, Sierra de Oaxaca, and Huasteca regions, internet connectivity ranges from unreliable to nonexistent. A cloud-based translator is useless where there is no cloud. Voces de la Sierra runs entirely on-device — **no API calls, no server dependencies, no data leaving the user's hands**. This also addresses a critical privacy concern: indigenous communities have historically had their linguistic data extracted without consent.

### Scalability

The pipeline is **language-agnostic**. The same process (parallel corpus → bidirectional formatting → LoRA fine-tuning → GGUF export) applies to any endangered language pair. Mexico alone has **68 indigenous language groups with 364 variants**. Globally, UNESCO estimates **40% of ~6,700 languages are endangered**.

---

## 🛠️ Challenges Solved

| Challenge | Solution |
|-----------|----------|
| Gemma 4 E2B OOM on T4 GPU | Unsloth official T4 config: max_seq=1024, r=8, dropout=0 |
| 5-hour Colab session limit | Checkpoint persistence system via Google Drive |
| GGUF export fails with bitsandbytes | Custom pipeline: text-only LoRA extraction → tensor renaming → 16-bit base conversion |
| Náhuatl dialectal variation in dataset | Morphological regex validator filtering non-Náhuatl entries |
| Gemma 4 multimodal tokenizer mismatch | Manual chat template construction with verified token strings |
| Unsloth MLX compilation bug on GPU | Disabled torch dynamo compiler via environment variables |

---

## 🔮 Future Roadmap

1. **Voice Input** — Gemma 4 E2B supports audio natively via USM encoder. When llama.cpp adds audio support, users can speak Náhuatl directly.
2. **Android APK** — Standalone app using llama.cpp Android bindings for direct phone installation.
3. **Expanded Datasets** — Partner with INALI and CIESAS for larger, dialect-labeled corpora.
4. **Multi-language** — Apply the same pipeline to Mixtec, Zapotec, Maya, and other endangered Mexican indigenous languages.

---

## 📁 Repository Structure

```
voces-de-la-sierra/
├── README.md                              # This file
├── LICENSE                                # Apache 2.0
├── run_server.bat                         # One-click Windows launcher
├── Modelfile                              # Ollama configuration
│
├── notebooks/
│   └── Voces_de_la_Sierra_Training.ipynb  # Complete training notebook
│
├── docs/
│   └── Voces_de_la_Sierra_Writeup.pdf     # Full technical write-up
│
└── demo/
    └── video_link.md                      # Link to demo video
```

---

## 📄 License

This project is licensed under the **Apache License 2.0** — see [LICENSE](LICENSE) for details.

**Gemma is a trademark of Google LLC.** This project uses the Gemma 4 E2B model under Google's Gemma Terms of Use. The fine-tuned adapter weights are distributed under Apache 2.0.

---

## 🙏 Acknowledgments

- **Google DeepMind** — Gemma 4 open models
- **Unsloth** — Efficient fine-tuning framework
- **SomosNLP** — Axolotl Spanish-Náhuatl parallel dataset
- **ggml-org** — llama.cpp inference engine
- **The Náhuatl-speaking communities of Mexico** — whose voices deserve to be heard

---

## 👤 Author

**Anthony Jair Torres Rosas**

Digital Transformation Consultant & AI/App Development Specialist

*"The most powerful AI in the world should work for the people who have the least."*

---

<p align="center">
  Built with ❤️ for the <a href="https://www.kaggle.com/competitions/gemma-4-good-hackathon">Gemma 4 Good Hackathon</a> · Kaggle × Google DeepMind · 2026
  <br>
  <em>Gemma is a trademark of Google LLC.</em>
</p>
