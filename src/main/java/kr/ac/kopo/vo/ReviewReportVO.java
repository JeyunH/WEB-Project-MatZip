package kr.ac.kopo.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ReviewReportVO {

    private int reportId;
    private int reviewId;
    private int restaurantId;
    private String memberId;
    private String reportCategory;
    private String reportContent;
    private Date reportDate;
    private String status;
    private String memberNickname;
    private String reviewContent;

}
