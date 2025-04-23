# 📱 포켓몬 연락처 앱

랜덤 포켓몬 이미지를 이용해 개성 있는 연락처를 만들고 관리할 수 있는 iOS 앱입니다.  
Alamofire를 사용해 포켓몬 API에서 이미지를 받아오고, CoreData로 로컬에 연락처 정보를 저장합니다.  
모든 UI는 코드 베이스로 구현되었습니다.

---

## 📸 스크린샷

<p align="center">
  <img src="https://github.com/user-attachments/assets/24913df9-eb23-4685-949e-0cd9636efc13" width="600"/>
</p>


---

## 🚀 주요 기능

- 포켓몬 API를 활용해 랜덤 프로필 이미지 적용
- 연락처 추가 / 편집 / 삭제 기능
- CoreData를 이용한 로컬 저장
- 이름순 정렬 기능
- UITableView를 활용한 목록 UI 구성

---

## 🔧 사용 기술

- `Swift`
- `UIKit`
- `Alamofire` – 네트워크 통신
- `CoreData` – 로컬 데이터 저장
- `PokéAPI` – 포켓몬 이미지 가져오기  
- `Code Base UI` – 스토리보드 없이 전부 코드로 UI 구성

---

## ✅ 요구사항 구현 목록

- [x] **1. 메인 화면**: 친구 목록 화면 UI 기본 구현
- [x] **2. 연락처 추가/편집 화면 UI** 구현
- [x] **3. 네비게이션 바**: 연락처 추가/편집 화면 상단 영역 구현
- [x] **4. 랜덤 프로필 이미지**: 포켓몬 API 연결 및 버튼 구현
- [x] **5. 데이터 저장 (Create)**: 이름, 전화번호, 프로필 이미지 저장 및 테이블 뷰 적용
- [x] **6. 데이터 정렬**: 메인 화면 진입 시 이름순 정렬
- [x] **7. 연락처 상세 보기 및 편집**: 셀 클릭 시 데이터 불러오기 및 타이틀 반영
- [x] **8. 데이터 업데이트 (Update)**: 기존 데이터 편집 및 적용

---

## 📦 설치 및 실행 방법

```bash
git clone https://github.com/yourusername/pokemon-contacts-app.git
cd pokemon-contacts-app
open PokemonContacts.xcodeproj
