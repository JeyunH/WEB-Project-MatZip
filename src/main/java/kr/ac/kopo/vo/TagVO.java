package kr.ac.kopo.vo;

import lombok.Data;

@Data
public class TagVO {
	private int tagId;
	private int restaurantId;
	private String tagName;
	private String tagType;
}