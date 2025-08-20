package kr.ac.kopo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.kopo.dao.RestaurantDAO;
import kr.ac.kopo.vo.FavoriteRestaurantVO;
import kr.ac.kopo.vo.NewBasicImageVO;
import kr.ac.kopo.vo.PaginationVO;
import kr.ac.kopo.vo.RestaurantVO;

@Service
public class RestaurantService {

    @Autowired
    private RestaurantDAO restaurantDAO;
    
    @Autowired
    private ReviewService reviewService;
    
    @Autowired
    private PagingService pagingService; // PagingService 주입

    @Autowired
    private RestaurantImageService restaurantImageService;

    /**
     * 맛집 목록 페이지에 필요한 모든 데이터(맛집 리스트, 총 개수, 필터 목록 등)를 조회하고 조합하는 오케스트레이션 메소드.
     * @param params 사용자가 선택한 모든 필터, 검색어, 페이징 정보가 담긴 Map
     * @return 목록 페이지 표시에 필요한 모든 데이터가 담긴 Map
     */
    public Map<String, Object> getFilteredRestaurantData(Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();

        // 1. 페이징 처리
        int page = (int) params.getOrDefault("page", 1);
        int pageSize = 12;

        // 2. 맛집 목록 및 총 개수 조회
        String keyword = (String) params.getOrDefault("keyword", "");
        int totalCount;

        if (keyword != null && !keyword.trim().isEmpty()) {
            totalCount = restaurantDAO.countSearchedRestaurants(params);
        } else {
            totalCount = restaurantDAO.selectRestaurantCount(params);
        }
        
        PaginationVO pagination = new PaginationVO(totalCount, page, pageSize, 9);
        params.put("offset", (pagination.getCurrentPage() - 1) * pageSize);
        params.put("limit", pageSize);

        List<RestaurantVO> restaurantList;
        if (keyword != null && !keyword.trim().isEmpty()) {
            restaurantList = restaurantDAO.searchRestaurants(params);
        } else {
            restaurantList = restaurantDAO.selectRestaurantList(params);
        }
        
        result.put("restaurantList", restaurantList);
        result.put("paging", pagination);

        // 3. 필터 목록 조회 (상위 5개)
        int filterLimit = 5;
        result.put("topRegions", restaurantDAO.selectTopRegions(filterLimit));
        result.put("allRegions", restaurantDAO.selectAllRegions());
        result.put("topCategories", restaurantDAO.selectTopCategories(filterLimit));
        result.put("allCategories", restaurantDAO.selectAllCategories());

        return result;
    }
    
    /**
     * 식당 상세 페이지에 필요한 모든 데이터를 조회하고 조합하는 오케스트레이션 메소드.
     * @param restaurantId 조회할 식당의 ID
     * @param memberId 현재 로그한 사용자의 ID (비로그인 시 null)
     * @return 상세 페이지 표시에 필요한 모든 데이터가 담긴 Map
     */
    public Map<String, Object> getRestaurantDetailById(int restaurantId, String memberId) {
        Map<String, Object> detailData = new HashMap<>();

        // memberId가 null이면 관리자 기능으로 간주, status와 무관하게 조회
        RestaurantVO restaurant = (memberId == null)
                                ? restaurantDAO.selectRestaurantByIdForAdmin(restaurantId)
                                : restaurantDAO.selectRestaurantById(restaurantId);

        detailData.put("restaurant", restaurant);
        
        if (restaurant != null) {
            detailData.put("tagList", restaurantDAO.selectTagListByRestaurantId(restaurantId));
            detailData.put("menuList", restaurantDAO.selectMenuListByRestaurantId(restaurantId));
            detailData.put("imageList", restaurantDAO.selectImageListByRestaurantId(restaurantId));
            detailData.put("reviewList", reviewService.getReviews(restaurantId));
            detailData.put("favoriteCount", this.getFavoriteCount(restaurantId));
            detailData.put("isFavorite", this.isFavorite(restaurantId, memberId));
        }

        return detailData;
    }

    public int getRandomRestaurantId() {
        return restaurantDAO.getRandomRestaurantId();
    }

