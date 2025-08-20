<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/detail-specific.css">

<div class="container">
	<div class="main-images">
        <c:choose>
            <c:when test="${not empty restaurant.mainImgUrl1 and (fn:startsWith(restaurant.mainImgUrl1, 'http') or fn:startsWith(restaurant.mainImgUrl1, '//'))}">
                <img src="${restaurant.mainImgUrl1}" alt="대표 이미지 1" />
            </c:when>
            <c:otherwise>
                <c:url value="${restaurant.mainImgUrl1}" var="imgUrl1"/>
                <img src="${imgUrl1}" alt="대표 이미지 1" />
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${not empty restaurant.mainImgUrl2 and (fn:startsWith(restaurant.mainImgUrl2, 'http') or fn:startsWith(restaurant.mainImgUrl2, '//'))}">
                <img src="${restaurant.mainImgUrl2}" alt="대표 이미지 2" />
            </c:when>
            <c:otherwise>
                <c:url value="${restaurant.mainImgUrl2}" var="imgUrl2"/>
                <img src="${imgUrl2}" alt="대표 이미지 2" />
            </c:otherwise>
        </c:choose>
	</div>

	<div class="info-group">
		<div class="info">
			<h1>${restaurant.name}
				<span class="favorite-heart"
					data-restaurant-id="${restaurant.restaurantId}"
					onclick="toggleFavorite(this)"> <i class="fa fa-heart"></i>
					<%-- FontAwesome 아이콘 사용 --%> <span class="favorite-count"></span>
				</span>
			</h1>
			<p>${restaurant.region} | ${restaurant.category}</p>
			<p class="address">${restaurant.address}</p>
			<p class="phone">${restaurant.phone}</p>

			<c:set var="starPercent" value="${restaurant.starScore * 20}" />
			<div class="star-rating-wrap">
				<div class="star-rating">
					<span class="star-base">★★★★★</span> <span class="star-fill"
						style="width: ${starPercent}%;">&#9733;&#9733;&#9733;&#9733;&#9733;</span>
				</div>
				<span class="star-score">(${restaurant.starScore}점)</span>
			</div>
			
			<!-- MZ 스코어 표시 영역 -->
			<div class="mz-score-wrap">
				<span class="mz-score-label">MZ스코어</span>
				<span class="mz-score-value"><fmt:formatNumber value="${restaurant.mzScore}" pattern="#,##0.0" />점</span>
				<div class="tooltip-container">
					<span class="tooltip-trigger">?</span>
					<div class="tooltip-content">
						<p><strong>MZ스코어란?</strong></p>
						<p>맛ZIP만의 자체적인 맛집 점수입니다.</p>
						<ul>
							<li>리뷰 평점 (60%)</li>
							<li>리뷰 수 (20%)</li>
							<li>찜 수 (20%)</li>
						</ul>
						<p>를 종합하여 100점 만점으로 계산됩니다.</p>
					</div>
				</div>
			</div>
		</div>

		<div class="tags">
			<c:forEach var="tag" items="${tagList}">
				<span class="tag">#${tag.tagName}</span>
			</c:forEach>
		</div>

		<div id="map"></div>

		<%-- 메뉴 리스트 --%>
		<div class="menu-list-container">
			<h2>메뉴</h2>
			<div class="menu-list" id="menuList">
				<c:forEach var="menu" items="${menuList}">
					<div class="menu-item">
						<span class="menu-name">${menu.menuName}</span>
						<span class="menu-price"><fmt:formatNumber value="${menu.price}" pattern="#,##0" />원</span>
					</div>
				</c:forEach>
			</div>
			<c:if test="${fn:length(menuList) > 6}">
				<button id="toggleMenuListBtn" class="btn btn-more">더보기</button>
			</c:if>
		</div>
	</div>

	<%-- 이 코드는 페이지 열리면 이미지 0개에서 시작하는 코드 (더보기 버튼 잘 동작함) --%>
	<div class="extra-images" id="imageContainer">
		<c:forEach var="img" items="${imageList}">
			<div class="image-card hidden">
				<c:choose>
					<c:when test="${fn:startsWith(img.imageUrl, 'http')}">
						<img src="${img.imageUrl}" alt="추가 이미지" />
					</c:when>
					<c:otherwise>
						<img src="${pageContext.request.contextPath}${img.imageUrl}"
							alt="추가 이미지" />
					</c:otherwise>
				</c:choose>
			</div>
		</c:forEach>
	</div>


	<%-- [수정] 더보기 버튼도 초기에 숨김 처리 --%>
	<button id="loadMoreBtn" class="btn btn-more hidden">더보기</button>

	<%-- 이미지 모달 (확대 기능) --%>
	<div id="imageModal" class="modal" onclick="closeModal()">
		<span class="modal-close"
			onclick="event.stopPropagation(); closeModal();">&times;</span>
		<button class="modal-button left"
			onclick="event.stopPropagation(); changeImage(-1)">&#10094;</button>
		<div class="modal-content">
			<img id="modalImg" src="" alt="확대 이미지" />
		</div>
		<button class="modal-button right"
			onclick="event.stopPropagation(); changeImage(1)">&#10095;</button>
	</div>
