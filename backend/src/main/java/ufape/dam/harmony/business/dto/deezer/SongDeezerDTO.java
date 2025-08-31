package ufape.dam.harmony.business.dto.deezer;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class SongDeezerDTO {
	private Long id;
    private String title;
    private int duration;
    private float bpm;
    private float gain;
    
    @JsonProperty("md5_image")
    private String md5Image;
    
    private ArtistDeezerDTO artist;
    private AlbumDeezerDTO album;
}
