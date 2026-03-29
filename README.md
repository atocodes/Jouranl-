
# Journal + 

A **local-first AI-integrated journal app** built with **Flutter**, featuring:  

- Local journal storage with **ObjectBox**  
- AI summarization of journal entries using **Ollama API**  
- Telegram bot integration for posting summarized entries  
- Modular architecture with **Flutter Modular** and **Bloc**  
- Clean and responsive UI  

> This project is a showcase of full-stack mobile app development with Flutter and modular architecture.  

---

## Features

1. **Local Journal Storage**  
   - All journal entries are stored locally with ObjectBox.  
   - Unsummarized content is saved locally; summaries are posted to Telegram.  

2. **AI Summarization**  
   - Summarizes your journal entries using the Ollama API.  
   - Summaries are concise and ready for Telegram posting.  

3. **Telegram Integration**  
   - Users can connect their own Telegram bot and channel.  
   - Posts summarized journal entries automatically.  

4. **Network Awareness**  
   - Checks internet connectivity before attempting to post.  
   - Reactive network service accessible throughout the app.  

5. **Clean Architecture**  
   - Modular structure with dependency injection via **Flutter Modular**.  
   - State management with **Flutter Bloc**.  
   - Services (AI, Telegram, Network, Storage) are globally accessible.  

6. **Onboarding Flow**  
   - Guides users to create a Telegram bot via **BotFather**.  
   - Allows optional Ollama API setup with guide link: [Ollama Keys](https://ollama.com/settings/keys).  

---

## Project Structure

```

lib/
├─ core/
│  ├─ services/
│  │  ├─ network_service.dart
│  │  ├─ telegram_service.dart
│  │  └─ ai_service.dart
│  └─ storage/
│     ├─ local_storage_service.dart
│     └─ secure_storage_service.dart
├─ features/
│  ├─ onboarding/
│  │  ├─ telegram_setup_page.dart
│  │  └─ bloc/
│  └─ home/
│     └─ home_page.dart
├─ app_module.dart
├─ app_widget.dart
└─ main.dart

````

---

## Getting Started

### 1. Install dependencies
```bash
flutter pub get
````

### 2. Run the app

```bash
flutter run
```

### 3. Setup Telegram bot

1. Open Telegram and search for **@BotFather**
2. Send `/start`
3. Send `/newbot` and follow the steps
4. Copy your bot token

> Enter the bot token and your channel ID in the onboarding page.

### 4. Optional Ollama API

1. Generate your API key at [Ollama Keys](https://ollama.com/settings/keys)
2. Enter your endpoint in the onboarding page

---

## Technologies Used

* **Flutter** – Cross-platform mobile development
* **ObjectBox** – Local database
* **Flutter Bloc** – State management
* **Flutter Modular** – Modular architecture & dependency injection
* **Ollama API** – AI summarization
* **Dio** – HTTP requests
* **Connectivity Plus** & **InternetConnectionChecker** – Network awareness

---

## Future Improvements

* Cloud sync for journals
* Multi-language AI summarization
* Rich text formatting
* Dark/light theme switch

---
## Screenshots

### 1. Onboarding & Telegram, AI Setup
![Onboarding Screen](screenshots\onboarding.png)
*Guide users to connect their Telegram bot and optionally Ollama API.*

---

### 2. Journal List
![Journal List Screen](screenshots\journals_list.png)
*Shows all local journal entries stored in ObjectBox.*

---

### 3. Journal Entry 
![Journal Entry Screen](screenshots\write_journal.png)
*Write new journal entries and see AI-generated summaries.*

---

### 4. Telegram Integration
![Telegram Post Screen](screenshots\integration.png)
*Tlegram Bot Token and Channel Id input to integrate to the channel*

---

### Notes
- Replace `screenshots/...` with your actual image file paths in the repo.
- You can use `.png`, `.jpg`, or `.gif` for animations.
- Optionally, you can use GitHub-flavored Markdown HTML to resize images:

```html
<img src="screenshots/journal_entry.png" width="300" />

---

## License

This project is **for demonstration and educational purposes**. No license yet.

```