package org.movie.domain;

import java.util.List;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class MovieVO {
	private Long code;
	private String title, director,price,actor ,poster, synopsis;
	
	private List<MovieAttachVO> attachList;
}
