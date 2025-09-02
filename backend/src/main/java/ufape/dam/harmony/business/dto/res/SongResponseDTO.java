package ufape.dam.harmony.business.dto.res;

import java.time.Duration;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Artist;
import ufape.dam.harmony.business.entity.Song;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class SongResponseDTO {

    private Long id;
    private String title;
    private Duration duration; 
    
    private ArtistInSongResponseDTO artist;
    private AlbumInSongResponseDTO album;


    @JsonProperty("md5_image")
    private String md5Image;
    
    
    public static SongResponseDTO fromEntity(Song entity) {
    	SongResponseDTO dto = new SongResponseDTO();
        
    	dto.setId(entity.getId());
        dto.setTitle(entity.getTitle());
        dto.setDuration(entity.getDuration());
        dto.setArtist(ArtistInSongResponseDTO.fromEntity(entity.getArtist()));
        dto.setAlbum(AlbumInSongResponseDTO.fromEntity(entity.getAlbum()));
        
        return dto;
    }

    @Data
    public static class ArtistInSongResponseDTO {
        private Long id;
        private String name;
        private String pictureUrl;

        public static ArtistInSongResponseDTO fromEntity(Artist entity) {
            if (entity == null) return null;
            var dto = new ArtistInSongResponseDTO();
            dto.setId(entity.getId());
            dto.setName(entity.getName());
            dto.setPictureUrl(entity.getPictureUrl());
            return dto;
        }
    }

    @Data
    public static class AlbumInSongResponseDTO {
        private Long id;
        private String title;
        private String urlCover;
        
        public static AlbumInSongResponseDTO fromEntity(Album entity) {
            if (entity == null) return null;
            var dto = new AlbumInSongResponseDTO();
            dto.setId(entity.getId());
            dto.setTitle(entity.getTitle());
            dto.setUrlCover(entity.getUrlCover());
            return dto;
        }
    }
}

