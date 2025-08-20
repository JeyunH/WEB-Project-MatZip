package kr.ac.kopo.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.kopo.dao.ReviewReportDAO;
import kr.ac.kopo.vo.ReviewReportVO;

@Service
public class ReviewReportService {

    @Autowired
    private ReviewReportDAO reviewReportDAO;

    @Autowired
    private PagingService pagingService;

    /**
     * 새로운 리뷰 신고를 접수합니다.
     * 데이터베이스에 직접 INSERT를 시도하기 전에,
     * 해당 사용자가 이미 동일한 리뷰를 신고했는지 먼저 확인합니다.
     * 
     * @param reportVO 신고 정보를 담은 VO 객체
     * @throws IllegalStateException 이미 신고한 리뷰일 경우 발생
     */
    @Transactional
    public void reportReview(ReviewReportVO reportVO) {
        // 1. 중복 신고 여부 확인
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", reportVO.getMemberId());
        params.put("reviewId", reportVO.getReviewId());
        
        int count = reviewReportDAO.countReportByMemberAndReview(params);

        // 2. 중복된 신고가 있을 경우, 예외를 발생시켜 처리 중단
        if (count > 0) {
            throw new IllegalStateException("이미 신고한 리뷰입니다.");
        }

        // 3. 중복이 아닐 경우에만 신고 등록
        reviewReportDAO.insertReport(reportVO);
    }

    /**
     * 관리자 페이지를 위한 페이징 처리된 신고 목록과 관련 정보를 조회합니다.
     * @param params 컨트롤러에서 전달된 파라미터 (page, keyword, status 등)
     * @return 페이징된 신고 목록과 페이징 정보를 담은 Map
     */
    public Map<String, Object> getReportedReviews(Map<String, Object> params) {
        
        Map<String, Object> result = pagingService.getPaginatedList(
            params,
            10, // 페이지 당 10개씩 표시
            p -> reviewReportDAO.selectReportCount(p),
            p -> reviewReportDAO.selectReportList(p),
            false // ROWNUM (start/end) 방식 사용
        );

        result.put("reportList", result.remove("list"));
        return result;
    }

    /**
     * 특정 신고 건의 처리 상태를 변경합니다.
     * @param reportId 처리할 신고의 ID
     * @param status 변경할 상태 ("PROCESSED" 또는 "REJECTED")
     */
    @Transactional
    public void updateReportStatus(int reportId, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("reportId", reportId);
        params.put("status", status);
        reviewReportDAO.updateReportStatus(params);
    }
    
    /**
     * 특정 신고 건의 상세 정보를 조회합니다.
     * @param reportId 조회할 신고의 ID
     * @return 신고 상세 정보
     */
    public ReviewReportVO getReportById(int reportId) {
        return reviewReportDAO.selectReportById(reportId);
    }
}