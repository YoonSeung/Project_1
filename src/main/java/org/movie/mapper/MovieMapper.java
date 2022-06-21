package org.movie.mapper;

import java.util.List;

import org.movie.domain.MovieVO;

public interface MovieMapper {

	public List<MovieVO> getList();
	
	public void insertSelectKey(MovieVO mVo);
	
	public MovieVO read(Long code); 
	
	public int delete(Long code); 
	
	public int update(MovieVO eVo);
}
