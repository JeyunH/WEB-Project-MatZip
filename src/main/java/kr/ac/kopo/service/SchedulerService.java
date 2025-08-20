package kr.ac.kopo.service;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class SchedulerService {

    @Autowired
    private RestaurantService restaurantService;

    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    /**
     * 매 10분마다 모든 맛집의 MZ스코어를 업데이트합니다.
     * cron = "초 분 시 일 월 요일"
     */
    @Scheduled(cron = "0 */10 * * * *")
    public void updateMzScoreRegularly() {
        long startTime = System.currentTimeMillis();
        System.out.println("MZ스코어 업데이트 스케줄러 실행 시작... (" + dateFormat.format(new Date(startTime)) + ")");
        
        try {
            restaurantService.batchUpdateAllMzScores();
            long endTime = System.currentTimeMillis();
            double duration = (endTime - startTime) / 1000.0; // 초 단위로 변환
            System.out.println("MZ스코어 업데이트 스케줄러 실행 완료. (" + dateFormat.format(new Date(endTime)) + ")");
            System.out.printf("총 소요 시간: %.2f초\n", duration); // 소수점 둘째 자리까지 출력
        } catch (Exception e) {
            System.err.println("MZ스코어 업데이트 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
