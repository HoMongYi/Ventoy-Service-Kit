# USB 배치

저장소의 `usb-template/` **내용물**을 Ventoy 데이터 파티션 루트에 복사합니다. 사용자가 직접 받은 부팅 이미지는 아래 위치에 넣습니다.

```text
Ventoy data partition/
├─ ISO/
│  ├─ Windows/                 Windows 11/10 ISO
│  └─ Linux/
│     ├─ Ubuntu/
│     ├─ Debian/
│     ├─ Fedora/
│     └─ Other/
├─ Diagnostics/
│  └─ Memory/
│     ├─ MemTest86/            PassMark 이미지
│     └─ Memtest86Plus/        별도 오픈소스 이미지
└─ ventoy/
   ├─ ventoy.json
   └─ profiles/windows/
      ├─ service-standard-kokr.xml
      └─ service-custom.xml
```

이미지 파일명은 임의로 정할 수 있습니다. 메뉴는 실제 파일명이 보이는 Ventoy 기본 탐색을 사용합니다. 폴더별 안내용 README 파일은 Ventoy 부팅 이미지가 아닙니다.
