<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="activeMenu" value="admin" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<%-- Font Awesome 아이콘을 위한 링크 (header.jsp에 없다면 추가) --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

<div class="container">
    <h2 class="center-title">관리자 대시보드</h2>

    <div class="admin-dashboard">
        <div class="dashboard-welcome">
            <h3>환영합니다, ${loginUser.nickname}님!</h3>
            <p>이곳에서 MatZip의 사용자, 맛집, 리뷰 등 주요 데이터를 관리할 수 있습니다.</p>
        </div>

        <div class="admin-menu-grid">
            <a href="${pageContext.request.contextPath}/admin/userList.do" class="admin-menu-item">
                <i class="fa fa-users"></i>
                <h4>회원 관리</h4>
                <p>전체 회원 목록을 조회하고 관리합니다.</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/restaurantList.do" class="admin-menu-item">
                <i class="fa fa-cutlery"></i>
                <h4>맛집 관리</h4>
                <p>맛집 정보를 추가, 수정, 삭제합니다.</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/reviewList.do" class="admin-menu-item">
                <i class="fa fa-comments"></i>
                <h4>리뷰 관리</h4>
                <p>사용자가 작성한 리뷰를 관리합니다.</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/reportList.do" class="admin-menu-item">
                <i class="fa fa-flag"></i>
                <h4>신고 관리</h4>
                <p>사용자가 신고한 리뷰를 관리합니다.</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/statistics.do" class="admin-menu-item">
                <i class="fa fa-bar-chart"></i>
                <h4>통계</h4>
                <p>사이트 관련 통계를 확인합니다.</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>