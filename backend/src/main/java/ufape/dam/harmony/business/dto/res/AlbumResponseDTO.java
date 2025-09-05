package ufape.dam.harmony.business.dto.res;

import java.time.Duration;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Artist;
import ufape.dam.harmony.business.entity.Song;

@Data
public class AlbumResponseDTO {
    private Long id;
    private String title;
    @JsonProperty("url_cover")
    private String urlCover;
    private Duration duration; // segundos
    @JsonProperty("release_date")
    private String releaseDate;
    
    private ArtistInsideAlbumDTO artist;
    private Set<SongInsideAlbumDTO> songs;

	
	public static AlbumResponseDTO fromEntity(Album entity, List<Song> songs) {
        if (entity == null) return null;
        
        AlbumResponseDTO dto = new AlbumResponseDTO();
        
        dto.setId(entity.getId());
        dto.setTitle(entity.getTitle());
        dto.setUrlCover(entity.getCoverMedium());
        dto.setReleaseDate(entity.getReleasedDate());
        
        int totalDurationInSeconds = 0;
        if (songs != null && !songs.isEmpty()) {
            dto.setSongs(
                songs.stream()
                    .map(SongInsideAlbumDTO::fromEntity) 
                    .collect(Collectors.toSet())        
            );
            
            totalDurationInSeconds = songs.stream()
                                           .mapToInt(Song::getDuration)
                                           .sum();                     
        }
        dto.setDuration(Duration.ofSeconds(totalDurationInSeconds));
        
        
        if (entity.getArtist() != null) {
            dto.setArtist(ArtistInsideAlbumDTO.fromEntity(entity.getArtist()));
        }
        
        return dto;
    }
	
	@Data
	public static class ArtistInsideAlbumDTO {
		private Long id;
	    private String name;
	    @JsonProperty("picture_url")
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
	    @JsonProperty("md5_image")
	    private String md5Image;

	    public static SongInsideAlbumDTO fromEntity(Song entity) {
	        if (entity == null) return null;
	        SongInsideAlbumDTO dto = new SongInsideAlbumDTO();
	        dto.setId(entity.getId());
	        dto.setTitle(entity.getTitle());
	        dto.setMd5Image(entity.getMd5Image());
	        dto.setDuration(Duration.ofSeconds(entity.getDuration()));
	        return dto;
	    }
	}

}
