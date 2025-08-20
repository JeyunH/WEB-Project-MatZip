<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 이 페이지는 _layout.jsp를 통해 렌더링됩니다. --%>
<%-- 컨트롤러에서 아래의 속성들을 모델에 담아 전달해야 합니다. --%>
<%-- pageTitle, itemUnit, searchPlaceholder, searchUrl, showStatusFilter, tableContentJsp, paging, keyword, selectedStatus --%>

<c:set var="activeMenu" value="reportList" scope="request"/>
<c:set var="tableContentJsp" value="/WEB-INF/jsp/admin/_reportTable.jsp" scope="request" />
<c:set var="additionalScriptJsp" value="/WEB-INF/jsp/admin/_reportScript.jsp" scope="request" />

<%@ include file="/WEB-INF/jsp/admin/_layout.jsp" %>
