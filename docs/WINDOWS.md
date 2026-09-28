# Windows 설치 프로파일

Windows 11 ISO를 `ISO/Windows/`에 넣으면 Ventoy Auto Install이 두 템플릿을 제시하도록 설정했습니다. Ventoy 기본 메뉴의 일반 부팅도 그대로 사용할 수 있습니다. ISO 파일명은 자유롭습니다. Windows 10은 표준 22H2 지원이 2025-10-14에 종료되었고 이 프로파일의 호환성은 검증하지 않았습니다.

| 프로파일 | 동작 | 상태 |
| --- | --- | --- |
| `service-standard-kokr.xml` | `User` 로컬 관리자, 한국어 지역 설정, 한국 시간대, 문서화된 OOBE 화면 일부 숨김 | 🧪 실기 검증 전 |
| `service-custom.xml` | 부팅 시 `USERNAME`, `COMPUTERNAME`을 입력받아 로컬 관리자와 컴퓨터 이름에 사용 | 🧪 Experimental |

두 템플릿 모두 제품 키, 에디션 인덱스, `DiskConfiguration`, `ImageInstall`, 설치 대상 파티션과 명령 실행을 지정하지 않습니다. **설치 화면에서 에디션·디스크·파티션을 사용자가 직접 확인해야 합니다.** Microsoft의 완전 무인 설치 문서는 `InstallTo` 또는 `InstallToAvailablePartition`을 요구합니다. 이 키트는 의도적으로 둘 다 사용하지 않으므로, 부분 Unattend와 대화식 디스크 선택의 결합은 Windows 11/10 실기 검증이 필요합니다.

## 빈 암호 계정 확인 필요

Service Standard는 `Password` 요소를 생략했습니다. Microsoft Learn은 `Password/Value`를 설명하지만 요소 생략 또는 빈 `Value`가 현재 Windows 11/10에서 완전한 빈 암호를 만드는지 명시하지 않습니다. 따라서 **`User` 계정 생성, 관리자 그룹, 빈 암호, 첫 로그인은 Needs verification**입니다. 이 XML을 고객 PC에 바로 적용하기 전에 VM 또는 테스트 장비에서 결과를 확인하세요.

## Custom 입력

Ventoy 1.0.77 이상에서 문서화된 Variables Expansion을 사용합니다. 사용자 정의 변수는 부팅 중 입력 UI를 띄웁니다. 템플릿은 UTF-8이고 각 줄에 변수가 하나씩 있습니다. 입력은 Ventoy가 Windows 계정명이나 컴퓨터 이름으로 검증해 주지 않습니다. `USERNAME`은 단순 영문/숫자 이름으로, `COMPUTERNAME`은 영문/숫자/하이픈의 짧은 이름으로 입력하고 XML 특수 문자(`&`, `<`, `>`)는 피하세요. 잘못된 입력의 거부 방식은 실기 확인이 필요합니다.

## 지역 및 OOBE

`oobeSystem`의 `International-Core`에 `ko-KR` 입력·시스템·UI·사용자 로캘을 지정하고 `Shell-Setup`에 `Korea Standard Time`을 지정했습니다. 한국어 UI는 ISO/설치 이미지에 해당 언어가 있어야 합니다. `HideOnlineAccountScreens`, `HideWirelessSetupInOOBE`, `ProtectYourPC`는 Microsoft가 문서화한 설정만 사용했습니다. 오래된 `SkipMachineOOBE`, `SkipUserOOBE`, `NetworkLocation`, `BypassNRO` 및 레지스트리 우회는 사용하지 않습니다.

## 실기 체크리스트

- Windows Setup 시작과 일반 부팅 선택
- 에디션 선택 가능 여부, 디스크·파티션 선택 화면 유지
- `User` 생성, `Administrators` 구성원, **정말 빈 암호인지**
- 한국어 UI·로캘과 한국 시간대, OOBE 결과, 첫 로그인
- Custom 입력 UI, 입력값 반영, 특수 문자 거부/오류 동작

이 검사는 아직 실행되지 않았습니다. [Microsoft 공식 문서 출처](REFERENCES.md)를 보세요.
