<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>

<%-- ==================================================================================
    관리자 페이지 공통 레이아웃 (_layout.jsp)
    - 이 레이아웃을 사용하는 페이지는 아래 파라미터들을 컨트롤러에서 모델에 담아 전달해야 합니다.
    - pageTitle: (String) 페이지 제목 (예: "전체 회원 관리")
    - itemUnit: (String) 아이템 단위 이름 (예: "명", "개")
    - searchPlaceholder: (String) 검색창 placeholder 텍스트
    - searchUrl: (String) 검색 폼이 제출될 URL
    - showStatusFilter: (Boolean) 상태 필터(전체/활성/비활성) 표시 여부
    - tableContentJsp: (String) 실제 테이블 내용이 담긴 JSP 파일 경로
    - paging: (PaginationVO) 페이징 객체
    - keyword: (String) 현재 검색 키워드
    - selectedStatus: (String) 현재 선택된 상태
================================================================================== --%>

<c:set var="activeMenu" value="admin" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

<div class="container">
    <%-- 1. 페이지 제목 --%>
    <h2 class="center-title">${pageTitle}</h2>
    <p class="center-description">총 <fmt:formatNumber value="${paging.totalCount}" />${itemUnit}의 데이터가 있습니다.</p>

    <%-- 2. 검색 폼 --%>
    <div class="admin-search-container">
        <c:url var="formActionUrl" value="${searchUrl}" />
        <form action="${formActionUrl}" method="get" class="admin-search-form">
            <c:if test="${showStatusFilter}">
                <input type="hidden" name="status" value="${selectedStatus}">
            </c:if>
            <input type="text" name="keyword" value="${keyword}" placeholder="${searchPlaceholder}" class="admin-search-input">
            <button type="submit" class="btn btn-main">검색</button>
        </form>
    </div>

    <%-- 3. 상태 필터 (필요한 경우에만 표시) --%>
    <c:if test="${showStatusFilter}">
        <div class="admin-filter-container">
            <c:choose>
                <%-- 신고 관리 페이지 전용 필터 --%>
                <c:when test="${filterType == 'report'}">
                    <c:url var="urlAll" value="${searchUrl}"><c:param name="status" value="all"/><c:param name="keyword" value="${keyword}"/></c:url>
                    <button onclick="location.href='${urlAll}'" class="filter-btn ${selectedStatus == 'all' ? 'active' : ''}">전체</button>
                    
                    <c:url var="urlPending" value="${searchUrl}"><c:param name="status" value="PENDING"/><c:param name="keyword" value="${keyword}"/></c:url>
                    <button onclick="location.href='${urlPending}'" class="filter-btn ${selectedStatus == 'PENDING' ? 'active' : ''}">대기</button>
                    
                    <c:url var="urlProcessed" value="${searchUrl}"><c:param name="status" value="PROCESSED"/><c:param name="keyword" value="${keyword}"/></c:url>
                    <button onclick="location.href='${urlProcessed}'" class="filter-btn ${selectedStatus == 'PROCESSED' ? 'active' : ''}">승인</button>
                    
                    <c:url var="urlRejected" value="${searchUrl}"><c:param name="status" value="REJECTED"/><c:param name="keyword" value="${keyword}"/></c:url>
                    <button onclick="location.href='${urlRejected}'" class="filter-btn ${selectedStatus == 'REJECTED' ? 'active' : ''}">반려</button>
                </c:when>
                <%-- 그 외 공통 필터 (회원, 맛집 관리) --%>
                <c:otherwise>
                    <c:url var="urlAll" value="${searchUrl}"><c:param name="status" value="all"/><c:param name="keyword" value="${keyword}"/></c:url>
                    <button onclick="location.href='${urlAll}'" class="filter-btn ${selectedStatus == 'all' ? 'active' : ''}">전체</button>
                    
                    <c:url var="urlY" value="${searchUrl}"><c:param name="status" value="Y"/><c:param name="keyword" value="${keyword}"/></c:url>
                    <button onclick="location.href='${urlY}'" class="filter-btn ${selectedStatus == 'Y' ? 'active' : ''}">활성</button>
                    
                    <c:url var="urlN" value="${searchUrl}"><c:param name="status" value="N"/><c:param name="keyword" value="${keyword}"/></c:url>
                    <button onclick="location.href='${urlN}'" class="filter-btn ${selectedStatus == 'N' ? 'active' : ''}">비활성</button>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <%-- 3.1. 신규 등록 버튼 (맛집 관리 페이지에만 표시) --%>
    <c:if test="${pageTitle == '전체 맛집 관리'}">
        <div class="admin-action-container" style="margin-bottom: 20px; text-align: center;">
            <a href="${pageContext.request.contextPath}/admin/addRestaurant.do" class="btn btn-main" style="width: 30%">신규 맛집 등록</a>
        </div>
    </c:if>

    <%-- 4. 테이블 본문 (각 페이지에서 구현하여 전달) --%>
    <div class="table-container">
        <jsp:include page="${tableContentJsp}" />
    </div>

    <%-- 5. 페이지네이션 --%>
    <c:url var="paginationBaseUrl" value="${searchUrl}" />
    <mytag:pagination 
        paging="${paging}" 
        baseUrl="${paginationBaseUrl}"
        pageParamName="page"
        otherParams="&keyword=${keyword}${showStatusFilter ? '&status='.concat(selectedStatus) : ''}"
        />
    
    <%-- 6. 하단 링크 --%>
    <div class="back-link-container">
        <a href="${pageContext.request.contextPath}/admin/dashboard.do" class="btn btn-secondary">대시보드로 돌아가기</a>
    </div>
</div>

<%-- 리뷰 페이지의 이미지 모달 스크립트 등 추가적인 스크립트는 각 페이지에서 구현 --%>
<c:if test="${not empty additionalScriptJsp}">
    <jsp:include page="${additionalScriptJsp}" />
</c:if>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
