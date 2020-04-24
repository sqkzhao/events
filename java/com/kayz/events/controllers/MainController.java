package com.kayz.events.controllers;

import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kayz.events.models.Event;
import com.kayz.events.models.User;
import com.kayz.events.services.MainService;
import com.kayz.events.validator.UserValidator;

@Controller
public class MainController {
	private final MainService service;
	private final UserValidator userValidator;
	public MainController(MainService service, UserValidator userValidator) {
		this.service = service;
		this.userValidator = userValidator;
	}

	// LOGIN & REGISTRATION PAGE
	@GetMapping("/")
	public String loginRegistration(@ModelAttribute("user") User user, Model model) {
		return "loginRegistration.jsp";
	}
	// REGISTER USER
	@PostMapping("/registration")
	public String registration(@Valid @ModelAttribute("user") User user, BindingResult result, HttpSession session) {
		userValidator.validate(user, result);
		if(result.hasErrors()) {
			return "loginRegistration.jsp";
		} else {
			User u = service.registerUser(user);
			session.setAttribute("userId", u.getId());
			return "redirect:/events";
		}
	}
	// LOGIN
	@PostMapping("/login")
	public String login(@ModelAttribute("user") User user, @RequestParam(value="email") String email, @RequestParam(value="password") String password, HttpSession session, Model model) {
		if(!service.isValidUser(email, password)) {
			model.addAttribute("error", "Email/password is invalid");
			return "loginRegistration.jsp";
		} else {
			User u = service.findUserByEmail(email);
			session.setAttribute("userId", u.getId());
			return "redirect:/events";
		}
	}
	// LOGOUT 
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/events";
	}
	
	
	
	// DASHBOARD
	@GetMapping("/events")
	public String dashboard(@ModelAttribute("event") Event event, HttpSession session, Model model) {
		// LOGGED IN USER
		if(session.getAttribute("userId") != null) {
			Long currentUid = (Long) session.getAttribute("userId");
			User currentUser = service.findUserById(currentUid);
			model.addAttribute("currentUser", currentUser);
			List<Event> allLocalEvents = service.findEventsByState(currentUser.getState());
			model.addAttribute("allLocalEvents", allLocalEvents);
			List<Event> otherEvents = service.findEventsNotInState(currentUser.getState());
			model.addAttribute("otherEvents", otherEvents);
			List<Event> joinedEvents = currentUser.getJoinedEvents();
			model.addAttribute("joinedEvents", joinedEvents);
		} else {
			List<Event> otherEvents = service.findAllEvents();
			model.addAttribute("otherEvents", otherEvents);
		}
		return "dashboard.jsp";
	}
	
	// CREATE EVENT
	@PostMapping("/events")
	public String createEvent(@Valid @ModelAttribute("event") Event event, BindingResult result, HttpSession session, Model model) {
		// ONLY LOGGED IN USER CAN CREATE EVENT
		Long currentUid = (Long) session.getAttribute("userId");
		User currentUser = service.findUserById(currentUid);
		if(result.hasErrors()) {
			model.addAttribute("currentUser", currentUser);
			List<Event> allLocalEvents = service.findEventsByState(currentUser.getState());
			model.addAttribute("allLocalEvents", allLocalEvents);
			List<Event> otherEvents = service.findEventsNotInState(currentUser.getState());
			model.addAttribute("otherEvents", otherEvents);
			List<Event> joinedEvents = currentUser.getJoinedEvents();
			model.addAttribute("joinedEvents", joinedEvents);
			return "dashboard.jsp";
		} else {
			service.createEvent(event);
			event.getMembers().add(currentUser);
			service.createEvent(event);
			return "redirect:/events";
		}
	}
	
	// JOIN EVENT
	@PostMapping("/events/join")
	public String joinEvent(@RequestParam(value="memberId") Long memberId, @RequestParam(value="eventId") Long eventId) {
		Event event = service.findEventById(eventId);
		User member = service.findUserById(memberId);
		event.getMembers().add(member);
		service.createEvent(event);
		return "redirect:/events";
	}
	// CANCEL JOIN
	@PostMapping("/events/cancel")
	public String cancelEvent(@RequestParam(value="memberId") Long memberId, @RequestParam(value="eventId") Long eventId) {
		Event event = service.findEventById(eventId);
		User member = service.findUserById(memberId);
		event.getMembers().remove(member);
		service.createEvent(event);
		return "redirect:/events";
	}
	// SHOW EVENT
	@GetMapping("/events/{id}")
	public String showEvent(@PathVariable("id") Long id, Model model) {
		Event event = service.findEventById(id);
		model.addAttribute("event", event);
		List<User> joinedMember = event.getMembers();
		model.addAttribute("count", joinedMember.size());
		return "showEvent.jsp";
	}
	// EDIT EVENT
	@GetMapping("/events/{id}/edit")
	public String editEvent(@ModelAttribute("editedEvent") Event editedEvent, @PathVariable("id") Long id, Model model, HttpSession session, RedirectAttributes ra) {
		if(session.getAttribute("userId") == null) {
			ra.addFlashAttribute("accessError", "Access Denied");
			return "redirect:/events";
		} 
		Long currentUid = (Long) session.getAttribute("userId");
		User currentUser = service.findUserById(currentUid);
		Event event = service.findEventById(id);
		if(currentUser != event.getUser()) {
			ra.addFlashAttribute("accessError", "Access Denied");
			return "redirect:/events";
		}
		model.addAttribute("event", event);
		String pattern = "yyyy-MM-dd";
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
		String date = simpleDateFormat.format(event.getDate());
		model.addAttribute("date", date);
		return "editEvent.jsp";
	}
	@PostMapping("/events/{id}/edit")
	public String updateEvent(@Valid @ModelAttribute("editedEvent") Event editedEvent, BindingResult result, Model model, @PathVariable("id") Long id) {
		Event event = service.findEventById(id);
		if(result.hasErrors()) {
			model.addAttribute("event", event);
			return "editEvent.jsp";
		}
		event.setName(editedEvent.getName());
		event.setDate(editedEvent.getDate());
		event.setLocation(editedEvent.getLocation());
		event.setState(editedEvent.getState());
		service.createEvent(event);
		return "redirect:/events/" + id;
	}
	// DELETE EVENT
	@DeleteMapping("/events/{id}")
	public String deleteEvent(@PathVariable("id") Long id) {
		service.deleteEvent(id);
		return "redirect:/events";
	}
}
