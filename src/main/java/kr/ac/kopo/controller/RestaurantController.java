package kr.ac.kopo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.service.RestaurantService;
import kr.ac.kopo.service.ReviewReportService;
import kr.ac.kopo.service.ReviewService;
import kr.ac.kopo.vo.MemberVO;
import kr.ac.kopo.vo.RestaurantReviewVO;
import kr.ac.kopo.vo.ReviewReportVO;


@Controller
@RequestMapping("/restaurant")
@PropertySource("classpath:api.properties")
public class RestaurantController {
	
	@Value("${kakaomap.apikey}")
	private String kakaoApiKey;
    @Autowired
    private RestaurantService restaurantService;
    @Autowired
    private ReviewService reviewService;
    @Autowired
    private ReviewReportService reviewReportService;
    
    
    // ▼▼▼▼▼ [수정] list.do 메소드 수정 ▼▼▼▼▼
    @RequestMapping("/list.do")
    public String list(Model model,
                       @RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "") String keyword,
                       @RequestParam(defaultValue = "all") String region,
                       @RequestParam(defaultValue = "all") String category,
                       @RequestParam(defaultValue = "mz") String sort) {

        // 1. 서비스 호출을 위한 파라미터 맵 생성
        Map<String, Object> params = new HashMap<>();
        params.put("page", page);
        params.put("keyword", keyword.trim());
        params.put("region", region);
        params.put("category", category);
        params.put("sort", sort);

        // 2. 서비스의 오케스트레이션 메소드 호출
        Map<String, Object> resultData = restaurantService.getFilteredRestaurantData(params);

        // 3. 모델에 데이터 추가
        model.addAllAttributes(resultData); // 맛집 리스트, 필터 목록, 페이징 정보 등 전체 추가
        model.addAttribute("selectedKeyword", keyword); // 사용자가 입력한 검색어 유지
        model.addAttribute("selectedRegion", region);   // 선택된 필터 값 유지
        model.addAttribute("selectedCategory", category);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("activeMenu", "list");

        return "restaurant/list";
    }
    // ▲▲▲▲▲ 여기까지 수정 ▲▲▲▲▲
    
