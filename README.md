## 커밋 메시지 규칙
커밋 메시지는 아래 형식을 준수합니다:

```
<type>(<scope>): <subject>	# 헤더
<BLANK LINE>
<body>						# 본문(생략 가능)
<BLANK LINE>
<footer>					# 바닥글


ex)
feat: SNS 로그인 개발

카카오 로그인, 애플 로그인 개발 및 로직 수정

close #{3}

```

<br>

## Commit 메시지 컨벤션
- **feat**: 새로운 기능 추가  
- **fix**: 버그 수정  
- **docs**: 문서 수정  
- **style**: 코드 스타일 변경 (포매팅, 세미콜론 누락 등)  
- **refactor**: 코드 리팩토링 (기능 변화 없음)  
- **test**: 테스트 코드 추가 또는 수정  
- **chore**: 기타 변경사항 (빌드 시스템, 패키지 설정 등)

<br>

## Branch 이름 규칙
- master branch
  - 배포용 브랜치
- develop branch
  - 다음 출시 버전 개발 브랜치
- feature branch
  - 기능을 개발하는 브랜치
  - feature/기능요약 ex) feature/sns-login
- release branch (사용 안함)
  - 이번 출시 버전을 준비하는 브랜치
- hotfix branch (추후 사용 예정)
  - 출시 버전에서 발생한 버그를 수정하는 브랜치







