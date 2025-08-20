package kr.ac.kopo.vo;

import lombok.Data;

@Data
public class RestaurantImageVO {
	private int imageId;
	private int restaurantId;
	private Integer reviewId; // 리뷰 이미지일 때만 값 있음
	private String memberId; // 업로더(리뷰 작성자 등)
	private String imageUrl; // 상대경로
	private String imgType; // 'BASIC' or 'REVIEW'
	private String regdate;
}
