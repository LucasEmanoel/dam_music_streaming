package ufape.dam.harmony.business.dto.reqs;

import lombok.Data;
import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Usuario;

@Data
public class PlaylistDto {

	private Long id;
	private String title;
	private String description;
	private String urlCover;
	private UsuarioDto author;
    
    
    public static Playlist toEntity(PlaylistDto dto, Usuario author) {
        Playlist entity = new Playlist();
        
        entity.setId(dto.getId());
        entity.setTitle(dto.getTitle());
        entity.setDescription(dto.getDescription());
        entity.setUrlCover(dto.getUrlCover());
        
        entity.setAuthor(author);
        
        return entity;
    }
	
	
	public static PlaylistDto fromEntity(Playlist entity) {
        PlaylistDto dto = new PlaylistDto();

        dto.setId(entity.getId());
        dto.setTitle(entity.getTitle());
        dto.setDescription(entity.getDescription());
        dto.setUrlCover(entity.getUrlCover());
        
        if (entity.getAuthor() != null) {
            dto.setAuthor(UsuarioDto.fromEntity(entity.getAuthor()));
        }


        return dto;
    }
	
	
}
