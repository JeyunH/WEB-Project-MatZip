package kr.ac.kopo.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class RestaurantReviewVO {
	
	
    private int reviewId;
    private int restaurantId;
    private String memberId;
    private String content;
    private Date regdate;
    private double starScore;
    private String nickname;
    private String restaurantName; // 식당 이름

    // 리뷰에 첨부된 이미지 리스트 (RestaurantImageVO 사용)
    private List<RestaurantImageVO> imageList;
}
