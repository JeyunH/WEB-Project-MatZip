package kr.ac.kopo.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.kopo.dao.RestaurantDAO;
import kr.ac.kopo.dao.RestaurantImageDAO;
import kr.ac.kopo.dao.ReviewDAO;
import kr.ac.kopo.vo.PaginationVO;
import kr.ac.kopo.vo.RestaurantImageVO;
import kr.ac.kopo.vo.RestaurantReviewVO;

@Service
public class ReviewService {

    @Value("${upload.path.review}")
    private String uploadBase;
	
    @Autowired
    private ReviewDAO reviewDAO;
    @Autowired
    private RestaurantImageDAO restaurantImageDAO;
    @Autowired
    private RestaurantDAO restaurantDAO; // RestaurantDAO 주입
    @Autowired
    private PagingService pagingService; // PagingService 주입
    
    /**
     * 특정 맛집의 평점 정보를 다시 계산하고 업데이트합니다.
     * 이 메소드는 다른 서비스에서도 호출될 수 있도록 public으로 선언됩니다.
     * @param restaurantId 평점을 업데이트할 맛집 ID
     */
    public void updateRestaurantRating(int restaurantId) {
        // 1. 활성 사용자의 리뷰만을 대상으로 평점과 리뷰 수를 다시 계산
        Map<String, Object> ratingData = reviewDAO.calculateRating(restaurantId);
        
        // 2. 계산된 결과를 RESTAURANT 테이블에 업데이트
        if (ratingData != null) {
            ratingData.put("restaurantId", restaurantId);
            restaurantDAO.updateRating(ratingData);
        }
    }
    
