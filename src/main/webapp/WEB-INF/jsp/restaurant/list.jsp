<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="mytag" tagdir="/WEB-INF/tags" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<div class="container">
	<h2 class="center-title">맛집 리스트</h2>

    <form id="filter-form" action="${pageContext.request.contextPath}/restaurant/list.do" method="get">
        <input type="hidden" name="page" value="1">
        <input type="hidden" name="region" value="${selectedRegion}">
        <input type="hidden" name="category" value="${selectedCategory}">
        <input type="hidden" name="sort" value="${selectedSort}">

        <!-- 검색창 -->
        <div class="search-bar-container">
            <div class="search-form-wrapper">
                <input type="text" name="keyword" placeholder="가게이름, 지역, 카테고리, 메뉴 검색" value="${selectedKeyword}">
                <button type="submit">검색</button>
            </div>
        </div>

        <!-- 필터 UI -->
        <div class="filter-container">
            <!-- 지역 필터 -->
            <div class="filter-group">
                <span class="filter-group-title">지역</span>
                <button type="button" onclick="applyFilter('region', 'all')" class="filter-btn ${selectedRegion == 'all' ? 'active' : ''}">전체</button>
                <c:forEach var="r" items="${topRegions}">
                    <button type="button" onclick="applyFilter('region', '${r}')" class="filter-btn ${selectedRegion == r ? 'active' : ''}">${r}</button>
                </c:forEach>
                <c:if test="${allRegions.size() > topRegions.size()}">
                    <button type="button" class="filter-btn more-btn" onclick="toggleMoreFilters('region-more', this)">더보기 ▼</button>
                </c:if>
            </div>
            <div id="region-more" class="more-filters-container hidden-filters">
                <input type="text" class="filter-search-input" placeholder="지역 검색..." onkeyup="filterButtons(this, 'region-more')">
                <div class="more-filters-list">
                    <c:forEach var="r" items="${allRegions}">
                        <c:set var="isTop" value="false" />
                        <c:forEach var="topR" items="${topRegions}"><c:if test="${topR == r}"><c:set var="isTop" value="true" /></c:if></c:forEach>
                        <c:if test="${!isTop}">
                            <button type="button" onclick="applyFilter('region', '${r}')" class="filter-btn ${selectedRegion == r ? 'active' : ''}">${r}</button>
                        </c:if>
                    </c:forEach>
                </div>
            </div>

            <!-- 카테고리 필터 -->
            <div class="filter-group">
                <span class="filter-group-title">종류</span>
                <button type="button" onclick="applyFilter('category', 'all')" class="filter-btn ${selectedCategory == 'all' ? 'active' : ''}">전체</button>
                <c:forEach var="c" items="${topCategories}">
                    <button type="button" onclick="applyFilter('category', '${c}')" class="filter-btn ${selectedCategory == c ? 'active' : ''}">${c}</button>
                </c:forEach>
                <c:if test="${allCategories.size() > topCategories.size()}">
                    <button type="button" class="filter-btn more-btn" onclick="toggleMoreFilters('category-more', this)">더보기 ▼</button>
                </c:if>
            </div>
            <div id="category-more" class="more-filters-container hidden-filters">
                <input type="text" class="filter-search-input" placeholder="종류 검색..." onkeyup="filterButtons(this, 'category-more')">
                <div class="more-filters-list">
                     <c:forEach var="c" items="${allCategories}">
                        <c:set var="isTop" value="false" />
                        <c:forEach var="topC" items="${topCategories}"><c:if test="${topC == c}"><c:set var="isTop" value="true" /></c:if></c:forEach>
                        <c:if test="${!isTop}">
                            <button type="button" onclick="applyFilter('category', '${c}')" class="filter-btn ${selectedCategory == c ? 'active' : ''}">${c}</button>
                        </c:if>
                    </c:forEach>
                </div>
            </div>

            <!-- 정렬 필터 -->
            <div class="filter-group">
                <span class="filter-group-title">정렬</span>
                <button type="button" onclick="applyFilter('sort', 'mz')" class="filter-btn ${selectedSort == 'mz' ? 'active' : ''}">MZ스코어순</button>
                <button type="button" onclick="applyFilter('sort', 'star')" class="filter-btn ${selectedSort == 'star' ? 'active' : ''}">별점순</button>
                <button type="button" onclick="applyFilter('sort', 'review')" class="filter-btn ${selectedSort == 'review' ? 'active' : ''}">리뷰순</button>
                <button type="button" onclick="applyFilter('sort', 'latest')" class="filter-btn ${selectedSort == 'latest' ? 'active' : ''}">최신순</button>
            </div>
        </div>
    </form>

	<div class="restaurant-list">
		<c:forEach var="r" items="${restaurantList}">
			<div class="restaurant-card"
				onclick="location.href='${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${r.restaurantId}'">
                <c:choose>
                    <c:when test="${not empty r.mainImgUrl1 and (fn:startsWith(r.mainImgUrl1, 'http') or fn:startsWith(r.mainImgUrl1, '//'))}">
                        <img src="${r.mainImgUrl1}" alt="${r.name} 대표 이미지" />
                    </c:when>
                    <c:otherwise>
                        <c:url value="${r.mainImgUrl1}" var="imgUrl"/>
                        <img src="${imgUrl}" alt="${r.name} 대표 이미지" />
                    </c:otherwise>
                </c:choose>
				<h3>${r.name}</h3>
				<p>${r.region} | ${r.category}</p>
				<p class="score">⭐ ${r.starScore} / MZ: ${r.mzScore}</p>
			</div>
		</c:forEach>
	</div>

    <!-- 페이지네이션 (커스텀 태그 사용) -->
    <mytag:pagination 
        paging="${paging}" 
        baseUrl="${pageContext.request.contextPath}/restaurant/list.do"
        pageParamName="page"
        otherParams="&keyword=${selectedKeyword}&region=${selectedRegion}&category=${selectedCategory}&sort=${selectedSort}"
        />
	
</div>

<script>
function applyFilter(type, value) {
    const form = document.getElementById('filter-form');
    form[type].value = value;
    form.submit();
}

function toggleMoreFilters(elementId, button) {
    const moreFilters = document.getElementById(elementId);
    const searchInput = moreFilters.querySelector('.filter-search-input');
    
    if (moreFilters.classList.contains('hidden-filters')) {
        moreFilters.classList.remove('hidden-filters');
        button.textContent = '숨기기 ▲';
        searchInput.value = ''; // 검색창 초기화
        filterButtons(searchInput, elementId); // 목록 전체 보이게
        searchInput.focus();
    } else {
        moreFilters.classList.add('hidden-filters');
        button.textContent = '더보기 ▼';
    }
}

function filterButtons(input, containerId) {
    const filter = input.value.toUpperCase();
    const container = document.getElementById(containerId);
    const buttons = container.querySelectorAll('.more-filters-list .filter-btn');
    
    buttons.forEach(btn => {
        const txtValue = btn.textContent || btn.innerText;
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
            btn.style.display = "";
        } else {
            btn.style.display = "none";
        }
    });
}

document.addEventListener('DOMContentLoaded', function() {
    // URL 파라미터에 focus=search가 있으면 검색창에 포커스
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('focus') === 'search') {
        const searchInput = document.querySelector('.search-bar-container input[name="keyword"]');
        if (searchInput) {
            searchInput.focus();
        }
    }
});
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>