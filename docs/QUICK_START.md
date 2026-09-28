# 빠른 시작

1. [Ventoy 공식 다운로드](https://www.ventoy.net/en/download.html)에서 Ventoy를 받은 뒤 USB에 직접 설치합니다. **Ventoy 설치는 USB 데이터를 지울 수 있으므로 먼저 백업하세요.** Service Kit 스크립트는 Ventoy를 설치하지 않습니다.
2. 저장소에서 `./scripts/Install-ServiceKit.ps1`을 실행하고 Ventoy 데이터 파티션 드라이브 문자를 직접 입력합니다. 드라이브와 파일 복사를 확인해야 진행됩니다. 또는 `usb-template`의 **내용물**을 데이터 파티션 루트에 수동 복사합니다.
3. 필요한 ISO/IMG를 [공식 다운로드 목록](../README.md#공식-다운로드)에서 직접 받습니다.
4. Windows ISO는 `ISO/Windows/`, Linux ISO는 `ISO/Linux/배포판/`, 메모리 진단 이미지는 `Diagnostics/Memory/제품/`에 넣습니다.
5. USB로 부팅합니다. Windows는 Ventoy의 일반 부팅 또는 표시된 Service Standard/Experimental Custom 프로파일을 고릅니다. 에디션, 디스크, 파티션은 설치 화면에서 직접 선택합니다.

복사 후 `./scripts/Test-ServiceKit.ps1 -Root 'E:\'`처럼 정적 검증할 수 있습니다. `E:`는 실제 데이터 파티션 문자로 바꾸세요. 검증기는 OS 설치 동작을 확인하지 않습니다.
