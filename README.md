# Business Central Semantic Search

Vector-based semantic search over Microsoft Dynamics 365 Business Central data — built at the Microsoft Business Central AI Hackathon (2024).

Keyword search finds records that contain the words you typed. Semantic search finds records that **mean** what you asked. This extension generates embeddings for Business Central records, stores them as vectors, and retrieves the closest matches to a natural-language query — roughly 1,000× better at surfacing relevant data than keyword search in our hackathon tests.

## What's inside

| Folder | Purpose |
|---|---|
| `src/VectorStorage` | Embedding generation and vector storage for Business Central records |
| `src/Search` | Semantic search over the stored vectors (similarity ranking) |
| `src/Copilot` | A sales Copilot that uses semantic search to ground its answers in ERP data |
| `src/API` | API pages exposing search results to external agents and apps |
| `src/Setup` | Azure OpenAI configuration |
| `src/DataForDemo` | Demo data generation |
| `src/Permissions` | Permission sets |

Branches: `master` (AL implementation), `sqlsemanticsearch` (SQL-based vector search experiment), `demiliani` (contributions by Stefano Demiliani).

## Why it matters

The ideas explored here — embeddings over ERP records, semantic retrieval, and grounding copilots in business data — now underpin search and AI agent scenarios in Business Central.

## Requirements

- Business Central 23.0+ with the Microsoft **Data Search** app
- An Azure OpenAI resource (embeddings + chat deployments)

## Authors

Built by [Dmitry Katson](https://github.com/DmitryKatson) with [Stefano Demiliani](https://github.com/demiliani) and [Jeremy Vyska](https://github.com/JeremyVyska).
