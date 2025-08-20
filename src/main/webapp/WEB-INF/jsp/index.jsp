<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<%-- 메인 배너 섹션 --%>
<div class="main-banner">
    <img src="${pageContext.request.contextPath}/resources/banner_img/banner_Image.png" alt="MatZip Banner">
    <div class="banner-text">
        <h1>맛있는 순간을 찾다</h1>
        <p>MatZip, 당신의 완벽한 한 끼를 위한 최고의 가이드.</p>
    </div>
</div>

<div class="container">
    <%-- 사이트 소개 섹션 --%>
    <div class="site-introduction">
        <h2>MatZip 주요 기능</h2>
        <div class="features-grid">
            <div class="feature-box" onclick="location.href='${pageContext.request.contextPath}/restaurant/list.do?focus=search'">
                <i class="fa fa-search"></i>
                <h3>맛집 검색</h3>
                <p>지역, 음식 종류, 가게 이름으로 원하는 맛집을 쉽게 찾아보세요.</p>
            </div>
            <div class="feature-box" onclick="location.href='${pageContext.request.contextPath}/restaurant/random.do'">
                <i class="fa fa-pencil-square-o"></i>
                <h3>솔직한 리뷰</h3>
                <p>다른 사용자들의 생생한 리뷰와 별점을 확인하고 직접 리뷰를 남겨보세요.</p>
            </div>
            
            <%-- 로그인 상태에 따라 동적으로 링크 변경 --%>
            <c:choose>
                <c:when test="${not empty loginUser}">
                    <%-- 로그인 상태: 마이페이지로 바로 이동 --%>
                    <div class="feature-box" onclick="location.href='${pageContext.request.contextPath}/member/mypage.do#favorites'">
                        <i class="fa fa-heart"></i>
                        <h3>나만의 찜 목록</h3>
                        <p>마음에 드는 맛집을 찜해서 나만의 맛집 리스트를 만들어 관리하세요.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <%-- 비로그인 상태: 로그인 페이지로 이동 (리다이렉트 URL에 #favorites 포함) --%>
                    <div class="feature-box" onclick="location.href='${pageContext.request.contextPath}/member/login.do?redirect=/member/mypage.do%23favorites'">
                        <i class="fa fa-heart"></i>
                        <h3>나만의 찜 목록</h3>
                        <p>마음에 드는 맛집을 찜해서 나만의 맛집 리스트를 만들어 관리하세요.</p>
                    </div>
                </c:otherwise>
            </c:choose>
            
        </div>
    </div>

    <!-- ▼▼▼▼▼ [수정] 주간 맛집 랭킹 섹션 (디자인 개선용) ▼▼▼▼▼ -->
    <div class="weekly-ranking-section">
        <h2>주간 맛집 랭킹</h2>
        <div class="ranking-grid">
            <!-- 1. 트렌디 맛집 -->
            <div class="ranking-category">
                <h3><i class="fa fa-rocket"></i> 모두의 위시리스트</h3>
                <p class="ranking-description">지난주, 가장 많은 회원이 '가고 싶다'고 찜했어요.</p>
                <c:choose>
                    <c:when test="${not empty trendyRestaurants}">
                        <c:forEach var="r" items="${trendyRestaurants}" varStatus="status">
                            <div class="ranking-card" onclick="location.href='${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${r.restaurantId}'">
                                <c:choose>
                                    <c:when test="${status.count == 1}"><span class="rank-badge gold">1</span></c:when>
                                    <c:when test="${status.count == 2}"><span class="rank-badge silver">2</span></c:when>
                                    <c:when test="${status.count == 3}"><span class="rank-badge bronze">3</span></c:when>
                                    <c:otherwise><span class="rank-badge">${status.count}</span></c:otherwise>
                                </c:choose>
                                <div class="ranking-card-img-wrapper">
                                    <c:choose>
                                        <c:when test="${not empty r.mainImgUrl1 and (fn:startsWith(r.mainImgUrl1, 'http') or fn:startsWith(r.mainImgUrl1, '//'))}">
                                            <img src="${r.mainImgUrl1}" alt="${r.name} 이미지">
                                        </c:when>
                                        <c:otherwise>
                                            <c:url value="${r.mainImgUrl1}" var="imgUrl"/>
                                            <img src="${imgUrl}" alt="${r.name} 이미지">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="ranking-card-info">
                                    <h4>${r.name}</h4>
                                    <p>${r.region} | ${r.category}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-ranking-data">아직 랭킹이 집계되지 않았어요.</div>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- 2. 뜨거운 감자 -->
            <div class="ranking-category">
                <h3><i class="fa fa-fire"></i> 이번 주, 가장 화제인 맛집</h3>
                <p class="ranking-description">좋든 싫든, 지난주 가장 많은 이야기가 오고 간 곳이에요.</p>
                <c:choose>
                    <c:when test="${not empty hotRestaurants}">
                        <c:forEach var="r" items="${hotRestaurants}" varStatus="status">
                            <div class="ranking-card" onclick="location.href='${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${r.restaurantId}'">
                                <c:choose>
                                    <c:when test="${status.count == 1}"><span class="rank-badge gold">1</span></c:when>
                                    <c:when test="${status.count == 2}"><span class="rank-badge silver">2</span></c:when>
                                    <c:when test="${status.count == 3}"><span class="rank-badge bronze">3</span></c:when>
                                    <c:otherwise><span class="rank-badge">${status.count}</span></c:otherwise>
                                </c:choose>
                                <div class="ranking-card-img-wrapper">
                                    <c:choose>
                                        <c:when test="${not empty r.mainImgUrl1 and (fn:startsWith(r.mainImgUrl1, 'http') or fn:startsWith(r.mainImgUrl1, '//'))}">
                                            <img src="${r.mainImgUrl1}" alt="${r.name} 이미지">
                                        </c:when>
                                        <c:otherwise>
                                            <c:url value="${r.mainImgUrl1}" var="imgUrl"/>
                                            <img src="${imgUrl}" alt="${r.name} 이미지">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="ranking-card-info">
                                    <h4>${r.name}</h4>
                                    <p>${r.region} | ${r.category}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-ranking-data">아직 랭킹이 집계되지 않았어요.</div>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- 3. 꾸준한 맛집 -->
            <div class="ranking-category">
                <h3><i class="fa fa-star"></i> 별점이 증명하는 찐맛집</h3>
                <p class="ranking-description">맛은 보장! 지난주, 가장 높은 만족도를 기록했어요.</p>
                <c:choose>
                    <c:when test="${not empty steadyRestaurants}">
                        <c:forEach var="r" items="${steadyRestaurants}" varStatus="status">
                            <div class="ranking-card" onclick="location.href='${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${r.restaurantId}'">
                                <c:choose>
                                    <c:when test="${status.count == 1}"><span class="rank-badge gold">1</span></c:when>
                                    <c:when test="${status.count == 2}"><span class="rank-badge silver">2</span></c:when>
                                    <c:when test="${status.count == 3}"><span class="rank-badge bronze">3</span></c:when>
                                    <c:otherwise><span class="rank-badge">${status.count}</span></c:otherwise>
                                </c:choose>
                                <div class="ranking-card-img-wrapper">
                                    <c:choose>
                                        <c:when test="${not empty r.mainImgUrl1 and (fn:startsWith(r.mainImgUrl1, 'http') or fn:startsWith(r.mainImgUrl1, '//'))}">
                                            <img src="${r.mainImgUrl1}" alt="${r.name} 이미지">
                                        </c:when>
                                        <c:otherwise>
                                            <c:url value="${r.mainImgUrl1}" var="imgUrl"/>
                                            <img src="${imgUrl}" alt="${r.name} 이미지">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="ranking-card-info">
                                    <h4>${r.name}</h4>
                                    <p>${r.region} | ${r.category}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-ranking-data">아직 랭킹이 집계되지 않았어요.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <!-- ▲▲▲▲▲ 여기까지 수정 ▲▲▲▲▲ -->
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
