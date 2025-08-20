<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="activeMenu" value="admin" scope="request"/>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
<style>
    /* editRestaurant.jsp 전용 스타일 */
    .edit-form-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 30px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        font-weight: bold;
        margin-bottom: 8px;
    }
    .form-group input[type="text"],
    .form-group input[type="url"],
    .form-group input[type="number"],
    .form-group select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 1rem;
    }
    .image-input-group {
        border: 1px solid #e0e0e0;
        padding: 15px;
        border-radius: 5px;
        margin-top: 5px;
    }
    .image-input-options label {
        margin-right: 15px;
        font-weight: normal;
    }
    .image-preview {
        margin-top: 10px;
    }
    .image-preview img {
        max-width: 200px;
        max-height: 150px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }
    .dynamic-list .list-item {
        display: flex;
        gap: 10px;
        margin-bottom: 10px;
    }
    .dynamic-list .list-item input {
        flex-grow: 1;
    }
    .btn-add {
        margin-top: 10px;
    }
    .form-actions {
        text-align: right;
        margin-top: 30px;
    }
    .basic-image-item {
        display: flex;
        align-items: center;
        gap: 10px;
    }
</style>

<div class="container">
    <div class="edit-form-container">
        <c:choose>
            <c:when test="${empty restaurant.name}">
                <c:set var="pageTitle" value="신규 맛집 등록"/>
                <c:set var="formAction" value="${pageContext.request.contextPath}/admin/createRestaurant.do"/>
            </c:when>
            <c:otherwise>
                <c:set var="pageTitle" value="맛집 정보 수정"/>
                <c:set var="formAction" value="${pageContext.request.contextPath}/admin/updateRestaurant.do"/>
            </c:otherwise>
        </c:choose>

        <h2 class="center-title">${pageTitle}</h2>
        <p class="center-description">맛집 ID: ${restaurant.restaurantId}</p>

        <form action="${formAction}" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
            <input type="hidden" name="restaurantId" value="${restaurant.restaurantId}">

            <div class="form-group">
                <label for="name">상호명</label>
                <input type="text" id="name" name="name" value="${restaurant.name}" required>
            </div>

            <div class="form-group">
                <label for="address">주소</label>
                <input type="text" id="address" name="address" value="${restaurant.address}" required>
            </div>

            <div class="form-group">
                <label for="phone">전화번호</label>
                <input type="text" id="phone" name="phone" value="${restaurant.phone}">
            </div>

            <div class="form-group">
                <label for="region">지역</label>
                <input type="text" id="region" name="region" value="${restaurant.region}" required>
            </div>

            <div class="form-group">
                <label for="category">카테고리</label>
                <input type="text" id="category" name="category" value="${restaurant.category}" required>
            </div>

            <!-- 대표 이미지 1 수정 -->
            <div class="form-group">
                <label>대표 이미지 1</label>
                <div class="image-input-group">
                    <div class="image-input-options">
                        <label><input type="radio" name="mainImg1_type" value="URL" checked onclick="toggleImageInput(1, 'URL')"> URI 또는 경로</label>
                        <label><input type="radio" name="mainImg1_type" value="FILE" onclick="toggleImageInput(1, 'FILE')"> 파일 업로드</label>
                    </div>
                    <div id="mainImg1_url_group">
                        <input type="text" name="mainImgUrl1" placeholder="/images/sample.jpg 또는 https://example.com/image.jpg" value="${restaurant.mainImgUrl1}" oninput="previewImage(1)">
                    </div>
                    <div id="mainImg1_file_group" style="display:none;">
                        <input type="file" name="mainImgFile1" accept="image/*" onchange="previewImage(1)">
                    </div>
                    <div class="image-preview">
                        <c:choose>
                            <c:when test="${not empty restaurant.mainImgUrl1 and (fn:startsWith(restaurant.mainImgUrl1, 'http') or fn:startsWith(restaurant.mainImgUrl1, '//'))}">
                                <img id="previewImg1" src="${restaurant.mainImgUrl1}" alt="대표 이미지 1">
                            </c:when>
                            <c:otherwise>
                                <c:url value="${restaurant.mainImgUrl1}" var="imgUrl1"/>
                                <img id="previewImg1" src="${imgUrl1}" alt="대표 이미지 1">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- 대표 이미지 2 수정 -->
            <div class="form-group">
                <label>대표 이미지 2</label>
                <div class="image-input-group">
                    <div class="image-input-options">
                        <label><input type="radio" name="mainImg2_type" value="URL" checked onclick="toggleImageInput(2, 'URL')"> URI 또는 경로</label>
                        <label><input type="radio" name="mainImg2_type" value="FILE" onclick="toggleImageInput(2, 'FILE')"> 파일 업로드</label>
                    </div>
                    <div id="mainImg2_url_group">
                        <input type="text" name="mainImgUrl2" placeholder="/images/sample.jpg 또는 https://example.com/image.jpg" value="${restaurant.mainImgUrl2}" oninput="previewImage(2)">
                    </div>
                    <div id="mainImg2_file_group" style="display:none;">
                        <input type="file" name="mainImgFile2" accept="image/*" onchange="previewImage(2)">
                    </div>
                    <div class="image-preview">
                        <c:choose>
                            <c:when test="${not empty restaurant.mainImgUrl2 and (fn:startsWith(restaurant.mainImgUrl2, 'http') or fn:startsWith(restaurant.mainImgUrl2, '//'))}">
                                <img id="previewImg2" src="${restaurant.mainImgUrl2}" alt="대표 이미지 2">
                            </c:when>
                            <c:otherwise>
                                <c:url value="${restaurant.mainImgUrl2}" var="imgUrl2"/>
                                <img id="previewImg2" src="${imgUrl2}" alt="대표 이미지 2">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <hr>

            <h4>메뉴 정보</h4>
            <div id="menu-list" class="dynamic-list">
                <c:forEach var="menu" items="${menuList}">
                    <div class="list-item">
                        <input type="text" name="menuNames" placeholder="메뉴명" value="${menu.menuName}" required>
                        <input type="text" name="menuPrices" placeholder="가격 (숫자만)" pattern="[0-9]*" value="${menu.price}">
                        <button type="button" class="btn btn-sm btn-danger" onclick="removeItem(this)">삭제</button>
                    </div>
                </c:forEach>
            </div>
            <button type="button" class="btn btn-sm btn-main btn-add" onclick="addMenuItem()">메뉴 추가</button>

            <hr>

            <h4>태그 정보</h4>
            <div id="tag-list" class="dynamic-list">
                <c:forEach var="tag" items="${tagList}">
                    <div class="list-item">
                        <select name="tagTypes" class="tag-type-select">
                            <option value="MAIN" ${tag.tagType == 'MAIN' ? 'selected' : ''}>메인</option>
                            <option value="SUB" ${tag.tagType == 'SUB' ? 'selected' : ''}>서브</option>
                        </select>
                        <input type="text" name="tagNames" placeholder="태그명" value="${tag.tagName}" required>
                        <button type="button" class="btn btn-sm btn-danger" onclick="removeItem(this)">삭제</button>
                    </div>
                </c:forEach>
            </div>
            <button type="button" class="btn btn-sm btn-main btn-add" onclick="addTagItem()">태그 추가</button>

            <hr>

            <h4>기본 이미지</h4>
            <div id="basic-image-list" class="dynamic-list">
                <%-- 기존 이미지 표시 --%>
                <c:choose>
                    <c:when test="${empty basicImageList}">
                        <p>등록된 기본 이미지가 없습니다.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="image" items="${basicImageList}">
                            <div class="list-item basic-image-item">
                                <c:choose>
                                    <c:when test="${fn:startsWith(image.imageUrl, 'http')}">
                                        <img src="${image.imageUrl}" alt="기본 이미지" style="width: 100px; height: auto; border-radius: 4px;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url value='${image.imageUrl}'/>" alt="기본 이미지" style="width: 100px; height: auto; border-radius: 4px;">
                                    </c:otherwise>
                                </c:choose>
                                <input type="text" value="${image.imageUrl}" readonly style="flex-grow: 1;">
                                <button type="button" class="btn btn-sm btn-danger" data-image-id="${image.imageId}" onclick="deleteBasicImage(this)">삭제</button>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            <button type="button" class="btn btn-sm btn-main btn-add" onclick="addBasicImageItem()">기본 이미지 추가</button>

            <%-- 새로운 기본 이미지 행을 위한 숨겨진 템플릿 --%>
            <template id="basic-image-template">
                <div class="list-item basic-image-item new-item">
                    <div style="width: 100px; height: 100px; border: 1px dashed #ccc; display: flex; align-items: center; justify-content: center; background-color: #f9f9f9; border-radius: 4px;">
                        <img class="new-image-preview" src="" alt="새 이미지" style="max-width: 100%; max-height: 100%; display: none;">
                    </div>
                    <div style="flex-grow: 1;">
                        <%-- [수정] VO의 필드명(type)과 매칭되는 name 속성으로 변경 --%>
                        <input type="hidden" class="type-input" name="newBasicImages[#INDEX#].type" value="URL">
                        <div class="image-input-options" style="margin-bottom: 5px;">
                            <label><input type="radio" name="newBasicImageType_#INDEX#" value="URL" checked> URI</label>
                            <label><input type="radio" name="newBasicImageType_#INDEX#" value="FILE"> 파일</label>
                        </div>
                        <div class="url-group">
                            <%-- [수정] VO의 필드명(url)과 매칭되는 name 속성으로 변경 --%>
                            <input type="text" class="url-input" name="newBasicImages[#INDEX#].url" placeholder="https://example.com/image.jpg">
                        </div>
                        <div class="file-group" style="display:none;">
                            <%-- [수정] VO의 필드명(file)과 매칭되는 name 속성으로 변경하고, 기본적으로 비활성화 --%>
                            <input type="file" class="file-input" name="newBasicImages[#INDEX#].file" accept="image/*" disabled>
                        </div>
                    </div>
                    <button type="button" class="btn btn-sm btn-danger btn-remove-new" onclick="removeItem(this)">삭제</button>
                </div>
            </template>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/admin/restaurantList.do" class="btn btn-secondary">취소</a>
                <button type="submit" class="btn btn-main">저장</button>
            </div>
        </form>
    </div>