</div>

<%-- 리뷰 관련 기능 --%>
<div class="container review-form-container" id="reviews">
	<c:if test="${not empty sessionScope.loginUser}">
		<h3>리뷰 작성</h3>
		<form id="reviewForm"
			action="${pageContext.request.contextPath}/restaurant/reviewWrite.do"
			method="post" enctype="multipart/form-data">
			<input type="hidden" name="restaurantId"
				value="${restaurant.restaurantId}">
			<div id="starRating"></div>
			<input type="hidden" name="starScore" id="starScore" value="0">
			<div id="starRatingError" class="star-rating-error">
				<c:if test="${not empty msg}">${msg}</c:if>
			</div>
			<input type="file" id="reviewImages" name="reviewImages" multiple
				accept="image/*" style="display: none;">
			<div id="dropZone">
				여기에 이미지를 끌어다 놓거나 클릭해서 선택 (최대 5장)</div>
			<div id="thumbnailPreview"></div>
			<textarea name="content" maxlength="1000"
				placeholder="리뷰를 입력하세요" required></textarea>
			<button type="submit" class="btn btn-main">리뷰 등록</button>
		</form>
	</c:if>
	<c:if test="${empty sessionScope.loginUser}">
	    <p>
	        리뷰 작성은 <a href="${pageContext.request.contextPath}/member/login.do?redirect=/restaurant/detail.do?restaurantId=${restaurant.restaurantId}">로그인</a>
	        후 이용해주세요.
	    </p>
	</c:if>

	<h3>리뷰 목록</h3>
	<c:forEach var="review" items="${reviewList}">
		<div class="review-item" id="review-${review.reviewId}">
			<div class="review-header">
				<strong>${review.nickname} (${review.memberId})</strong>
				<span class="review-regdate">
					<fmt:formatDate value="${review.regdate}" pattern="yyyy-MM-dd HH:mm" />
				</span>
				<span class="review-star-rating">
					<c:set var="score" value="${review.starScore}" />
					<c:forEach begin="1" end="5" var="i">
						<c:choose>
							<c:when test="${score >= i}">
								<img src="${pageContext.request.contextPath}/resources/star/star-rating_1.png" alt="Full Star">
							</c:when>
							<c:when test="${score >= i - 0.5}">
								<img src="${pageContext.request.contextPath}/resources/star/star-rating_0.5.png" alt="Half Star">
							</c:when>
							<c:otherwise>
								<img src="${pageContext.request.contextPath}/resources/star/star-rating_0.png" alt="Empty Star">
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<span class="review-star-score">(${review.starScore})</span>
				</span>
			</div>
			<div class="review-content">${review.content}</div>

			<%-- 리뷰에 첨부된 이미지가 있을 경우, 이미지들을 표시합니다. --%>
			<c:if test="${not empty review.imageList}">
				<div class="review-images">
					<c:forEach var="img" items="${review.imageList}">
						<c:url value="${img.imageUrl}" var="imageUrl"/>
						<img src="${imageUrl}" alt="리뷰 이미지" class="review-image-item">
					</c:forEach>
				</div>
			</c:if>

			<div class="review-actions">
				<%-- 로그인한 사용자가 리뷰 작성자이거나 관리자일 경우 삭제 버튼 표시 --%>
				<c:if test="${not empty sessionScope.loginUser and (sessionScope.loginUser.id eq review.memberId or sessionScope.loginUser.type eq 'ADMIN')}">
					<form class="review-delete-form" action="${pageContext.request.contextPath}/restaurant/reviewDelete.do" method="post">
						<input type="hidden" name="reviewId" value="${review.reviewId}">
						<input type="hidden" name="restaurantId" value="${restaurant.restaurantId}">
						<button type="submit" class="btn btn-danger btn-sm">삭제</button>
					</form>
				</c:if>
				<%-- 로그인했고, 자신의 리뷰가 아닐 때만 신고 버튼 표시 --%>
				<c:if test="${not empty sessionScope.loginUser and sessionScope.loginUser.id ne review.memberId}">
					<button class="btn btn-secondary btn-sm btn-report" onclick="openReportModal(${review.reviewId})">신고</button>
				</c:if>
			</div>
		</div>
	</c:forEach>
	<c:if test="${empty reviewList}">
		<p>등록된 리뷰가 없습니다.</p>
	</c:if>