    // 주간 랭킹 조회
    public List<RestaurantVO> getTrendyRestaurants() {
        return restaurantDAO.selectTrendyRestaurants();
    }

    public List<RestaurantVO> getHotRestaurants() {
        return restaurantDAO.selectHotRestaurants();
    }

    public List<RestaurantVO> getSteadyRestaurants() {
        return restaurantDAO.selectSteadyRestaurants();
    }

    /**
     * 관리자 페이지를 위한 페이징 처리된 맛집 목록과 전체 맛집 수를 조회합니다.
     * @param params 컨트롤러에서 전달된 파라미터 (page, keyword 등)
     * @return 페이징된 맛집 목록과 전체 맛집 수를 담은 Map
     */
    public java.util.Map<String, Object> getRestaurantsForAdmin(java.util.Map<String, Object> params) {
        
        Map<String, Object> result = pagingService.getPaginatedList(
            params,
            10, // 페이지 사이즈
            p -> restaurantDAO.selectRestaurantCountForAdmin(p),
            p -> restaurantDAO.selectRestaurantsForAdmin(p),
            false // ROWNUM (start/end) 방식 사용
        );

        result.put("restaurantList", result.remove("list"));
        return result;
    }

    /**
     * 관리자 통계 페이지에 필요한 맛집 관련 통계 데이터를 조회합니다.
     * @return 총 맛집 수, 승인/미승인 맛집 수, 신규 등록 추이 데이터를 담은 Map
     */
    public Map<String, Object> getRestaurantStatistics() {
        Map<String, Object> stats = new HashMap<>();
        int rankingLimit = 10; // 순위는 상위 10개까지만 조회

        // 1. 맛집 수 통계
        stats.put("totalRestaurants", restaurantDAO.selectTotalRestaurantCount());
        stats.put("approvedRestaurants", restaurantDAO.selectApprovedRestaurantCount());
        stats.put("unapprovedRestaurants", restaurantDAO.selectUnapprovedRestaurantCount());

        // 2. 신규 맛집 등록 추이
        stats.put("dailyNewRestaurants", restaurantDAO.selectDailyNewRestaurants());
        stats.put("weeklyNewRestaurants", restaurantDAO.selectWeeklyNewRestaurants());
        stats.put("monthlyNewRestaurants", restaurantDAO.selectMonthlyNewRestaurants());

        // 3. 맛집 활동 순위
        stats.put("reviewRankers", restaurantDAO.selectTopRestaurantsByReview(rankingLimit));
        stats.put("favoriteRankers", restaurantDAO.selectTopRestaurantsByFavorite(rankingLimit));
        stats.put("ratingRankers", restaurantDAO.selectTopRestaurantsByRating(rankingLimit));

        return stats;
    }

    /**
     * 특정 맛집의 상태를 변경합니다.
     * @param restaurantId 맛집 ID
     * @param status 변경할 상태 ('Y' 또는 'N')
     */
    public void updateRestaurantStatus(int restaurantId, String status) {
        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("restaurantId", restaurantId);
        params.put("status", status);
        restaurantDAO.updateRestaurantStatus(params);
    }

