package ufape.dam.harmony.business.dto.res;

import java.time.Duration;

import lombok.Data;
import ufape.dam.harmony.business.entity.Song;

@Data
public class SongInsideAlbumDTO {
	private Long id;
    private String title;
    private Duration duration;

    public static SongInsideAlbumDTO fromEntity(Song entity) {
        if (entity == null) return null;
        SongInsideAlbumDTO dto = new SongInsideAlbumDTO();
        dto.setId(entity.getId());
        dto.setTitle(entity.getTitle());
        dto.setDuration(Duration.ofSeconds(entity.getDuration()));
        return dto;
    }
}
