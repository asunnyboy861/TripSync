# TripSync - iOS App Development Guide

## Executive Summary

**TripSync** is a collaborative travel planning app that eliminates the friction of group trip organization. Unlike existing solutions where collaboration is an afterthought, TripSync is built from the ground up for real-time group coordination with three core differentiators:

1. **No-Login Collaboration**: Share a link and anyone can view/edit without registration — solving the #1 user complaint across all competitors
2. **Swipe-to-Vote Decision Making**: Tinder-style card swiping for group decisions on restaurants, activities, and accommodations — replacing endless group chat debates
3. **Native-First iOS Experience**: Built with SwiftUI + SwiftData + MapKit for buttery smooth performance, offline support, and deep Apple ecosystem integration

**Product Vision**: "Plan Together, Travel Better" — TripSync transforms group travel planning from a chaotic, multi-app experience into a single, intuitive workspace where every voice matters and decisions happen in minutes, not days.

**Target Market**: US travelers aged 22-40 who plan trips with friends/family. This demographic values seamless collaboration, mobile-first experiences, and is frustrated by the current fragmented tool landscape (group chats + spreadsheets + multiple apps).

**App Category**: Travel / Productivity

**Bundle ID**: com.zzoutuo.TripSync

**Minimum iOS**: 17.0

---

## Competitive Analysis

| Feature | TripSync | Wanderlog | TripIt | Troupe |
|---------|----------|-----------|--------|--------|
| **No-Login Access** | ✅ Share link, instant access | ❌ Requires account | ❌ Requires account | ❌ Requires account |
| **Real-Time Collaboration** | ✅ Native real-time sync | ✅ Google Docs-style | ❌ Read-only sharing | ❌ Limited |
| **Voting/Decision Making** | ✅ Swipe + poll voting | ⚠️ Basic suggestions | ❌ None | ✅ Date/destination polls |
| **Interactive Map** | ✅ MapKit native | ✅ Google Maps | ❌ Basic map | ❌ None |
| **Itinerary Builder** | ✅ Drag-and-drop | ✅ Full builder | ✅ Auto-import | ❌ None |
| **Expense Splitting** | ✅ Built-in | ✅ Built-in | ❌ None | ❌ None |
| **Packing Lists** | ✅ Built-in | ✅ Built-in | ❌ None | ❌ None |
| **Offline Mode** | ✅ SwiftData local-first | ❌ Requires internet | ✅ Cached | ❌ None |
| **Dark Mode** | ✅ Free | ❌ $40/year paywall | ✅ Free | ✅ Free |
| **Native iOS** | ✅ SwiftUI | ❌ Web-based hybrid | ❌ Legacy codebase | ❌ Web-based |
| **Price** | Free + IAP | Free + $40/yr Pro | Free + $49/yr Pro | Free |
| **App Store Rating** | N/A (New) | 4.7 (App Store) / 1.9 (Trustpilot) | 4.8 (App Store) / 1.5 (Trustpilot) | N/A |

### Key Differentiators vs Competitors

**vs Wanderlog**: TripSync offers no-login collaboration (Wanderlog requires email signup), free dark mode, native iOS performance (Wanderlog is web-hybrid), and swipe voting. Wanderlog's biggest user complaint is the $40/year paywall for basic features like dark mode.

**vs TripIt**: TripSync is collaborative by design (TripIt is single-user with read-only sharing), offers built-in expense splitting, interactive maps, and modern SwiftUI interface. TripIt's UI is widely criticized as "clunky" and "dated."

**vs Troupe**: TripSync offers full itinerary building, maps, expenses, and packing lists beyond just voting. Troupe only handles the decision phase with no trip execution tools.

---

## Technical Architecture

### Technology Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| **UI Framework** | SwiftUI | Native performance, declarative UI, smooth animations |
| **Architecture** | MVVM + Clean Architecture | Testable, maintainable, separation of concerns |
| **Local Storage** | SwiftData | Apple native ORM, automatic iCloud sync capability |
| **Cloud Sync** | CloudKit (Public DB) | Free tier generous, no server needed, native integration |
| **Real-Time Sync** | CloudKit Subscriptions | Push-based change notifications |
| **Maps** | MapKit + Apple Maps | Native, no API key, 3D support |
| **Place Search** | MKLocalSearch | Native integration, free |
| **Share Links** | Universal Links + CloudKit Sharing | No-login access via link |
| **Networking** | URLSession + Async/Await | Native, modern concurrency |
| **Offline Cache** | SwiftData + NSCache | Offline-first architecture |
| **Animations** | SwiftUI Animation + PhaseAnimator | Fluid interaction experience |

