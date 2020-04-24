package com.kayz.events.repositories;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.kayz.events.models.Event;

@Repository
public interface EventRepo extends CrudRepository<Event, Long> {
	List<Event> findAll();
	List<Event> findByStateContains(String state);
	List<Event> findByStateNotContains(String state);
}
