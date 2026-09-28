# 🧰 Ventoy Service Kit

Ventoy USB에서 PC 설치·복구·A/S 작업에 쓰는 폴더 구조, Windows 설치 프로파일, 관리 스크립트와 문서 모음입니다. PC A/S 센터, 수리점, 조립 업체, 사내 IT 지원팀, 기술지원 엔지니어, 개인 정비 사용자와 홈랩 사용자를 위한 공개 예제입니다.

> **ISO/IMG는 포함되지 않습니다.** 필요한 이미지는 각 프로젝트의 공식 사이트에서 직접 다운로드해 넣으세요. 버전은 `0.1.0` Initial Preview입니다.

## 기능과 상태

`✅` 정적 검증 또는 파일 구조 확인 · `🧪` 설정 구현, 실기 검증 전 · `🚧` 계획 · `⚠️` 별도 확인 필요 · `❌` 미포함

| 기능 | v0.1.0 |
| --- | :---: |
| Windows 11 Service Standard / Ventoy Auto Install 설정 | 🧪 |
| Service Custom 변수 입력 프로파일 | 🧪 |
| Windows 10 프로파일 호환성 | ⚠️ |
| `User` 관리자 계정과 빈 암호 | ⚠️ |
| 한국어 지역 설정 예제 | 🧪 |
| Linux ISO 폴더·배치 문서 | ✅ |
| Linux 자동 설치 | 🚧 |
| MemTest86 / Memtest86+ 배치 안내 | ✅ |
| 디렉터리 메뉴 이름·짧은 설명 설정 | 🧪 |
| Service Kit 파일 복사·업데이트·정적 검증 스크립트 | ✅ |
| 자동 디스크 초기화 / OS 이미지 포함 | ❌ |

## 빠른 시작

