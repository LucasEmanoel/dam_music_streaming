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
public class ArtistResponseDTO {
	private Long id;
    private String name;
    @JsonProperty("picture_url")
    private String pictureUrl;
    
    private List<AlbumInArtistResponseDTO> albums;
    private List<SongInArtistResponseDTO> songs;
    
    public static ArtistResponseDTO fromEntity(Artist entity, List<Album> albums, List<Song> songs) {
        if (entity == null) return null;
        
        ArtistResponseDTO dto = new ArtistResponseDTO();
        
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setPictureUrl(entity.getPictureMedium());

        if (albums != null) {
            dto.setAlbums(
                albums.stream()
                    .map(AlbumInArtistResponseDTO::fromEntity)
                    .collect(Collectors.toList())
            );
        }

        if (songs != null) {
            dto.setSongs(
                songs.stream()
                    .map(SongInArtistResponseDTO::fromEntity)
                    .collect(Collectors.toList())
            );
        }

        
        return dto;
    }
    
    @Data
    public static class AlbumInArtistResponseDTO {
        private Long id;
        private String title;
        @JsonProperty("url_cover")
        private String urlCover;
        @JsonProperty("release_date")
        private String releaseDate;

        public static AlbumInArtistResponseDTO fromEntity(Album entity) {
            if (entity == null) return null;
            var dto = new AlbumInArtistResponseDTO();
            dto.setId(entity.getId());
            dto.setTitle(entity.getTitle());
            dto.setUrlCover(entity.getCoverMedium());
            dto.setReleaseDate(entity.getReleasedDate());
            return dto;
        }
    }

    @Data
    public static class SongInArtistResponseDTO {
        private Long id;
        private String title;
        private Duration duration;
        private AlbumInSongResponseDTO album;

        public static SongInArtistResponseDTO fromEntity(Song entity) {
            if (entity == null) return null;
            var dto = new SongInArtistResponseDTO();
            dto.setId(entity.getId());
            dto.setAlbum(AlbumInSongResponseDTO.fromEntity(entity.getAlbum()));
            dto.setTitle(entity.getTitle());
            dto.setDuration(Duration.ofSeconds(entity.getDuration()));
            return dto;
        }
    }
    
    @Data
    public static class AlbumInSongResponseDTO {
        private Long id;
        @JsonProperty("url_cover")
        private String urlCover;

        public static AlbumInSongResponseDTO fromEntity(Album entity) {
            if (entity == null) return null;
            var dto = new AlbumInSongResponseDTO();
            dto.setId(entity.getId());
            dto.setUrlCover(entity.getCoverMedium());
            return dto;
        }
    }
}
