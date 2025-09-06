package ufape.dam.harmony.business.dto.reqs;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Usuario;

@Data
public class PlaylistRequestDTO {

	private Long id;
	private String title;
	private String description;
	@JsonProperty("url_cover")
	private String urlCover;
    private Usuario author; //vem da sessao
    
    public static Playlist toEntity(PlaylistRequestDTO dto, Usuario author) {
        Playlist entity = new Playlist();
        
        entity.setId(dto.getId());
        entity.setTitle(dto.getTitle());
        entity.setDescription(dto.getDescription());
        entity.setUrlCover(dto.getUrlCover());
        
        entity.setAuthor(author);
        
        return entity;
    }
	

	@Override
	public String toString() {
		return "PlaylistDto [id=" + id + ", title=" + title + ", description=" + description + ", urlCover=" + urlCover
				+ ", author=" + author + "]";
	}
	
	
	
	
}
