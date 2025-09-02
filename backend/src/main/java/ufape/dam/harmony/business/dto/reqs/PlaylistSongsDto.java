package ufape.dam.harmony.business.dto.reqs;

import java.util.List;

import lombok.Data;

@Data
public class PlaylistSongsDto {
	private List<Long> songIds;
}
