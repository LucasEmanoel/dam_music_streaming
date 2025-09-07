package ufape.dam.harmony.presentation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ufape.dam.harmony.business.dto.reqs.UpdateUserRequestDTO;
import ufape.dam.harmony.business.dto.res.UserResponseDTO;
import ufape.dam.harmony.business.service.UserService;

@RestController
@RequestMapping("/user") 
public class UsuarioController {
	@Autowired
	private UserService userService;
	
	@GetMapping("/profile/{userId}")
    public ResponseEntity getUserDetails(@PathVariable long userId) {
		try {
			UserResponseDTO userResponse = userService.getUserDetails(userId);

			return ResponseEntity.status(HttpStatus.OK).body(userResponse);
		} catch (Exception ex){
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Cannot update user.");
		}
    }
	
	@PatchMapping("/{userId}")
    public ResponseEntity updateUser(@PathVariable long userId, @RequestBody UpdateUserRequestDTO request) {
		try {
			UserResponseDTO userResponse = userService.updateUserProfile(userId, request.getFullName(), request.getUsername(), request.getProfilePictureUrl() );

			return ResponseEntity.status(HttpStatus.OK).body(userResponse);
		} catch (Exception ex){
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Cannot update user.");
		}
    }
	
	@DeleteMapping("/{userId}")
	public ResponseEntity deleteUser(@PathVariable long userId) {
		try {
			userService.deleteUser(userId);

			return ResponseEntity.status(HttpStatus.OK).body("User deleted Successfully");
		} catch (Exception ex){
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Cannot update user.");
		}
	}
}
