# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | TripSync |
| **Git URL** | git@github.com:asunnyboy861/TripSync.git |
| **Repo URL** | https://github.com/asunnyboy861/TripSync |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ❌ **DISABLED** (iOS app distributed via App Store) |

## Policy Pages (Separate Repository)

| Item | Value |
|------|-------|
| **Repository Name** | TripSync-pages |
| **Git URL** | git@github.com:asunnyboy861/TripSync-pages.git |
| **Repo URL** | https://github.com/asunnyboy861/TripSync-pages |
| **Visibility** | Public |
| **GitHub Pages** | ✅ **ENABLED** |

### Deployed Pages

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/TripSync-pages/ | ⏳ Pending |
| Support | https://asunnyboy861.github.io/TripSync-pages/support.html | ⏳ Pending |
| Privacy Policy | https://asunnyboy861.github.io/TripSync-pages/privacy.html | ⏳ Pending |
| Terms of Use | https://asunnyboy861.github.io/TripSync-pages/terms.html | ⏳ Pending |

## Repository Structure

### Main App Repository
```
TripSync/
├── TripSync/                   # iOS App Source Code
│   ├── TripSync.xcodeproj/     # Xcode Project
│   ├── TripSync/               # Swift Source Files
│   │   ├── Models/
│   │   ├── ViewModels/
│   │   ├── Views/
│   │   ├── Components/
│   │   ├── Services/
│   │   └── Utilities/
│   └── ...
├── us.md                         # English Development Guide
├── keytext.md                    # App Store Metadata
├── capabilities.md               # Capabilities Configuration
├── icon.md                       # App Icon Details
├── price.md                      # Pricing Configuration
└── nowgit.md                     # This File
```

### Policy Pages Repository
```
TripSync-pages/
├── index.html                    # Landing Page
├── support.html                  # Support Page
├── privacy.html                  # Privacy Policy
├── terms.html                    # Terms of Use (subscription app)
├── .github/
│   └── workflows/
│       └── deploy.yml            # GitHub Pages deployment
└── README.md
```
