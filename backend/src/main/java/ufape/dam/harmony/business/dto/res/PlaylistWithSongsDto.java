package ufape.dam.harmony.business.dto.res;


import java.util.Set;

import lombok.Data;
import ufape.dam.harmony.business.dto.reqs.PlaylistDto;
import ufape.dam.harmony.business.dto.reqs.UsuarioDto;
import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.business.entity.Usuario;


@Data
public class PlaylistWithSongsDto {
	private Long id;
	private String title;
	private String description;
	private String urlCover;
	private UsuarioDto author;
    private Set<Song> songs;
    
    public static Playlist toEntity(PlaylistDto dto, Usuario author) {
        Playlist entity = new Playlist();
        entity.setTitle(dto.getTitle());
        entity.setDescription(dto.getDescription());
        entity.setUrlCover(dto.getUrlCover());
        
        entity.setAuthor(author);
        
        return entity;
    }
    
    public static PlaylistWithSongsDto fromEntity(Playlist entity) {
    	PlaylistWithSongsDto dto = new PlaylistWithSongsDto();

        dto.setId(entity.getId());
        dto.setTitle(entity.getTitle());
        dto.setDescription(entity.getDescription());
        dto.setUrlCover(entity.getUrlCover());

        if (entity.getAuthor() != null) {
            dto.setAuthor(UsuarioDto.fromEntity(entity.getAuthor()));
        }
        if (entity.getSongs() != null) {
            dto.setSongs(entity.getSongs());
        }
        return dto;
    }
}
