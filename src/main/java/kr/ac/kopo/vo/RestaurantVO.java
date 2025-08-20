package kr.ac.kopo.vo;

import lombok.Data;

@Data
public class RestaurantVO {
    private int restaurantId;
    private String name;
    private String region;
    private String category;
    private int starPercent;
    private double starScore;
    private int reviewCount;
    private double mzScore;
    private String address;
    private String phone;
    private String mainImgUrl1;
    private String mainImgUrl2;
    private String status;
    private int favoriteCount; // 통계용: 찜 수 카운트

}