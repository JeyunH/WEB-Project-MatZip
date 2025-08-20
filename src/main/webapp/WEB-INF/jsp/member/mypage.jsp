<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<div class="container">
    <h2 class="center-title">마이페이지</h2>
    
    <div class="profile-card">
        <div class="profile-icon">
            <i class="fa fa-user-circle-o"></i>
        </div>
        <div class="profile-details">
            <div class="profile-info-item">
                <span class="label">닉네임</span>
                <span class="value">${loginUser.nickname}</span>
            </div>
            <div class="profile-info-item">
                <span class="label">아이디</span>
                <span class="value">${loginUser.id}</span>
            </div>
            <div class="profile-info-item">
                <span class="label">이메일</span>
                <span class="value">${loginUser.email}</span>
            </div>
        </div>
        <div class="profile-actions">
            <a href="${pageContext.request.contextPath}/member/editProfile.do" class="btn btn-main">프로필 수정</a>
            <a href="${pageContext.request.contextPath}/member/changePassword.do" class="btn btn-secondary">비밀번호 변경</a>
            <a href="${pageContext.request.contextPath}/member/deleteAccount.do" 
               id="deleteAccountBtn"
               class="btn btn-danger">회원 탈퇴</a>
        </div>
    </div>

    <hr>

    <h3 class="center-title" id="favorites">❤️ 찜한 맛집 목록</h3>
    <c:choose>
      <c:when test="${empty favoriteList}">
        <p style="text-align:center;">찜한 맛집이 없습니다.</p>
      </c:when>
      <c:otherwise>
        <%-- [수정] list.jsp와 동일한 클래스 구조 적용 --%>
        <div class="restaurant-list">
          <c:forEach var="res" items="${favoriteList}">
            <div class="restaurant-card"
                 onclick="location.href='${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${res.restaurantId}'">
              
                <%-- 웹 URL과 로컬 경로를 모두 처리 --%>
                <c:choose>
                    <c:when test="${not empty res.mainImgUrl1 and (fn:startsWith(res.mainImgUrl1, 'http') or fn:startsWith(res.mainImgUrl1, '//'))}">
                        <img src="${res.mainImgUrl1}" alt="${res.name} 대표 이미지">
                    </c:when>
                    <c:otherwise>
                        <c:url value="${res.mainImgUrl1}" var="imgUrl"/>
                        <img src="${imgUrl}" alt="${res.name} 대표 이미지">
                    </c:otherwise>
                </c:choose>
                <h3>${res.name}</h3>
                <p>${res.region} | ${res.category}</p>
                <p class="score">⭐ ${res.starScore}, 리뷰: ${res.reviewCount}</p>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>   
</div>
   
<script>
document.addEventListener('DOMContentLoaded', function() {
    // 회원 탈퇴 버튼 이벤트
    const deleteBtn = document.getElementById('deleteAccountBtn');
    if (deleteBtn) {
        deleteBtn.addEventListener('click', function(e) {
            e.preventDefault(); // 링크의 기본 이동 방지
            const deleteUrl = this.href;
            showSystemAlert({
                message: '정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.',
                onConfirm: () => { window.location.href = deleteUrl; }
            });
        });
    }

    // 서버 메시지(알림창) 처리
    <c:if test="${not empty msg}">
        showSystemAlert({
            message: "${msg}",
            showCancel: false
        });
    </c:if>
});
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>