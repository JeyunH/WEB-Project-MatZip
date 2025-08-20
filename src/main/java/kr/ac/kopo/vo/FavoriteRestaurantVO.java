package kr.ac.kopo.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor // Lombok: 기본 생성자 추가
public class FavoriteRestaurantVO {
	private int favoriteId; // PK
	private String memberId; // 찜한 회원ID
	private int restaurantId; // 찜한 가게ID
	private Date regdate; // 찜한 날짜

	// 서비스 레이어에서 사용할 생성자 추가
	public FavoriteRestaurantVO(int restaurantId, String memberId) {
		this.restaurantId = restaurantId;
		this.memberId = memberId;
	}
}
