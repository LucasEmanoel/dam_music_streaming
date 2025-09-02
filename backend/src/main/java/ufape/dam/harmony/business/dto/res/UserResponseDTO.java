package ufape.dam.harmony.business.dto.res;

import lombok.Data;
import ufape.dam.harmony.business.entity.Usuario;

@Data
public class UserResponseDTO {
	private Long id;
    private String username;
    private String email;
    private String role;

    public static UserResponseDTO fromEntity(Usuario entity) {
        if (entity == null) return null;
        UserResponseDTO dto = new UserResponseDTO();
        dto.setId(entity.getId());
        dto.setUsername(entity.getUsername());
        dto.setEmail(entity.getEmail());
        dto.setRole(entity.getRole());
        return dto;
    }
}
