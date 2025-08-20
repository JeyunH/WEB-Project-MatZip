<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%-- 이 파일은 수정할 내용이 없습니다. --%>
<footer class="main-footer">
    <div class="footer-container">
        <div class="footer-section about">
            <h3 class="footer-logo">🍔 MatZip</h3>
            <p>맛ZIP은 전국의 맛집 정보를 공유하고 평가하는 포트폴리오용 프로젝트입니다. 최고의 맛집을 찾아보세요!</p>
        </div>
        <div class="footer-section links">
            <h4>바로가기</h4>
            <ul>
                <li><a href="#">서비스 소개</a></li>
                <li><a href="#">이용약관</a></li>
                <li><a href="#">개인정보처리방침</a></li>
                <li><a href="#">고객센터</a></li>
            </ul>
        </div>
        <div class="footer-section contact">
            <h4>연락처</h4>
            <p><strong>대표:</strong> 황제윤</p>
            <p><strong>이메일:</strong> his8835@gmail.com</p>
            <p><strong>주소:</strong> 서울특별시 가상구 맛집로 123</p>
        </div>
        <div class="footer-section social">
            <h4>소셜</h4>
            <div class="social-links">
                <a href="#" class="social-icon"><i class="fa fa-github"></i></a>
                <a href="#" class="social-icon"><i class="fa fa-linkedin"></i></a>
                <a href="#" class="social-icon"><i class="fa fa-twitter"></i></a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <p>&copy; 2025 MatZip Project. All Rights Reserved.</p>
    </div>
</footer>

<style>
.main-footer {
    background-color: #2c3e50;
    color: #bdc3c7;
    padding: 40px 20px 20px 20px;
    margin-top: 60px;
}
.footer-container {
    max-width: 1200px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 30px;
    padding-bottom: 30px;
    border-bottom: 1px solid #34495e;
}
.footer-section h4, .footer-section .footer-logo {
    color: #ffffff;
    font-size: 1.2rem;
    margin-bottom: 15px;
}
.footer-section p {
    margin: 0 0 10px 0;
    font-size: 0.95rem;
    line-height: 1.6;
}
.footer-section ul {
    list-style: none;
    padding: 0;
    margin: 0;
}
.footer-section ul li {
    margin-bottom: 10px;
}
.footer-section ul a {
    color: #bdc3c7;
    text-decoration: none;
    transition: color 0.2s;
}
.footer-section ul a:hover {
    color: #ffffff;
    text-decoration: none;
}
.social-links {
    display: flex;
    justify-content: center; /* 아이콘 중앙 정렬 */
    gap: 15px;
}
.social-icon {
    display: inline-block;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background-color: #34495e;
    color: #ffffff;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 1.2rem;
    transition: background-color 0.2s, transform 0.2s;
}
.social-icon:hover {
    background-color: #4a627a;
    transform: translateY(-2px);
    text-decoration: none;
    color: white;
}
.footer-bottom {
    text-align: center;
    padding-top: 20px;
    font-size: 0.9rem;
}
.footer-bottom p {
    margin: 0;
}
</style>
</body>
</html>