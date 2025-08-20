package kr.ac.kopo.vo;

import java.util.Date;
import lombok.Data;

@Data
public class MemberVO {
    private String id;
    private String password;
    private String nickname;
    private String email;
    private Date regdate;
    private String status;
    private String type;

    // 랭킹 데이터를 담기 위한 추가 필드
    private int reviewCount;
    private int favoriteCount;
}
