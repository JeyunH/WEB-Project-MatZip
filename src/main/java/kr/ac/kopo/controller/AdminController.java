package kr.ac.kopo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.ac.kopo.service.MemberService;
import kr.ac.kopo.service.RestaurantImageService;
import kr.ac.kopo.service.RestaurantService;
import kr.ac.kopo.service.ReviewReportService;
import kr.ac.kopo.service.ReviewService;
import kr.ac.kopo.vo.RestaurantUpdateFormVO;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private RestaurantService restaurantService;

    @Autowired
    private RestaurantImageService restaurantImageService;
    
    @Autowired
    private ReviewReportService reviewReportService;

    /**
     * 데이터 바인딩 시, 빈 문자열을 null로 변환하도록 설정합니다.
     * 특히 메뉴 가격처럼 비어있을 수 있는 숫자 필드의 오류를 방지합니다.
     */
    @InitBinder
    public void initBinder(org.springframework.web.bind.WebDataBinder binder) {
        binder.registerCustomEditor(Integer.class, new java.beans.PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                if (text == null || text.trim().isEmpty()) {
                    setValue(null);
                } else {
                    setValue(Integer.parseInt(text));
                }
            }
        });
    }

    /**
     * 관리자 페이지의 메인 대시보드를 보여줍니다.
     */
    @GetMapping("/dashboard.do")
    public String dashboard() {
        // 나중에 통계 데이터 등을 모델에 추가할 수 있습니다.
        return "admin/dashboard";
    }

    /**
     * 회원 목록을 조회하고 페이지네이션 정보를 계산하여 전달합니다.
     */
    @GetMapping("/userList.do")
    public String userList(@RequestParam(value = "page", defaultValue = "1") int page,
                           @RequestParam(value = "keyword", defaultValue = "") String keyword,
                           @RequestParam(value = "status", defaultValue = "all") String status,
                           Model model) {
        
        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("page", page);
        params.put("keyword", keyword.trim());
        params.put("status", status);

        java.util.Map<String, Object> result = memberService.getUsers(params);
        
        model.addAttribute("userList", result.get("userList"));
        model.addAttribute("paging", result.get("paging"));
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedStatus", status);
        
        // 레이아웃을 위한 정보 추가
        model.addAttribute("pageTitle", "전체 회원 관리");
        model.addAttribute("itemUnit", "명");
        model.addAttribute("searchPlaceholder", "아이디 또는 닉네임으로 검색");
        model.addAttribute("searchUrl", "/admin/userList.do");
        model.addAttribute("showStatusFilter", true);
        model.addAttribute("filterType", "common"); // 필터 타입 추가
        
        return "admin/userList";
    }

    /**
     * 특정 회원의 상태(활성/비활성)를 변경하고, 그 사유를 로그로 남깁니다.
     * AJAX 요청으로 처리됩니다.
     */
    @PostMapping("/updateUserStatus.do")
    @ResponseBody
    public java.util.Map<String, Object> updateUserStatus(@RequestParam("id") String memberId,
                                                          @RequestParam("status") String status,
                                                          @RequestParam("reason") String reason,
                                                          jakarta.servlet.http.HttpSession session) {
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        kr.ac.kopo.vo.MemberVO loginUser = (kr.ac.kopo.vo.MemberVO) session.getAttribute("loginUser");

        if (loginUser == null || !"ADMIN".equals(loginUser.getType())) {
            response.put("success", false);
            response.put("message", "권한이 없습니다.");
            return response;
        }

        try {
            memberService.updateUserStatus(memberId, status, reason, loginUser.getId());
            response.put("success", true);
            response.put("message", "회원 상태가 성공적으로 변경되었습니다.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "상태 변경 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        return response;
    }

    /**
     * 특정 맛집의 상태(활성/비활성)를 변경합니다.
     */
    @PostMapping("/updateRestaurantStatus.do")
    public String updateRestaurantStatus(@RequestParam("restaurantId") int restaurantId,
                                         @RequestParam("status") String status,
                                         RedirectAttributes redirectAttrs) {
        restaurantService.updateRestaurantStatus(restaurantId, status);
        redirectAttrs.addFlashAttribute("toast", "맛집 상태가 성공적으로 변경되었습니다.");
        return "redirect:/admin/restaurantList.do";
    }

    /**
     * 신규 맛집 등록을 위한 페이지로 이동합니다.
     * 빈 VO 객체를 모델에 담아 전달하여 editRestaurant.jsp를 재활용합니다.
     */
    @GetMapping("/addRestaurant.do")
    public String addRestaurant(Model model) {
        // 1. 다음 맛집 ID를 시퀀스에서 미리 가져옵니다.
        int nextId = restaurantService.getNextRestaurantId();
        
        // 2. 비어있는 RestaurantVO 객체를 생성하고 미리 가져온 ID를 설정합니다.
        kr.ac.kopo.vo.RestaurantVO restaurant = new kr.ac.kopo.vo.RestaurantVO();
        restaurant.setRestaurantId(nextId);

        // 3. 모델에 VO와 빈 리스트들을 추가하여 폼이 정상적으로 렌더링되도록 합니다.
        model.addAttribute("restaurant", restaurant);
        model.addAttribute("menuList", new java.util.ArrayList<kr.ac.kopo.vo.MenuVO>());
        model.addAttribute("tagList", new java.util.ArrayList<kr.ac.kopo.vo.TagVO>());
        
        return "admin/editRestaurant";
    }

    /**
     * 신규 맛집 정보를 등록합니다.
     */
    @PostMapping("/createRestaurant.do")
    public String createRestaurant(kr.ac.kopo.vo.RestaurantVO restaurant,
                                   @RequestParam String mainImg1_type,
                                   @RequestParam String mainImg2_type,
                                   @RequestParam(value = "mainImgFile1", required = false) org.springframework.web.multipart.MultipartFile mainImgFile1,
                                   @RequestParam(value = "mainImgFile2", required = false) org.springframework.web.multipart.MultipartFile mainImgFile2,
                                   @RequestParam(value = "menuNames", required = false) java.util.List<String> menuNames,
                                   @RequestParam(value = "menuPrices", required = false) java.util.List<Integer> menuPrices,
                                   @RequestParam(value = "tagNames", required = false) java.util.List<String> tagNames,
                                   @RequestParam(value = "tagTypes", required = false) java.util.List<String> tagTypes,
                                   RedirectAttributes redirectAttrs) {
        
        try {
            restaurantService.createRestaurant(restaurant, 
                                               mainImg1_type, mainImgFile1, 
                                               mainImg2_type, mainImgFile2, 
                                               menuNames, menuPrices, 
                                               tagNames, tagTypes);
            redirectAttrs.addFlashAttribute("toast", "신규 맛집이 성공적으로 등록되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("toast", "오류: " + e.getMessage());
        }
        
        return "redirect:/admin/restaurantList.do";
    }

    /**
     * 맛집 정보 수정을 위한 페이지로 이동합니다.
     * 기존 맛집 정보를 조회하여 모델에 담아 전달합니다.
     */
    @GetMapping("/editRestaurant.do")
    public String editRestaurant(@RequestParam("restaurantId") int restaurantId, Model model) {
        // 서비스의 상세 정보 조회 메서드를 활용 (memberId는 null로 전달)
        java.util.Map<String, Object> detailData = restaurantService.getRestaurantDetailById(restaurantId, null);
        
        // 기본 이미지 목록 조회
        java.util.List<kr.ac.kopo.vo.RestaurantImageVO> basicImageList = restaurantImageService.getBasicImagesByRestaurantId(restaurantId);
        
        model.addAllAttributes(detailData);
        model.addAttribute("basicImageList", basicImageList); // 모델에 추가
        
        return "admin/editRestaurant";
    }

    /**
     * 맛집 정보를 업데이트합니다.
     */
    @PostMapping("/updateRestaurant.do")
    public String updateRestaurant(RestaurantUpdateFormVO form, RedirectAttributes redirectAttrs) {
        
        try {
            restaurantService.updateRestaurant(form);
            redirectAttrs.addFlashAttribute("toast", "맛집 정보가 성공적으로 수정되었습니다.");
        } catch (Exception e) {
            e.printStackTrace(); // 콘솔에 전체 에러 로그 출력
            // 예외의 상세 메시지를 토스트로 전달
            redirectAttrs.addFlashAttribute("toast", "오류: " + e.getMessage());
        }
        
        return "redirect:/admin/restaurantList.do";
    }

    /**
     * 맛집 목록을 조회하고 페이지네이션 정보를 계산하여 전달합니다.
     */
    @GetMapping("/restaurantList.do")
    public String restaurantList(@RequestParam(value = "page", defaultValue = "1") int page,
                                 @RequestParam(value = "keyword", defaultValue = "") String keyword,
                                 @RequestParam(value = "status", defaultValue = "all") String status,
                                 Model model) {

        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("page", page);
        params.put("keyword", keyword.trim());
        params.put("status", status);

        java.util.Map<String, Object> result = restaurantService.getRestaurantsForAdmin(params);

        model.addAttribute("restaurantList", result.get("restaurantList"));
        model.addAttribute("paging", result.get("paging"));
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedStatus", status);

        // 레이아웃을 위한 정보 추가
        model.addAttribute("pageTitle", "전체 맛집 관리");
        model.addAttribute("itemUnit", "개");
        model.addAttribute("searchPlaceholder", "상호명, 지역, 카테고리로 검색");
        model.addAttribute("searchUrl", "/admin/restaurantList.do");
        model.addAttribute("showStatusFilter", true);
        model.addAttribute("filterType", "common"); // 필터 타입 추가

        return "admin/restaurantList";
    }

    /**
     * 모든 리뷰 목록을 조회합니다. (페이징 및 검색 기능 포함)
     */
    @GetMapping("/reviewList.do")
    public String reviewList(@RequestParam(value = "page", defaultValue = "1") int page,
                             @RequestParam(value = "keyword", defaultValue = "") String keyword,
                             Model model) {
        
        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("page", page);
        params.put("keyword", keyword.trim());

        java.util.Map<String, Object> result = reviewService.getReviewsForAdmin(params);
        
        model.addAttribute("reviewList", result.get("reviewList"));
        model.addAttribute("paging", result.get("paging"));
        model.addAttribute("keyword", keyword);
        
        // 레이아웃을 위한 정보 추가
        model.addAttribute("pageTitle", "전체 리뷰 관리");
        model.addAttribute("itemUnit", "개");
        model.addAttribute("searchPlaceholder", "리뷰내용, 식당명, 작성자ID, 닉네임 검색");
        model.addAttribute("searchUrl", "/admin/reviewList.do");
        model.addAttribute("showStatusFilter", false); // 리뷰 목록에는 상태 필터 없음
        
        return "admin/reviewList";
    }

    /**
     * 특정 리뷰를 삭제합니다.
     */
    @PostMapping("/deleteReview.do")
    public String deleteReview(@RequestParam("reviewId") int reviewId, RedirectAttributes redirectAttrs) {
        reviewService.deleteReview(reviewId);
        redirectAttrs.addFlashAttribute("toast", "리뷰가 성공적으로 삭제되었습니다.");
        return "redirect:/admin/reviewList.do";
    }
    
    /**
     * 신고된 리뷰 목록을 조회합니다.
     */
    @GetMapping("/reportList.do")
    public String reportList(@RequestParam(value = "page", defaultValue = "1") int page,
                             @RequestParam(value = "keyword", defaultValue = "") String keyword,
                             @RequestParam(value = "status", defaultValue = "all") String status,
                             Model model) {

        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("page", page);
        params.put("keyword", keyword.trim());
        params.put("status", status);

        java.util.Map<String, Object> result = reviewReportService.getReportedReviews(params);

        model.addAttribute("reportList", result.get("reportList"));
        model.addAttribute("paging", result.get("paging"));
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedStatus", status);

        model.addAttribute("pageTitle", "리뷰 신고 관리");
        model.addAttribute("itemUnit", "건");
        model.addAttribute("searchPlaceholder", "리뷰내용, 신고자ID, 닉네임 검색");
        model.addAttribute("searchUrl", "/admin/reportList.do");
        model.addAttribute("showStatusFilter", true);
        model.addAttribute("filterType", "report"); // 필터 타입 추가

        return "admin/reportList";
    }

    /**
     * 신고 처리 상태를 변경합니다.
     */
    @PostMapping("/report/updateStatus.do")
    public String updateReportStatus(@RequestParam("reportId") int reportId,
                                     @RequestParam("status") String status,
                                     RedirectAttributes redirectAttrs) {
        try {
            reviewReportService.updateReportStatus(reportId, status);
            redirectAttrs.addFlashAttribute("toast", "신고 처리 상태가 성공적으로 변경되었습니다.");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("toast", "처리 중 오류가 발생했습니다.");
        }
        return "redirect:/admin/reportList.do";
    }

    /**
     * 특정 회원의 상세 정보를 조회합니다. (리뷰, 찜 목록 포함)
     */
    @GetMapping("/userDetail.do")
    public String userDetail(@RequestParam("id") String id,
                             @RequestParam(value = "page", defaultValue = "1") int page,
                             @RequestParam(value = "reviewPage", defaultValue = "1") int reviewPage,
                             @RequestParam(value = "favPage", defaultValue = "1") int favPage,
                             @RequestParam(value = "keyword", defaultValue = "") String keyword,
                             @RequestParam(value = "status", defaultValue = "all") String status,
                             @RequestParam(value = "activeTab", defaultValue = "reviews") String activeTab, // activeTab 파라미터 추가
                             Model model) {
        // 1. 회원 기본 정보 조회
        java.util.Map<String, Object> userDetailData = memberService.getUserDetail(id);
        model.addAllAttributes(userDetailData);

        // 2. 해당 회원의 리뷰 목록 페이징 처리
        java.util.Map<String, Object> reviewParams = new java.util.HashMap<>();
        reviewParams.put("id", id);
        reviewParams.put("page", reviewPage);
        
        java.util.Map<String, Object> reviewResult = reviewService.getReviewsByUserId(reviewParams);
        model.addAttribute("reviews", reviewResult.get("reviews"));
        model.addAttribute("reviewPaging", reviewResult.get("paging"));

        // 3. 해당 회원의 찜 목록 페이징 처리
        java.util.Map<String, Object> favParams = new java.util.HashMap<>();
        favParams.put("id", id);
        favParams.put("page", favPage);
        
        java.util.Map<String, Object> favResult = restaurantService.getFavoritesByUserId(favParams);
        model.addAttribute("favorites", favResult.get("favorites"));
        model.addAttribute("favPaging", favResult.get("favPaging"));

        // 4. 목록으로 돌아가기 위한 파라미터 및 활성 탭 정보 추가
        model.addAttribute("page", page);
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("activeTab", activeTab); // 모델에 activeTab 추가
        
        return "admin/userDetail";
    }
    
    /**
     * 관리자 페이지의 통계 페이지를 보여줍니다.
     */
    @GetMapping("/statistics.do")
    public String statistics(Model model) {
        try {
            // 1. 사용자 통계 데이터 조회
            java.util.Map<String, Object> userStats = memberService.getUserStatistics();
            model.addAttribute("userStats", userStats);

            // 2. 맛집 통계 데이터 조회
            java.util.Map<String, Object> restaurantStats = restaurantService.getRestaurantStatistics();
            model.addAttribute("restaurantStats", restaurantStats);

            // 3. 리뷰 통계 데이터 조회
            java.util.Map<String, Object> reviewStats = reviewService.getReviewStatistics();
            model.addAttribute("reviewStats", reviewStats);

            // 4. ObjectMapper를 사용하여 차트용 데이터를 JSON 문자열로 변환
            ObjectMapper objectMapper = new ObjectMapper();
            
            // 사용자 차트 데이터
            String dailyNewUsersJson = objectMapper.writeValueAsString(userStats.get("dailyNewUsers"));
            String weeklyNewUsersJson = objectMapper.writeValueAsString(userStats.get("weeklyNewUsers"));
            String monthlyNewUsersJson = objectMapper.writeValueAsString(userStats.get("monthlyNewUsers"));

            // 맛집 차트 데이터
            String dailyNewRestaurantsJson = objectMapper.writeValueAsString(restaurantStats.get("dailyNewRestaurants"));
            String weeklyNewRestaurantsJson = objectMapper.writeValueAsString(restaurantStats.get("weeklyNewRestaurants"));
            String monthlyNewRestaurantsJson = objectMapper.writeValueAsString(restaurantStats.get("monthlyNewRestaurants"));

            // 리뷰 차트 데이터
            String dailyNewReviewsJson = objectMapper.writeValueAsString(reviewStats.get("dailyNewReviews"));
            String weeklyNewReviewsJson = objectMapper.writeValueAsString(reviewStats.get("weeklyNewReviews"));
            String monthlyNewReviewsJson = objectMapper.writeValueAsString(reviewStats.get("monthlyNewReviews"));
            String ratingDistributionJson = objectMapper.writeValueAsString(reviewStats.get("ratingDistribution"));

            // 5. 변환된 JSON 문자열을 모델에 추가
            model.addAttribute("dailyNewUsersJson", dailyNewUsersJson);
            model.addAttribute("weeklyNewUsersJson", weeklyNewUsersJson);
            model.addAttribute("monthlyNewUsersJson", monthlyNewUsersJson);

            model.addAttribute("dailyNewRestaurantsJson", dailyNewRestaurantsJson);
            model.addAttribute("weeklyNewRestaurantsJson", weeklyNewRestaurantsJson);
            model.addAttribute("monthlyNewRestaurantsJson", monthlyNewRestaurantsJson);

            model.addAttribute("dailyNewReviewsJson", dailyNewReviewsJson);
            model.addAttribute("weeklyNewReviewsJson", weeklyNewReviewsJson);
            model.addAttribute("monthlyNewReviewsJson", monthlyNewReviewsJson);
            model.addAttribute("ratingDistributionJson", ratingDistributionJson);

        } catch (com.fasterxml.jackson.core.JsonProcessingException e) {
            // JSON 변환 중 오류 발생 시 처리
            e.printStackTrace();
            // 필요하다면 오류 메시지를 모델에 담아 전달할 수 있습니다.
            model.addAttribute("errorMessage", "통계 데이터를 불러오는 중 오류가 발생했습니다.");
        }
        
        return "admin/statistics";
    }

    /**
     * 기본 이미지를 ID로 삭제하는 API (POST 방식)
     * @param imageId 삭제할 이미지의 ID
     * @return 성공 또는 실패 메시지를 담은 ResponseEntity
     */
    @PostMapping("/images/delete")
    @ResponseBody
    public org.springframework.http.ResponseEntity<?> deleteBasicImage(@RequestParam("imageId") int imageId) {
        try {
            restaurantImageService.deleteImage(imageId);
            // 성공 시, 클라이언트에게 JSON 형태로 성공 메시지를 보냄
            return org.springframework.http.ResponseEntity.ok().body(java.util.Collections.singletonMap("message", "이미지가 성공적으로 삭제되었습니다."));
        } catch (Exception e) {
            e.printStackTrace();
            // 실패 시, 서버 오류 상태와 함께 에러 메시지를 보냄
            return org.springframework.http.ResponseEntity.status(org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR)
                                       .body(java.util.Collections.singletonMap("message", "이미지 삭제 중 오류가 발생했습니다."));
        }
    }
}