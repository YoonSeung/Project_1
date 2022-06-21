package org.movie.mapper;

import java.util.List;

import org.movie.domain.MovieAttachVO;

public interface MovieAttachMapper {

	public void insert(MovieAttachVO vo);
	
	public void delete(String uuid);
	
	public List<MovieAttachVO> findBycode(Long code);
	
	public void deleteAll(Long code);
	
	public List<MovieAttachVO> getOldFiles(Long code);
}
