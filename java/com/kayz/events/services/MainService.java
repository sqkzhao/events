package com.kayz.events.services;

import java.util.List;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

import com.kayz.events.models.Event;
import com.kayz.events.models.User;
import com.kayz.events.repositories.EventRepo;
import com.kayz.events.repositories.UserRepo;

@Service	
public class MainService {
	private final UserRepo userRepo;
	private final EventRepo eRepo;
	public MainService(UserRepo userRepo, EventRepo eRepo) {
		this.userRepo = userRepo;
		this.eRepo = eRepo;
	}
	
	// FIND
	public User findUserByEmail(String email) {
		return userRepo.findByEmail(email);
	}
	public User findUserById(Long id) {
		return userRepo.findById(id).orElse(null);
	}
	public Event findEventById(Long id) {
		return eRepo.findById(id).orElse(null);
	}
	public List<Event> findAllEvents(){
		return eRepo.findAll();
	}
	public List<Event> findEventsByState(String state){
		return eRepo.findByStateContains(state);
	}
	public List<Event> findEventsNotInState(String state){
		return eRepo.findByStateNotContains(state);
	}

	// REGISTER
	public User registerUser(User user) {
		String hashedPw = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
		user.setPassword(hashedPw);
		return userRepo.save(user);
	}
	
	// LOGIN AUTHENTICATION
	public Boolean isValidUser(String email, String password) {
		User temp = userRepo.findByEmail(email);
		if(temp == null) {
			return false;
		}
		if(!BCrypt.checkpw(password, temp.getPassword())) {
			return false;
		}
		return true;
	}
	
	// CREATE EVENT
	public Event createEvent(Event e) {
		return eRepo.save(e);
	}
	
	// DELETE EVENT
	public void deleteEvent(Long id) {
		eRepo.deleteById(id);
	}
}
