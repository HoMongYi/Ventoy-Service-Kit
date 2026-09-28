# Ventoy 설정

`ventoy.json`은 Ventoy 데이터 파티션의 `/ventoy/`에 있어야 합니다. Windows 프로파일은 `profiles/windows/`에 둡니다. ISO/IMG는 이 폴더가 아니라 USB의 `ISO/` 또는 `Diagnostics/`에 넣습니다.

설정은 텍스트 편집기나 [VentoyPlugson 공식 안내](https://www.ventoy.net/en/plugin_plugson.html)를 참고해 수정할 수 있습니다. VentoyPlugson은 필수가 아닙니다. JSON과 XML을 수정한 뒤 `Test-ServiceKit.ps1`로 정적 검증하세요.
