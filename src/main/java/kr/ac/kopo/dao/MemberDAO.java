package kr.ac.kopo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.kopo.vo.MemberVO;

@Mapper
public interface MemberDAO {

	// 회원가입
	void insertMember(MemberVO member);

	// 로그인
	public MemberVO login(MemberVO member);

	// 아이디 중복체크
	public MemberVO selectMemberById(String id);
	
	// 비밀번호 변경
	void updatePassword(@Param("id") String id, @Param("newPassword") String newPassword);
	
	// 계정 삭제
	void deleteAccount(String id);

	void updateProfile(MemberVO member);

	List<MemberVO> selectUserList(java.util.Map<String, Object> params);

	void updateUserStatus(java.util.Map<String, Object> params);

	int selectUserCount(java.util.Map<String, Object> params);
	
	/**
     * 전체 회원 수를 조회합니다.
     * @return 전체 회원 수
     */
    int getTotalUserCount();

    /**
     * 특정 상태(활성/비활성)의 회원 수를 조회합니다.
     * @param status 조회할 회원 상태 ('Y' 또는 'N')
     * @return 해당 상태의 회원 수
     */
    int getUserCountByStatus(@Param("status") String status);
    
    /**
     * 지정된 기간별 신규 가입자 수를 조회합니다.
     * @param period "daily", "weekly", "monthly" 중 하나
     * @return 기간별 가입자 수 목록 (Map의 List 형태)
     */
    java.util.List<java.util.Map<String, Object>> getNewUserCountByPeriod(@Param("period") String period);

    /**
     * 리뷰를 가장 많이 작성한 사용자 상위 10명을 조회합니다.
     * @return 리뷰 랭킹 목록
     */
    java.util.List<kr.ac.kopo.vo.MemberVO> getUsersRankedByReviewCount();

    /**
     * 찜을 가장 많이 등록한 사용자 상위 10명을 조회합니다.
     * @return 찜 랭킹 목록
     */
    java.util.List<kr.ac.kopo.vo.MemberVO> getUsersRankedByFavoriteCount();
}

