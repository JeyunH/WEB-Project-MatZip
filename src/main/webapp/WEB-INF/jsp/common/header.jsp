<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/ico/favicon.ico/favicon.png">
	
    <title>MatZip</title>
    
    <%-- [수정] 흩어져 있던 CSS 링크를 통합된 main.css 하나로 변경 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
    
    <%-- FontAwesome 아이콘 CDN은 그대로 유지 --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">    
</head>
<body> <%-- [수정] body의 인라인 스타일 제거 --%>
<header class="main-header">
    <div class="header-content">
        <a href="${pageContext.request.contextPath}/main.do" class="logo">🍔 MatZip</a>
        
        <%-- 데스크탑용 검색창 (중앙 배치) --%>
        <div class="header-search">
            <form action="${pageContext.request.contextPath}/restaurant/list.do" method="get" class="header-search-form">
                <input type="text" name="keyword" placeholder="맛집, 지역, 카테고리 검색" class="header-search-input">
                <button type="submit" class="header-search-button"><i class="fa fa-search"></i></button>
            </form>
        </div>

        <nav class="main-nav">
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/restaurant/list.do" class="${activeMenu == 'list' ? 'active' : ''}">맛집리스트</a></li>
                <c:choose>
                    <c:when test="${not empty loginUser}">

                        <li><a href="${pageContext.request.contextPath}/member/mypage.do" class="${activeMenu == 'mypage' ? 'active' : ''}">마이페이지</a></li>
                        
                        <%-- ▼▼▼▼▼ [추가] 관리자일 경우 '관리자' 메뉴 표시 ▼▼▼▼▼ --%>
                        <c:if test="${sessionScope.loginUser.type == 'ADMIN'}">
                            <li><a href="${pageContext.request.contextPath}/admin/dashboard.do" class="${activeMenu == 'admin' ? 'active' : ''}">관리자</a></li>
                        </c:if>
                        <%-- ▲▲▲▲▲ 여기까지 추가 ▲▲▲▲▲ --%>
                        
                        <li><a href="#" id="logoutBtn" class="logout-link">로그아웃</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/member/join.do" class="${activeMenu == 'join' ? 'active' : ''}">회원가입</a></li>
                        <li><a href="${pageContext.request.contextPath}/member/login.do" class="${activeMenu == 'login' ? 'active' : ''}">로그인</a></li>
                    </c:otherwise>
                </c:choose>
                
                <%-- 모바일용 검색창 (햄버거 메뉴 안에 표시됨) --%>
                <li class="mobile-search">
                    <form action="${pageContext.request.contextPath}/restaurant/list.do" method="get" class="header-search-form">
                        <input type="text" name="keyword" placeholder="맛집 검색..." class="header-search-input">
                        <button type="submit" class="header-search-button"><i class="fa fa-search"></i></button>
                    </form>
                </li>
            </ul>
        </nav>
        
        <button class="hamburger-menu">
            <i class="fa fa-bars"></i>
        </button>
    </div>
</header>

<script>
// 이 스크립트 블록은 DOMContentLoaded 이후에 실행되어야 하므로, header.jsp의 하단으로 이동합니다.
document.addEventListener('DOMContentLoaded', function() {
    // 로그아웃 처리
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function(e) {
            e.preventDefault();
            const ctx = "${pageContext.request.contextPath}";
            // 현재 페이지의 전체 경로를 redirect 파라미터로 사용
            const redirectUrl = window.location.pathname + window.location.search;
            const relativePath = redirectUrl.startsWith(ctx) ? redirectUrl.substring(ctx.length) : redirectUrl;
            const logoutUrl = ctx + "/member/logout.do?redirect=" + encodeURIComponent(relativePath);

            showSystemAlert({
                message: '로그아웃 하시겠습니까?',
                onConfirm: () => { window.location.href = logoutUrl; }
            });
        });
    }

    // 햄버거 메뉴 토글
    const hamburger = document.querySelector('.hamburger-menu');
    const mainNav = document.querySelector('.main-nav');
    if (hamburger && mainNav) {
        hamburger.addEventListener('click', () => {
            mainNav.classList.toggle('active');
        });
    }
});
</script>