</div>

<script>
let basicImageCounter = 0; // 고유 ID를 위한 카운터

// --- Start of The New, Template-based Logic ---

/**
 * '기본 이미지 추가' 버튼 클릭 시 실행됩니다.
 * 숨겨진 템플릿을 복제하고, 고유한 name 속성을 부여한 뒤, 이벤트 리스너를 연결하여 화면에 추가합니다.
 */
function addBasicImageItem() {
    const imageList = document.getElementById('basic-image-list');
    const template = document.getElementById('basic-image-template');

    const clone = template.content.cloneNode(true);
    basicImageCounter++;

    // [수정] 복제된 모든 요소의 name 속성에서 플레이스홀더(#INDEX#)를 실제 카운터 값으로 교체합니다.
    clone.querySelectorAll('[name*="#INDEX#"]').forEach(el => {
        el.name = el.name.replace(/#INDEX#/g, basicImageCounter);
    });

    // [수정] 라디오 버튼 그룹의 name도 고유하게 변경하여 각 행이 독립적으로 동작하도록 합니다.
    const radioButtons = clone.querySelectorAll('input[type="radio"]');
    radioButtons.forEach(radio => {
        radio.name = 'newBasicImageType_' + basicImageCounter;
    });

    // 복제된 요소들에 이벤트 리스너를 연결합니다.
    const radioGroup = clone.querySelector('.image-input-options');
    radioGroup.addEventListener('change', handleRadioChange);

    const urlInput = clone.querySelector('.url-input');
    urlInput.addEventListener('input', handleImagePreview);

    const fileInput = clone.querySelector('.file-input');
    fileInput.addEventListener('change', handleImagePreview);
    
    const removeBtn = clone.querySelector('.btn-remove-new');
    removeBtn.addEventListener('click', (e) => {
        e.target.closest('.list-item').remove();
    });

    const noImageMsg = imageList.querySelector('p');
    if (noImageMsg) {
        noImageMsg.remove();
    }

    imageList.appendChild(clone);
}

/**
 * 동적으로 추가된 행의 라디오 버튼(URI/파일) 변경을 처리합니다.
 */
function handleRadioChange(event) {
    const radio = event.target;
    const container = radio.closest('.list-item');
    const type = radio.value;

    // [수정] 클래스 이름으로 input 요소를 찾습니다.
    const typeInput = container.querySelector('.type-input');
    const urlGroup = container.querySelector('.url-group');
    const fileGroup = container.querySelector('.file-group');
    const urlInput = urlGroup.querySelector('.url-input');
    const fileInput = fileGroup.querySelector('.file-input');

    typeInput.value = type;

    // [수정] 전송되지 않는 input은 name을 비우는 대신 disabled 속성으로 제어합니다.
    if (type === 'URL') {
        urlGroup.style.display = 'block';
        fileGroup.style.display = 'none';
        urlInput.disabled = false;
        fileInput.disabled = true;
    } else { // FILE
        urlGroup.style.display = 'none';
        fileGroup.style.display = 'block';
        urlInput.disabled = true;
        fileInput.disabled = false;
    }
}

/**
 * 동적으로 추가된 행의 이미지 미리보기를 처리합니다.
 */
function handleImagePreview(event) {
    const inputElement = event.target;
    const container = inputElement.closest('.list-item');
    const previewImg = container.querySelector('.new-image-preview');
    const typeRadio = container.querySelector('input[type="radio"]:checked');
    
    if (!typeRadio) return;
    const type = typeRadio.value;

    let src = '';
    if (type === 'URL') {
        src = inputElement.value;
    } else { // FILE
        if (inputElement.files && inputElement.files[0]) {
            src = URL.createObjectURL(inputElement.files[0]);
        }
    }

    if (src) {
        previewImg.src = src;
        previewImg.style.display = 'block';
    } else {
        previewImg.src = '';
        previewImg.style.display = 'none';
    }
}

// --- End of The New Logic ---


function toggleImageInput(imgIndex, type) {
    const urlGroup = document.getElementById('mainImg' + imgIndex + '_url_group');
    const fileGroup = document.getElementById('mainImg' + imgIndex + '_file_group');
    if (type === 'URL') {
        urlGroup.style.display = 'block';
        fileGroup.style.display = 'none';
    } else {
        urlGroup.style.display = 'none';
        fileGroup.style.display = 'block';
    }
}

function addMenuItem() {
    const menuList = document.getElementById('menu-list');
    const newItem = document.createElement('div');
    newItem.className = 'list-item';
    newItem.innerHTML = `
        <input type="text" name="menuNames" placeholder="메뉴명" required>
        <input type="text" name="menuPrices" placeholder="가격 (숫자만)" pattern="[0-9]*">
        <button type="button" class="btn btn-sm btn-danger" onclick="removeItem(this)">삭제</button>
    `;
    menuList.appendChild(newItem);
}

function addTagItem() {
    const tagList = document.getElementById('tag-list');
    const newItem = document.createElement('div');
    newItem.className = 'list-item';
    newItem.innerHTML = `
        <select name="tagTypes" class="tag-type-select">
            <option value="MAIN" selected>메인</option>
            <option value="SUB">서브</option>
        </select>
        <input type="text" name="tagNames" placeholder="태그명" required>
        <button type="button" class="btn btn-sm btn-danger" onclick="removeItem(this)">삭제</button>
    `;
    tagList.appendChild(newItem);
}

function removeItem(button) {
    button.closest('.list-item').remove();
}

function previewImage(imgIndex) {
    const radioName = 'mainImg' + imgIndex + '_type';
    const selectedType = document.querySelector('input[name="' + radioName + '"]:checked').value;
    const previewImg = document.getElementById('previewImg' + imgIndex);

    if (selectedType === 'URL') {
        const urlInput = document.querySelector('input[name="mainImgUrl' + imgIndex + '"]');
        if (urlInput.value.startsWith('http')) {
            previewImg.src = urlInput.value;
        } else {
            previewImg.src = '${pageContext.request.contextPath}' + urlInput.value;
        }
    } else if (selectedType === 'FILE') {
        const fileInput = document.querySelector('input[name="mainImgFile' + imgIndex + '"]');
        if (fileInput.files && fileInput.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImg.src = e.target.result;
            }
            reader.readAsDataURL(fileInput.files[0]);
        }
    }
}

