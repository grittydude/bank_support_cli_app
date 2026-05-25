# Bank Support CLI App

An AI-powered banking support CLI application built with Dart and OpenRouter.

The app processes customer banking queries through a 5-step prompt chain to understand the issue, classify it, extract important details, and generate a professional response.

---

## Features

- Customer intent detection
- Possible category mapping
- Best category selection
- Additional detail extraction
- AI-generated customer response
- Environment variable support with `.env`
- Command-line execution

---

## Prompt Chain Steps

1. Interpret customer intent
2. Suggest possible categories
3. Choose the most appropriate category
4. Extract additional required details
5. Generate a short customer response

---

## Available Categories

- Account Opening
- Billing Issue
- Account Access
- Transaction Inquiry
- Card Services
- Account Statement
- Loan Inquiry
- General Information

---

## Tech Stack

- Dart
- OpenRouter API
- HTTP package
- dotenv package

---

## Setup

### 1. Install dependencies

```bash
dart pub get
```

---

### 2. Create a `.env` file

Create a `.env` file in the root directory:

```env
OPENROUTER_API_KEY=your_api_key_here
MODEL_NAME=openai/gpt-4o-mini
```

---

### 3. Run the application

```bash
dart run lib/main.dart "My card was charged twice"
```

---

## Example Query

```bash
dart run lib/main.dart "I can't access my account after resetting my password"
```

---

## Project Structure

```txt
bank_support_cli_app/
│
├── lib/
│   ├── main.dart
│   └── prompts/
│       ├── customers_intent.txt
│       ├── possible_categories.txt
│       ├── appropraite_category.txt
│       ├── additional_details.txt
│       └── generate_short_response.txt
│
├── .env
├── .gitignore
├── pubspec.yaml
└── README.md
```

---

## Notes

- `.env` is excluded from GitHub using `.gitignore`
- API keys are never hardcoded
- The app prints the AI response after every prompt step

---

## Author

Built by Ikechukwu Achom