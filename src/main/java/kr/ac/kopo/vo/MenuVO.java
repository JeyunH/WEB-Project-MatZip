package kr.ac.kopo.vo;

import lombok.Data;

@Data
public class MenuVO {
	private int menuId;
	private int restaurantId;
	private String menuName;
	private Integer price; // 가격 NULL 허용
}
