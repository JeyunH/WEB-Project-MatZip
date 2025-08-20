package kr.ac.kopo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.kopo.vo.FavoriteRestaurantVO;
import kr.ac.kopo.vo.ImageVO;
import kr.ac.kopo.vo.MenuVO;
import kr.ac.kopo.vo.RestaurantReviewVO;
import kr.ac.kopo.vo.RestaurantVO;
import kr.ac.kopo.vo.TagVO;

@Mapper
public interface RestaurantDAO {

	// 여긴 맛집 리스트 페이지 부분
	List<RestaurantVO> selectRestaurantList(Map<String, Object> paramMap);
	int selectRestaurantCount(Map<String, Object> paramMap);

	// ▼▼▼▼▼ [수정] 검색 관련 메소드 파라미터 수정 ▼▼▼▼▼
	List<RestaurantVO> searchRestaurants(Map<String, Object> paramMap);
	int countSearchedRestaurants(Map<String, Object> paramMap);
	// ▲▲▲▲▲ 여기까지 수정 ▲▲▲▲▲
	
	
	// ▼▼▼▼▼ [추가] 필터 목록 조회용 메소드 4개 ▼▼▼▼▼
	List<String> selectTopRegions(int limit);
	List<String> selectAllRegions();
	List<String> selectTopCategories(int limit);
	List<String> selectAllCategories();
	// ▲▲▲▲▲ 여기까지 추가 ▲▲▲▲▲
	
	
	// 여기서부터 restaurant detail 페이지 부분
	RestaurantVO selectRestaurantById(int restaurantId);
	RestaurantVO selectRestaurantByIdForAdmin(int restaurantId); // 관리자용 추가

	List<TagVO> selectTagListByRestaurantId(int restaurantId);

	List<MenuVO> selectMenuListByRestaurantId(int restaurantId);

	List<ImageVO> selectImageListByRestaurantId(int restaurantId);

	int getRandomRestaurantId();

	// 주간 랭킹
	List<RestaurantVO> selectTrendyRestaurants();
	List<RestaurantVO> selectHotRestaurants();
	List<RestaurantVO> selectSteadyRestaurants();

	// 관리자용
	int selectRestaurantCountForAdmin(java.util.Map<String, Object> params);
	List<RestaurantVO> selectRestaurantsForAdmin(java.util.Map<String, Object> params);
	void updateRestaurantStatus(java.util.Map<String, Object> params);
	void updateRestaurant(RestaurantVO restaurant);
	void updateRating(Map<String, Object> params); // 별점 정보 업데이트
	void deleteMenusByRestaurantId(int restaurantId);
	void deleteTagsByRestaurantId(int restaurantId);
	void insertMenu(MenuVO menu);
	void insertTag(TagVO tag);
	int selectMaxRestaurantId(); // 신규 맛집 ID 조회 (MAX+1)
	void insertRestaurant(RestaurantVO restaurant);

	// 통계 관련
	int selectTotalRestaurantCount();
	int selectApprovedRestaurantCount();
	int selectUnapprovedRestaurantCount();
	List<Map<String, Object>> selectDailyNewRestaurants();
	List<Map<String, Object>> selectWeeklyNewRestaurants();
	List<Map<String, Object>> selectMonthlyNewRestaurants();
	List<RestaurantVO> selectTopRestaurantsByReview(int limit);
	List<RestaurantVO> selectTopRestaurantsByFavorite(int limit);
	List<RestaurantVO> selectTopRestaurantsByRating(int limit);

	// 찜(Favorite) 관련 메소드
	void insertFavorite(FavoriteRestaurantVO vo);
	void deleteFavorite(FavoriteRestaurantVO vo);
	FavoriteRestaurantVO selectFavorite(FavoriteRestaurantVO vo);
	int countFavoriteByRestaurant(int restaurantId);
	List<RestaurantVO> selectFavoriteRestaurantsByMember(Map<String, Object> params);
	List<RestaurantVO> selectFavoriteRestaurantsByMemberId(String memberId);
	int selectFavoriteCountByMemberId(String memberId);
	int selectFavoriteCountByUserId(String id);
	List<RestaurantVO> selectFavoritesByUserId(Map<String, Object> params);

	// MZ스코어 계산용
	Map<String, Object> getMzScoreStatistics();
	void updateMzScore(Map<String, Object> params);
	List<RestaurantVO> selectAllRestaurantsForMzScore();
}
