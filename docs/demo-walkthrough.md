# Demo Walkthrough — First Engagement

> **Senaryo:** Kendi web sitenizde ilk pentest akışını baştan sona çalıştırın.  
> **Süre:** ~30 dakika  
> **Yetki:** Sadece kendi sahip olduğunuz sistemlere karşı çalıştırın.

---

## Ön Koşullar

```bash
# 1. Araçları kur
chmod +x install.sh && ./install.sh

# 2. Proje dizinine gir
cd "siber-guvenlik"  # veya klasörün adı

# 3. Claude Code'u başlat
claude
```

---

## Adım 1 — Studioyu Başlat

```
/start
```

Claude CISO kimliğine bürünür, studioyu yükler ve etik sınırları doğrular.

**Beklenen çıktı:**
```
[STUDIO] Claude Code Cybersecurity Studios aktif
[CISO] Etik sınırlar yüklendi. Kapsam doğrulaması hazır.
```

---

## Adım 2 — Kapsamı Tanımla

```
/scope-define
```

Sorulara cevap ver:
- **Hedef domain:** `sizin-siteniz.com`
- **Test türü:** Web Application
- **Yetki:** Siz sahipsiniz — "Yes, I own this"

Bu adım `production/active-engagement.md` dosyasını oluşturur ve `validate-scope.sh` hook'unu aktive eder.

---

## Adım 3 — OSINT Keşif

```
/osint-gather
```

**Agent:** `osint-analyst` devreye girer.

Claude şunları yapacak:
- Sertifika şeffaflık loglarından alt alan adlarını keşfeder
- DNS kayıtlarını haritalandırır (A, MX, TXT, SOA, CAA)
- Email güvenliğini kontrol eder (SPF, DMARC, DKIM)
- WHOIS bilgilerini toplar

---

## Adım 4 — Saldırı Yüzeyi Haritası

```
/subdomain-enum
```

Ardından:

```
/attack-surface-map
```

**Agent:** `osint-analyst` + `network-pentester` koordineli çalışır.

Çıktı: Tüm keşfedilen varlıklar, açık servisler ve önceliklendirilmiş test hedefleri.

---

## Adım 5 — Web Pentest

```
/web-pentest
```

**Agent:** `web-pentester` devreye girer.

Test fazları:
1. Teknoloji tespiti ve endpoint keşfi
2. Authentication mekanizması testi
3. Authorization kontrolleri (IDOR vb.)
4. Injection testleri (SQLi, XSS, SSRF)
5. Güvenlik başlıkları analizi
6. Hassas dosya ve bilgi sızıntısı

---

## Adım 6 — Bulgular Raporla

```
/vuln-scorecard
```

```
/pentest-report
```

```
/exec-summary
```

**Agent:** `report-writer` → `risk-analyst` koordinasyonu.

Çıktı:
- Zafiyet puan kartı (renk kodlu risk matrisi)
- Teknik pentest raporu (CVSS skorlu bulgular)
- Yönetici özeti (non-teknik, karar odaklı)

---

## Tam Akış Özeti

```
/start
  └─► /scope-define
        └─► /osint-gather
              └─► /subdomain-enum
                    └─► /attack-surface-map
                          └─► /web-pentest
                                └─► /vuln-scorecard
                                      └─► /pentest-report
                                            └─► /exec-summary
```

---

## Diğer Demo Senaryoları

### Senaryo 2 — Incident Response Tatbikatı
```
/ir-initiate        ← Olayı başlat
/evidence-preserve  ← Delil koru
/forensics-collect  ← Sistem toplan
/timeline-build     ← Zaman çizelgesi
/post-mortem        ← Lessons learned
```

### Senaryo 3 — Kod Güvenlik İncelemesi
```
/code-audit         ← Kaynak kod analizi
/sast-scan          ← Statik analiz
/dependency-check   ← Bağımlılık güvenliği
/secure-review      ← Güvenli kod incelemesi
/remediation-plan   ← Düzeltme planı
```

### Senaryo 4 — Tehdit Avı
```
/hunt-hypothesis    ← Hipotez oluştur
/threat-hunt        ← Avı yürüt
/ioc-extract        ← IOC çıkar
/yara-rule          ← YARA kuralı yaz
/threat-brief       ← İstihbarat raporu
```

### Senaryo 5 — Cloud Güvenlik Denetimi
```
/cloud-audit        ← Genel bulut denetimi
/iam-review         ← Kimlik ve erişim
/k8s-security       ← Kubernetes güvenliği
/container-audit    ← Container denetimi
/cspm-check         ← Güvenlik duruşu
```

---

## Sık Sorulan Sorular

**S: Araçlar kurulu değilse ne olur?**  
A: Studio yine çalışır ama ilgili bash komutları atlanır. Tam güç için `./install.sh` çalıştırın.

**S: Üretim sistemine karşı kullanabilir miyim?**  
A: Sadece sahip olduğunuz veya yazılı yetki aldığınız sistemlere karşı.

**S: Raporlar nereye kaydedilir?**  
A: `engagements/[proje-adı]/` dizinine. `.gitignore` hassas bulgu dosyalarını git dışında tutar.

**S: Bir agent yanlış davranırsa ne yapmalıyım?**  
A: `ciso` ajanını çağırın: "CISO, [ajan-adı] ajanının davranışını değerlendir."

---

*Claude Code Cybersecurity Studios — Professional Security Operations, AI-Augmented*
