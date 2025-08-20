<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script>
function updateStatus(reportId, status) {
    const message = status === 'PROCESSED' ? '이 신고를 승인 처리하시겠습니까?' : '이 신고를 반려 처리하시겠습니까?';
    
    showSystemAlert({
        message: message,
        onConfirm: () => {
            // 동적 폼 생성 및 제출
            const form = document.createElement('form');
            form.method = 'post';
            form.action = '${pageContext.request.contextPath}/admin/report/updateStatus.do';

            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'reportId';
            idInput.value = reportId;

            const statusInput = document.createElement('input');
            statusInput.type = 'hidden';
            statusInput.name = 'status';
            statusInput.value = status;

            form.appendChild(idInput);
            form.appendChild(statusInput);
            document.body.appendChild(form);
            form.submit();
        }
    });
}
</script>
