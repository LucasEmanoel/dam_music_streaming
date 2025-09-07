package ufape.dam.harmony.business.dto.res;

import lombok.Data;
import ufape.dam.harmony.business.entity.Usuario;

@Data
public class UserResponseDTO {
	private Long id;
	private String fullName;
    private String username;
    private String email;
    private String role;
    private String profilePicUrl;

    public static UserResponseDTO fromEntity(Usuario entity) {
        if (entity == null) return null;
        UserResponseDTO dto = new UserResponseDTO();
        dto.setId(entity.getId());
        dto.setFullName(entity.getFullName());
        dto.setUsername(entity.getUsername());
        dto.setEmail(entity.getEmail());
        dto.setRole(entity.getRole());
        dto.setProfilePicUrl(entity.getProfilePicUrl());
        return dto;
    }
}
