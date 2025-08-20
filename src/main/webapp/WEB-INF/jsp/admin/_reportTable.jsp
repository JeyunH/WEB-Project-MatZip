<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<table class="admin-table">
    <thead>
        <tr>
            <th>신고 ID</th>
            <th>신고 사유</th>
            <th>리뷰 ID</th>
            <th>신고자</th>
            <th>신고 분류</th>
            <th>신고일</th>
            <th>상태</th>
            <th>관리</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${empty reportList}">
                <tr>
                    <td colspan="8" class="no-data">신고 내역이 없습니다.</td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="report" items="${reportList}">
                    <tr>
                        <td>${report.reportId}</td>
                        <td class="review-content" title="${report.reportContent}">
                            <c:out value="${report.reportContent}" />
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${report.restaurantId}#review-${report.reviewId}" target="_blank">
                                ${report.reviewId}
                            </a>
                        </td>
                        <td>${report.memberNickname} (${report.memberId})</td>
                        <td>
                            <span class="badge category-${report.reportCategory}">
                                ${report.reportCategory}
                            </span>
                        </td>
                        <td><fmt:formatDate value="${report.reportDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>
                            <span class="badge status-${report.status}">
                                ${report.status}
                            </span>
                        </td>
                        <td>
                            <c:if test="${report.status == 'PENDING'}">
                                <button class="btn btn-sm btn-main" onclick="updateStatus(${report.reportId}, 'PROCESSED')">승인</button>
                                <button class="btn btn-sm btn-secondary" onclick="updateStatus(${report.reportId}, 'REJECTED')">반려</button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </tbody>
</table>
