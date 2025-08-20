<div align="center">
  <img src="./etc/banner.png" alt="banner" width="400px" />
  <br />
  <h2> 맛있는 순간을 찾다, MatZip(맛집)</h2>
  <img src="./etc/intro200.gif" alt="intro" width="800px" />
</div>

## 1. 프로젝트 개요

**MatZip**은 사용자 주변의 숨겨진 맛집을 발견하고, 자신의 미식 경험을 다른 사람들과 공유할 수 있는 **맛집 추천 및 리뷰 커뮤니티 웹 서비스**입니다. 단순한 정보 제공을 넘어, 사용자들이 '맛있는 순간'을 기록하고 연결되는 공간을 만드는 것을 목표로 합니다.

<br>

## 2. 주요 특징 (Key Features)

- **직관적인 맛집 정보**: 위치 기반 검색과 상세 필터를 통해 원하는 맛집을 쉽게 찾을 수 있습니다.
- **신뢰성 있는 정보**: 사용자들이 직접 작성한 리뷰와 별점을 통해 신뢰도 높은 정보를 제공합니다.
- **개인화된 경험**: '나만의 맛집 리스트'를 만들 수 있는 찜 기능을 지원합니다.
- **효율적인 관리**: 관리자에게는 사용자, 맛집, 리뷰 데이터를 한눈에 파악하고 관리할 수 있는 대시보드를 제공합니다.

<br>

## 3. 기술 스택 및 아키텍처

### Tech Stack
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring](https://img.shields.io/badge/Spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white)
![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![MyBatis](https://img.shields.io/badge/MyBatis-000000?style=for-the-badge&logo=mybatis&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=jee&logoColor=white)
![Maven](https://img.shields.io/badge/Maven-C71A36?style=for-the-badge&logo=apachemaven&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)

### Architecture
본 프로젝트는 **Spring MVC 프레임워크**를 기반으로 한 **MVC (Model-View-Controller) 패턴**을 따릅니다. 이를 통해 역할과 책임을 분리하여 코드의 재사용성과 유지보수성을 높였습니다.

| 구분 | 기술 | 설명 |
| :--: | :--: | :-- |
| **Presentation Layer** | `JSP`, `HTML`, `CSS`, `JavaScript` | 사용자 인터페이스 및 동적 웹 페이지 렌더링 |
| **Business Layer** | `Spring MVC`, `Java` | 비즈니스 로직 처리, Controller/Service 계층 구성 |
| **Persistence Layer** | `MyBatis`, `Oracle DB` | 데이터베이스 연동 및 영속성 관리 (DAO) |
| **Server** | `Apache Tomcat` | 웹 애플리케이션 서버 |
| **Build Tool** | `Maven` | 의존성 관리 및 프로젝트 빌드 |

<br>

## 4. 데이터 구축 (Data Construction)

본 프로젝트의 맛집, 리뷰 등 대용량의 초기 데이터는 **Python**을 사용하여 구축되었습니다.

- **수집**: 공공 데이터 포털 API 및 웹 크롤링을 통해 원시 데이터를 수집했습니다.
- **전처리 및 삽입**: 수집된 데이터를 정제하고, Oracle DB 구조에 맞게 가공하여 `cx_Oracle` 라이브러리를 통해 대량 삽입(Bulk Insert)을 진행했습니다.

**보안 및 정책상의 이유로 데이터 수집 및 삽입에 사용된 Python 코드는 저장소에 포함하지 않았습니다.** 대신, `sql/` 디렉토리에 DB 테이블과 시퀀스를 생성하는 `schema.sql` 파일을 제공합니다.

<br>

## 5. 프로젝트 구조
```
MatZip-WEB-Project/
├── pom.xml           # Maven 의존성 및 빌드 설정
├── sql/              # DB 스키마 및 데이터
│   └── MatZip4.sql   # 테이블 생성 스크립트
├── src/
│   ├── main/
│   │   ├── java/     # Java 소스 코드 (패키지별 분리)
│   │   │   └── kr/ac/kopo
│   │   │       ├── controller
│   │   │       ├── service
│   │   │       ├── dao
│   │   │       ├── vo
│   │   │       └── util
│   │   ├── resources/        # MyBatis 매퍼(XML), 프로퍼티 파일
│   │   └── webapp/
│   │       ├── resources/    # CSS, 이미지 등 정적 파일
│   │       └── WEB-INF/
│   │           ├── jsp/      # JSP 뷰 파일
│   │           ├── tags/     # 범용 tag 파일
│   │           ├── dispatcher-servlet.xml      # Spring Web Context 설정
│   │           └── web.xml   # 웹 애플리케이션 배포 서술자 (최초 진입점)
│   └── test/
└── target/                   # 빌드 결과물 (.war)
```