    /**
     * 새로운 리뷰와 관련 이미지들을 등록합니다.
     * 이 메소드는 트랜잭션으로 관리되어 모든 DB 작업이 성공하거나 실패해야 합니다.
     * @param review         리뷰 정보 VO
     * @param reviewImages   업로드된 이미지 파일 리스트
     * @param session        파일의 실제 저장 경로를 얻기 위한 HttpSession
     * @throws Exception     파일 저장 등에서 발생할 수 있는 예외
     */
    @Transactional(rollbackFor = Exception.class)
    public void writeNewReview(RestaurantReviewVO review, List<MultipartFile> reviewImages) throws Exception {
        
        // 1. 리뷰 텍스트를 먼저 DB에 저장합니다. (mapper의 selectKey를 통해 reviewId가 review 객체에 채워짐)
        reviewDAO.insertReview(review);
        int generatedReviewId = review.getReviewId(); // 저장 후 생성된 리뷰 ID

        // 2. 이미지 파일 처리 및 DB 저장
        if (reviewImages != null && !reviewImages.isEmpty()) {
            int imgCount = 0;
            for (MultipartFile file : reviewImages) {
                if (file == null || file.isEmpty() || imgCount >= 5) continue;
                
                // 파일 유효성 검사 (필요 시 확장자, 크기 등 추가)
                String orgName = file.getOriginalFilename();
                if (orgName == null || orgName.trim().isEmpty()) continue;
                
                String ext = orgName.substring(orgName.lastIndexOf(".") + 1).toLowerCase();
                if (!List.of("jpg","jpeg","png","gif").contains(ext)) continue;

                // 파일 저장 경로 설정 (외부 경로)
                String relPath = review.getRestaurantId() + "/" + generatedReviewId + "/";
                String realUploadDir = uploadBase + relPath;
                
                File dir = new File(realUploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                // 파일명 중복 방지를 위한 고유 파일명 생성 및 저장
                String saveName = System.currentTimeMillis() + "_" + (int)(Math.random() * 10000) + "." + ext;
                File dest = new File(dir, saveName);
                file.transferTo(dest);

                // 이미지 정보를 DB에 저장
                RestaurantImageVO imgVO = new RestaurantImageVO();
                imgVO.setRestaurantId(review.getRestaurantId());
                imgVO.setReviewId(generatedReviewId);
                imgVO.setMemberId(review.getMemberId());
                imgVO.setImageUrl("/review_images/" + relPath + saveName); // 웹 접근 URL
                imgVO.setImgType("REVIEW");
                
                restaurantImageDAO.insertImage(imgVO);
                imgCount++;
            }
        }
        
        // 3. 리뷰 등록 후, 해당 맛집의 평점 정보를 업데이트합니다.
        updateRestaurantRating(review.getRestaurantId());
    }
	
    /**
     * 특정 식당에 등록된 모든 리뷰와 각 리뷰에 포함된 이미지 목록을 함께 조회합니다.
     * @param restaurantId 식당 ID
     * @return 이미지 목록을 포함한 리뷰 리스트
     */
	public List<RestaurantReviewVO> getReviews(int restaurantId) {
	    return reviewDAO.selectReviewsWithImagesByRestaurantId(restaurantId);
	}

    /**
     * 관리자용: 모든 리뷰와 관련 이미지들을 조회합니다.
     * @return 이미지 목록을 포함한 전체 리뷰 리스트
     */
    public List<RestaurantReviewVO> getAllReviewsWithImages() {
        return reviewDAO.selectAllReviewsWithImages();
    }

    public RestaurantReviewVO getReviewById(int reviewId) {
        return reviewDAO.selectReviewById(reviewId);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteReview(int reviewId) {
        // 0. 리뷰를 삭제하기 전에, 어떤 맛집에 속해있는지 ID를 먼저 조회
        RestaurantReviewVO review = reviewDAO.selectReviewById(reviewId);
        if (review == null) {
            // 이미 삭제되었거나 존재하지 않는 리뷰일 경우, 여기서 작업을 중단
            return;
        }
        int restaurantId = review.getRestaurantId();

        // 1. 삭제할 이미지 파일들의 정보(URL)를 미리 조회
        List<RestaurantImageVO> imagesToDelete = restaurantImageDAO.selectImagesByReviewId(reviewId);

        // 2. DB에서 이미지 레코드 삭제
        restaurantImageDAO.deleteImagesByReviewId(reviewId);

        // 3. DB에서 리뷰 레코드 삭제
        reviewDAO.deleteReview(reviewId);

        // 4. 실제 이미지 파일 및 폴더 삭제
        if (imagesToDelete != null && !imagesToDelete.isEmpty()) {
            // 외부 저장소 기본 경로
            for (RestaurantImageVO image : imagesToDelete) {
                // DB에 저장된 웹 경로("/review_images/...")를 실제 파일 시스템 경로로 변환
                String webPath = image.getImageUrl();
                String filePath = webPath.replace("/review_images/", "");
                File file = new File(uploadBase + filePath);
                
                if (file.exists()) {
                    file.delete();
                }
            }

            // 이미지가 저장되었던 부모 폴더 경로를 추정
            // (주의: 이 방식은 URL 구조에 의존적이므로, 구조 변경 시 함께 수정 필요)
            String firstImagePath = imagesToDelete.get(0).getImageUrl().replace("/review_images/", "");
            File parentDir = new File(uploadBase + firstImagePath).getParentFile();
            
            // 폴더가 비어있으면 삭제
            if (parentDir != null && parentDir.exists() && parentDir.isDirectory()) {
                File[] files = parentDir.listFiles();
                if (files == null || files.length == 0) {
                    parentDir.delete();
                    
                    // 식당 ID 폴더까지 비었는지 확인하고 삭제
                    File grandParentDir = parentDir.getParentFile();
                    if(grandParentDir != null && grandParentDir.exists() && grandParentDir.isDirectory()){
                        File[] parentFiles = grandParentDir.listFiles();
                        if(parentFiles == null || parentFiles.length == 0){
                            grandParentDir.delete();
                        }
                    }
                }
            }
        }
        
        // 5. 리뷰 삭제 후, 해당 맛집의 평점 정보를 업데이트합니다.
        updateRestaurantRating(restaurantId);
    }
    
    /**
     * 관리자 페이지를 위한 페이징 처리된 리뷰 목록과 전체 리뷰 수를 조회합니다.
     * @param params 컨트롤러에서 전달된 파라미터 (page, keyword 등)
     * @return 페이징된 리뷰 목록과 전체 리뷰 수를 담은 Map
     */
    public java.util.Map<String, Object> getReviewsForAdmin(java.util.Map<String, Object> params) {
        
        // 1. PagingService를 통해 페이징된 '중복 포함 리스트'와 '페이징 정보'를 받음
        Map<String, Object> pagedResult = pagingService.getPaginatedList(
            params,
            10, // 페이지 사이즈
            p -> reviewDAO.selectReviewCountForAdmin(p),
            p -> reviewDAO.selectReviewsForAdmin(p),
            false // ROWNUM (start/end) 방식 사용
        );

        // 2. 결과를 각 객체로 추출
        List<RestaurantReviewVO> listWithDuplicates = (List<RestaurantReviewVO>) pagedResult.get("list");
        PaginationVO pagination = (PaginationVO) pagedResult.get("paging");

        // 3. MyBatis <collection> 사용 시 발생하는 중복된 부모 객체(리뷰)를 제거
        List<RestaurantReviewVO> distinctReviewList = new java.util.ArrayList<>();
        java.util.Set<Integer> seenReviewIds = new java.util.HashSet<>();
        if (listWithDuplicates != null) {
            for (RestaurantReviewVO review : listWithDuplicates) {
                if (seenReviewIds.add(review.getReviewId())) {
                    distinctReviewList.add(review);
                }
            }
        }

        // 4. 컨트롤러에 전달할 최종 Map을 새로 생성
        java.util.Map<String, Object> finalResult = new java.util.HashMap<>();
        finalResult.put("reviewList", distinctReviewList); // 중복 제거된 리스트를 "reviewList" 키로 저장
        finalResult.put("paging", pagination);             // 페이징 정보를 "paging" 키로 저장
        
        return finalResult;
    }

    /**
     * 특정 사용자가 작성한 리뷰 목록을 페이징 처리하여 조회합니다.
     * @param params 컨트롤러에서 전달된 파라미터 (id, page)
     * @return 페이징된 리뷰 목록과 페이징 정보를 담은 Map
     */
    public java.util.Map<String, Object> getReviewsByUserId(java.util.Map<String, Object> params) {
        int page = (int) params.get("page");
        int pageSize = 10; // 한 페이지에 10개씩 표시

        int totalCount = reviewDAO.selectReviewCountByUserId((String) params.get("id"));
        PaginationVO pagination = new PaginationVO(totalCount, page, pageSize, 9); // 블록 사이즈는 9로 설정

        params.put("start", (pagination.getCurrentPage() - 1) * pageSize + 1);
        params.put("end", pagination.getCurrentPage() * pageSize);

        List<RestaurantReviewVO> reviews = reviewDAO.selectReviewsByUserId(params);

        java.util.Map<String, Object> result = new java.util.HashMap<>();
        result.put("paging", pagination);
        result.put("reviews", reviews);
        
        return result;
    }

    /**
     * 관리자 통계 페이지에 필요한 모든 리뷰 관련 통계 데이터를 조회하여 반환합니다.
     * @return 통계 데이터를 담은 Map 객체
     */
    @Transactional(readOnly = true)
    public java.util.Map<String, Object> getReviewStatistics() {
        java.util.Map<String, Object> reviewStats = new java.util.HashMap<>();

        // 1. 리뷰 요약 정보 조회 (총 리뷰 수, 평균 별점, 포토 리뷰 수)
        java.util.Map<String, Object> summary = reviewDAO.selectReviewStatistics();
        reviewStats.putAll(summary);

        // 2. 신규 리뷰 등록 추이 데이터 조회
        reviewStats.put("dailyNewReviews", reviewDAO.selectNewReviewCountByPeriod("daily"));
        reviewStats.put("weeklyNewReviews", reviewDAO.selectNewReviewCountByPeriod("weekly"));
        reviewStats.put("monthlyNewReviews", reviewDAO.selectNewReviewCountByPeriod("monthly"));

        // 3. 별점 분포 데이터 조회
        reviewStats.put("ratingDistribution", reviewDAO.selectRatingDistribution());

        return reviewStats;
    }
}
