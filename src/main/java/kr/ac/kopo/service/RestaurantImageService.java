package kr.ac.kopo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.kopo.dao.RestaurantImageDAO;
import kr.ac.kopo.vo.RestaurantImageVO;

@Service
public class RestaurantImageService {
	
    @Autowired
    private RestaurantImageDAO restaurantImageDAO;

    /**
     * 맛집 ID로 기본 이미지 목록을 조회합니다.
     * @param restaurantId 맛집 ID
     * @return 기본 이미지 목록
     */
    public List<RestaurantImageVO> getBasicImagesByRestaurantId(int restaurantId) {
        return restaurantImageDAO.selectBasicImagesByRestaurantId(restaurantId);
    }

    /**
     * 이미지 정보를 DB에 추가합니다.
     * @param imageVO 추가할 이미지 정보
     */
    @Transactional
    public void addImage(RestaurantImageVO imageVO) {
        restaurantImageDAO.insertImage(imageVO);
    }

    /**
     * 이미지 ID로 이미지를 삭제합니다.
     * @param imageId 삭제할 이미지의 ID
     */
    @Transactional
    public void deleteImage(int imageId) {
        restaurantImageDAO.deleteImage(imageId);
    }

    /**
     * 파일을 지정된 경로에 저장하고, 저장된 파일명을 반환하는 헬퍼 메소드.
     * @param file 저장할 MultipartFile
     * @param basePath 파일을 저장할 기본 경로
     * @return 저장된 파일명 (경로 제외)
     * @throws Exception 파일 저장 중 예외 발생
     */
    public String saveFile(MultipartFile file, String basePath) throws Exception {
        if (file == null || file.isEmpty()) {
            return null;
        }
        
        String originalName = file.getOriginalFilename();
        String extension = originalName.substring(originalName.lastIndexOf("."));
        String savedName = System.currentTimeMillis() + "_" + (int)(Math.random() * 10000) + extension;
        
        java.io.File directory = new java.io.File(basePath);
        if (!directory.exists()) {
            directory.mkdirs();
        }
        
        java.io.File dest = new java.io.File(directory, savedName);
        file.transferTo(dest);
        
        return savedName;
    }
}
