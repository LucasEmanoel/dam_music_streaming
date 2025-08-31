package ufape.dam.harmony.business.dto.reqs;
import lombok.Data;
import ufape.dam.harmony.business.entity.Usuario;

@Data
public class UsuarioDto {
	
    private String username;
    private String email;
    private String role;
    
    public static UsuarioDto fromEntity(Usuario entity) {
        UsuarioDto dto = new UsuarioDto();
        
        dto.setUsername(entity.getUsername());
        //dto.setEmail(entity.getEmail());
        //dto.setRole(entity.getRole());
        
        return dto;
    }
} 