    /**
     * 맛집 정보를 전체적으로 업데이트합니다. (트랜잭션 처리)
     * 메뉴, 태그, 이미지, 기본 정보를 모두 포함합니다.
     */
    @org.springframework.transaction.annotation.Transactional(rollbackFor = Exception.class)
    public void updateRestaurant(kr.ac.kopo.vo.RestaurantUpdateFormVO form) throws Exception {
        
        int restaurantId = form.getRestaurantId();
        kr.ac.kopo.vo.RestaurantVO existingRestaurant = restaurantDAO.selectRestaurantByIdForAdmin(restaurantId);
        if (existingRestaurant == null) {
            throw new Exception("존재하지 않는 맛집입니다.");
        }

        existingRestaurant.setName(form.getName());
        existingRestaurant.setAddress(form.getAddress());
        existingRestaurant.setPhone(form.getPhone());
        existingRestaurant.setRegion(form.getRegion());
        existingRestaurant.setCategory(form.getCategory());
        
        String uploadBasePath = "D:/OneDrive_Kopo/matzip_uploads/restaurant_main_img";

        if ("FILE".equals(form.getMainImg1_type()) && form.getMainImgFile1() != null && !form.getMainImgFile1().isEmpty()) {
            String savedFileName = restaurantImageService.saveFile(form.getMainImgFile1(), uploadBasePath);
            existingRestaurant.setMainImgUrl1("/restaurant_images/" + savedFileName);
        } else if ("URL".equals(form.getMainImg1_type())) {
            existingRestaurant.setMainImgUrl1(form.getMainImgUrl1());
        }

        if ("FILE".equals(form.getMainImg2_type()) && form.getMainImgFile2() != null && !form.getMainImgFile2().isEmpty()) {
            String savedFileName = restaurantImageService.saveFile(form.getMainImgFile2(), uploadBasePath);
            existingRestaurant.setMainImgUrl2("/restaurant_images/" + savedFileName);
        } else if ("URL".equals(form.getMainImg2_type())) {
            existingRestaurant.setMainImgUrl2(form.getMainImgUrl2());
        }
        
        restaurantDAO.deleteMenusByRestaurantId(restaurantId);
        restaurantDAO.deleteTagsByRestaurantId(restaurantId);

        List<String> menuNames = form.getMenuNames();
        List<Integer> menuPrices = form.getMenuPrices();
        if (menuNames != null) {
            for (int i = 0; i < menuNames.size(); i++) {
                String menuName = menuNames.get(i);
                if (menuName == null || menuName.trim().isEmpty()) continue;
                kr.ac.kopo.vo.MenuVO menu = new kr.ac.kopo.vo.MenuVO();
                menu.setRestaurantId(restaurantId);
                menu.setMenuName(menuName.trim());
                if (menuPrices != null && i < menuPrices.size() && menuPrices.get(i) != null) {
                    menu.setPrice(menuPrices.get(i));
                }
                restaurantDAO.insertMenu(menu);
            }
        }
        
        List<String> tagNames = form.getTagNames();
        List<String> tagTypes = form.getTagTypes();
        if (tagNames != null) {
            for (int i = 0; i < tagNames.size(); i++) {
                String tagName = tagNames.get(i);
                if (tagName == null || tagName.trim().isEmpty()) continue;
                kr.ac.kopo.vo.TagVO tag = new kr.ac.kopo.vo.TagVO();
                tag.setRestaurantId(restaurantId);
                tag.setTagName(tagName.trim());
                if (tagTypes != null && i < tagTypes.size()) {
                    tag.setTagType(tagTypes.get(i));
                }
                restaurantDAO.insertTag(tag);
            }
        }
        
        List<NewBasicImageVO> newBasicImages = form.getNewBasicImages();
        if (newBasicImages != null) {
            String basicImageUploadPath = "D:/OneDrive_Kopo/matzip_uploads/restaurant_basic_img";
            for (NewBasicImageVO imageVO : newBasicImages) {
                String url = null;
                String type = imageVO.getType();

                if ("FILE".equals(type) && imageVO.getFile() != null && !imageVO.getFile().isEmpty()) {
                    String savedFileName = restaurantImageService.saveFile(imageVO.getFile(), basicImageUploadPath);
                    url = "/restaurant_images/basic/" + savedFileName;
                } else if ("URL".equals(type) && imageVO.getUrl() != null && !imageVO.getUrl().trim().isEmpty()) {
                    url = imageVO.getUrl().trim();
                }

                if (url != null) {
                    kr.ac.kopo.vo.RestaurantImageVO newImage = new kr.ac.kopo.vo.RestaurantImageVO();
                    newImage.setRestaurantId(restaurantId);
                    newImage.setImageUrl(url);
                    newImage.setImgType("BASIC");
                    restaurantImageService.addImage(newImage);
                }
            }
        }
        
        restaurantDAO.updateRestaurant(existingRestaurant);
    }