/*
    // ▼▼▼▼▼ [추가] 무한 스크롤을 위한 메소드 ▼▼▼▼▼
    @GetMapping("/loadMore.do")
    public String loadMore(Model model, @RequestParam(value = "page", defaultValue = "1") int page,
                           @RequestParam(value = "keyword", required = false) String keyword) {
        
        int pageSize = 12; // 기존 list.do와 동일한 페이지 사이즈
        List<RestaurantVO> restaurantList;

        // 검색어가 있는지 없는지에 따라 다른 서비스 호출
        if (keyword != null && !keyword.trim().isEmpty()) {
            restaurantList = restaurantService.getSearchedRestaurantList(keyword, page, pageSize);
        } else {
            restaurantList = restaurantService.getRestaurantList(page, pageSize);
        }

        model.addAttribute("restaurantList", restaurantList);

        // [핵심] 전체 페이지가 아닌, 맛집 카드 목록만 담긴 JSP 조각 파일을 반환
        return "restaurant/_restaurantCardList";
    }
    // ▲▲▲▲▲ 여기까지 추가 ▲▲▲▲▲
*/
    
    @RequestMapping("/detail.do")
    public String detail(@RequestParam("restaurantId") int id, Model model, HttpSession session, RedirectAttributes redirectAttrs) {
        
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        String memberId = (loginUser != null) ? loginUser.getId() : null;

        Map<String, Object> detailData = restaurantService.getRestaurantDetailById(id, memberId);
        
        // URL을 통한 직접 접근 방지: 비활성화되거나 존재하지 않는 맛집일 경우
        if (detailData.get("restaurant") == null) {
            redirectAttrs.addFlashAttribute("toast", "존재하지 않거나 삭제된 맛집입니다.");
            return "redirect:/restaurant/list.do";
        }
        
        model.addAllAttributes(detailData);
        model.addAttribute("activeMenu", "list");
        model.addAttribute("kakaoApiKey", kakaoApiKey);

        return "restaurant/detail";
    }
    
    // 랜덤 맛집 상세 페이지로 리다이렉트
    @RequestMapping("/random.do")
    public String randomDetail() {
        int randomId = restaurantService.getRandomRestaurantId();
        return "redirect:/restaurant/detail.do?restaurantId=" + randomId + "#reviews";
    }
    
    @PostMapping("/reviewWrite.do")
    public String writeReview(@RequestParam int restaurantId,
                              @RequestParam String content,
                              @RequestParam double starScore,
                              @RequestParam(value = "reviewImages", required = false) List<MultipartFile> reviewImages,
                              HttpSession session,
                              RedirectAttributes redirectAttrs) {
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            redirectAttrs.addFlashAttribute("msg", "로그인 후 이용해주세요.");
            return "redirect:/member/login.do";
        }

        // 백엔드 유효성 검사: 별점이 0점 이하인 경우
        if (starScore <= 0) {
            redirectAttrs.addFlashAttribute("msg", "별점을 선택해주세요.");
            return "redirect:/restaurant/detail.do?restaurantId=" + restaurantId;
        }

        RestaurantReviewVO review = new RestaurantReviewVO();
        review.setRestaurantId(restaurantId);
        review.setMemberId(loginUser.getId());
        review.setContent(content);
        review.setStarScore(starScore);

        try {
            reviewService.writeNewReview(review, reviewImages);
            redirectAttrs.addFlashAttribute("toast", "리뷰가 성공적으로 등록되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("toast", "리뷰 등록 중 오류가 발생했습니다.");
        }
        
        return "redirect:/restaurant/detail.do?restaurantId=" + restaurantId;
    }

    @PostMapping("/reviewDelete.do")
    public String reviewDelete(@RequestParam("reviewId") int reviewId,
                               @RequestParam("restaurantId") int restaurantId,
                               HttpSession session,
                               RedirectAttributes redirectAttrs) {
        
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            redirectAttrs.addFlashAttribute("toast", "로그인이 필요합니다.");
            return "redirect:/member/login.do";
        }

        RestaurantReviewVO review = reviewService.getReviewById(reviewId);

        // 권한 확인: 리뷰 작성자 본인이거나 관리자('ADMIN')일 경우에만 삭제 권한 부여
        boolean isAdmin = "ADMIN".equals(loginUser.getType());
        boolean isOwner = (review != null && review.getMemberId().equals(loginUser.getId()));

        if (!isAdmin && !isOwner) {
            redirectAttrs.addFlashAttribute("toast", "리뷰를 삭제할 권한이 없습니다.");
            return "redirect:/restaurant/detail.do?restaurantId=" + restaurantId;
        }

        try {
            reviewService.deleteReview(reviewId);
            redirectAttrs.addFlashAttribute("toast", "리뷰가 성공적으로 삭제되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("toast", "리뷰 삭제 중 오류가 발생했습니다.");
        }

        return "redirect:/restaurant/detail.do?restaurantId=" + restaurantId;
    }
    
    @PostMapping("/review/report.do")
    @ResponseBody
    public Map<String, Object> reportReview(ReviewReportVO reportVO, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return response;
        }

        reportVO.setMemberId(loginUser.getId());

        try {
            reviewReportService.reportReview(reportVO);
            response.put("success", true);
            response.put("message", "리뷰가 성공적으로 신고되었습니다.");
        } catch (IllegalStateException e) {
            // 서비스에서 중복 신고 예외 발생 시
            response.put("success", false);
            response.put("message", e.getMessage());
        } catch (Exception e) {
            // 그 외 일반적인 예외 처리
            response.put("success", false);
            response.put("message", "신고 처리 중 오류가 발생했습니다.");
        }
        return response;
    }
    
    // =================================================================
    // 찜(Favorite) 관련 AJAX 핸들러 (통합됨)
    // =================================================================

    @PostMapping("/favorite/add")
    @ResponseBody
    public String addFavorite(@RequestParam("restaurantId") int restaurantId, HttpSession session) {
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "NEED_LOGIN";
        }
        restaurantService.addFavorite(restaurantId, loginUser.getId());
        return "OK";
    }

    @PostMapping("/favorite/remove")
    @ResponseBody
    public String removeFavorite(@RequestParam("restaurantId") int restaurantId, HttpSession session) {
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "NEED_LOGIN";
        }
        restaurantService.removeFavorite(restaurantId, loginUser.getId());
        return "OK";
    }

    @GetMapping("/favorite/isFavorite")
    @ResponseBody
    public boolean isFavorite(@RequestParam("restaurantId") int restaurantId, HttpSession session) {
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return false;
        }
        return restaurantService.isFavorite(restaurantId, loginUser.getId());
    }

    @GetMapping("/favorite/count")
    @ResponseBody
    public int countFavorite(@RequestParam("restaurantId") int restaurantId) {
        return restaurantService.getFavoriteCount(restaurantId);
    }
}
