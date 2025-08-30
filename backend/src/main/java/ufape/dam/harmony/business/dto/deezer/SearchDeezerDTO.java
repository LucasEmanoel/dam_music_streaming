package ufape.dam.harmony.business.dto.deezer;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class SearchDeezerDTO {

	private List<SongDeezerDTO> data; 
    private int total;
}