</div>

<style>
@keyframes highlight-fade {
    0% {
        background-color: transparent;
    }
    50% {
        background-color: #fff3cd;
        border-color: #ffeeba;
    }
    100% {
        background-color: transparent;
    }
}
.review-item.highlight {
    animation: highlight-fade 2s ease-in-out;
    border: 1px solid transparent;
    border-radius: 5px;
}
</style>

<script>
document.addEventListener("DOMContentLoaded", function() {

    // URL 해시(#)를 이용한 부드러운 스크롤 및 하이라이트 기능
    if (window.location.hash) {
        // setTimeout을 사용하여 브라우저의 기본 스크롤 동작 후, 스크롤 위치를 보정합니다.
        setTimeout(() => {
            const hash = window.location.hash;
            const targetElement = document.querySelector(hash);
            
            if (targetElement) {
                const header = document.querySelector('.main-header');
                const headerHeight = header ? header.offsetHeight : 0;
                
                // 화면 높이의 20%를 추가 여백으로 설정
                const additionalPadding = window.innerHeight * 0.2;
                
                const targetPosition = targetElement.getBoundingClientRect().top + window.pageYOffset - headerHeight - additionalPadding;

                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });

                targetElement.classList.add('highlight');
                targetElement.addEventListener('animationend', () => {
                    targetElement.classList.remove('highlight');
                }, { once: true });
            }
        }, 100); // 100ms 지연
    }

    // =================================================================
    // 모달 상태 및 제어 함수 (Modal State and Control Functions)
    // =================================================================
    const modal = document.getElementById("imageModal");
    const modalImg = document.getElementById("modalImg");
    
    // 모달이 현재 보여주고 있는 이미지 목록과 인덱스를 관리하는 상태 객체
    let modalState = {
        images: [],
        currentIndex: 0
    };

    // 모달을 여는 함수
    function openModal(images, startIndex) {
        if (!modal || !modalImg) return;
        
        // 모달 상태 업데이트
        modalState.images = images;
        modalState.currentIndex = startIndex;
        
        // 첫 이미지 표시 및 모달 활성화
        modalImg.src = modalState.images[modalState.currentIndex];
        modal.classList.add("active");
    }

    // 모달을 닫는 함수
    window.closeModal = function() {
        if (!modal) return;
        modal.classList.remove("active");
    };

    // 모달의 이미지를 변경하는 함수 (좌/우 버튼 클릭 시)
    window.changeImage = function(step) {
        if (modalState.images.length === 0) return;
        
        // 인덱스 계산 (배열의 처음과 끝을 순환하도록)
        const newIndex = (modalState.currentIndex + step + modalState.images.length) % modalState.images.length;
        modalState.currentIndex = newIndex;
        
        // 새 이미지 표시
        modalImg.src = modalState.images[modalState.currentIndex];
    };

    // =================================================================
    // 이벤트 위임을 사용한 통합 이미지 클릭 핸들러
    // =================================================================
    document.body.addEventListener('click', function(e) {
        const target = e.target;

        // Case 1: 식당 추가 이미지 클릭 시 (.extra-images 내부의 img)
        const extraImageCard = target.closest('.extra-images .image-card img');
        if (extraImageCard) {
            const imageContainer = target.closest('.extra-images');
            const allExtraImages = Array.from(imageContainer.querySelectorAll('.image-card img'));
            const imageUrls = allExtraImages.map(img => img.src);
            const clickedIndex = allExtraImages.indexOf(extraImageCard);
            
            openModal(imageUrls, clickedIndex);
            return; // 처리 완료
        }

        // Case 2: 리뷰 이미지 클릭 시 (.review-images 내부의 img)
        const reviewImage = target.closest('.review-images img');
        if (reviewImage) {
            const imageContainer = target.closest('.review-images');
            const allReviewImages = Array.from(imageContainer.querySelectorAll('img'));
            const imageUrls = allReviewImages.map(img => img.src);
            const clickedIndex = allReviewImages.indexOf(reviewImage);

            openModal(imageUrls, clickedIndex);
            return; // 처리 완료
        }
    });
    
    // 모달 외부 클릭 시 닫기 (기존 onclick 속성 대신 이벤트 리스너로 구현)
    if (modal) {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) { // 모달 배경 클릭 시
                closeModal();
            }
        });
    }

    // =================================================================
    // 기타 페이지 기능 초기화
    // =================================================================

    // '더보기' 기능 (식당 추가 이미지)
    const imageContainer = document.getElementById("imageContainer");
    const loadMoreBtn = document.getElementById("loadMoreBtn");
    if (imageContainer && loadMoreBtn) {
        const allImageCards = Array.from(imageContainer.querySelectorAll(".image-card"));
        const increment = 10;
        
        const showMoreImages = function() {
            const currentlyVisible = Array.from(imageContainer.querySelectorAll(".image-card.visible")).length;
            const nextImages = allImageCards.slice(currentlyVisible, currentlyVisible + increment);
            
            nextImages.forEach(card => {
                card.classList.remove("hidden");
                setTimeout(() => card.classList.add("visible"), 10);
            });

            if (currentlyVisible + increment >= allImageCards.length) {
                loadMoreBtn.classList.add("hidden");
            } else {
                loadMoreBtn.classList.remove("hidden");
            }
        };

        loadMoreBtn.addEventListener("click", showMoreImages);

        if (allImageCards.length > 0) {
            showMoreImages();
        }
    }

    // 키보드 좌/우 화살표로 이미지 전환
    window.addEventListener('keydown', function(e) {
      if (!modal || !modal.classList.contains('active')) return;
      if (e.key === 'ArrowLeft') {
          e.preventDefault();
          window.changeImage(-1);
      } else if (e.key === 'ArrowRight') {
          e.preventDefault();
          window.changeImage(1);
      } else if (e.key === 'Escape') {
          e.preventDefault();
          window.closeModal();
      }
    });

    // 메뉴 리스트 더보기/접기 기능
    const menuList = document.getElementById('menuList');
    const toggleBtn = document.getElementById('toggleMenuListBtn');
    if (menuList && toggleBtn) {
        toggleBtn.addEventListener('click', function() {
            menuList.classList.toggle('expanded');
            this.textContent = menuList.classList.contains('expanded') ? '접기' : '더보기';
        });
    }
});
</script>

