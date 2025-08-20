package kr.ac.kopo.vo;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;

/**
 * 맛집 정보 수정을 위한 폼 데이터를 담는 전용 VO 객체
 */
public class RestaurantUpdateFormVO {

    private Integer restaurantId;
    private String name;
    private String address;
    private String phone;
    private String region;
    private String category;

    // 대표 이미지 1
    private String mainImgUrl1;
    private String mainImg1_type;
    private MultipartFile mainImgFile1;

    // 대표 이미지 2
    private String mainImgUrl2;
    private String mainImg2_type;
    private MultipartFile mainImgFile2;

    // 메뉴 정보
    private List<String> menuNames;
    private List<Integer> menuPrices;

    // 태그 정보
    private List<String> tagNames;
    private List<String> tagTypes;

    // 새로 추가된 기본 이미지 정보
    private List<NewBasicImageVO> newBasicImages;

    // --- Getters and Setters ---

    public Integer getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getMainImgUrl1() {
        return mainImgUrl1;
    }

    public void setMainImgUrl1(String mainImgUrl1) {
        this.mainImgUrl1 = mainImgUrl1;
    }

    public String getMainImg1_type() {
        return mainImg1_type;
    }

    public void setMainImg1_type(String mainImg1_type) {
        this.mainImg1_type = mainImg1_type;
    }

    public MultipartFile getMainImgFile1() {
        return mainImgFile1;
    }

    public void setMainImgFile1(MultipartFile mainImgFile1) {
        this.mainImgFile1 = mainImgFile1;
    }

    public String getMainImgUrl2() {
        return mainImgUrl2;
    }

    public void setMainImgUrl2(String mainImgUrl2) {
        this.mainImgUrl2 = mainImgUrl2;
    }

    public String getMainImg2_type() {
        return mainImg2_type;
    }

    public void setMainImg2_type(String mainImg2_type) {
        this.mainImg2_type = mainImg2_type;
    }

    public MultipartFile getMainImgFile2() {
        return mainImgFile2;
    }

    public void setMainImgFile2(MultipartFile mainImgFile2) {
        this.mainImgFile2 = mainImgFile2;
    }

    public List<String> getMenuNames() {
        return menuNames;
    }

    public void setMenuNames(List<String> menuNames) {
        this.menuNames = menuNames;
    }

    public List<Integer> getMenuPrices() {
        return menuPrices;
    }

    public void setMenuPrices(List<Integer> menuPrices) {
        this.menuPrices = menuPrices;
    }

    public List<String> getTagNames() {
        return tagNames;
    }

    public void setTagNames(List<String> tagNames) {
        this.tagNames = tagNames;
    }

    public List<String> getTagTypes() {
        return tagTypes;
    }

    public void setTagTypes(List<String> tagTypes) {
        this.tagTypes = tagTypes;
    }

    public List<NewBasicImageVO> getNewBasicImages() {
        return newBasicImages;
    }

    public void setNewBasicImages(List<NewBasicImageVO> newBasicImages) {
        this.newBasicImages = newBasicImages;
    }
}
