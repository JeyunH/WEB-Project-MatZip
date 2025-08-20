<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav>
	<a href="${pageContext.request.contextPath}/main.do">메인</a> | 
	<a href="${pageContext.request.contextPath}/restaurant/list.do">맛집리스트</a> | 

	<c:choose>
		<c:when test="${not empty loginUser}">
			<a href="${pageContext.request.contextPath}/member/mypage.do">마이페이지</a> | 
			<a href="#" id="logoutBtn" onclick="handleLogout(event)">로그아웃</a> | 
			<span class="welcome-msg">${loginUser.nickname}님 환영합니다.</span>
        </c:when>
		<c:otherwise>
			<a href="${pageContext.request.contextPath}/member/join.do">회원가입</a> | 
			<a href="${pageContext.request.contextPath}/member/login.do">로그인</a>
		</c:otherwise>
	</c:choose>
</nav>

<script>
function handleLogout(event) {
    event.preventDefault(); // a 태그의 기본 동작(페이지 이동)을 막음

    const ctx = "${pageContext.request.contextPath}";
    const currentPage = window.location.pathname;
    
    // 로그인이 필요한 페이지 목록
    const privatePages = [
        ctx + "/member/mypage.do",
        ctx + "/member/changePassword.do"
        // 여기에 다른 로그인 전용 페이지 경로를 추가할 수 있습니다.
    ];

    if (privatePages.some(page => currentPage.startsWith(page))) {
        // 로그인 전용 페이지에 있을 경우, 시스템 알림을 띄우고 확인 시 메인으로 이동
        showSystemAlert({
            message: "로그아웃 후에는 접근할 수 없는 페이지입니다. 메인 페이지로 이동합니다.",
            showCancel: false, // 확인 버튼만 표시
            onConfirm: () => {
                window.location.href = ctx + "/member/logout.do"; // redirect 없이 로그아웃
            }
        });
    } else {
        // 그 외 일반 페이지에 있을 경우
        const redirectUrl = window.location.pathname + window.location.search;
        // context path를 제외한 순수 경로를 redirect 파라미터로 넘김
        const relativePath = redirectUrl.startsWith(ctx) ? redirectUrl.substring(ctx.length) : redirectUrl;
        window.location.href = ctx + "/member/logout.do?redirect=" + encodeURIComponent(relativePath);
    }
}
</script>