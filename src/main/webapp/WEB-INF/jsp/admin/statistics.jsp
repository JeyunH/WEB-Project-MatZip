<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="activeMenu" value="admin" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

<div class="container">
    <h2 class="center-title">통계</h2>

    <div class="tabs">
        <button class="tab-link active" onclick="openTab(event, 'user-stats')">사용자 통계</button>
        <button class="tab-link" onclick="openTab(event, 'restaurant-stats')">맛집 통계</button>
        <button class="tab-link" onclick="openTab(event, 'review-stats')">리뷰 통계</button>
    </div>

    <div id="user-stats" class="tab-content" style="display: block;">
        <div class="admin-content">
            <%-- 사용자 통계 섹션 --%>
            <div class="stat-section">
                <h3><i class="fa fa-users"></i> 사용자 통계</h3>
                <div class="stat-grid">
                    <div class="stat-item">
                        <h4>총 회원 수</h4>
                        <p>${userStats.totalUsers} 명</p>
                    </div>
                    <div class="stat-item">
                        <h4>활성 회원</h4>
                        <p>${userStats.activeUsers} 명</p>
                        <span class="stat-percentage">(${userStats.activePercentage})</span>
                    </div>
                    <div class="stat-item">
                        <h4>비활성 회원</h4>
                        <p>${userStats.inactiveUsers} 명</p>
                        <span class="stat-percentage">(${userStats.inactivePercentage})</span>
                    </div>
                </div>
            </div>

            <%-- 신규 가입자 추이 섹션 --%>
            <div class="stat-section">
                <h3><i class="fa fa-line-chart"></i> 신규 가입자 추이</h3>
                <div class="chart-controls">
                    <button class="chart-tab-btn active" data-period="daily">일별</button>
                    <button class="chart-tab-btn" data-period="weekly">주별</button>
                    <button class="chart-tab-btn" data-period="monthly">월별</button>
                </div>
                <div class="chart-container">
                    <canvas id="newUserChart"></canvas>
                </div>
            </div>

            <%-- 사용자 활동 순위 섹션 --%>
            <div class="stat-section">
                <h3><i class="fa fa-trophy"></i> 사용자 활동 순위</h3>
                <div class="ranking-controls">
                    <button class="ranking-tab-btn active" data-ranking="reviews">리뷰 순위</button>
                    <button class="ranking-tab-btn" data-ranking="favorites">찜 순위</button>
                </div>

                <%-- 리뷰 랭킹 테이블 --%>
                <div id="reviews-ranking" class="ranking-table-container">
                    <table class="ranking-table">
                        <thead>
                            <tr>
                                <th>순위</th>
                                <th>아이디</th>
                                <th>닉네임</th>
                                <th>리뷰 수</th>
                                <th>가입일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${userStats.reviewRankers}" var="ranker" varStatus="status">
                                <tr>
                                    <td>${status.count}</td>
                                    <td><a href="${pageContext.request.contextPath}/admin/userDetail.do?id=${ranker.id}">${ranker.id}</a></td>
                                    <td>${ranker.nickname}</td>
                                    <td>${ranker.reviewCount}</td>
                                    <td><fmt:formatDate value="${ranker.regdate}" pattern="yyyy-MM-dd"/></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty userStats.reviewRankers}">
                                <tr><td colspan="5">리뷰를 작성한 사용자가 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <%-- 찜 랭킹 테이블 --%>
                <div id="favorites-ranking" class="ranking-table-container" style="display: none;">
                    <table class="ranking-table">
                        <thead>
                            <tr>
                                <th>순위</th>
                                <th>아이디</th>
                                <th>닉네임</th>
                                <th>찜 수</th>
                                <th>가입일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${userStats.favoriteRankers}" var="ranker" varStatus="status">
                                <tr>
                                    <td>${status.count}</td>
                                    <td><a href="${pageContext.request.contextPath}/admin/userDetail.do?id=${ranker.id}">${ranker.id}</a></td>
                                    <td>${ranker.nickname}</td>
                                    <td>${ranker.favoriteCount}</td>
                                    <td><fmt:formatDate value="${ranker.regdate}" pattern="yyyy-MM-dd"/></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty userStats.favoriteRankers}">
                                <tr><td colspan="5">찜을 등록한 사용자가 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="restaurant-stats" class="tab-content" style="display: none;">
        <div class="admin-content">
            <%-- 맛집 통계 섹션 --%>
            <div class="stat-section">
                <h3><i class="fa fa-cutlery"></i> 맛집 통계</h3>
                <div class="stat-grid">
                    <div class="stat-item">
                        <h4>총 맛집 수</h4>
                        <p>${restaurantStats.totalRestaurants} 개</p>
                    </div>
                    <div class="stat-item">
                        <h4>승인된 맛집</h4>
                        <p>${restaurantStats.approvedRestaurants} 개</p>
                    </div>
                    <div class="stat-item">
                        <h4>미승인 맛집</h4>
                        <p>${restaurantStats.unapprovedRestaurants} 개</p>
                    </div>
                </div>
            </div>

            <%-- 신규 맛집 등록 추이 섹션 --%>
            <div class="stat-section">
                <h3><i class="fa fa-line-chart"></i> 신규 맛집 등록 추이</h3>
                <div class="chart-controls">
               		<button class="chart-tab-btn-resto active" data-period="daily">일별</button>
                    <button class="chart-tab-btn-resto" data-period="weekly">주별</button>                    
                    <button class="chart-tab-btn-resto" data-period="monthly">월별</button>
                </div>
                <div class="chart-container">
                    <canvas id="newRestaurantChart"></canvas> <%-- TODO: 차트 구현 --%>
                </div>
            </div>

            <%-- 맛집 활동 순위 섹션 --%>
            <div class="stat-section">
                <h3><i class="fa fa-trophy"></i> 맛집 활동 순위</h3>
                <div class="ranking-controls">
                    <button class="ranking-tab-btn-resto active" data-ranking="reviews">리뷰 순위</button>
                    <button class="ranking-tab-btn-resto" data-ranking="favorites">찜 순위</button>
                    <button class="ranking-tab-btn-resto" data-ranking="ratings">평점 순위</button>
                </div>

                <%-- 리뷰 랭킹 테이블 --%>
                <div id="reviews-ranking-resto" class="ranking-table-container-resto">
                    <table class="ranking-table">
                        <thead>
                            <tr>
                                <th>순위</th>
                                <th>상호명</th>
                                <th>카테고리</th>
                                <th>리뷰 수</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${restaurantStats.reviewRankers}" var="ranker" varStatus="status">
                                <tr>
                                    <td>${status.count}</td>
                                    <td><a href="${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${ranker.restaurantId}">${ranker.name}</a></td>
                                    <td>${ranker.category}</td>
                                    <td>${ranker.reviewCount}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty restaurantStats.reviewRankers}">
                                <tr><td colspan="4">리뷰가 많은 맛집이 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <%-- 찜 랭킹 테이블 --%>
                <div id="favorites-ranking-resto" class="ranking-table-container-resto" style="display: none;">
                    <table class="ranking-table">
                        <thead>
                            <tr>
                                <th>순위</th>
                                <th>상호명</th>
                                <th>카테고리</th>
                                <th>찜 수</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${restaurantStats.favoriteRankers}" var="ranker" varStatus="status">
                                <tr>
                                    <td>${status.count}</td>
                                    <td><a href="${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${ranker.restaurantId}">${ranker.name}</a></td>
                                    <td>${ranker.category}</td>
                                    <td>${ranker.favoriteCount}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty restaurantStats.favoriteRankers}">
                                <tr><td colspan="4">찜이 많은 맛집이 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                
                <%-- 평점 랭킹 테이블 --%>
                <div id="ratings-ranking-resto" class="ranking-table-container-resto" style="display: none;">
                    <table class="ranking-table">
                        <thead>
                            <tr>
                                <th>순위</th>
                                <th>상호명</th>
                                <th>카테고리</th>
                                <th>평점</th>
                                <th>리뷰 수</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${restaurantStats.ratingRankers}" var="ranker" varStatus="status">
                                <tr>
                                    <td>${status.count}</td>
                                    <td><a href="${pageContext.request.contextPath}/restaurant/detail.do?restaurantId=${ranker.restaurantId}">${ranker.name}</a></td>
                                    <td>${ranker.category}</td>
                                    <td><fmt:formatNumber value="${ranker.starScore}" maxFractionDigits="1"/></td>
                                    <td>${ranker.reviewCount}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty restaurantStats.ratingRankers}">
                                <tr><td colspan="5">평점이 높은 맛집이 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="review-stats" class="tab-content" style="display: none;">
        <div class="admin-content">
            <%-- 리뷰 통계 섹션 --%>
            <div class="stat-section">
                <h3><i class="fa fa-comments"></i> 리뷰 통계</h3>
                <div class="stat-grid">
                    <div class="stat-item">
                        <h4>총 리뷰 수</h4>
                        <p><fmt:formatNumber value="${reviewStats.TOTALREVIEWS}" pattern="#,##0" /> 개</p>
                    </div>
                    <div class="stat-item">
                        <h4>평균 별점</h4>
                        <p><fmt:formatNumber value="${reviewStats.AVERAGERATING}" maxFractionDigits="1" /> 점</p>
                    </div>
                    <div class="stat-item">
                        <h4>포토 리뷰 수</h4>
                        <p><fmt:formatNumber value="${reviewStats.PHOTOREVIEWCOUNT}" pattern="#,##0" /> 개</p>
                    </div>
                </div>
            </div>

            <%-- 신규 리뷰 등록 추이 섹션 --%>
            <div class="stat-section">
                <h3><i class="fa fa-line-chart"></i> 신규 리뷰 등록 추이</h3>
                <div class="chart-controls">
                	<button class="chart-tab-btn-review active" data-period="daily">일별</button>
                    <button class="chart-tab-btn-review" data-period="weekly">주별</button>                    
                    <button class="chart-tab-btn-review" data-period="monthly">월별</button>
                </div>
                <div class="chart-container">
                    <canvas id="newReviewChart"></canvas>
                </div>
            </div>

            <%-- 별점 분포 섹션 --%>
            <div class="stat-section">
                <h3><i class="fa fa-star"></i> 별점 분포</h3>
                <div class="chart-container">
                    <canvas id="ratingDistributionChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>

