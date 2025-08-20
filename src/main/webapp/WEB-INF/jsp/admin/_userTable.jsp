<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<table class="user-table">
    <thead>
        <tr>
            <th>아이디</th>
            <th>닉네임</th>
            <th>이메일</th>
            <th>가입일</th>
            <th>상태</th>
            <th>유형</th>
            <th>관리</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${not empty userList}">
                <c:forEach var="user" items="${userList}">
                    <tr>
                        <td>
                            <c:url var="detailUrl" value="/admin/userDetail.do">
                                <c:param name="id" value="${user.id}" />
                                <c:param name="page" value="${paging.currentPage}" />
                                <c:param name="keyword" value="${keyword}" />
                                <c:param name="status" value="${selectedStatus}" />
                            </c:url>
                            <a href="${detailUrl}">${user.id}</a>
                        </td>
                        <td>${user.nickname}</td>
                        <td>${user.email}</td>
                        <td><fmt:formatDate value="${user.regdate}" pattern="yyyy-MM-dd"/></td>
                        <td>
                            <span class="status-badge status-${user.status == 'Y' ? 'active' : 'inactive'}">
                                ${user.status == 'Y' ? '활성' : '탈퇴'}
                            </span>
                        </td>
                        <td>
                            <span class="type-badge type-${user.type}">
                                ${user.type}
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${user.status == 'Y'}">
                                    <button class="btn btn-sm btn-danger" 
                                            onclick="openReasonModal('${user.id}', 'N', '[${user.nickname}]님을 비활성화합니다.')">비활성화</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-sm btn-main"
                                            onclick="openReasonModal('${user.id}', 'Y', '[${user.nickname}]님을 활성화합니다.')">활성화</button>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="7" class="no-data">회원 정보가 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </tbody>
</table>

<!-- 회원 상태 변경 사유 입력 모달 -->
<div id="reasonModal" class="confirm-modal-overlay">
    <div class="confirm-modal-content">
        <h3 id="reasonModalTitle" class="confirm-modal-title" style="margin-bottom: 20px;"></h3>
        <form id="reasonForm">
            <input type="hidden" id="reasonMemberId" name="id">
            <input type="hidden" id="reasonNewStatus" name="status">
            
            <div class="form-group" style="margin-bottom: 20px; text-align: left;">
                <label for="reasonText" style="display: block; margin-bottom: 8px; font-weight: 500;">변경 사유 (필수)</label>
                <textarea id="reasonText" name="reason" rows="4" class="form-control" 
                          placeholder="상태 변경에 대한 사유를 반드시 입력해주세요." 
                          style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; resize: vertical;"></textarea>
            </div>

            <div class="confirm-modal-buttons">
                <button type="button" class="btn btn-secondary" onclick="closeReasonModal()">취소</button>
                <button type="submit" class="btn btn-danger">확인</button>
            </div>
        </form>
    </div>
</div>

<script>
function openReasonModal(memberId, newStatus, title) {
    document.getElementById('reasonModalTitle').textContent = title;
    document.getElementById('reasonMemberId').value = memberId;
    document.getElementById('reasonNewStatus').value = newStatus;
    
    document.getElementById('reasonModal').classList.add('show');
    document.getElementById('reasonText').focus();
}

function closeReasonModal() {
    document.getElementById('reasonModal').classList.remove('show');
    document.getElementById('reasonForm').reset();
}

document.getElementById('reasonForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const reason = document.getElementById('reasonText').value;
    if (!reason.trim()) {
        showToast('사유를 반드시 입력해야 합니다.');
        return;
    }

    const formData = new FormData(this);

    const url = "${pageContext.request.contextPath}/admin/updateUserStatus.do";
    fetch(url, {
        method: 'POST',
        body: new URLSearchParams(formData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // 성공 메시지를 sessionStorage에 저장하고 페이지를 즉시 새로고침
            sessionStorage.setItem('toastMessage', data.message);
            window.location.reload();
        } else {
            // 실패 시에는 바로 토스트를 띄움
            showToast(data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('오류가 발생했습니다.');
    });
});

// 모달 외부 클릭 시 닫기
document.getElementById('reasonModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeReasonModal();
    }
});
</script>