    /**
     * 신규 맛집 등록을 위해 다음 ID를 결정합니다. (MAX(ID) + 1 방식)
     * @return 다음 맛집 ID
     */
    public int getNextRestaurantId() {
        return restaurantDAO.selectMaxRestaurantId() + 1;
    }

    /**
     * 신규 맛집 정보를 등록합니다. (트랜잭션 처리)
     */
    @org.springframework.transaction.annotation.Transactional(rollbackFor = Exception.class)
    public void createRestaurant(kr.ac.kopo.vo.RestaurantVO restaurant,
                                 String mainImg1_type, org.springframework.web.multipart.MultipartFile mainImgFile1,
                                 String mainImg2_type, org.springframework.web.multipart.MultipartFile mainImgFile2,
                                 java.util.List<String> menuNames,
                                 java.util.List<Integer> menuPrices,
                                 java.util.List<String> tagNames,
                                 java.util.List<String> tagTypes) throws Exception {

        // 1. 이미지 파일 처리
        String uploadBasePath = "D:/OneDrive_Kopo/matzip_uploads/restaurant_main_img";
        if ("FILE".equals(mainImg1_type) && mainImgFile1 != null && !mainImgFile1.isEmpty()) {
            String savedFileName = restaurantImageService.saveFile(mainImgFile1, uploadBasePath);
            restaurant.setMainImgUrl1("/restaurant_images/" + savedFileName);
        }
        if ("FILE".equals(mainImg2_type) && mainImgFile2 != null && !mainImgFile2.isEmpty()) {
            String savedFileName = restaurantImageService.saveFile(mainImgFile2, uploadBasePath);
            restaurant.setMainImgUrl2("/restaurant_images/" + savedFileName);
        }

        // 2. 초기 상태 및 통계값 설정
        restaurant.setStatus("Y"); // 관리자가 등록하므로 바로 '승인' 상태

        // 3. 기본 맛집 정보 DB에 삽입
        restaurantDAO.insertRestaurant(restaurant);
        int restaurantId = restaurant.getRestaurantId(); // 컨트롤러에서 설정한 ID를 그대로 사용

        // 4. 메뉴 정보 삽입
        if (menuNames != null) {
            for (int i = 0; i < menuNames.size(); i++) {
                String menuName = menuNames.get(i);
                if (menuName == null || menuName.trim().isEmpty()) continue;

                kr.ac.kopo.vo.MenuVO menu = new kr.ac.kopo.vo.MenuVO();
                menu.setRestaurantId(restaurantId);
                menu.setMenuName(menuName.trim());
                
                if (menuPrices != null && i < menuPrices.size() && menuPrices.get(i) != null) {
                    menu.setPrice(menuPrices.get(i));
                } else {
                    menu.setPrice(null);
                }
                restaurantDAO.insertMenu(menu);
            }
        }

        // 5. 태그 정보 삽입
        if (tagNames != null) {
            for (int i = 0; i < tagNames.size(); i++) {
                String tagName = tagNames.get(i);
                if (tagName == null || tagName.trim().isEmpty()) continue;
                
                kr.ac.kopo.vo.TagVO tag = new kr.ac.kopo.vo.TagVO();
                tag.setRestaurantId(restaurantId);
                tag.setTagName(tagName.trim());
                if (tagTypes != null && i < tagTypes.size()) {
                    tag.setTagType(tagTypes.get(i));
                }
                restaurantDAO.insertTag(tag);
            }
        }
    }

    // =================================================================
    // 찜(Favorite) 관련 로직 (통합됨)
    // =================================================================

    public void addFavorite(int restaurantId, String memberId) {
        FavoriteRestaurantVO vo = new FavoriteRestaurantVO(restaurantId, memberId);
        restaurantDAO.insertFavorite(vo);
    }

    public void removeFavorite(int restaurantId, String memberId) {
        FavoriteRestaurantVO vo = new FavoriteRestaurantVO(restaurantId, memberId);
        restaurantDAO.deleteFavorite(vo);
    }

