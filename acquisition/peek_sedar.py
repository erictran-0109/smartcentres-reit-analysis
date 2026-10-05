import json

with open('data/processed/sedar/sedar_documents.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Find the Q1 2026 interim report specifically
q1_doc = next(d for d in data if d['filename'] == '2026_q1_interim_mda_english.pdf')
text = q1_doc['text']

# Search for a keyword and print the surrounding context
keyword = "payout"
idx = text.lower().find(keyword)

if idx != -1:
    # Print 500 characters before and after the keyword for context
    start = max(0, idx - 500)
    end = idx + 500
    print(text[start:end])
else:
    print(f"Keyword '{keyword}' not found.")