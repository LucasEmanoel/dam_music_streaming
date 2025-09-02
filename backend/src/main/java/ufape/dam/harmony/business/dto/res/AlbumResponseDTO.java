package ufape.dam.harmony.business.dto.res;

import java.time.Duration;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import lombok.Data;
import ufape.dam.harmony.business.entity.Album;

@Data
public class AlbumResponseDTO {
    private Long id;
    private String title;
    private String urlCover;
    private Duration duration;
    private Date release_date;
    
    private ArtistResponseDTO artist;
    private List<SongInsideAlbumDTO> songs;

	
	public static AlbumResponseDTO fromEntity(Album entity) {
        if (entity == null) return null;
        
        AlbumResponseDTO dto = new AlbumResponseDTO();
        
        dto.setId(entity.getId());
        dto.setTitle(entity.getTitle());
        dto.setUrlCover(entity.getUrlCover());
        dto.setDuration(entity.getDuration());
        dto.setRelease_date(entity.getRelease_date());
        
        if (entity.getArtist() != null) {
            dto.setArtist(ArtistResponseDTO.fromEntity(entity.getArtist()));
        }
        
        if (entity.getSongs() != null) {
            dto.setSongs(
                entity.getSongs().stream()          
                    .map(SongInsideAlbumDTO::fromEntity)   
                    .collect(Collectors.toList())     
            );
        }
        
        return dto;
    }
}
