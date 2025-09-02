package ufape.dam.harmony.business.dto.res;

import java.time.Duration;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import ufape.dam.harmony.business.entity.Song;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class SongResponseDTO {

    private Long id;
    private String title;
    private Duration duration; 
    
    private ArtistResponseDTO artist;
    private AlbumResponseDTO album;


    @JsonProperty("md5_image")
    private String md5Image;
    
    
    public static SongResponseDTO fromEntity(Song entity) {
    	SongResponseDTO dto = new SongResponseDTO();
        
    	dto.setId(entity.getId());
        dto.setTitle(entity.getTitle());
        dto.setDuration(entity.getDuration());
        dto.setArtist(ArtistResponseDTO.fromEntity(entity.getArtist()));
        dto.setAlbum(AlbumResponseDTO.fromEntity(entity.getAlbum()));
        //dto.setEmail(entity.getEmail());
        //dto.setRole(entity.getRole());
        
        return dto;
    }

}

