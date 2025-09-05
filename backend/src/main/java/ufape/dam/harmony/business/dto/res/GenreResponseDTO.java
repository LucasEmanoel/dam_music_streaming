package ufape.dam.harmony.business.dto.res;

import java.time.Duration;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Artist;
import ufape.dam.harmony.business.entity.Genre;
import ufape.dam.harmony.business.entity.Song;

@Data
public class GenreResponseDTO {
    private Long id;
	private String name;
	
	private List<ArtistInGenreResponseDTO> artists;
    private List<AlbumInGenreResponseDTO> albums;
    private List<SongInsideGenreDTO> songs;
    
	public static GenreResponseDTO fromEntity(Genre entity, List<Album> albums, List<Song> songs, List<Artist> artists) {
        if (entity == null) return null;
        
        GenreResponseDTO dto = new GenreResponseDTO();
        
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        
        if (artists != null) {
            dto.setArtists(artists.stream()
                .map(ArtistInGenreResponseDTO::fromEntity)
                .collect(Collectors.toList()));
        }
        
        if (albums != null) {
            dto.setAlbums(albums.stream()
                .map(AlbumInGenreResponseDTO::fromEntity)
                .collect(Collectors.toList()));
        }

        if (songs != null) {
            dto.setSongs(songs.stream()
                .map(SongInsideGenreDTO::fromEntity)
                .collect(Collectors.toList()));
        }
        
        return dto;
    }
	
    @Data
    public static class ArtistInGenreResponseDTO {
        private Long id;
        private String name;
        @JsonProperty("url_cover")
        private String urlCover; 

        public static ArtistInGenreResponseDTO fromEntity(Artist entity) {
            if (entity == null) return null;
            var dto = new ArtistInGenreResponseDTO();
            dto.setId(entity.getId());
            dto.setName(entity.getName());
            dto.setUrlCover(entity.getPictureMedium());
            return dto;
        }
    }
	
    @Data
    public static class AlbumInGenreResponseDTO {
        private Long id;
        private String title;
        @JsonProperty("url_cover")
        private String urlCover;
        @JsonProperty("release_date")
        private String releaseDate;

        public static AlbumInGenreResponseDTO fromEntity(Album entity) {
            if (entity == null) return null;
            var dto = new AlbumInGenreResponseDTO();
            dto.setId(entity.getId());
            dto.setTitle(entity.getTitle());
            dto.setUrlCover(entity.getCoverMedium());
            dto.setReleaseDate(entity.getReleasedDate());
            return dto;
        }
    }
	
	@Data
	public static class SongInsideGenreDTO {
		private Long id;
	    private String title;
	    private Duration duration;

	    public static SongInsideGenreDTO fromEntity(Song entity) {
	        if (entity == null) return null;
	        SongInsideGenreDTO dto = new SongInsideGenreDTO();
	        dto.setId(entity.getId());
	        dto.setTitle(entity.getTitle());
	        dto.setDuration(Duration.ofSeconds(entity.getDuration()));
	        return dto;
	    }
	}

}
