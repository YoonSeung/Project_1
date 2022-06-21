package org.movie.service;

import java.util.List;

import org.movie.domain.MovieAttachVO;
import org.movie.domain.MovieVO;
import org.movie.mapper.MovieAttachMapper;
import org.movie.mapper.MovieMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service

public class MovieServiceImpl implements MovieService {

	@Setter(onMethod_ = @Autowired)
	private MovieMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private MovieAttachMapper attachMapper;
	
	@Override
	public List<MovieVO> getList() {
		// TODO Auto-generated method stub
		return mapper.getList();
	}
	
	
	@Override
	@Transactional
	public void register(MovieVO mVo) {
		// TODO Auto-generated method stub
			log.info("register......." + mVo);
			mapper.insertSelectKey(mVo);
			
			if(mVo.getAttachList() ==null || mVo.getAttachList().size()<=0) {
				return;
			}
			
			mVo.getAttachList().forEach(attach ->{
				attach.setCode(mVo.getCode());
				
				attachMapper.insert(attach);
			});
	}
	
	@Override
	public List<MovieAttachVO> getAttachList(Long code){
		log.info("get Attach list by code: " + code);
		return attachMapper.findBycode(code);
	}
	
	
	@Override
	@Transactional
	public boolean modify(MovieVO mVo) {
		// TODO Auto-generated method stub
		log.info("modify........" + mVo);
		
		attachMapper.deleteAll(mVo.getCode());
		
		boolean modifyResult = mapper.update(mVo)==1;
		
		if(modifyResult && mVo.getAttachList()!= null && mVo.getAttachList().size() >0) {
			mVo.getAttachList().forEach(attach->{
				attach.setCode(mVo.getCode());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	
	@Override
	@Transactional
	public boolean remove(Long code) {
		// TODO Auto-generated method stub
		log.info("remove........" + code);
		attachMapper.deleteAll(code);
		return mapper.delete(code)==1;
	}
	
	@Override
	public MovieVO get(Long code) {
		// TODO Auto-generated method stub
		log.info("get........." + code);
		return mapper.read(code);
	}
}