<%-- 찜하기, 리뷰작성 등 나머지 스크립트는 분리하여 유지 --%>
<script>
// 찜 버튼 기능
var ctx = "${pageContext.request.contextPath}";
function toggleFavorite(el) {
    var restaurantId = el.getAttribute("data-restaurant-id");
    var isActive = el.classList.contains("active");
    var url = isActive ? ctx + "/restaurant/favorite/remove" : ctx + "/restaurant/favorite/add";
    fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "restaurantId=" + restaurantId
    })
    .then(res => res.text())
    .then(msg => {
        if (msg === "OK") {
            el.classList.toggle("active");
            updateFavoriteCount(el, restaurantId);
        } else if (msg === "NEED_LOGIN") {
            // 현재 페이지의 전체 경로에서 context path를 제외한 상대 경로를 구함
            const path = window.location.pathname;
            const search = window.location.search;
            const relativePath = path.startsWith(ctx) ? path.substring(ctx.length) : path;
            const redirectUrl = relativePath + search;
            
            // 로그인 페이지로 이동
            window.location.href = ctx + "/member/login.do?redirect=" + encodeURIComponent(redirectUrl);
        }
    });
}
function updateFavoriteCount(el, restaurantId) {
    fetch(ctx + "/restaurant/favorite/count?restaurantId=" + restaurantId)
    .then(res => res.text())
    .then(cnt => {
        el.querySelector(".favorite-count").innerText = cnt > 0 ? "( " + cnt + "명 )" : "( 0명 )";
    });
}
document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll(".favorite-heart").forEach(function(el) {
        var restaurantId = el.getAttribute("data-restaurant-id");
        fetch(ctx + "/restaurant/favorite/isFavorite?restaurantId=" + restaurantId)
        .then(res => res.text())
        .then(isFav => {
            if (isFav === "true") el.classList.add("active");
            updateFavoriteCount(el, restaurantId);
        });
    });
});
</script>