function validateForm() {
    // 신규 등록일 때만 대표 이미지를 필수로 검사합니다.
    const isCreateMode = "${empty restaurant.name}";
    if (isCreateMode !== 'true') {
        return true; // 수정 모드에서는 검사하지 않음
    }

    // 대표 이미지 1 검사
    const mainImg1Type = document.querySelector('input[name="mainImg1_type"]:checked').value;
    if (mainImg1Type === 'URL') {
        const urlInput = document.querySelector('input[name="mainImgUrl1"]');
        if (urlInput.value.trim() === '') {
            alert('대표 이미지 1의 웹 URL을 입력해주세요.');
            urlInput.focus();
            return false;
        }
    } else if (mainImg1Type === 'FILE') {
        const fileInput = document.querySelector('input[name="mainImgFile1"]');
        if (fileInput.files.length === 0) {
            alert('대표 이미지 1의 파일을 선택해주세요.');
            fileInput.focus();
            return false;
        }
    }

    // 대표 이미지 2 검사
    const mainImg2Type = document.querySelector('input[name="mainImg2_type"]:checked').value;
    if (mainImg2Type === 'URL') {
        const urlInput = document.querySelector('input[name="mainImgUrl2"]');
        if (urlInput.value.trim() === '') {
            alert('대표 이미지 2의 웹 URL을 입력해주세요.');
            urlInput.focus();
            return false;
        }
    } else if (mainImg2Type === 'FILE') {
        const fileInput = document.querySelector('input[name="mainImgFile2"]');
        if (fileInput.files.length === 0) {
            alert('대표 이미지 2의 파일을 선택해주세요.');
            fileInput.focus();
            return false;
        }
    }
    
    return true; // 유효성 검사 통과
}

