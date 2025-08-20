package kr.ac.kopo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.service.MemberService;
import kr.ac.kopo.service.RestaurantService;
import kr.ac.kopo.util.SHA256Util;
import kr.ac.kopo.vo.MemberStatusLogVO;
import kr.ac.kopo.vo.MemberVO;
import kr.ac.kopo.vo.RestaurantVO;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private RestaurantService restaurantService;

    // --- 회원가입 화면 호출 (GET) ---
    @GetMapping("/join.do")
    public String joinForm(Model model) {
        model.addAttribute("activeMenu", "join");
        return "member/join"; // WEB-INF/jsp/member/join.jsp
    }

    // --- 회원가입 요청 (POST) ---
    @PostMapping("/join.do")
    public String join(MemberVO member, RedirectAttributes redirectAttrs, @RequestParam(value = "redirect", required = false) String redirect) {
        String encPw = SHA256Util.encrypt(member.getPassword());
        member.setPassword(encPw);
        memberService.register(member);
        
        // redirect 파라미터가 있으면 해당 목적지를 유지한 채 로그인 페이지로 이동
        if (redirect != null && !redirect.isEmpty()) {
            return "redirect:/member/login.do?redirect=" + redirect;
        }
        
        // redirect 파라미터가 없으면, 회원가입 완료 토스트와 함께 로그인 페이지로 이동
        redirectAttrs.addFlashAttribute("toast", "회원가입이 완료되었습니다. 로그인해주세요.");
        return "redirect:/member/login.do";
    }

    // --- 아이디 중복체크 요청 (GET) ---
    @GetMapping("/checkId.do")
    @ResponseBody
    public String checkId(@RequestParam("id") String id) {
        MemberVO member = memberService.getMemberById(id);
        return (member == null) ? "OK" : "EXISTS";
    }


    // --- 로그인 화면 호출 (GET) ---
    @GetMapping("/login.do")
    public String loginForm(Model model, @RequestParam(value = "redirect", required = false) String redirect) {
        // 다른 페이지에서 리다이렉트된 경우, 메시지와 돌아갈 주소를 모델에 추가
        if (redirect != null && !redirect.isEmpty()) {
            model.addAttribute("redirect", redirect);
            model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
        }
        model.addAttribute("activeMenu", "login");
        return "member/login";
    }

    // --- 로그인 요청 (POST) ---
    @PostMapping("/login.do")
    public String login(MemberVO member, Model model, HttpSession session, RedirectAttributes redirectAttrs, @RequestParam(value = "redirect", required = false) String redirect) {
        MemberVO loginUser = memberService.login(member);
        
        if (loginUser == null) {
            model.addAttribute("msg", "아이디 또는 패스워드가 유효하지 않습니다.");
            model.addAttribute("activeMenu", "login"); // 로그인 실패 시에도 activeMenu 유지
            return "member/login"; // 로그인 실패 시, 다시 로그인 페이지로
        }

        // 비활성화된 계정인지 확인
        if ("N".equals(loginUser.getStatus())) {
            // 서비스 계층을 통해 가장 최근의 비활성화 로그를 조회
            MemberStatusLogVO log = memberService.getLatestDeactivationLog(loginUser.getId());
            String reason = (log != null) ? log.getReason() : "알 수 없는 사유";
            
            redirectAttrs.addFlashAttribute("deactivationReason", reason);
            return "redirect:/member/login.do";
        }

        // 로그인 성공 시, 세션에 사용자 정보 저장
        session.setAttribute("loginUser", loginUser);
        redirectAttrs.addFlashAttribute("toast", "성공적으로 로그인되었습니다.");

        // 돌아갈 페이지가 지정되어 있으면 해당 페이지로, 없으면 메인으로 리다이렉트
        if (redirect != null && !redirect.isEmpty() && !redirect.equals("null")) {
            return "redirect:" + redirect;
        }
        
        return "redirect:/main.do";
    }

    // ... (다른 메소드 생략) ...

    // --- 로그아웃 요청 ---
    @RequestMapping("/logout.do")
    public String logout(HttpSession session, RedirectAttributes redirectAttrs, @RequestParam(value = "redirect", required = false) String redirect) {
        session.invalidate(); // 세션 전체를 무효화
        redirectAttrs.addFlashAttribute("toast", "성공적으로 로그아웃되었습니다.");
        
        // 돌아갈 페이지가 지정되어 있으면 해당 페이지로, 없으면 메인으로 리다이렉트
        if (redirect != null && !redirect.isEmpty()) {
            return "redirect:" + redirect;
        }
        
        return "redirect:/main.do";
    }


    // --- 마이페이지 화면 호출 (GET) ---
    @GetMapping("/mypage.do")
    public String myPage(HttpSession session, Model model, RedirectAttributes redirectAttrs) {
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            // 로그인 페이지로 리다이렉트, 돌아갈 주소(mypage.do)를 파라미터로 추가
            redirectAttrs.addAttribute("redirect", "/member/mypage.do");
            return "redirect:/member/login.do";
        }
        List<RestaurantVO> favoriteList = restaurantService.getMyFavoriteRestaurants(loginUser.getId());
        
        
        model.addAttribute("favoriteList", favoriteList);
        model.addAttribute("activeMenu", "mypage");
        return "member/mypage";
    }
    
    // --- 프로필 수정 화면 호출 (GET) ---
    @GetMapping("/editProfile.do")
    public String editProfileForm(HttpSession session, RedirectAttributes redirectAttrs, Model model) {
        if (session.getAttribute("loginUser") == null) {
            redirectAttrs.addAttribute("redirect", "/member/editProfile.do");
            return "redirect:/member/login.do";
        }
        model.addAttribute("activeMenu", "mypage");
        return "member/editProfile";
    }

    // --- 프로필 수정 요청 (POST) ---
    @PostMapping("/editProfile.do")
    public String editProfile(MemberVO member, HttpSession session, RedirectAttributes redirectAttrs) {
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        member.setId(loginUser.getId()); // 현재 로그인된 사용자의 ID를 설정
        
        memberService.updateProfile(member);
        
        // 세션에 저장된 사용자 정보도 업데이트
        loginUser.setNickname(member.getNickname());
        loginUser.setEmail(member.getEmail());
        session.setAttribute("loginUser", loginUser);
        
        redirectAttrs.addFlashAttribute("toast", "프로필 정보가 성공적으로 수정되었습니다.");
        return "redirect:/member/mypage.do";
    }
    
    // --- 비밀번호변경 화면 호출 (GET) ---
    @GetMapping("/changePassword.do")
    public String changePasswordForm(HttpSession session, RedirectAttributes redirectAttrs, Model model) {
        if (session.getAttribute("loginUser") == null) {
            // 로그인 페이지로 리다이렉트, 돌아올 주소(changePassword.do)를 파라미터로 추가
            redirectAttrs.addAttribute("redirect", "/member/changePassword.do");
            return "redirect:/member/login.do";
        }
        model.addAttribute("activeMenu", "mypage");
        return "member/changePassword";
    }
    
    // --- 비밀번호 변경 요청 (POST) ---
	@PostMapping("/changePassword.do")
    public String changePassword(@RequestParam String currentPassword,
            @RequestParam String newPassword,
            HttpSession session, RedirectAttributes redirectAttrs) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		
		// 현재 비밀번호가 맞는지 확인 (서비스에서 암호화를 처리하므로 원본 비밀번호 전달)
		MemberVO checkUser = new MemberVO();
		checkUser.setId(loginUser.getId());
		checkUser.setPassword(currentPassword); // 암호화하지 않은 원본 비밀번호 전달
		
		if (memberService.login(checkUser) == null) {
		    redirectAttrs.addFlashAttribute("msg", "현재 비밀번호가 일치하지 않습니다.");
		    return "redirect:/member/changePassword.do";
		}
		
		// 새 비밀번호로 변경
		String encNewPw = SHA256Util.encrypt(newPassword);
		memberService.updatePassword(loginUser.getId(), encNewPw);
		redirectAttrs.addFlashAttribute("toast", "비밀번호가 성공적으로 변경되었습니다.");
		return "redirect:/member/mypage.do";
	}
    
    // --- 계정 삭제 요청 (GET) ---
	@GetMapping("/deleteAccount.do")
	public String deleteAccount(HttpSession session, RedirectAttributes redirectAttrs) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
            // 로그인 되어있지 않으면 로그인 페이지로
            redirectAttrs.addAttribute("redirect", "/member/mypage.do"); // 삭제 후 갈 곳이 없으니 마이페이지로 설정
            return "redirect:/member/login.do";
        }
		memberService.deleteAccount(loginUser.getId());
		session.invalidate(); // 세션 무효화 (로그아웃)
		return "redirect:/main.do";
	}
}