<!-- Toast Notification Container -->
<div id="toast-container"></div>

<script>
    /**
     * 범용 토스트 알림을 표시하는 함수
     * @param {string} message - 토스트에 표시할 메시지
     * @param {number} [duration=3000] - 토스트가 표시될 시간 (밀리초)
     */
    function showToast(message, duration = 3000) {
        const container = document.getElementById('toast-container');
        if (!container) return;

        const toast = document.createElement('div');
        toast.className = 'toast-notification';
        toast.textContent = message;

        container.appendChild(toast);

        // Show animation
        setTimeout(() => {
            toast.classList.add('show');
        }, 10); // Delay to ensure transition is applied

        // Hide and remove after duration
        setTimeout(() => {
            toast.classList.remove('show');
            toast.addEventListener('transitionend', () => {
                toast.remove();
            });
        }, duration);
    }
</script>

<!-- Confirm Modal HTML -->
<div id="confirmModal" class="confirm-modal-overlay">
    <div class="confirm-modal-content">
        <p id="confirmModalMessage" class="confirm-modal-message"></p>
        <div class="confirm-modal-buttons">
            <button id="confirmCancelBtn" class="btn btn-secondary">취소</button>
            <button id="confirmOkBtn" class="btn btn-danger">확인</button>
        </div>
    </div>
</div>

<script>
    // Confirm Modal Functions
    const systemAlertModal = document.getElementById('confirmModal'); // HTML ID는 그대로 사용
    if (systemAlertModal) {
        const msgElem = document.getElementById('confirmModalMessage');
        const okBtn = document.getElementById('confirmOkBtn');
        const cancelBtn = document.getElementById('confirmCancelBtn');
        let onConfirmCallback = null;

        /**
         * 커스텀 시스템 알림/확인 모달을 표시하는 함수
         * @param {object} options - 모달 옵션
         * @param {string} options.message - 표시할 메시지
         * @param {function} [options.onConfirm] - 확인 버튼 클릭 시 실행될 콜백 함수
         * @param {boolean} [options.showCancel=true] - 취소 버튼 표시 여부
         */
        function showSystemAlert(options) {
            const { message, onConfirm, showCancel = true } = options;
            
            msgElem.textContent = message;
            onConfirmCallback = onConfirm;

            if (showCancel) {
                cancelBtn.style.display = 'inline-block';
                okBtn.classList.remove('btn-main');
                okBtn.classList.add('btn-danger');
                okBtn.textContent = '확인';
            } else {
                cancelBtn.style.display = 'none';
                okBtn.classList.remove('btn-danger');
                okBtn.classList.add('btn-main');
                okBtn.textContent = '확인';
            }
            
            systemAlertModal.classList.add('show');
        }

        function hideSystemAlert() {
            systemAlertModal.classList.remove('show');
            onConfirmCallback = null;
        }

        okBtn.addEventListener('click', () => {
            if (typeof onConfirmCallback === 'function') {
                onConfirmCallback();
            }
            hideSystemAlert();
        });

        cancelBtn.addEventListener('click', hideSystemAlert);
        systemAlertModal.addEventListener('click', (e) => {
            if (e.target === systemAlertModal) {
                hideSystemAlert();
            }
        });
        
        // 전역에서 접근 가능하도록 window 객체에 할당
        window.showSystemAlert = showSystemAlert;
    }
</script>

<%-- 페이지 로드 시 서버 메시지 처리를 위한 통합 스크립트 --%>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 1. 서버에서 전달된 토스트 메시지(RedirectAttributes)가 있으면 표시
        const serverToastMessage = '${toast}';
        if (serverToastMessage) {
            showToast(serverToastMessage);
        }

        // 2. 클라이언트 측 sessionStorage에 저장된 토스트 메시지가 있으면 표시
        const clientToastMessage = sessionStorage.getItem('toastMessage');
        if (clientToastMessage) {
            showToast(clientToastMessage);
            // 표시 후 즉시 삭제하여 새로고침 시 다시 뜨지 않도록 함
            sessionStorage.removeItem('toastMessage');
        }
    });
</script>