<script>
// 리뷰 작성 관련 스크립트 (별점, 이미지 업로드, 유효성 검사 등)
document.addEventListener('DOMContentLoaded', function() {
    const reviewForm = document.getElementById('reviewForm');
    if (!reviewForm) return;

    const starRatingContainer = document.getElementById('starRating');
    const starScoreInput = document.getElementById('starScore');
    const starRatingError = document.getElementById('starRatingError');
    let currentRating = 0;

    // 별점 렌더링 함수
    function renderStars(rating) {
        starRatingContainer.innerHTML = '';
        for (let i = 1; i <= 5; i++) {
            const starWrapper = document.createElement('div');
            starWrapper.className = 'star-wrapper';
            const star = document.createElement('img');
            star.className = 'star-image';
            
            star.src = `${pageContext.request.contextPath}/resources/star/star-rating_0.png`;
            if (rating >= i) {
                star.src = `${pageContext.request.contextPath}/resources/star/star-rating_1.png`;
            } else if (rating >= i - 0.5) {
                star.src = `${pageContext.request.contextPath}/resources/star/star-rating_0.5.png`;
            }
            
            starWrapper.appendChild(star);
            starRatingContainer.appendChild(starWrapper);
        }
    }

    // 마우스 위치에 따른 별점 계산
    function getRatingFromEvent(e) {
        const containerRect = starRatingContainer.getBoundingClientRect();
        const starBlockWidth = 35 * 5;
        const offset = (containerRect.width - starBlockWidth) / 2;
        const starBlockLeft = containerRect.left + offset;
        const mouseX = e.clientX - starBlockLeft;

        if (mouseX < 0 || mouseX > starBlockWidth) return -1; 

        const starWidth = 35;
        const starIndex = Math.floor(mouseX / starWidth);
        const starValue = starIndex + 1;
        const positionInStar = mouseX % starWidth;
        const rating = positionInStar < (starWidth / 2) ? starValue - 0.5 : starValue;

        return Math.max(0.5, Math.min(5, rating));
    }

    // 별점 이벤트 리스너
    starRatingContainer.addEventListener('mousemove', e => renderStars(getRatingFromEvent(e) !== -1 ? getRatingFromEvent(e) : currentRating));
    starRatingContainer.addEventListener('mouseout', () => renderStars(currentRating));
    starRatingContainer.addEventListener('click', e => {
        const clickedRating = getRatingFromEvent(e);
        if (clickedRating !== -1) {
            currentRating = clickedRating;
            starScoreInput.value = currentRating;
            renderStars(currentRating);
            // 별점을 선택하면 오류 메시지 숨김
            starRatingError.style.display = 'none';
        }
    });

    renderStars(0); // 초기 별점 렌더링

    // --- 이미지 업로드 미리보기 및 삭제 기능 ---
	const dropZone = document.getElementById('dropZone');
	const fileInput = document.getElementById('reviewImages');
	const preview = document.getElementById('thumbnailPreview');
	const MAX_IMAGES = 5;
	let fileBuffer = [];

	if (dropZone && fileInput && preview) {
		dropZone.onclick = () => fileInput.click();
		fileInput.onchange = handleFiles;
		dropZone.ondragover = e => { e.preventDefault(); dropZone.style.background = '#eee'; };
		dropZone.ondragleave = () => { dropZone.style.background = '#fafafa'; };
		dropZone.ondrop = e => {
			e.preventDefault();
			dropZone.style.background = '#fafafa';
			handleFiles(e);
		};

		function handleFiles(e) {
			const newFiles = e.target.files || e.dataTransfer.files;
			const imageFiles = Array.from(newFiles).filter(f => f.type.startsWith('image/'));
			const combinedFiles = [...fileBuffer, ...imageFiles];
			fileBuffer = combinedFiles.slice(0, MAX_IMAGES);
			updateFileInput();
			refreshPreview();
		}

		function refreshPreview() {
			preview.innerHTML = '';
			fileBuffer.forEach((file, index) => {
				const reader = new FileReader();
				reader.onload = e => {
					const wrapper = document.createElement('div');
					wrapper.className = 'thumbnail-wrapper';
					const img = document.createElement('img');
					img.src = e.target.result;
					img.className = 'thumbnail-img';
					const deleteBtn = document.createElement('button');
					deleteBtn.type = 'button';
					deleteBtn.className = 'thumbnail-delete-btn';
					deleteBtn.innerText = 'X';
					deleteBtn.dataset.index = index;
					deleteBtn.onclick = removeFile;
					wrapper.appendChild(img);
					wrapper.appendChild(deleteBtn);
					preview.appendChild(wrapper);
				};
				reader.readAsDataURL(file);
			});
		}
		
		function removeFile(e) {
			const indexToRemove = parseInt(e.target.dataset.index, 10);
			fileBuffer.splice(indexToRemove, 1);
			updateFileInput();
			refreshPreview();
		}
		
		function updateFileInput() {
			const dataTransfer = new DataTransfer();
			fileBuffer.forEach(file => dataTransfer.items.add(file));
			fileInput.files = dataTransfer.files;
		}
	}

    // --- 폼 제출 유효성 검사 ---
    reviewForm.addEventListener('submit', function(e) {
        if (parseFloat(starScoreInput.value) <= 0) {
            e.preventDefault(); // 폼 제출 중단
            starRatingError.innerText = '별점을 선택해주세요.';
            starRatingError.style.display = 'block';
        }
    });

    // 페이지 로드 시, 컨트롤러에서 보낸 에러 메시지가 있으면 표시
    if (starRatingError.innerText.trim()) {
        starRatingError.style.display = 'block';
    }

    // 리뷰 삭제 확인 커스텀 모달 적용
    const reviewContainer = document.querySelector('.review-form-container');
    if(reviewContainer) {
        reviewContainer.addEventListener('submit', function(e) {
            const form = e.target;
            if (form.classList.contains('review-delete-form')) {
                e.preventDefault(); // 폼 기본 제출 방지
                showSystemAlert({
                    message: '정말로 이 리뷰를 삭제하시겠습니까?',
                    onConfirm: () => form.submit()
                });
            }
        });
    }
});
</script>
<script
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoApiKey}&libraries=services"></script>
<script>
  var mapContainer = document.getElementById('map');
  var mapOption = {
      center: new kakao.maps.LatLng(37.5665, 126.9780),
      level: 3
  };
  var map = new kakao.maps.Map(mapContainer, mapOption);
  var placeName = "${restaurant.name}";
  var ps = new kakao.maps.services.Places();
  ps.keywordSearch(placeName, function(result, status) {
    if (status === kakao.maps.services.Status.OK) {
      var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
      var marker = new kakao.maps.Marker({
          map: map,
          position: coords
      });
      map.setCenter(coords);
    } else {
      // 장소를 찾지 못했을 때 사용자에게 알림을 주지 않도록 주석 처리하거나 로직을 변경할 수 있습니다.
      // console.error('장소를 찾을 수 없습니다:', placeName);
    }
  });