function deleteBasicImage(button) {
    const imageId = button.getAttribute('data-image-id');
    const imageItem = button.closest('.list-item');

    if (!imageId) {
        showToast('오류: 이미지 ID를 찾을 수 없습니다.');
        return;
    }

    showSystemAlert({
        message: '정말로 이 이미지를 삭제하시겠습니까?',
        onConfirm: () => {
            const formData = new FormData();
            formData.append('imageId', imageId);

            fetch(`${pageContext.request.contextPath}/admin/images/delete`, {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                return response.json().then(err => { 
                    throw new Error(err.message || '이미지 삭제 중 서버 오류가 발생했습니다.'); 
                });
            })
            .then(data => {
                imageItem.remove();
                showToast(data.message || '이미지가 삭제되었습니다.');
                
                // 모든 이미지가 삭제되었을 때 안내 문구 표시
                const imageList = document.getElementById('basic-image-list');
                if (imageList.children.length === 0 || (imageList.children.length === 1 && imageList.querySelector('p'))) {
                    if (!imageList.querySelector('p')) {
                    	const noImageMsg = document.createElement('p');
                    	noImageMsg.textContent = '등록된 기본 이미지가 없습니다.';
                    	imageList.innerHTML = ''; // 기존 내용 삭제
                    	imageList.appendChild(noImageMsg);
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast(error.message);
            });
        }
    });
}
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>