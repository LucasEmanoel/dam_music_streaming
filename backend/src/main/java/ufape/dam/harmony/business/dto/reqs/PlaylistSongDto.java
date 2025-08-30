package ufape.dam.harmony.business.dto.reqs;

import java.time.Duration;

import lombok.Data;

@Data
public class PlaylistSongDto {
	private String apiId;
    private Duration duration;
}
