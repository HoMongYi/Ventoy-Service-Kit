# 문제 해결

## Windows ISO가 보이지 않음

`ISO/Windows/`에 ISO가 있는지, 확장자와 파일 손상 여부, Ventoy 버전을 확인하세요. 이미지는 사용자 제공 파일입니다.

## Service Profile이 나오지 않음

`/ventoy/ventoy.json`과 `/ventoy/profiles/windows/` 경로를 확인하고 `Test-ServiceKit.ps1`로 JSON/XML 구문을 검사하세요. ISO 경로와 Auto Install 매칭 규칙을 [Ventoy 공식 Auto Install 문서](https://www.ventoy.net/en/plugin_autoinstall.html)와 대조하세요.

## Unattend가 적용되지 않음

선택한 프로파일 경로, XML 구문, UTF-8 저장, 실제 Windows 버전과 Microsoft Unattend 설정 유효성을 확인하세요. 이 키트의 정적 검증은 Windows Setup의 수용 여부를 증명하지 않습니다.

## MemTest 이미지가 보이지 않거나 부팅되지 않음

PassMark MemTest86과 Memtest86+는 다른 제품입니다. 공식 다운로드 패키지에서 부팅 이미지 형식을 확인하고 현재 Ventoy의 해당 이미지 호환성을 확인하세요.

## Secure Boot에서 부팅되지 않음

[Ventoy 공식 Secure Boot 안내](https://www.ventoy.net/en/doc_secure.html)에 따라 사용 중인 펌웨어와 Ventoy 버전의 절차를 확인하세요.
