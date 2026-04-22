#!/bin/bash
# ============================================================
# Claude Code Cybersecurity Studios — Tool Installer
# ============================================================
# Installs all tools referenced in studio skills.
# Supports: macOS (Homebrew) and Debian/Ubuntu (apt)
# Usage: chmod +x install.sh && ./install.sh
# ============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
info() { echo -e "${BLUE}[*]${NC} $1"; }
fail() { echo -e "${RED}[✗]${NC} $1"; }

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║   Claude Code Cybersecurity Studios — Setup          ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# ── Detect OS ────────────────────────────────────────────────
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [ -f /etc/debian_version ]; then
        OS="debian"
    elif [ -f /etc/redhat-release ]; then
        OS="redhat"
    else
        OS="unknown"
    fi
    info "Detected OS: $OS"
}

# ── macOS: Homebrew ───────────────────────────────────────────
install_macos() {
    info "Checking Homebrew..."
    if ! command -v brew &>/dev/null; then
        warn "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        ok "Homebrew found"
    fi

    info "Updating Homebrew..."
    brew update --quiet

    # Core tools
    BREW_PACKAGES=(
        "nmap"           # Network scanner
        "curl"           # HTTP client
        "wget"           # File downloader
        "git"            # Version control
        "python3"        # Python runtime
        "go"             # Go runtime (for Go-based tools)
        "openssl"        # SSL/TLS toolkit
        "jq"             # JSON processor
        "masscan"        # Fast port scanner
        "nikto"          # Web vulnerability scanner
        "sqlmap"         # SQL injection tool
        "gobuster"       # Directory/DNS brute-forcer
        "ffuf"           # Web fuzzer
        "hydra"          # Login brute-forcer
        "john"           # Password cracker
        "hashcat"        # GPU password cracker
        "aircrack-ng"    # WiFi security suite
        "wireshark"      # Network protocol analyzer
        "tcpdump"        # Packet capture
        "radare2"        # Binary analysis
        "binwalk"        # Firmware analysis
        "strings"        # String extraction
        "file"           # File type identification
        "xxd"            # Hex dump
        "netcat"         # Network utility
        "socat"          # Data relay
        "docker"         # Container platform
        "semgrep"        # Static analysis
        "trivy"          # Container/code vulnerability scanner
        "gitleaks"       # Secret scanning
        "trufflehog"     # Secret scanning (git history)
        "subfinder"      # Subdomain enumeration
        "amass"          # Attack surface mapping
        "httpx"          # HTTP toolkit
        "nuclei"         # Vulnerability scanner
        "dnsx"           # DNS toolkit
        "katana"         # Web crawler
        "waybackurls"    # Historical URLs
        "theHarvester"   # OSINT harvesting
        "yara"           # Malware pattern matching
        "volatility"     # Memory forensics
        "foremost"       # File carving
        "exiftool"       # Metadata extraction
        "pdfinfo"        # PDF analysis
        "antiword"       # Word document analysis
    )

    info "Installing Homebrew packages..."
    FAILED=()
    for pkg in "${BREW_PACKAGES[@]}"; do
        if brew list "$pkg" &>/dev/null 2>&1; then
            ok "$pkg (already installed)"
        else
            if brew install "$pkg" --quiet 2>/dev/null; then
                ok "$pkg"
            else
                warn "$pkg (failed — skipping)"
                FAILED+=("$pkg")
            fi
        fi
    done

    # Homebrew Cask (GUI tools)
    CASK_PACKAGES=(
        "wireshark"    # GUI network analyzer
    )

    info "Installing Cask packages..."
    for pkg in "${CASK_PACKAGES[@]}"; do
        if brew list --cask "$pkg" &>/dev/null 2>&1; then
            ok "$pkg (already installed)"
        else
            brew install --cask "$pkg" --quiet 2>/dev/null && ok "$pkg" || warn "$pkg (failed — skipping)"
        fi
    done
}

# ── Debian/Ubuntu: apt ────────────────────────────────────────
install_debian() {
    info "Updating apt..."
    sudo apt-get update -qq

    APT_PACKAGES=(
        "nmap" "curl" "wget" "git" "python3" "python3-pip"
        "golang" "openssl" "jq" "masscan" "nikto" "sqlmap"
        "gobuster" "hydra" "john" "hashcat" "aircrack-ng"
        "wireshark" "tcpdump" "radare2" "binwalk" "yara"
        "netcat-openbsd" "socat" "docker.io" "exiftool"
        "foremost" "binwalk" "steghide"
        "trufflehog"
    )

    info "Installing apt packages..."
    for pkg in "${APT_PACKAGES[@]}"; do
        if dpkg -l "$pkg" &>/dev/null 2>&1; then
            ok "$pkg (already installed)"
        else
            sudo apt-get install -y -qq "$pkg" 2>/dev/null && ok "$pkg" || warn "$pkg (failed)"
        fi
    done
}

# ── Python tools (pip) ────────────────────────────────────────
install_python_tools() {
    info "Installing Python security tools..."

    PIP_PACKAGES=(
        "impacket"      # Windows network protocols (SMB, Kerberos)
        "volatility3"   # Memory forensics
        "scapy"         # Packet manipulation
        "pwntools"      # Exploit development
        "requests"      # HTTP library
        "beautifulsoup4" # HTML parsing
        "shodan"        # Shodan API client
        "semgrep"       # SAST
        "trufflehog3"   # Secrets scanner
        "pypykatz"      # Mimikatz in Python
        "ldapdomaindump" # LDAP enumeration
        "bloodhound"    # AD attack path analysis
        "crackmapexec"  # Post-exploitation
    )

    for pkg in "${PIP_PACKAGES[@]}"; do
        if pip3 show "$pkg" &>/dev/null 2>&1; then
            ok "$pkg (already installed)"
        else
            pip3 install "$pkg" --quiet 2>/dev/null && ok "$pkg" || warn "$pkg (failed — skipping)"
        fi
    done
}

