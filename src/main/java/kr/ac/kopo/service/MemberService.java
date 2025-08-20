package kr.ac.kopo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.kopo.dao.MemberDAO;
import kr.ac.kopo.dao.MemberStatusLogDAO;
import kr.ac.kopo.dao.ReviewDAO;
import kr.ac.kopo.util.FormatUtil;
import kr.ac.kopo.util.SHA256Util;
import kr.ac.kopo.vo.MemberStatusLogVO;
import kr.ac.kopo.vo.MemberVO;
import kr.ac.kopo.vo.RestaurantReviewVO;

@Service
public class MemberService {

	@Autowired
	private MemberDAO memberDAO;
	
	@Autowired
	private ReviewDAO reviewDAO;

	@Autowired
	private ReviewService reviewService; // ReviewService 주입

	@Autowired
	private PagingService pagingService; // PagingService 주입

	@Autowired
	private MemberStatusLogDAO memberStatusLogDAO; // 로그 DAO 주입

	// 회원가입
	public void register(MemberVO member) {
		memberDAO.insertMember(member);
	}
	
	// 로그인
	public MemberVO login(MemberVO member) {
		// 1. 사용자가 입력한 비밀번호를 암호화
		String encryptedPw = SHA256Util.encrypt(member.getPassword());
		member.setPassword(encryptedPw);
		
		// 2. 암호화된 비밀번호로 로그인 시도
		return memberDAO.login(member);
	}

	// 아이디 중복체크
	public MemberVO getMemberById(String id) {
		return memberDAO.selectMemberById(id);
	}
	
	// 비밀번호 변경
	public void updatePassword(String id, String newPassword) {
	    memberDAO.updatePassword(id, newPassword);
	}

	// 계정 삭제
	public void deleteAccount(String id) {
	    memberDAO.deleteAccount(id);
	}

	// 프로필 정보(닉네임, 이메일) 변경
	public void updateProfile(MemberVO member) {
		memberDAO.updateProfile(member);
	}

	// [관리자] 회원 목록 및 수 조회 (페이지네이션)
	public Map<String, Object> getUsers(Map<String, Object> params) {
		
		// 1. PagingService를 통해 페이징된 리스트와 페이징 정보를 받음
        Map<String, Object> pagedResult = pagingService.getPaginatedList(
            params,
            20, // 페이지 사이즈
            p -> memberDAO.selectUserCount(p),   // 카운트 쿼리
            p -> memberDAO.selectUserList(p),     // 목록 조회 쿼리
            true // offset/limit 방식 사용
        );

        // 2. 컨트롤러에 전달할 최종 Map을 생성
        Map<String, Object> finalResult = new java.util.HashMap<>();
        finalResult.put("userList", pagedResult.get("list")); // "list" 키의 값을 "userList" 키로 저장
        finalResult.put("paging", pagedResult.get("paging"));
		
		return finalResult;
	}

	// [관리자] 회원 상태 변경
	@Transactional(rollbackFor = Exception.class)
	public void updateUserStatus(String memberId, String newStatus, String reason, String adminId) {
		// 0. 변경 전 회원 정보 조회
        MemberVO member = memberDAO.selectMemberById(memberId);
        if (member == null) {
            throw new IllegalArgumentException("존재하지 않는 회원입니다.");
        }
        String previousStatus = member.getStatus();

		// 1. 상태 변경 전, 해당 회원이 작성한 모든 리뷰를 조회하여 영향을 받을 맛집 ID 목록을 확보
        List<RestaurantReviewVO> reviews = reviewDAO.selectAllReviewsByMemberId(memberId);
        Set<Integer> restaurantIdsToUpdate = new java.util.HashSet<>();
        if (reviews != null) {
            for (RestaurantReviewVO review : reviews) {
                restaurantIdsToUpdate.add(review.getRestaurantId());
            }
        }

		// 2. 회원의 상태를 DB에서 변경
		Map<String, Object> params = new java.util.HashMap<>();
		params.put("id", memberId);
		params.put("status", newStatus);
		memberDAO.updateUserStatus(params);

		// 3. 상태 변경 이력 로그 기록
        MemberStatusLogVO log = new MemberStatusLogVO();
        log.setMemberId(memberId);
        log.setAdminId(adminId);
        log.setPreviousStatus(previousStatus);
        log.setNewStatus(newStatus);
        log.setReason(reason);
        memberStatusLogDAO.insertLog(log);

		// 4. 영향을 받는 모든 맛집의 평점을 다시 계산하여 업데이트
        for (int restaurantId : restaurantIdsToUpdate) {
            reviewService.updateRestaurantRating(restaurantId);
        }
	}



	// [관리자] 회원 상세 정보 조회 (찜, 리뷰 목록 제외)
	public Map<String, Object> getUserDetail(String id) {
		Map<String, Object> userDetail = new java.util.HashMap<>();

		// 1. 회원 기본 정보
		userDetail.put("member", memberDAO.selectMemberById(id));
		
		// 2. 회원의 상태 변경 로그 수 조회
		userDetail.put("logCount", memberStatusLogDAO.countLogsByMemberId(id));
		
		// 3. 회원의 상태 변경 로그 목록 조회
		userDetail.put("logList", memberStatusLogDAO.selectLogsByMemberId(id));

		return userDetail;
	}
	
	/**
     * 사용자 관련 통계를 조회합니다.
     * @return 통계 정보가 담긴 Map
     */
    public Map<String, Object> getUserStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        // 기본 통계
        int totalUsers = memberDAO.getTotalUserCount();
        int activeUsers = memberDAO.getUserCountByStatus("Y");
        int inactiveUsers = memberDAO.getUserCountByStatus("N");
        
        stats.put("totalUsers", totalUsers);
        stats.put("activeUsers", activeUsers);
        stats.put("inactiveUsers", inactiveUsers);

        // 비율 계산 및 포맷팅
        if (totalUsers > 0) {
            double activeRatio = (double) activeUsers / totalUsers;
            double inactiveRatio = (double) inactiveUsers / totalUsers;
            stats.put("activePercentage", FormatUtil.formatPercentage(activeRatio));
            stats.put("inactivePercentage", FormatUtil.formatPercentage(inactiveRatio));
        } else {
            stats.put("activePercentage", "0%");
            stats.put("inactivePercentage", "0%");
        }
        
        // 기간별 신규 가입자 통계
        stats.put("dailyNewUsers", memberDAO.getNewUserCountByPeriod("daily"));
        stats.put("weeklyNewUsers", memberDAO.getNewUserCountByPeriod("weekly"));
        stats.put("monthlyNewUsers", memberDAO.getNewUserCountByPeriod("monthly"));
        
        // 사용자 활동 순위
        stats.put("reviewRankers", memberDAO.getUsersRankedByReviewCount());
        stats.put("favoriteRankers", memberDAO.getUsersRankedByFavoriteCount());
        
        return stats;
    }

    /**
     * 특정 회원의 가장 최근 비활성화 사유를 조회합니다.
     * @param memberId 조회할 회원의 ID
     * @return 가장 최근의 비활성화 로그 객체
     */
    public MemberStatusLogVO getLatestDeactivationLog(String memberId) {
        return memberStatusLogDAO.selectLatestDeactivationLog(memberId);
    }
}

