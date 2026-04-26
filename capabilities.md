# Capabilities Configuration Guide

## Configuration Summary

| Capability | Status | Configured By | Action Required |
|------------|--------|---------------|-----------------|
| **Location (When In Use)** | ✅ Success | Auto | None |
| **iCloud / CloudKit** | ⏳ Pending | - | See "Manual Configuration" section below |

---

## Manual Configuration Required

### 1. iCloud / CloudKit
**Status**: ⏳ Requires manual setup
**Why needed**: TripSync uses CloudKit for sharing trips via links and real-time collaboration sync
**Why auto-config failed**: Requires Apple Developer Portal container ID configuration

**Manual Configuration Steps**:

**Step 1: Xcode Configuration**
1. Select project in Navigator → Select target → Signing & Capabilities
2. Click "+ Capability"
3. Select "iCloud"
4. Check "CloudKit"
5. Click "+" to add a container: `iCloud.com.zzoutuo.TripSync`

**Step 2: Apple Developer Portal**
1. Go to https://developer.apple.com/account/resources/identifiers/list
2. Select your App ID (com.zzoutuo.TripSync)
3. Enable iCloud capability
4. Confirm CloudKit container: `iCloud.com.zzoutuo.TripSync`

**Step 3: Verify**
1. Build project (Cmd+B)
2. Check for errors
3. If successful: Update this doc with ✅

**Note**: For initial development, the app uses SwiftData with local storage. CloudKit sync can be enabled later via Settings toggle.

---

## Auto-Configured Capabilities (✅ Success - No Action Needed)

### 1. Location (When In Use)
**Status**: ✅ Successfully configured automatically
**Configuration Details**:
- **Build Settings**: INFOPLIST_KEY_NSLocationWhenInUseUsageDescription added
- **Usage**: MapKit user location display, nearby place search
- **Verification**: Build succeeded

---

## Summary Checklist

### Manual Configuration (To Do)
- [ ] iCloud/CloudKit manually configured (see "Manual Configuration" section at top)

### Auto-Configured (Verified)
- [x] Location (When In Use) verified working
