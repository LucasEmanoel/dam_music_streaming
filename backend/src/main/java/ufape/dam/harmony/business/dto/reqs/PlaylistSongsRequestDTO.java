package ufape.dam.harmony.business.dto.reqs;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class PlaylistSongsRequestDTO {
	@JsonProperty("songs_ids")
	private List<Long> songIds;
}
