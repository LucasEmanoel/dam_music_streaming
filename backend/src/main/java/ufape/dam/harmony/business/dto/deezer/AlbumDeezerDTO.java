package ufape.dam.harmony.business.dto.deezer;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class AlbumDeezerDTO {

	private Long id;
	private String title;
	private String cover_big;
	private int nb_tracks;
	private int duration;
	private Date release_date;
	
	
	
	
}