# ── Go-based tools ────────────────────────────────────────────
install_go_tools() {
    if ! command -v go &>/dev/null; then
        warn "Go not found — skipping Go tools"
        return
    fi

    info "Installing Go-based tools..."

    GO_TOOLS=(
        "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
        "github.com/owasp-amass/amass/v4/...@master"
        "github.com/projectdiscovery/httpx/cmd/httpx@latest"
        "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
        "github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
        "github.com/projectdiscovery/katana/cmd/katana@latest"
        "github.com/tomnomnom/waybackurls@latest"
        "github.com/lc/gau/v2/cmd/gau@latest"
        "github.com/ffuf/ffuf/v2@latest"
        "github.com/OJ/gobuster/v3@latest"
    )

    for tool in "${GO_TOOLS[@]}"; do
        tool_name=$(basename "$tool" | cut -d@ -f1)
        if command -v "$tool_name" &>/dev/null; then
            ok "$tool_name (already installed)"
        else
            go install "$tool" 2>/dev/null && ok "$tool_name" || warn "$tool_name (failed)"
        fi
    done
}

# ── Wordlists ────────────────────────────────────────────────
install_wordlists() {
    info "Setting up wordlists..."
    WORDLIST_DIR="/opt/wordlists"

    if [ ! -d "$WORDLIST_DIR" ]; then
        sudo mkdir -p "$WORDLIST_DIR"
        sudo chown "$(whoami)" "$WORDLIST_DIR"
    fi

    # SecLists
    if [ ! -d "$WORDLIST_DIR/SecLists" ]; then
        info "Downloading SecLists (~700MB)..."
        git clone --depth 1 https://github.com/danielmiessler/SecLists.git \
            "$WORDLIST_DIR/SecLists" --quiet && ok "SecLists" || warn "SecLists (failed)"
    else
        ok "SecLists (already exists)"
    fi

    # rockyou.txt (if not present)
    if [ ! -f "$WORDLIST_DIR/rockyou.txt" ]; then
        if [ -f /usr/share/wordlists/rockyou.txt.gz ]; then
            gunzip -c /usr/share/wordlists/rockyou.txt.gz > "$WORDLIST_DIR/rockyou.txt"
            ok "rockyou.txt (extracted from gz)"
        elif [ -f /usr/share/wordlists/rockyou.txt ]; then
            cp /usr/share/wordlists/rockyou.txt "$WORDLIST_DIR/"
            ok "rockyou.txt (copied from system)"
        else
            info "Downloading rockyou.txt (~134MB)..."
            curl -sL "https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt" \
                -o "$WORDLIST_DIR/rockyou.txt" && ok "rockyou.txt (downloaded)" || warn "rockyou.txt download failed"
        fi
    else
        ok "rockyou.txt (already exists)"
    fi

    # Symlinks for quick access
    [ -d "$WORDLIST_DIR/SecLists" ] && {
        ln -sf "$WORDLIST_DIR/SecLists/Discovery/DNS/subdomains-top1million-5000.txt" \
               "$WORDLIST_DIR/subdomains-top5000.txt" 2>/dev/null
        ln -sf "$WORDLIST_DIR/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt" \
               "$WORDLIST_DIR/directory-list-2.3-medium.txt" 2>/dev/null
        ok "Wordlist symlinks created"
    }
}

# ── Verify Installation ───────────────────────────────────────
verify_tools() {
    echo ""
    echo -e "${BOLD}── Verification ────────────────────────────────────────${NC}"

    CRITICAL_TOOLS=(
        "nmap" "curl" "wget" "git" "python3" "openssl" "jq"
        "sqlmap" "nikto" "gobuster" "ffuf" "hydra" "hashcat"
        "wireshark" "tcpdump" "yara"
    )

    PASSED=0
    MISSING=0
    for tool in "${CRITICAL_TOOLS[@]}"; do
        if command -v "$tool" &>/dev/null; then
            ok "$tool"
            ((PASSED++))
        else
            fail "$tool — NOT FOUND"
            ((MISSING++))
        fi
    done

    echo ""
    echo -e "${BOLD}Results: ${GREEN}${PASSED} installed${NC} | ${RED}${MISSING} missing${NC}"

    if [ ${#FAILED[@]} -gt 0 ]; then
        echo ""
        warn "The following packages failed to install:"
        for pkg in "${FAILED[@]}"; do
            echo "  - $pkg"
        done
        echo ""
        info "Try installing manually: brew install <package>"
    fi
}

# ── Main ──────────────────────────────────────────────────────
main() {
    detect_os

    case $OS in
        macos)
            install_macos
            install_python_tools
            install_go_tools
            install_wordlists
            ;;
        debian)
            install_debian
            install_python_tools
            install_go_tools
            install_wordlists
            ;;
        *)
            fail "Unsupported OS: $OS"
            info "Please install tools manually. See docs/tool-requirements.md"
            exit 1
            ;;
    esac

    verify_tools

    echo ""
    echo -e "${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║   Setup complete! Start the studio:                  ║${NC}"
    echo -e "${BOLD}║   $ claude                                           ║${NC}"
    echo -e "${BOLD}║   Then type: /start                                  ║${NC}"
    echo -e "${BOLD}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

main "$@"
