<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<div class="form-card">
    <h2>회원가입</h2>
    <form action="${pageContext.request.contextPath}/member/join.do" method="post" onsubmit="return validateForm();">
		
        <%-- redirect 파라미터가 있으면, 그 값을 form과 함께 전송하기 위한 hidden input --%>
        <c:if test="${not empty param.redirect}">
            <input type="hidden" name="redirect" value="${param.redirect}">
        </c:if>

        <label for="id">아이디</label>
        <div class="input-group"> <%-- [추가] input과 button을 그룹화 --%>
            <input type="text" id="id" name="id" required />
            <button type="button" onclick="checkId()" class="btn">중복확인</button>
        </div>
        <span id="idCheckResult"></span> <%-- [수정] 위치 변경 및 스타일 클래스화 --%>

        <label for="password">비밀번호</label>
        <input type="password" id="password" name="password" required>

        <label for="nickname">닉네임</label>
        <input type="text" id="nickname" name="nickname" required>

        <label for="email">이메일</label>
        <input type="email" id="email" name="email">

        <button type="submit" class="btn btn-main" style="width:100%; margin-top: 20px;">회원가입</button>
	    
        <div class="link-row">
	      <a href="${pageContext.request.contextPath}/member/login.do">이미 계정이 있으신가요?</a>
	    </div>
    </form>
</div>

<script>
// 기존 스크립트는 유지
let isIdChecked = false;

function checkId() {
    const id = document.getElementById("id").value.trim();
    const ctx = '${pageContext.request.contextPath}';
    if (!id) {
        alert("아이디를 입력하세요.");
        return;
    }

    fetch(ctx + "/member/checkId.do?id=" + encodeURIComponent(id))
        .then(res => res.text())
        .then(msg => {
            const result = document.getElementById("idCheckResult");
            if (msg === "OK") {
                result.innerText = "사용 가능한 아이디입니다.";
                result.className = 'success'; // [수정] 클래스로 상태 표시
                isIdChecked = true;
            } else {
                result.innerText = "이미 사용 중입니다.";
                result.className = 'error'; // [수정] 클래스로 상태 표시
                isIdChecked = false;
            }
        });
}

function validateForm() {
    if (!isIdChecked) {
        alert("아이디 중복체크를 해주세요.");
        return false;
    }
    return true;
}
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
