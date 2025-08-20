<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<table class="user-table">
    <thead>
        <tr>
            <th>ID</th>
            <th>상호명</th>
            <th>지역</th>
            <th>카테고리</th>
            <th>별점</th>
            <th>리뷰 수</th>
            <th>상태</th>
            <th>관리</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${not empty restaurantList}">
                <c:forEach var="r" items="${restaurantList}">
                    <tr>
                        <td><a href="${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${r.restaurantId}" target="_blank">${r.restaurantId}</a></td>
                        <td>${r.name}</td>
                        <td>${r.region}</td>
                        <td>${r.category}</td>
                        <td><fmt:formatNumber value="${r.starScore}" pattern="0.0" /></td>
                        <td><fmt:formatNumber value="${r.reviewCount}" pattern="#,##0" /></td>
                        <td>
                            <span class="status-badge status-${r.status == 'Y' ? 'active' : 'inactive'}">
                                ${r.status == 'Y' ? '활성' : '비활성'}
                            </span>
                        </td>
                        <td>
                            <button type="button" class="btn btn-sm btn-secondary" onclick="location.href='${pageContext.request.contextPath}/admin/editRestaurant.do?restaurantId=${r.restaurantId}'">수정</button>
                            
                            <form method="POST" action="${pageContext.request.contextPath}/admin/updateRestaurantStatus.do" style="display:none;" id="statusForm_${r.restaurantId}">
                                <input type="hidden" name="restaurantId" value="${r.restaurantId}">
                                <input type="hidden" name="status" value="${r.status == 'Y' ? 'N' : 'Y'}">
                            </form>

                            <c:choose>
                                <c:when test="${r.status == 'Y'}">
                                    <button class="btn btn-sm btn-danger"
                                            onclick="showSystemAlert({
                                                message: '[${r.name}] 맛집을 비활성 상태로 변경하시겠습니까?',
                                                onConfirm: () => document.getElementById('statusForm_${r.restaurantId}').submit()
                                            });">비활성화</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-sm btn-main"
                                            onclick="showSystemAlert({
                                                message: '[${r.name}] 맛집을 활성 상태로 변경하시겠습니까?',
                                                onConfirm: () => document.getElementById('statusForm_${r.restaurantId}').submit()
                                            });">활성화</button>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="8" class="no-data">맛집 정보가 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </tbody>
</table>
