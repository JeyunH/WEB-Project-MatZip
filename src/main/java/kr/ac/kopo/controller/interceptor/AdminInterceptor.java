package kr.ac.kopo.controller.interceptor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.vo.MemberVO;

@Component("adminInterceptor")
public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        
        HttpSession session = request.getSession();
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");

        // 1. 비로그인 사용자인 경우
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/member/login.do");
            return false;
        }

        // 2. 로그인했지만 관리자가 아닌 경우
        if (!"ADMIN".equals(loginUser.getType())) {
            // 이전 페이지 URL을 세션에 저장하여 리다이렉트 후 사용할 수 있도록 함
            String referer = request.getHeader("Referer");
            request.getSession().setAttribute("redirectMsg", "권한이 없습니다.");
            
            // 이전 페이지가 없는 경우를 대비하여 기본 리다이렉트 경로 설정
            String redirectUrl = (referer != null && !referer.isEmpty()) ? referer : request.getContextPath() + "/";
            response.sendRedirect(redirectUrl);
            return false;
        }

        // 3. 관리자인 경우
        return true;
    }
}
