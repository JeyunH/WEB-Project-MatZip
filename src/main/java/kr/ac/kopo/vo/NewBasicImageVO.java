package kr.ac.kopo.vo;

import org.springframework.web.multipart.MultipartFile;

/**
 * 맛집 수정/등록 시 새로 추가되는 기본 이미지를 전송하기 위한 VO
 */
public class NewBasicImageVO {

    private String type; // "URL" 또는 "FILE"
    private String url;
    private MultipartFile file;

    // Getter 및 Setter
    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }
    public String getUrl() {
        return url;
    }
    public void setUrl(String url) {
        this.url = url;
    }
    public MultipartFile getFile() {
        return file;
    }
    public void setFile(MultipartFile file) {
        this.file = file;
    }
}
