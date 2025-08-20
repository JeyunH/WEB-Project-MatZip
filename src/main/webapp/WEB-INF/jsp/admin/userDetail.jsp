<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="activeMenu" value="admin" scope="request"/>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

<c:set var="activeTab" value="${empty param.activeTab ? 'reviews' : param.activeTab}" />

<div class="container">
    <h2 class="center-title">회원 상세 정보</h2>
    
    <!-- 회원 기본 정보 -->
    <div class="detail-section">
        <h3 class="section-title">기본 정보</h3>
        <table class="detail-view-table">
            <tr>
                <th>아이디</th>
                <td>${member.id}</td>
            </tr>
            <tr>
                <th>닉네임</th>
                <td>${member.nickname}</td>
            </tr>
            <tr>
                <th>이메일</th>
                <td>${member.email}</td>
            </tr>
            <tr>
                <th>가입일</th>
                <td><fmt:formatDate value="${member.regdate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
            <tr>
                <th>상태</th>
                <td>
                    <span class="status-badge status-${member.status == 'Y' ? 'active' : 'inactive'}">
                        ${member.status == 'Y' ? '활성' : '탈퇴'}
                    </span>
                </td>
            </tr>
            <tr>
                <th>유형</th>
                <td>
                    <span class="type-badge type-${member.type}">
                        ${member.type}
                    </span>
                </td>
            </tr>
        </table>
    </div>

    <!-- 탭 메뉴 -->
    <ul class="nav nav-tabs" id="myTab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link ${activeTab == 'reviews' ? 'active' : ''}" id="reviews-tab" data-bs-target="#reviews" type="button" role="tab">
                작성한 리뷰 <span class="count-badge">${reviewPaging.totalCount}</span>
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link ${activeTab == 'favorites' ? 'active' : ''}" id="favorites-tab" data-bs-target="#favorites" type="button" role="tab">
                찜한 가게 <span class="count-badge">${favPaging.totalCount}</span>
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link ${activeTab == 'logs' ? 'active' : ''}" id="logs-tab" data-bs-target="#logs" type="button" role="tab">
                상태 변경 로그 <span class="count-badge">${logCount}</span>
            </button>
        </li>
    </ul>

    <!-- 탭 콘텐츠 -->
    <div class="tab-content" id="myTabContent">
        <!-- 작성한 리뷰 탭 -->
        <div class="tab-pane ${activeTab == 'reviews' ? 'active' : ''}" id="reviews" role="tabpanel">
            <div class="table-container">
                <table class="user-table">
                    <thead>
                        <tr>
                            <th>리뷰 ID</th>
                            <th>식당명</th>
                            <th>내용</th>
                            <th>별점</th>
                            <th>작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <c:forEach var="review" items="${reviews}">
                                    <tr>
                                        <td>${review.reviewId}</td>
                                        <td><a href="${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${review.restaurantId}" target="_blank">${review.restaurantName}</a></td>
                                        <td>${review.content}</td>
                                        <td>${review.starScore}</td>
                                        <td><fmt:formatDate value="${review.regdate}" pattern="yyyy-MM-dd"/></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="no-data">작성한 리뷰가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            
            <!-- 리뷰 목록 페이지네이션 -->
            <mytag:pagination 
                paging="${reviewPaging}" 
                baseUrl="${pageContext.request.contextPath}/admin/userDetail.do"
                pageParamName="reviewPage"
                otherParams="&id=${member.id}&favPage=${favPaging.currentPage}&page=${page}&keyword=${keyword}&status=${status}&activeTab=reviews"
                />
        </div>

        <!-- 찜한 가게 탭 -->
        <div class="tab-pane ${activeTab == 'favorites' ? 'active' : ''}" id="favorites" role="tabpanel">
            <div class="table-container">
                <table class="user-table">
                    <thead>
                        <tr>
                            <th>식당 ID</th>
                            <th>식당명</th>
                            <th>카테고리</th>
                            <th>주소</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty favorites}">
                                <c:forEach var="fav" items="${favorites}">
                                    <tr>
                                        <td>${fav.restaurantId}</td>
                                        <td><a href="${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${fav.restaurantId}" target="_blank">${fav.name}</a></td>
                                        <td>${fav.category}</td>
                                        <td>${fav.address}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="no-data">찜한 가게가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- 찜 목록 페이지네이션 -->
            <mytag:pagination
                paging="${favPaging}"
                baseUrl="${pageContext.request.contextPath}/admin/userDetail.do"
                pageParamName="favPage"
                otherParams="&id=${member.id}&reviewPage=${reviewPaging.currentPage}&page=${page}&keyword=${keyword}&status=${status}&activeTab=favorites"
                />
        </div>

        <!-- 상태 변경 로그 탭 -->
        <div class="tab-pane ${activeTab == 'logs' ? 'active' : ''}" id="logs" role="tabpanel">
            <c:choose>
                <c:when test="${not empty logList}">
                    <div class="table-container">
                        <table class="user-table">
                            <thead>
                                <tr>
                                    <th>로그 ID</th>
                                    <th>변경일</th>
                                    <th>처리 관리자</th>
                                    <th>상태 변경</th>
                                    <th style="width: 40%;">변경 사유</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="log" items="${logList}">
                                    <tr>
                                        <td>${log.logId}</td>
                                        <td><fmt:formatDate value="${log.logDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <td>${log.adminId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${log.previousStatus == 'Y'}">활성</c:when>
                                                <c:otherwise>비활성</c:otherwise>
                                            </c:choose>
                                            →
                                            <c:choose>
                                                <c:when test="${log.newStatus == 'Y'}">활성</c:when>
                                                <c:otherwise>비활성</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align: left;">${log.reason}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-data">상태 변경 로그가 없습니다.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="back-link-container">
        <c:url var="listUrl" value="/admin/userList.do">
            <c:param name="page" value="${page}" />
            <c:param name="keyword" value="${keyword}" />
            <c:param name="status" value="${status}" />
        </c:url>
        <a href="${listUrl}" class="btn btn-secondary">목록으로 돌아가기</a>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    const tabButtons = document.querySelectorAll('.nav-tabs .nav-link');
    const tabPanes = document.querySelectorAll('.tab-content .tab-pane');

    tabButtons.forEach(button => {
        button.addEventListener('click', function (event) {
            event.preventDefault();
            
            // 모든 탭 버튼과 패널에서 active 클래스 제거
            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabPanes.forEach(pane => pane.classList.remove('active'));

            // 클릭된 탭 버튼에 active 클래스 추가
            this.classList.add('active');

            // 연결된 탭 패널을 보여줌
            const targetPaneId = this.getAttribute('data-bs-target');
            const targetPane = document.querySelector(targetPaneId);
            if (targetPane) {
                targetPane.classList.add('active');
            }
        });
    });
});
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>

