<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<div class="form-card">
    <h2>프로필 수정</h2>

    <form action="${pageContext.request.contextPath}/member/editProfile.do" method="post">
        <label for="nickname">닉네임</label>
        <input type="text" id="nickname" name="nickname" value="${loginUser.nickname}" required>

        <label for="email">이메일</label>
        <input type="email" id="email" name="email" value="${loginUser.email}" required>

        <button type="submit" class="btn btn-main" style="width:100%; margin-top:20px;">수정 완료</button>
    </form>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
