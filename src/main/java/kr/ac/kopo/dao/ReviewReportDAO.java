package kr.ac.kopo.dao;

import java.util.List;
import java.util.Map;
import kr.ac.kopo.vo.ReviewReportVO;

public interface ReviewReportDAO {
    
    /**
     * 새로운 리뷰 신고를 등록합니다.
     * @param reportVO 신고 정보를 담은 VO 객체
     */
    void insertReport(ReviewReportVO reportVO);

    /**
     * 관리자 페이지에서 보여줄 신고 목록의 전체 개수를 조회합니다.
     * @param params 검색 조건(keyword, status)
     * @return 조건에 맞는 신고 건수
     */
    int selectReportCount(Map<String, Object> params);

    /**
     * 관리자 페이지에서 보여줄 신고 목록을 조회합니다.
     * @param params 검색 및 페이징 조건(keyword, status, offset, limit)
     * @return 신고 목록
     */
    List<ReviewReportVO> selectReportList(Map<String, Object> params);

    /**
     * 특정 신고 건의 상태를 변경합니다.
     * @param params 변경할 신고 ID(reportId)와 새로운 상태(status)
     */
    void updateReportStatus(Map<String, Object> params);
    
    /**
     * 특정 신고 건의 상세 정보를 조회합니다.
     * @param reportId 조회할 신고의 ID
     * @return 신고 상세 정보
     */
    ReviewReportVO selectReportById(int reportId);
    
    /**
     * 특정 사용자가 특정 리뷰를 이미 신고했는지 확인합니다.
     * @param params 확인할 사용자 ID(memberId)와 리뷰 ID(reviewId)
     * @return 신고 건수 (0 또는 1)
     */
    int countReportByMemberAndReview(Map<String, Object> params);
}