### Data Model Overview

```
Trip
├── TripDay[]
│   ├── Activity[]
│   └── CheckIn[]
├── TripMember[]
├── Expense[]
├── PackingItem[]
└── Poll[]
    └── PollOption[]
        └── Vote[]

AnonymousVisitor (no-login access)
```

### Module Structure & File Organization

```
TripSync/
├── TripSyncApp.swift
├── Models/
│   ├── Trip.swift
│   ├── TripDay.swift
│   ├── Activity.swift
│   ├── TripMember.swift
│   ├── Expense.swift
│   ├── PackingItem.swift
│   ├── Poll.swift
│   ├── PollOption.swift
│   ├── Vote.swift
│   └── AnonymousVisitor.swift
├── ViewModels/
│   ├── TripListViewModel.swift
│   ├── TripDetailViewModel.swift
│   ├── ItineraryViewModel.swift
│   ├── MapViewModel.swift
│   ├── PollViewModel.swift
│   ├── ExpenseViewModel.swift
│   ├── PackingViewModel.swift
│   ├── ShareViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── TripListView.swift
│   ├── TripDetailView.swift
│   ├── ItineraryView.swift
│   ├── ItineraryDayView.swift
│   ├── ActivityCardView.swift
│   ├── AddActivityView.swift
│   ├── MapView.swift
│   ├── MapMarkerView.swift
│   ├── PollListView.swift
│   ├── PollDetailView.swift
│   ├── SwipeVoteView.swift
│   ├── ExpenseView.swift
│   ├── AddExpenseView.swift
│   ├── PackingListView.swift
│   ├── ShareView.swift
│   ├── JoinTripView.swift
│   ├── SettingsView.swift
│   └── ContactSupportView.swift
├── Components/
│   ├── ActivityCategoryIcon.swift
│   ├── MemberAvatarView.swift
│   ├── VoteResultBar.swift
│   ├── ExpensePieChart.swift
│   └── ShareLinkCard.swift
├── Services/
│   ├── ShareLinkManager.swift
│   ├── SyncManager.swift
│   ├── LocationSearchService.swift
│   └── PurchaseManager.swift
├── Utilities/
│   ├── Constants.swift
│   └── Extensions.swift
└── Assets.xcassets/
```

---

## Implementation Flow

### Step 1: Data Models (SwiftData)
- Create all @Model classes with proper relationships
- Ensure all attributes are optional or have defaults
- All relationships must have inverse relationships

### Step 2: App Entry & Navigation
- TripSyncApp.swift with WindowGroup + SwiftData container
- TabView navigation: Trips, Map, Polls, Packing, Settings
- NavigationStack for each tab

### Step 3: Trip List & CRUD
- TripListView with grid/list toggle
- Create trip form with date picker, destination
- Swipe to delete, edit trip

### Step 4: Itinerary Builder
- Day-by-day view with drag-and-drop reordering
- Activity cards with category icons and colors
- Add activity with map pin selection
- Time slot management

### Step 5: Interactive Map
- MapKit integration with activity markers
- Marker clustering by day
- Route visualization between activities
- Tap marker to see activity details

### Step 6: Voting & Decision Making
- Poll creation (single choice, multiple choice, swipe)
- SwipeVoteView with Tinder-style card animation
- Real-time vote counting and results display
- Poll option with images

### Step 7: Expense Tracking & Splitting
- Add expenses with category, payer, split method
- Equal split, percentage split, custom amounts
- Summary view with per-person balance
- Multi-currency support

### Step 8: Packing List
- Categorized packing items
- Template presets (beach, city, camping)
- Assign items to members
- Check/uncheck with progress bar

### Step 9: No-Login Sharing
- Generate share link with access level
- JoinTripView for link-based access
- AnonymousVisitor with random name/emoji
- ShareLinkCard for iOS Share Sheet

### Step 10: Settings & Support
- App settings with iCloud toggle
- Contact support form
- Privacy policy & terms links
- Restore purchases

---

## UI/UX Design Specifications

