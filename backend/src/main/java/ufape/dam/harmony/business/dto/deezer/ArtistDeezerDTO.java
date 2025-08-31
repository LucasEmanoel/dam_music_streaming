package ufape.dam.harmony.business.dto.deezer;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class ArtistDeezerDTO {
	
	private int id;
	private String name;
    private String picture_big;	
}
