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
public class ArtistResponseDTO {
	private Long id;
    private String name;
    private String pictureUrl;
    
    private List<AlbumInArtistResponseDTO> albums;
    private List<SongInArtistResponseDTO> songs;
    
    public static ArtistResponseDTO fromEntity(Artist entity) {
        if (entity == null) return null;
        
        ArtistResponseDTO dto = new ArtistResponseDTO();
        
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setPictureUrl(entity.getPictureMedium());
        
        return dto;
    }
    
    public static ArtistResponseDTO fromEntityWithAlbums(Artist entity) {
        if (entity == null) return null;
        
        ArtistResponseDTO dto = new ArtistResponseDTO();
        
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setPictureUrl(entity.getPictureMedium());
        
	      if (entity.getAlbums() != null) {
		      dto.setAlbums(
		          entity.getAlbums().stream()
		              .map(AlbumInArtistResponseDTO::fromEntity)
		              .collect(Collectors.toList())
		      );
		  }
        
        return dto;
    }
    
    @Data
    public static class AlbumInArtistResponseDTO {
        private Long id;
        private String title;
        private String urlCover;
        private String release_date;

        public static AlbumInArtistResponseDTO fromEntity(Album entity) {
            if (entity == null) return null;
            var dto = new AlbumInArtistResponseDTO();
            dto.setId(entity.getId());
            dto.setTitle(entity.getTitle());
            dto.setUrlCover(entity.getCoverMedium());
            dto.setRelease_date(entity.getReleasedDate());
            return dto;
        }
    }

    @Data
    public static class SongInArtistResponseDTO {
        private Long id;
        private String title;
        private Duration duration;

        public static SongInArtistResponseDTO fromEntity(Song entity) {
            if (entity == null) return null;
            var dto = new SongInArtistResponseDTO();
            dto.setId(entity.getId());
            dto.setTitle(entity.getTitle());
            dto.setDuration(Duration.ofSeconds(entity.getDuration()));
            return dto;
        }
    }
}