    public boolean isFavorite(int restaurantId, String memberId) {
        if (memberId == null || memberId.trim().isEmpty()) {
            return false;
        }
        FavoriteRestaurantVO vo = new FavoriteRestaurantVO(restaurantId, memberId);
        return restaurantDAO.selectFavorite(vo) != null;
    }

    public int getFavoriteCount(int restaurantId) {
        return restaurantDAO.countFavoriteByRestaurant(restaurantId);
    }

    public List<RestaurantVO> getMyFavoriteRestaurants(String memberId) {
        return restaurantDAO.selectFavoriteRestaurantsByMemberId(memberId);
    }
    
    public java.util.Map<String, Object> getFavoritesByUserId(java.util.Map<String, Object> params) {
        int page = (int) params.get("page");
        String userId = (String) params.get("id");
        int pageSize = 10;

        int totalCount = restaurantDAO.selectFavoriteCountByUserId(userId);
        PaginationVO pagination = new PaginationVO(totalCount, page, pageSize, 9);

        params.put("start", (pagination.getCurrentPage() - 1) * pageSize + 1);
        params.put("end", pagination.getCurrentPage() * pageSize);

        List<RestaurantVO> favorites = restaurantDAO.selectFavoritesByUserId(params);

        java.util.Map<String, Object> result = new java.util.HashMap<>();
        result.put("favPaging", pagination);
        result.put("favorites", favorites);
        
        return result;
    }

    /**
     * 모든 맛집의 MZ스코어를 일괄적으로 업데이트하는 배치 메소드.
     */
    @org.springframework.transaction.annotation.Transactional
    public void batchUpdateAllMzScores() {
        // 1. 점수 계산에 필요한 통계 정보 조회 (리뷰/찜 최대,최소값)
        Map<String, Object> stats = restaurantDAO.getMzScoreStatistics();
        
        // 데이터가 없는 경우 NullPointerException 방지
        if (stats == null || stats.isEmpty()) {
            System.out.println("MZ스코어 계산을 위한 통계 데이터가 없습니다. 작업을 중단합니다.");
            return;
        }

        long minReview = ((Number) stats.getOrDefault("MINREVIEW", 0)).longValue();
        long maxReview = ((Number) stats.getOrDefault("MAXREVIEW", 0)).longValue();
        long minFavorite = ((Number) stats.getOrDefault("MINFAVORITE", 0)).longValue();
        long maxFavorite = ((Number) stats.getOrDefault("MAXFAVORITE", 0)).longValue();

        // 2. MZ스코어 계산에 필요한 모든 맛집 정보 조회 (찜 수 포함)
        List<RestaurantVO> allRestaurants = restaurantDAO.selectAllRestaurantsForMzScore();
        
        if (allRestaurants == null || allRestaurants.isEmpty()) {
            System.out.println("MZ스코어를 계산할 맛집이 없습니다. 작업을 중단합니다.");
            return;
        }

        for (RestaurantVO r : allRestaurants) {
            // 3. 리뷰 점수 계산 (60점 만점)
            double reviewScore = (r.getStarScore() / 5.0) * 60;

            // 4. 리뷰 수 상대 점수 계산 (20점 만점)
            double reviewCountScore = 0;
            if (maxReview > minReview) {
                reviewCountScore = ((double) (r.getReviewCount() - minReview) / (maxReview - minReview)) * 20;
            }

            // 5. 찜 수 상대 점수 계산 (20점 만점)
            double favoriteCountScore = 0;
            if (maxFavorite > minFavorite) {
                favoriteCountScore = ((double) (r.getFavoriteCount() - minFavorite) / (maxFavorite - minFavorite)) * 20;
            }
            
            // 6. 최종 MZ스코어 계산 및 반올림
            double mzScore = reviewScore + reviewCountScore + favoriteCountScore;
            mzScore = Math.round(mzScore * 10.0) / 10.0; // 소수점 첫째 자리까지 반올림

            // 7. DB에 업데이트
            Map<String, Object> params = new HashMap<>();
            params.put("restaurantId", r.getRestaurantId());
            params.put("mzScore", mzScore);
            restaurantDAO.updateMzScore(params);
        }
    }
}
