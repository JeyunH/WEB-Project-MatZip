package kr.ac.kopo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.kopo.vo.RestaurantReviewVO;

@Mapper
public interface ReviewDAO {
		
	void insertReview(RestaurantReviewVO review);
	List<RestaurantReviewVO> selectReviewsWithImagesByRestaurantId(int restaurantId);
	List<RestaurantReviewVO> selectAllReviewsWithImages(); // 관리자용: 모든 리뷰 조회
	RestaurantReviewVO selectReviewById(int reviewId);
	void deleteReview(int reviewId);

	// 특정 회원이 작성한 리뷰 조회 (페이지네이션)
	List<RestaurantReviewVO> selectReviewsByMemberId(@Param("memberId") String memberId, @Param("offset") int offset, @Param("limit") int limit);
	
	// 특정 회원이 작성한 모든 리뷰 조회
	List<RestaurantReviewVO> selectAllReviewsByMemberId(String memberId);

	// 특정 회원이 작성한 리뷰 총 개수
	int selectReviewCountByMemberId(String memberId);

	// 관리자용
	int selectReviewCountForAdmin(java.util.Map<String, Object> params);
	List<RestaurantReviewVO> selectReviewsForAdmin(java.util.Map<String, Object> params);

	// 회원 상세 정보 페이지용
	int selectReviewCountByUserId(String id);
	List<RestaurantReviewVO> selectReviewsByUserId(java.util.Map<String, Object> params);
	
	// 통계용
	Map<String, Object> selectReviewStatistics();
	List<Map<String, Object>> selectNewReviewCountByPeriod(String period);
	List<Map<String, Object>> selectRatingDistribution();
	Map<String, Object> calculateRating(int restaurantId);
}
