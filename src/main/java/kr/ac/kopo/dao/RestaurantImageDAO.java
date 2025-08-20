package kr.ac.kopo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.kopo.vo.RestaurantImageVO;

@Mapper
public interface RestaurantImageDAO {
    // 리뷰 ID로 이미지 목록 조회
    List<RestaurantImageVO> selectImagesByReviewId(int reviewId);

    // 맛집 ID로 '기본' 이미지 목록 조회
    List<RestaurantImageVO> selectBasicImagesByRestaurantId(int restaurantId);

    // 이미지 등록
    void insertImage(RestaurantImageVO imageVO);

    // 이미지 ID로 이미지 삭제
    void deleteImage(int imageId);

    // 리뷰 ID로 이미지 목록 삭제
    void deleteImagesByReviewId(int reviewId);
}
