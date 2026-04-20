# /mobile-security — Mobile Application Security Audit

```
Use agent: appsec-engineer
Coordinate with: appsec-lead, mobile-pentester
```

## Purpose

Perform a structured source-code-level security audit of mobile applications (Android/iOS) — reviewing authentication flows, data storage, cryptographic implementations, network security, and compliance with OWASP MASVS (Mobile Application Security Verification Standard).

## Pre-Execution Check

- [ ] Source code access granted (white-box audit)
- [ ] Target platform defined: Android / iOS / Both
- [ ] MASVS compliance level: L1 (Basic) / L2 (Standard) / R (Resilience)
- [ ] Backend API documentation available

## Audit Framework — MASVS

### MASVS-STORAGE — Data Storage Security

```bash
# Android — Review SharedPreferences usage
grep -rn "SharedPreferences\|getSharedPreferences\|MODE_WORLD" ./app/src/ | \
  grep -v "MODE_PRIVATE"  # World-readable prefs = FINDING

# Check SQLite encryption
grep -rn "SQLiteDatabase\|openOrCreateDatabase\|Room" ./app/src/ | \
  grep -v "SQLCipher\|EncryptedRoom"  # Unencrypted DB = review

# Sensitive data in logs
grep -rn "Log\.\|System\.out\.print\|println" ./app/src/ | \
  grep -iE "password|token|key|secret|ssn|credit"  # Logging sensitive data = FINDING

# iOS — NSUserDefaults for sensitive data
grep -rn "NSUserDefaults\|UserDefaults" ./Sources/ | \
  grep -iE "password|token|secret"  # Sensitive in UserDefaults = FINDING

# Keychain usage (iOS — correct way to store credentials)
grep -rn "SecItemAdd\|kSecClass\|KeychainHelper" ./Sources/

# Android Keystore (correct way)
grep -rn "KeyStore\|KeyPairGenerator\|KeyGenerator" ./app/src/
```

### MASVS-CRYPTO — Cryptography

```bash
# Weak algorithms
grep -rn "DES\|3DES\|RC2\|RC4\|MD5\|SHA1\b" ./app/src/ | \
  grep -iv "//\|#\|test"  # Deprecated algorithms in production = FINDING

# Hardcoded IV / fixed nonce (CBC mode)
grep -rn "IvParameterSpec\|iv = \|new byte\[16\]" ./app/src/

# Hardcoded keys
grep -rn "AESKey\|privateKey\|secretKey\s*=\s*\"" ./app/src/ | \
  grep -iE "\"[A-Za-z0-9+/]{16,}\""  # Hardcoded crypto keys = CRITICAL

# iOS — Check for weak random
grep -rn "arc4random\|rand()\|srand" ./Sources/ | \
  grep -v "//\|#"  # Weak random for crypto = FINDING

# Proper implementations to verify
grep -rn "SecureRandom\|CryptographicRandom\|CommonCrypto" ./app/src/
```

### MASVS-AUTH — Authentication & Session Management

```bash
# Biometric authentication implementation
grep -rn "BiometricPrompt\|FingerprintManager\|LocalAuthentication" ./app/src/
# Verify: fallback mechanism, auth result validation

# JWT handling
grep -rn "jwt\|JSON\.parseBase64\|decodeJWT" ./app/src/ | \
  grep -iE "\"alg\"\s*:\s*\"none\"\|verify\s*=\s*false"  # Dangerous JWT config

# Session timeout
grep -rn "session\|token.*expir\|expiresIn" ./app/src/
# Verify tokens expire and are properly invalidated on logout

# Certificate pinning implementation
grep -rn "CertificatePinner\|TrustKit\|PublicKeyPinning\|SSLPinning" ./app/src/
# Should be implemented for network connections
```

### MASVS-NETWORK — Network Communication

```bash
# HTTP cleartext connections (Android)
grep -rn "http://" ./app/src/ | grep -v "//\|#\|schemas\|xmlns\|test"  # HTTP in prod = FINDING
grep -rn "clearTextTrafficPermitted\|usesCleartextTraffic" ./app/

# iOS ATS (App Transport Security)
grep -rn "NSAllowsArbitraryLoads\|NSExceptionAllowsInsecureHTTPLoads" ./Sources/ | \
  grep "true"  # ATS disabled = FINDING

# Hostname verification
grep -rn "setHostnameVerifier\|ALLOW_ALL_HOSTNAME_VERIFIER" ./app/src/  # Critical finding

# WebView security (Android)
grep -rn "setJavaScriptEnabled\|addJavascriptInterface\|setAllowFileAccess" ./app/src/
grep -rn "loadUrl\|evaluateJavascript" ./app/src/  # Check for JavaScript injection
```

### MASVS-PLATFORM — Platform Interaction

```bash
# Android exported components (attack surface)
grep -A3 "android:exported=\"true\"" ./app/src/main/AndroidManifest.xml | \
  grep -v "android:permission"  # Exported without permission = review

# Deep link handling
grep -rn "intent-filter\|host =\|scheme =" ./app/src/main/AndroidManifest.xml
# Verify: Deep link parameters are validated, no arbitrary URL loading

# Content providers (data exposure)
grep -rn "ContentProvider\|android.permission.READ" ./app/src/main/AndroidManifest.xml

# iOS — URL scheme handling
grep -rn "application.*openURL\|handleDeepLink" ./Sources/
# Verify: Parameters validated, no JS injection via URL schemes

# Android Broadcast Receivers
grep -rn "BroadcastReceiver\|sendBroadcast" ./app/src/ | \
  grep -v "//\|#"
```

### MASVS-CODE — Code Quality

```bash
# Debug flags in production build
grep -rn "BuildConfig\.DEBUG\|isDebuggable\|android:debuggable" ./app/ | \
  grep "true"  # Debug in release = FINDING

# Test/dev endpoints in production
grep -rn "localhost\|127\.0\.0\.1\|192\.168\.\|staging\|test\|dev\." ./app/src/ | \
  grep -iv "//\|#\|\*\|test"

# Error handling — stack traces to users
grep -rn "printStackTrace\|Log\.e\|exception\.message" ./app/src/ | \
  grep -iE "catch|exception"
```

## MASVS Compliance Matrix

| MASVS Category | L1 | L2 | R | Status |
|----------------|----|----|---|--------|
| MASVS-STORAGE | ✓ | ✓ | - | [ ] |
| MASVS-CRYPTO | ✓ | ✓ | - | [ ] |
| MASVS-AUTH | ✓ | ✓ | - | [ ] |
| MASVS-NETWORK | ✓ | ✓ | - | [ ] |
| MASVS-PLATFORM | ✓ | ✓ | - | [ ] |
| MASVS-CODE | ✓ | ✓ | - | [ ] |
| MASVS-RESILIENCE | - | - | ✓ | [ ] |

## Output

```
engagements/[id]/mobile-security/
├── findings/
│   ├── CRITICAL-hardcoded-key.md
│   └── HIGH-cleartext-storage.md
├── masvs-compliance-matrix.md
└── mobile-security-report.md
```

Feed to `report-writer`. Combine with dynamic testing results from `/mobile-pentest`.
