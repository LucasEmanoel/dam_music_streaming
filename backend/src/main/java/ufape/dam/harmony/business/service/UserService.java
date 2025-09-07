package ufape.dam.harmony.business.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ufape.dam.harmony.business.dto.res.UserResponseDTO;
import ufape.dam.harmony.business.entity.Usuario;
import ufape.dam.harmony.data.UsuarioRepository;

@Service
public class UserService {
	@Autowired
	private UsuarioRepository usuarioRepository;
	
	public UserResponseDTO getUserDetails(long idUser) throws Exception  {
		Usuario user = usuarioRepository.findById(idUser).orElse(null);
		
		if(user == null) {
			throw new Exception();
		}
		
		return UserResponseDTO.fromEntity(user);
	}
	
	public UserResponseDTO updateUserProfile(Long idUser, String fullName, String username, String profilePictureUrl) throws Exception {
		Usuario user = usuarioRepository.findById(idUser).orElse(null);
		
		if(user == null) {
			throw new Exception();
		}
		
		if(fullName != null) {
			user.setFullName(fullName);
		}
		
		if(username != null) {
			user.setUsername(username);
		}
		
		if(profilePictureUrl != null) {
			user.setProfilePicUrl(profilePictureUrl);
		}
		
		Usuario userUpdated = usuarioRepository.save(user);
		return UserResponseDTO.fromEntity(userUpdated);
	}
	
	public void deleteUser(long idUser)  throws Exception{
		Usuario user = usuarioRepository.findById(idUser).orElse(null);
		
		if(user == null) {
			throw new Exception();
		}
		
		usuarioRepository.delete(user);
	}
}
