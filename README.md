# 📰 News Summarizer & Categorizer App

## Overview
A Flutter-based **News Application** with a Flask backend that delivers **summarized**, **cleaned**, **clustered**, and **categorized** news articles using advanced **NLP** and **Machine Learning** techniques.

---

## Features
- 📰 Live News Feed
- ✂️ Automatic News Summarization
- 🧹 Text Data Cleaning
- 🧠 Clustering News using TF-IDF + K-Means
- 🧩 Duplicate News Detection using Cosine Similarity
- 🏷️ News Categorization into topics using SVM Classifier
- 🚀 Fast and Minimalistic Flutter UI

---

## Tech Stack
- **Frontend**: Flutter
- **Backend**: Flask (Python)
- **Tunneling**: ngrok
- **ML/NLP**:
  - Data Cleaning
  - Summarization
  - TF-IDF Vectorization
  - K-Means Clustering
  - Cosine Similarity
  - SVM Classification

---

## Architecture


```plaintext
Flutter App
    ↓
Ngrok Tunnel
    ↓
Flask Backend
    ↓
NLP/ML Pipeline
        - Data Cleaning
        - Summarization
        - TF-IDF Vectorization
        - K-Means Clustering
        - Duplicate Detection (Cosine Similarity)
        - News Categorization (SVM)