</script>

<!-- 신규 신고 모달 (System Alert 스타일) -->
<div id="reportModal" class="confirm-modal-overlay">
    <div class="confirm-modal-content">
        <h3 class="confirm-modal-title" style="margin-bottom: 20px;">리뷰 신고</h3>
        <form id="reportForm">
            <input type="hidden" id="reportReviewId" name="reviewId">
            
            <div class="form-group" style="margin-bottom: 15px; text-align: left;">
                <label for="reportCategory" style="display: block; margin-bottom: 8px; font-weight: 500;">신고 사유</label>
                <select name="reportCategory" id="reportCategory" class="form-control" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
                    <option value="SPAM">스팸/홍보성</option>
                    <option value="INAPPROPRIATE">욕설/비방 등 부적절한 내용</option>
                    <option value="ETC">기타 (직접 입력)</option>
                </select>
            </div>
            
            <div class="form-group" id="reportContentGroup" style="display:none; margin-bottom: 20px; text-align: left;">
                <label for="reportContent" style="display: block; margin-bottom: 8px; font-weight: 500;">상세 사유</label>
                <textarea name="reportContent" id="reportContent" rows="3" class="form-control" placeholder="상세한 신고 사유를 입력해주세요." style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; resize: vertical;"></textarea>
            </div>

            <div class="confirm-modal-buttons">
                <button type="button" class="btn btn-secondary" style="padding: 10px 20px; font-size: 1em;" onclick="closeReportModal()">취소</button>
                <button type="submit" class="btn btn-danger" style="padding: 10px 20px; font-size: 1em;">신고하기</button>
            </div>
        </form>
    </div>
