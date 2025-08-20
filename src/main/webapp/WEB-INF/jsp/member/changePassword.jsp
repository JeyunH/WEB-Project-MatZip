<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<%-- [수정] .form-card 클래스를 적용하여 다른 폼들과 디자인 통일 --%>
<div class="form-card">
    <h2>비밀번호 변경</h2>

    <form action="${pageContext.request.contextPath}/member/changePassword.do" method="post">
        <label for="currentPassword">현재 비밀번호</label>
        <input type="password" id="currentPassword" name="currentPassword" required>

        <label for="newPassword">새 비밀번호</label>
        <input type="password" id="newPassword" name="newPassword" required>

        <button type="submit" class="btn btn-main" style="width:100%; margin-top:20px;">변경하기</button>
    </form>
</div>

<c:if test="${not empty msg}">
    <script>
        // 페이지 로드 시 'msg'가 있으면 시스템 알림을 띄웁니다.
        window.onload = function() {
            showSystemAlert({
                message: "${msg}",
                showCancel: false // 확인 버튼만 있는 알림창
            });
        };
    </script>
</c:if>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>