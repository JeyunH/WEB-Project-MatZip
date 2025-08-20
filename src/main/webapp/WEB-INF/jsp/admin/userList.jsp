<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%--
    이 페이지는 이제 레이아웃을 호출하는 역할만 담당합니다.
    모든 프레젠테이션 로직은 _layout.jsp와 _userTable.jsp에 위임됩니다.
    컨트롤러는 이 페이지로 포워딩하기 전에 아래의 모델 속성들을 설정해야 합니다.
    - pageTitle, itemUnit, searchPlaceholder, searchUrl, showStatusFilter, tableContentJsp 등
--%>

<c:set var="tableContentJsp" value="/WEB-INF/jsp/admin/_userTable.jsp" scope="request" />

<jsp:include page="/WEB-INF/jsp/admin/_layout.jsp" />
