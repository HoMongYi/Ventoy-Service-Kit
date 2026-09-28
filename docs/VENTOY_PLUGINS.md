# Ventoy 플러그인

USB 데이터 파티션의 `/ventoy/ventoy.json`이 설정 진입점입니다. v0.1.0은 Auto Install을 사용합니다.

```json
{
  "auto_install": [
    {
      "parent": "/ISO/Windows",
      "template": [
        "/ventoy/profiles/windows/service-standard-kokr.xml",
        "/ventoy/profiles/windows/service-custom.xml"
      ],
      "autosel": 0,
      "timeout": 0
    }
  ]
}
```

Ventoy의 `parent`는 해당 디렉터리의 이미지에 적용되어 ISO 파일명을 고정하지 않아도 됩니다. `autosel: 0`은 자동 템플릿 선택을 하지 않고, `timeout: 0`은 선택 메뉴에서 기다립니다. Ventoy의 일반 부팅 항목을 사용하므로 가짜 일반 설치 프로파일은 없습니다. 프로파일이 실제 Windows Setup에서 적용되는지는 별도 테스트가 필요합니다.

Ventoy의 `*`는 일반 shell glob이 아니며 별표 하나가 파일명의 한 글자에 대응합니다. 그래서 `*.iso`를 모든 ISO에 적용하는 규칙으로 사용하지 않습니다. [Path Matching 공식 문서](https://www.ventoy.net/en/plugin_path_match.html)

Variables Expansion은 Ventoy 1.0.77부터 문서화되어 있습니다. `$$USERNAME$$` 같은 사용자 변수는 부팅 중 입력을 받으며, 변수명은 영문·숫자·밑줄만 쓰고 63자보다 짧아야 합니다. UTF-8 템플릿의 한 줄에 변수를 하나만 둡니다. [Auto Install 공식 문서](https://www.ventoy.net/en/plugin_autoinstall.html)

Menu Alias와 Menu Tip은 Windows/Linux/Memory **디렉터리 항목**에 짧은 이름과 설명을 붙입니다. 이미지 파일명은 바꾸지 않습니다. 디렉터리 항목이 보이는 탐색 방식에서만 효과를 기대할 수 있습니다. 두 플러그인은 `image` 또는 `dir`을 지원하지만 이미지용 `parent` 매칭은 제공하지 않으므로 파일명별 고정 규칙을 넣지 않았습니다. Menu Class는 `parent`를 지원하지만 아이콘 리소스가 필요한 테마를 이 버전에 포함하지 않아 적용하지 않았습니다. 기본 Ventoy UI로 동작합니다. [Alias](https://www.ventoy.net/en/plugin_menualias.html) · [Class](https://www.ventoy.net/en/plugin_menuclass.html) · [Tip](https://www.ventoy.net/en/plugin_menutip.html)

Ventoy는 ISO, WIM, IMG, VHD/VHDX, EFI 이미지 형식을 안내합니다. 이 키트의 배치 안내는 주로 ISO/IMG에 초점을 맞춥니다. 개별 이미지의 실제 호환성은 별도 확인해야 합니다. [Ventoy 공식 사이트](https://www.ventoy.net/en/index.html)

[VentoyPlugson](https://www.ventoy.net/en/plugin_plugson.html)은 선택적 GUI 편집 도구입니다. USB의 설정을 수정할 때 기존 파일 백업과 변경 이력을 직접 확인하세요.