### Design Principles
- **Clarity**: Clean, minimal interface with generous whitespace
- **Deference**: Content-first design, UI serves the travel content
- **Depth**: Subtle layering with material backgrounds and shadows

### Color System

| Role | Color | Usage |
|------|-------|-------|
| **Primary** | #007AFF (System Blue) | CTAs, active states, links |
| **Secondary** | #5856D6 (System Purple) | Polls, voting features |
| **Success** | #34C759 (System Green) | Completed items, confirmed |
| **Warning** | #FF9500 (System Orange) | Pending actions, food category |
| **Danger** | #FF3B30 (System Red) | Delete actions, over-budget |
| **Background** | System backgrounds | Auto light/dark mode |

### Activity Category Colors

| Category | Color | Icon (SF Symbol) |
|----------|-------|------------------|
| Food | Orange | fork.knife |
| Accommodation | Blue | bed.double |
| Transport | Green | car |
| Attraction | Red | mappin.and.ellipse |
| Shopping | Pink | bag |
| Activity | Teal | figure.hiking |
| Nightlife | Purple | music.note |
| Other | Gray | star |

### Typography
- **Large Title**: 34pt, Bold — Trip names, section headers
- **Title 2**: 22pt, Bold — Day headers, card titles
- **Title 3**: 20pt, Semibold — Subsection headers
- **Body**: 17pt, Regular — Descriptions, notes
- **Caption**: 12pt, Regular — Timestamps, metadata

### Key UI Components

**Trip Card**: Rounded rectangle with cover gradient, trip name, dates, member avatars, destination

**Activity Card**: Left color bar by category, icon, title, time, location, drag handle

**Swipe Vote Card**: Full-screen card with place image, name, description, swipe left (nope) / right (like) with spring animation

**Expense Row**: Category icon, description, amount, payer, split indicator

**Packing Item**: Checkbox, item name, assigned member avatar, category tag

### iPad Layout
- Split view with sidebar navigation
- Main content area with `.frame(maxWidth: 720).frame(maxWidth: .infinity)`
- No restrictive tab view styles

---

## Code Generation Rules

1. **No comments in code** unless explicitly requested
2. **SwiftUI + SwiftData** for all UI and persistence
3. **MVVM pattern**: View + ViewModel for each feature
4. **All SwiftData attributes** must be optional or have default values
5. **All relationships** must have inverse relationships
6. **Never use** `.tabViewStyle(.sidebarAdaptable)` on iPad
7. **Always add** `.frame(maxWidth: 720).frame(maxWidth: .infinity)` to main ScrollView content
8. **Never use** `ObservableObject` on views already marked `@Observable`
9. **Never use** iOS 18+ only APIs (target is iOS 17+)
10. **Use** `Color.accentColor` instead of `ShapeStyle.accent`
11. **Never hardcode** version numbers — read from `Bundle.main.infoDictionary`
12. **CoreData rules**: Use `NSPersistentContainer` during development, switch to `NSPersistentCloudKitContainer` when CloudKit is configured

---

## Testing & Validation Standards

### Build Validation
- Must compile with zero errors on iPhone and iPad simulators
- No warnings related to deprecated APIs

### Feature Testing
- Create a trip, add days and activities
- Share a trip via link, join as anonymous visitor
- Create a poll, vote with swipe gesture
- Add expenses, verify split calculations
- Check packing list check/uncheck
- Verify map markers display correctly
- Test offline mode by disabling network

### UI Testing
- iPhone XS Max: All views render correctly
- iPad Pro 13-inch (M4): Split view layout works, no narrow sidebar
- Dark mode: All views adapt properly
- Dynamic type: Large accessibility sizes work

---

## Build & Deployment Checklist

- [ ] Xcode project configured with Bundle ID: com.zzoutuo.TripSync
- [ ] iOS Deployment Target: 17.0
- [ ] All SwiftData models compile without errors
- [ ] Build succeeds on iPhone simulator
- [ ] Build succeeds on iPad simulator
- [ ] App icon configured in Assets.xcassets
- [ ] Privacy permissions configured (Location, etc.)
- [ ] CloudKit capability configured (if needed)
- [ ] StoreKit configuration file created (if IAP)
- [ ] Policy pages deployed to GitHub Pages
- [ ] App Store metadata prepared (keytext.md)
- [ ] Screenshots captured for iPhone and iPad
