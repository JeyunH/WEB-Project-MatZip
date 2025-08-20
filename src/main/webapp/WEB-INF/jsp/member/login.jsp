<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<div class="form-card">
    <h2>로그인</h2>

    <%-- 리다이렉트 메시지 또는 에러 메시지 표시 영역 --%>
    <c:if test="${not empty msg || not empty error}">
        <div class="alert-message">
            <c:if test="${not empty msg}">${msg}</c:if>
            <c:if test="${not empty error}">${error}</c:if>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/member/login.do" method="post">
        
        <%-- 컨트롤러에서 모델에 담아준 redirect 주소를 사용. 없으면 param 값 사용 --%>
        <input type="hidden" name="redirect" value="${not empty redirect ? redirect : param.redirect}"/>

        <label for="id">아이디</label>
        <input type="text" id="id" name="id" required>

        <label for="password">비밀번호</label>
        <input type="password" id="password" name="password" required>

        <button type="submit" class="btn btn-main" style="width: 100%; margin-top: 20px;">로그인</button>
        
        <div class="link-row">
            <a href="${pageContext.request.contextPath}/member/join.do?redirect=${param.redirect}">아직 회원이 아니신가요? 회원가입</a>
        </div>
    </form>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 컨트롤러에서 비활성화 사유를 전달받은 경우, 알림창을 띄웁니다.
    const reason = "${deactivationReason}";
    if (reason) {
        showSystemAlert({
            message: `계정이 비활성화되었습니다.\n사유: `+reason,
            showCancel: false // 확인 버튼만 표시
        });
    }
});
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