<%-- Chart.js 라이브러리 --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
function openTab(evt, tabName) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tab-content");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tab-link");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
}

document.addEventListener('DOMContentLoaded', function () {
    <%-- 페이지 로드 시 초기 상태는 HTML에 이미 설정되어 있으므로, 불필요한 클릭 이벤트를 제거합니다. --%>

    <%-- Controller에서 전달한 JSON 문자열을 JavaScript 객체로 파싱 --%>
    const chartData = {
        daily: ${dailyNewUsersJson},
        weekly: ${weeklyNewUsersJson},
        monthly: ${monthlyNewUsersJson}
    };

    const ctx = document.getElementById('newUserChart').getContext('2d');
    let userChart;

    <%-- 차트 생성 및 업데이트 함수 --%>
    function createOrUpdateChart(period) {
        const data = chartData[period];
        const labels = data.map(d => d.period);
        const counts = data.map(d => d.count);

        let labelText = '';
        if (period === 'daily') labelText = '일별 신규 가입자 수';
        else if (period === 'weekly') labelText = '주별 신규 가입자 수';
        else if (period === 'monthly') labelText = '월별 신규 가입자 수';

        if (userChart) {
            userChart.data.labels = labels;
            userChart.data.datasets[0].data = counts;
            userChart.data.datasets[0].label = labelText;
            userChart.update();
        } else {
            userChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: labelText,
                        data: counts,
                        borderColor: '#5c67f2',
                        backgroundColor: 'rgba(92, 103, 242, 0.1)',
                        fill: true,
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1 <%-- 정수 단위로만 y축 표시 --%>
                            }
                        }
                    }
                }
            });
        }
    }

    <%-- 탭 버튼 이벤트 리스너 --%>
    const tabButtons = document.querySelectorAll('.chart-tab-btn');
    tabButtons.forEach(button => {
        button.addEventListener('click', function () {
            <%-- 활성 탭 스타일 변경 --%>
            tabButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');

            const period = this.getAttribute('data-period');
            createOrUpdateChart(period);
        });
    });

    <%-- 초기 차트 로드 (일별) --%>
    createOrUpdateChart('daily');

    <%-- 랭킹 탭 기능 --%>
    const rankingTabButtons = document.querySelectorAll('.ranking-tab-btn');
    const rankingContainers = document.querySelectorAll('.ranking-table-container');

    rankingTabButtons.forEach(button => {
        button.addEventListener('click', function() {
            <%-- 모든 버튼의 active 클래스 제거 --%>
            rankingTabButtons.forEach(btn => btn.classList.remove('active'));
            <%-- 현재 클릭한 버튼에 active 클래스 추가 --%>
            this.classList.add('active');

            const rankingToShow = this.getAttribute('data-ranking');

            <%-- 모든 랭킹 컨테이너 숨기기 --%>
            rankingContainers.forEach(container => {
                container.style.display = 'none';
            });

            <%-- 선택된 랭킹 컨테이너 보여주기 --%>
            document.getElementById(rankingToShow + '-ranking').style.display = 'block';
        });
    });

    <%-- ================================================================= --%>
    <%-- 맛집 통계 스크립트 --%>
    <%-- ================================================================= --%>

    const restaurantChartData = {
        daily: ${dailyNewRestaurantsJson},
        weekly: ${weeklyNewRestaurantsJson},
        monthly: ${monthlyNewRestaurantsJson}
    };
    
    const restoCtx = document.getElementById('newRestaurantChart').getContext('2d');
    let restaurantChart;

    function createOrUpdateRestaurantChart(period) {
        const data = restaurantChartData[period];
        const labels = data.map(d => d.period);
        const counts = data.map(d => d.count);

        let labelText = '';
        if (period === 'daily') labelText = '일별 신규 맛집 수';
        else if (period === 'weekly') labelText = '주별 신규 맛집 수';
        else if (period === 'monthly') labelText = '월별 신규 맛집 수';

        if (restaurantChart) {
            restaurantChart.data.labels = labels;
            restaurantChart.data.datasets[0].data = counts;
            restaurantChart.data.datasets[0].label = labelText;
            restaurantChart.update();
        } else {
            restaurantChart = new Chart(restoCtx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: labelText,
                        data: counts,
                        borderColor: '#f2a65c',
                        backgroundColor: 'rgba(242, 166, 92, 0.1)',
                        fill: true,
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    }
                }
            });
        }
    }

    const restoTabButtons = document.querySelectorAll('.chart-tab-btn-resto');
    restoTabButtons.forEach(button => {
        button.addEventListener('click', function () {
            restoTabButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            const period = this.getAttribute('data-period');
            createOrUpdateRestaurantChart(period);
        });
    });

    createOrUpdateRestaurantChart('daily');

    const restoRankingTabButtons = document.querySelectorAll('.ranking-tab-btn-resto');
    const restoRankingContainers = document.querySelectorAll('.ranking-table-container-resto');

    restoRankingTabButtons.forEach(button => {
        button.addEventListener('click', function() {
            restoRankingTabButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');

            const rankingToShow = this.getAttribute('data-ranking');

            restoRankingContainers.forEach(container => {
                container.style.display = 'none';
            });

            document.getElementById(rankingToShow + '-ranking-resto').style.display = 'block';
        });
    });

    <%-- ================================================================= --%>
    <%-- 리뷰 통계 스크립트 (0.5점 단위 수정) --%>
    <%-- ================================================================= --%>

    const reviewChartData = {
        daily: ${dailyNewReviewsJson},
        weekly: ${weeklyNewReviewsJson},
        monthly: ${monthlyNewReviewsJson}
    };
    
    // DB에서 받은 데이터를 Chart.js 형식에 맞게 가공 (0.5점 단위 처리)
    const rawRatingData = ${ratingDistributionJson};
    const ratingDistributionData = {
        labels: ['0.5점', '1점', '1.5점', '2점', '2.5점', '3점', '3.5점', '4점', '4.5점', '5점'],
        counts: Array(10).fill(0) // 10칸짜리 배열로 초기화
    };

    rawRatingData.forEach(item => {
        // item.rating 값 (0.5 ~ 5.0)을 인덱스 (0 ~ 9)로 변환
        const index = (item.rating * 2) - 1;
        if (index >= 0 && index < 10) {
            ratingDistributionData.counts[index] = item.count;
        }
    });

    const reviewCtx = document.getElementById('newReviewChart').getContext('2d');
    let reviewChart;

    function createOrUpdateReviewChart(period) {
        const data = reviewChartData[period];
        const labels = data.map(d => d.period);
        const counts = data.map(d => d.count);

        let labelText = '';
        if (period === 'daily') labelText = '일별 신규 리뷰 수';
        else if (period === 'weekly') labelText = '주별 신규 리뷰 수';
        else if (period === 'monthly') labelText = '월별 신규 리뷰 수';

        if (reviewChart) {
            reviewChart.data.labels = labels;
            reviewChart.data.datasets[0].data = counts;
            reviewChart.data.datasets[0].label = labelText;
            reviewChart.update();
        } else {
            reviewChart = new Chart(reviewCtx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: labelText,
                        data: counts,
                        borderColor: '#4BC0C0',
                        backgroundColor: 'rgba(75, 192, 192, 0.1)',
                        fill: true,
                        tension: 0.1
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } } }
            });
        }
    }

    const reviewTabButtons = document.querySelectorAll('.chart-tab-btn-review');
    reviewTabButtons.forEach(button => {
        button.addEventListener('click', function () {
            reviewTabButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            const period = this.getAttribute('data-period');
            createOrUpdateReviewChart(period);
        });
    });

    createOrUpdateReviewChart('daily');

    const ratingCtx = document.getElementById('ratingDistributionChart').getContext('2d');
    new Chart(ratingCtx, {
        type: 'bar',
        data: {
            labels: ratingDistributionData.labels,
            datasets: [{
                label: '별점 수',
                data: ratingDistributionData.counts,
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)', 'rgba(255, 120, 132, 0.2)',
                    'rgba(255, 159, 64, 0.2)', 'rgba(255, 179, 64, 0.2)',
                    'rgba(255, 205, 86, 0.2)', 'rgba(255, 225, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)', 'rgba(75, 212, 192, 0.2)',
                    'rgba(54, 162, 235, 0.2)', 'rgba(54, 182, 235, 0.2)'
                ],
                borderColor: [
                    'rgb(255, 99, 132)', 'rgb(255, 120, 132)',
                    'rgb(255, 159, 64)', 'rgb(255, 179, 64)',
                    'rgb(255, 205, 86)', 'rgb(255, 225, 86)',
                    'rgb(75, 192, 192)', 'rgb(75, 212, 192)',
                    'rgb(54, 162, 235)', 'rgb(54, 182, 235)'
                ],
                borderWidth: 1
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } } }
    });
});
</script>