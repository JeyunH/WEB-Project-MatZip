package kr.ac.kopo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

import org.springframework.stereotype.Service;

import kr.ac.kopo.vo.PaginationVO;

@Service
public class PagingService {

    /**
     * 페이징 처리된 데이터 목록을 조회하는 공통 메소드
     * @param <T>           리스트의 데이터 타입 (e.g., MemberVO, RestaurantVO)
     * @param params        컨트롤러로부터 받은 파라미터 (page, keyword 등 포함)
     * @param pageSize      페이지 당 아이템 수
     * @param countFunction 총 아이템 개수를 조회하는 DAO 메소드 (람다식으로 전달)
     * @param listFunction  해당 페이지의 아이템 목록을 조회하는 DAO 메소드 (람다식으로 전달)
     * @param useOffset     페이징 쿼리 방식으로 offset/limit을 사용할지 (true), ROWNUM의 start/end를 사용할지 (false) 결정
     * @return              페이징 객체(paging)와 데이터 목록(list)이 담긴 Map
     */
    public <T> Map<String, Object> getPaginatedList(
            Map<String, Object> params,
            int pageSize,
            Function<Map<String, Object>, Integer> countFunction,
            Function<Map<String, Object>, List<T>> listFunction,
            boolean useOffset
    ) {
        // 1. 현재 페이지 번호 추출
        int page = (int) params.getOrDefault("page", 1);

        // 2. 전체 아이템 개수 조회 (DAO 호출)
        int totalCount = countFunction.apply(params);
        
        // 3. 페이징 객체 생성
        PaginationVO pagination = new PaginationVO(totalCount, page, pageSize, 9);

        // 4. DB 쿼리를 위한 페이징 파라미터 추가
        if (useOffset) {
            // MySQL, PostgreSQL, MariaDB 등에서 사용하는 offset 기반 페이징
            params.put("offset", (pagination.getCurrentPage() - 1) * pageSize);
            params.put("limit", pageSize);
        } else {
            // Oracle에서 사용하는 ROWNUM 기반 페이징
            params.put("start", (pagination.getCurrentPage() - 1) * pageSize + 1);
            params.put("end", pagination.getCurrentPage() * pageSize);
        }

        // 5. 현재 페이지의 데이터 목록 조회 (DAO 호출)
        List<T> list = listFunction.apply(params);

        // 6. 최종 결과를 Map에 담아 반환
        Map<String, Object> result = new HashMap<>();
        result.put("list", list); // key는 "list"로 고정
        result.put("paging", pagination);

        return result;
    }
}
