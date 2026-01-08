<div align="center">
  <img src="./logo.png" width="23%" />
</div>

# Namaskar 🙏

> [!NOTE]
> A minimal, fast, and clean alternative to **neofetch**

<div align="center">
  <img src="./screenshot.png" width="100%" />
</div>

---

## ✨ Features

- Minimal and distraction-free system info
- Super fast startup
- Zero dependencies at runtime
- Nerd Font support
- Interactive installer
- Auto-detecting uninstaller

---

## 📦 Pre-requisites

Before installing, make sure you have:

- **GNU Make**
- **Bash**
- **Git**
- A compatible **[Nerd Font](https://www.nerdfonts.com/)** (recommended)

---

## ⬇️ Download

### Step 1: Clone the repository

```sh
git clone https://github.com/DavidBalishyan/namaskar.git
cd namaskar
```

---

## 🚀 Installation

Run the interactive installer:

```sh
make install
```

You’ll be prompted to choose an installation directory:

```
1) /usr/local/bin   (requires sudo)
2) ~/.local/bin
3) ~/bin
```

### Notes

- `/usr/local/bin` → automatically uses `sudo`
- User directories → no sudo required
- You’ll be warned if the chosen directory is not in your `$PATH`

---

## 🧹 Uninstallation

Uninstalling is automatic and safe:

```sh
make uninstall
```

Namaskar will:
- Locate itself using `which`
- Remove the correct binary
- Exit gracefully if not installed

---

## ▶️ Usage

After installation, run:

```sh
namaskar
```

---

## 🛠 Development / Run without installing

```sh
./namaskar.sh
```

---

## 🤝 Contributing

Pull requests, issues, and feature requests are welcome.

---

## 📜 License

This project is licensed under the MIT License. See [LICENSE](LICENSE)
