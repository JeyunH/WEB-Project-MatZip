<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<table class="user-table">
    <thead>
        <tr>
            <th>리뷰ID</th>
            <th>식당명</th>
            <th>작성자</th>
            <th style="width: 30%;">내용</th>
            <th>별점</th>
            <th>작성일</th>
            <th>이미지</th>
            <th>관리</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${not empty reviewList}">
                <c:forEach var="review" items="${reviewList}">
                    <tr>
                        <td><a href="${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${review.restaurantId}#review-${review.reviewId}" target="_blank" title="새 탭에서 해당 리뷰 위치로 이동">${review.reviewId}</a></td>
                        <td><a href="${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${review.restaurantId}" target="_blank" title="새 탭에서 식당 보기">${review.restaurantName}</a></td>
                        <td>${review.nickname} (${review.memberId})</td>
                        <td class="review-content">${review.content}</td>
                        <td>
                            <div class="star-rating-display">
                                <div class="star-rating-fill" style="width: ${review.starScore * 20}%;">★★★★★</div>
                                <div class="star-rating-base">☆☆☆☆☆</div>
                            </div>
                            <span class="star-score-text">(<fmt:formatNumber value="${review.starScore}" pattern="0.0" />)</span>
                        </td>
                        <td><fmt:formatDate value="${review.regdate}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td class="review-images">
                            <c:choose>
                                <c:when test="${not empty review.imageList}">
                                    <c:forEach var="image" items="${review.imageList}">
                                        <c:url value="${image.imageUrl}" var="finalImageUrl"/>
                                        <img src="${finalImageUrl}" alt="리뷰 이미지" class="thumbnail">
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <span class="no-image">-</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form method="POST" action="${pageContext.request.contextPath}/admin/deleteReview.do" style="display:none;" id="deleteForm_${review.reviewId}">
                                <input type="hidden" name="reviewId" value="${review.reviewId}">
                            </form>
                            <button class="btn btn-sm btn-danger" 
                                    onclick="showSystemAlert({
                                        message: '리뷰ID [${review.reviewId}]를 정말로 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.',
                                        onConfirm: () => document.getElementById('deleteForm_${review.reviewId}').submit()
                                    });">삭제</button>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="8" class="no-data">검색 결과가 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </tbody>
</table>

<!-- [추가] 이미지 모달 (확대 기능) -->
<div id="imageModal" class="modal">
    <span class="modal-close">&times;</span>
    <button class="modal-button left">&#10094;</button>
    <div class="modal-content">
        <img id="modalImg" src="">
    </div>
    <button class="modal-button right">&#10095;</button>
</div>