1. [Ventoy 공식 다운로드](https://www.ventoy.net/en/download.html)에서 Ventoy를 받아 USB에 직접 설치합니다. **Ventoy 설치 자체는 USB 데이터를 지울 수 있습니다.** Service Kit는 Ventoy를 설치하지 않습니다.
2. `./scripts/Install-ServiceKit.ps1`을 실행해 데이터 파티션 드라이브를 직접 지정하고 확인합니다. 또는 `usb-template` **내용물**을 데이터 파티션 루트에 수동 복사합니다.
3. 아래 공식 다운로드 페이지에서 필요한 ISO/IMG를 직접 받습니다.
4. Windows ISO는 `/ISO/Windows/`, Linux ISO는 `/ISO/Linux/Ubuntu/` 등, 메모리 진단 이미지는 `/Diagnostics/Memory/` 아래의 해당 제품 폴더에 넣습니다.
5. USB로 부팅합니다. Windows ISO는 일반 부팅, Service Standard 또는 Experimental Service Custom을 선택합니다. **설치 에디션, 디스크와 파티션은 엔지니어가 직접 선택합니다.**

자세한 절차: [QUICK_START.md](docs/QUICK_START.md)

## USB 구조

```text
Ventoy data partition/
├─ ISO/
│  ├─ Windows/
│  └─ Linux/{Ubuntu,Debian,Fedora,Other}/
├─ Diagnostics/Memory/{MemTest86,Memtest86Plus}/
└─ ventoy/
   ├─ ventoy.json
   └─ profiles/windows/{service-standard-kokr,service-custom}.xml
```

이미지 파일명은 자유롭게 정할 수 있습니다. 세부 배치는 [USB_LAYOUT.md](docs/USB_LAYOUT.md)를 보세요.

## Windows Service Standard

| 항목 | 설정 |
| --- | --- |
| 사용자 | `User` |
| 권한 | `Administrators` |
| 암호 | 없음 — **실제 Windows 설치 검증 필요** |
| UI/시스템/사용자 로캘 | `ko-KR` |
| 시간대 | `Korea Standard Time` |
| Windows 에디션·설치 디스크·파티션 | 설치 화면에서 직접 선택 |
| Product Key | 포함 안 함 |

`Password` 요소를 생략한 방식이 실제 빈 암호 계정을 만드는지 Microsoft 문서만으로 확정할 수 없었습니다. 계정 생성과 첫 로그인도 **Needs verification**입니다. 이 프로파일은 서비스센터 테스트벤치와 설치 직후 점검용 예제이며 최종 고객에게 그대로 인도할 보안 설정으로 권장하지 않습니다. 인도 전 고객 계정과 인증을 설정하고 서비스용 계정 제거 여부를 조직 정책에 따라 확인하세요. Service Custom은 부팅 시 계정명과 컴퓨터 이름을 입력받는 Experimental 템플릿입니다. [Windows 설정 상세](docs/WINDOWS.md)

Windows 10 표준 22H2 지원은 2025-10-14에 종료되었습니다. 일부 LTSC/ESU는 별도 수명 주기를 갖습니다. 구형 환경 호환성 확인에만 사용하고 [Microsoft 지원 수명 주기](https://learn.microsoft.com/en-us/lifecycle/products/windows-10-home-and-pro)를 확인하세요.

## Linux와 진단

Linux는 ISO 정리와 일반 부팅을 안내합니다. 자동 설치 템플릿은 [향후 후보](ROADMAP.md)입니다. [Linux 안내](docs/LINUX.md)

MemTest86은 PassMark 제품이고 Memtest86+는 별도 오픈소스 프로젝트입니다. 이미지는 제공하지 않으며, 각 다운로드 파일의 Ventoy 부팅 가능 여부는 확인해야 합니다. [진단 안내](docs/DIAGNOSTICS.md)

## 공식 다운로드

| 종류 | 프로젝트 | 공식 페이지 |
| --- | --- | --- |
| Boot | Ventoy | [Ventoy 공식 다운로드](https://www.ventoy.net/en/download.html) |
| OS | Windows 11 | [Microsoft Windows 11 공식 다운로드](https://www.microsoft.com/software-download/windows11) |
| OS | Windows 10 | [Microsoft Windows 10 공식 다운로드](https://www.microsoft.com/software-download/windows10) |
| OS | Ubuntu | [Ubuntu 공식 다운로드](https://ubuntu.com/download) |
| OS | Debian | [Debian 공식 다운로드](https://www.debian.org/distrib/) |
| OS | Fedora | [Fedora 공식 다운로드](https://fedoraproject.org/workstation/download) |
| Memory | MemTest86 | [PassMark MemTest86 공식 다운로드](https://www.memtest86.com/download.htm) |
| Memory | Memtest86+ | [Memtest86+ 공식 다운로드](https://memtest.org/) |

## Ventoy 설정과 관리

`/ventoy/ventoy.json`은 Auto Install과 디렉터리용 Menu Alias/Tip 설정을 담습니다. 일반 부팅 선택은 Ventoy 기본 동작을 사용합니다. 텍스트 편집기 또는 [VentoyPlugson 공식 GUI](https://www.ventoy.net/en/plugin_plugson.html)로 수정할 수 있으며 GUI는 필수가 아닙니다. [플러그인 설정](docs/VENTOY_PLUGINS.md)

`Update-ServiceKit.ps1`은 관리 대상 파일을 갱신합니다. 수정되었거나 관리 이력이 없는 파일은 보존하고, 교체하는 기존 파일은 `ServiceKit-Backup/`에 백업합니다. ISO/IMG와 개인 파일은 복사 대상이 아닙니다. `Test-ServiceKit.ps1`은 JSON/XML과 배치 경로를 정적으로 검사합니다. [문제 해결](docs/TROUBLESHOOTING.md)

## ⚠️ 안전

Service Kit는 디스크 초기화, 파티션 삭제·생성, 포맷, BIOS 업데이트, 정품 인증, 드라이버 설치를 자동 수행하지 않습니다. 다만 사용자가 Windows Setup에서 파티션을 삭제하거나 포맷하면 데이터가 손실될 수 있습니다.

## 라이선스

이 저장소의 코드와 문서는 [MIT](LICENSE)입니다. Ventoy, Microsoft Windows, Canonical Ubuntu, Debian, Fedora, PassMark MemTest86, Memtest86+는 각각 별도 프로젝트이며 이 라이선스가 그 소프트웨어에 적용되지는 않습니다.
