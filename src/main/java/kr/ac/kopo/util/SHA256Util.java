package kr.ac.kopo.util;

import java.security.MessageDigest;

public class SHA256Util {

    public static String encrypt(String text) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(text.getBytes("UTF-8"));

            // 바이트 배열 → 16진수 문자열로 변환
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }

            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("SHA-256 암호화 실패", e);
        }
    }
}
