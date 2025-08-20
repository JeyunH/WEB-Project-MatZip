package kr.ac.kopo.dao;

import java.util.List;

import kr.ac.kopo.vo.MemberStatusLogVO;

public interface MemberStatusLogDAO {

    /**
     * 회원 상태 변경 이력을 기록합니다.
     * @param logVO 로그 정보를 담은 VO 객체
     */
    void insertLog(MemberStatusLogVO logVO);

    /**
     * 특정 회원의 가장 최근 비활성화 로그를 조회합니다.
     * @param memberId 조회할 회원의 ID
     * @return 가장 최근의 비활성화 로그 정보
     */
    MemberStatusLogVO selectLatestDeactivationLog(String memberId);

    /**
     * 특정 회원의 전체 상태 변경 로그 개수를 조회합니다.
     * @param memberId 조회할 회원의 ID
     * @return 해당 회원의 로그 개수
     */
    int countLogsByMemberId(String memberId);

    /**
     * 특정 회원의 전체 상태 변경 로그 목록을 조회합니다.
     * @param memberId 조회할 회원의 ID
     * @return 해당 회원의 로그 목록 (최신순)
     */
    List<MemberStatusLogVO> selectLogsByMemberId(String memberId);
}
