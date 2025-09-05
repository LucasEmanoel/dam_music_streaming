package ufape.dam.harmony.business.dto.res;

import java.time.Duration;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import lombok.Data;
import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Artist;
import ufape.dam.harmony.business.entity.Song;

@Data
public class AlbumResponseDTO {
    private Long id;
    private String title;
    private String urlCover;
    private Duration duration;
    private String release_date;
    
    private ArtistInsideAlbumDTO artist;
    private List<SongInsideAlbumDTO> songs;

	
	public static AlbumResponseDTO fromEntity(Album entity) {
        if (entity == null) return null;
        
        AlbumResponseDTO dto = new AlbumResponseDTO();
        
        dto.setId(entity.getId());
        dto.setTitle(entity.getTitle());
        dto.setUrlCover(entity.getCoverMedium());
        dto.setDuration(entity.getDuration());
        dto.setRelease_date(entity.getReleasedDate());
        
        if (entity.getArtist() != null) {
            dto.setArtist(ArtistInsideAlbumDTO.fromEntity(entity.getArtist()));
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
	
	@Data
	public static class ArtistInsideAlbumDTO {
		private Long id;
	    private String name;
	    private String pictureUrl;

	    public static ArtistInsideAlbumDTO fromEntity(Artist entity) {
	        if (entity == null) return null;
	        ArtistInsideAlbumDTO dto = new ArtistInsideAlbumDTO();
	        dto.setId(entity.getId());
	        dto.setName(entity.getName());
	        dto.setPictureUrl(entity.getPictureMedium());
	        return dto;
	    }
	}
	
	@Data
	public static class SongInsideAlbumDTO {
		private Long id;
	    private String title;
	    private Duration duration;

	    public static SongInsideAlbumDTO fromEntity(Song entity) {
	        if (entity == null) return null;
	        SongInsideAlbumDTO dto = new SongInsideAlbumDTO();
	        dto.setId(entity.getId());
	        dto.setTitle(entity.getTitle());
	        dto.setDuration(Duration.ofSeconds(entity.getDuration()));
	        return dto;
	    }
	}

}
