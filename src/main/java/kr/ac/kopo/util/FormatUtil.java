package kr.ac.kopo.util;

import java.text.DecimalFormat;

public class FormatUtil {

    /**
     * 비율 값을 요구사항에 맞는 퍼센트 문자열로 변환합니다.
     * 
     * @param ratio 비율 (예: 0.995)
     * @return 포맷된 퍼센트 문자열 (예: "99.50%")
     */
    public static String formatPercentage(double ratio) {
        if (ratio == 0) {
            return "0%";
        }
        if (ratio == 1) {
            return "100%";
        }

        double percentage = ratio * 100;

        // 0.01% 이상일 경우, 소수점 둘째 자리까지 표시
        if (percentage >= 0.01) {
            DecimalFormat df = new DecimalFormat("#,##0.00'%'");
            return df.format(percentage);
        } 
        // 0.01% 미만일 경우, 첫 유효숫자가 나올 때까지 소수점 확장
        else {
            // 유효숫자를 찾기 위한 로직
            int decimalPlaces = 2; // 최소 소수점 2자리
            while (ratio * 100 * Math.pow(10, decimalPlaces - 2) < 1) {
                decimalPlaces++;
                if (decimalPlaces > 10) break; // 무한 루프 방지 (최대 10자리)
            }
            
            StringBuilder pattern = new StringBuilder("#,##0.");
            for (int i = 0; i < decimalPlaces; i++) {
                pattern.append("0");
            }
            pattern.append("'%'");
            
            DecimalFormat df = new DecimalFormat(pattern.toString());
            return df.format(percentage);
        }
    }
}