</div>

<script>
// 신고 모달 관련 스크립트
function openReportModal(reviewId) {
    document.getElementById('reportReviewId').value = reviewId;
    document.getElementById('reportModal').classList.add('show');
}

function closeReportModal() {
    const modal = document.getElementById('reportModal');
    modal.classList.remove('show');
    // 모달이 닫힐 때 폼 내용 초기화
    document.getElementById('reportForm').reset();
    document.getElementById('reportContentGroup').style.display = 'none';
}

// '기타' 선택 시 상세 사유 입력창 표시
document.getElementById('reportCategory').addEventListener('change', function() {
    const reportContentGroup = document.getElementById('reportContentGroup');
    reportContentGroup.style.display = (this.value === 'ETC') ? 'block' : 'none';
});

// 폼 제출 로직
document.getElementById('reportForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const reviewId = document.getElementById('reportReviewId').value;
    const category = document.getElementById('reportCategory').value;
    const content = document.getElementById('reportContent').value;

    // '기타' 선택 시 내용이 비어있는지 확인
    if (category === 'ETC' && !content.trim()) {
        showToast('상세한 신고 사유를 입력해주세요.');
        return;
    }

    const formData = new FormData(this);

    // 신고 모달을 먼저 닫고, 확인 모달을 띄웁니다.
    closeReportModal();

    // 최종 확인 알림창 (setTimeout으로 약간의 지연을 줌)
    setTimeout(() => {
        showSystemAlert({
            message: '정말로 이 리뷰를 신고하시겠습니까?',
            onConfirm: () => {
                fetch('${pageContext.request.contextPath}/restaurant/review/report.do', {
                    method: 'POST',
                    body: new URLSearchParams(formData)
                })
                .then(response => response.json())
                .then(data => {
                    showToast(data.message || (data.success ? '신고가 접수되었습니다.' : '오류가 발생했습니다.'));
                    if(data.success) {
                        // 성공 시 신고 버튼을 비활성화하고 텍스트 변경
                        const reportButton = document.querySelector(`.btn-report[onclick="openReportModal(${reviewId})"]`);
                        if(reportButton) {
                            reportButton.disabled = true;
                            reportButton.textContent = '신고됨';
                            reportButton.classList.add('disabled');
                        }
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('신고 처리 중 오류가 발생했습니다.');
                });
            }
        });
    }, 150); // 150ms 지연
});

// 모달 외부 클릭 시 닫기
document.getElementById('reportModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeReportModal();
    }
});
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
