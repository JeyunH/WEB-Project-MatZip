<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 태그 속성 정의 --%>
<%@ attribute name="paging" required="true" type="kr.ac.kopo.vo.PaginationVO" description="페이지네이션 정보 객체" %>
<%@ attribute name="baseUrl" required="true" type="java.lang.String" description="기본 URL" %>
<%@ attribute name="pageParamName" required="true" type="java.lang.String" description="페이지 번호 파라미터 이름" %>
<%@ attribute name="otherParams" required="false" type="java.lang.String" description="유지할 다른 파라미터들 (예: &key=value)" %>

<div class="pagination">
    <c:if test="${paging.totalCount > 0}">
        
        <%-- 맨 처음으로 --%>
        <c:if test="${paging.currentPage > 1}">
            <a href="${baseUrl}?${pageParamName}=1${otherParams}">&laquo;</a>
        </c:if>

        <%-- 이전 페이지로 --%>
        <c:if test="${paging.currentPage > 1}">
            <a href="${baseUrl}?${pageParamName}=${paging.currentPage - 1}${otherParams}">&lt;</a>
        </c:if>

        <%-- 페이지 번호 목록 --%>
        <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
            <a href="${baseUrl}?${pageParamName}=${i}${otherParams}" class="${i == paging.currentPage ? 'active' : ''}">${i}</a>
        </c:forEach>

        <%-- 다음 페이지로 --%>
        <c:if test="${paging.currentPage < paging.totalPage}">
            <a href="${baseUrl}?${pageParamName}=${paging.currentPage + 1}${otherParams}">&gt;</a>
        </c:if>

        <%-- 맨 끝으로 --%>
        <c:if test="${paging.currentPage < paging.totalPage}">
            <a href="${baseUrl}?${pageParamName}=${paging.totalPage}${otherParams}">&raquo;</a>
        </c:if>
        
    </c:if>
</div>
