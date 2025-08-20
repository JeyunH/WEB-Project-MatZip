<div align="center">
  <img src="./etc/banner.PNG" alt="preview" width="320px" height="80px" />
  <br />
  <h2> 맛있는 순간을 찾다, MatZip(맛집)</h2>
</div>

## 1. 프로젝트 소개

맛집 추천 및 리뷰 웹사이트 프로젝트입니다. 사용자들은 음식점을 검색하고, 리뷰를 작성하며, 즐겨찾기에 추가할 수 있습니다. 관리자는 사용자, 음식점, 리뷰 등을 관리할 수 있는 대시보드를 제공받습니다.

<br>

## 2. 기술 스택

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring](https://img.shields.io/badge/Spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white)
![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![MyBatis](https://img.shields.io/badge/MyBatis-000000?style=for-the-badge&logo=mybatis&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=jee&logoColor=white)
![Maven](https://img.shields.io/badge/Maven-C71A36?style=for-the-badge&logo=apachemaven&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)

<br>

## 3. 주요 기능

### 사용자 기능
* 회원가입 및 로그인
* 음식점 검색 및 상세 정보 조회
* 리뷰 작성, 수정, 삭제
* 즐겨찾는 음식점 등록 및 관리
* 마이페이지 (내 정보 수정, 비밀번호 변경)

### 관리자 기능
* 대시보드
* 회원 관리 (조회, 상태 변경)
* 음식점 정보 관리 (등록, 수정, 삭제)
* 리뷰 관리 (조회, 삭제)
* 신고된 리뷰 관리

<br>

## 4. 실행 방법

1.  **데이터베이스 설정**:
    * `sql/` 디렉토리의 `.sql` 파일을 사용하여 Oracle 데이터베이스에 테이블과 시퀀스를 생성합니다.

2.  **API Key 설정**:
    * `src/main/resources/api.properties.example` 파일을 복사하여 `api.properties` 파일을 생성합니다.
    * 생성된 `api.properties` 파일에 필요한 API 키 (예: 지도 API)를 입력합니다.

3.  **프로젝트 빌드**:
    * Maven을 사용하여 프로젝트를 빌드합니다.
    ```shell
    mvn clean install
    ```

4.  **서버 배포**:
    * 생성된 `target/*.war` 파일을 Apache Tomcat 서버에 배포하여 실행합니다.

<br>

## 5. 프로젝트 구조
MatZip-WEB-Project/
├── pom.xml
├── sql/                  -- DB 스키마 및 데이터
├── src/
│   ├── main/
│   │   ├── java/         -- Java 소스 코드 (Controller, Service, DAO, VO)
│   │   ├── resources/    -- MyBatis 매퍼, 설정 파일
│   │   └── webapp/
│   │       ├── resources/  -- CSS, JavaScript, 이미지
│   │       └── WEB-INF/
│   │           ├── jsp/      -- JSP 뷰 파일
│   │           └── ...       -- Spring 설정 파일
│   └── test/
└── target/               -- 빌드 결과물