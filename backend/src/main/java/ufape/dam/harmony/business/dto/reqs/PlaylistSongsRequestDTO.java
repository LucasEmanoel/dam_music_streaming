package ufape.dam.harmony.business.dto.reqs;

import java.util.List;

import lombok.Data;

@Data
public class PlaylistSongsRequestDTO {
	private List<Long> songIds;
}
