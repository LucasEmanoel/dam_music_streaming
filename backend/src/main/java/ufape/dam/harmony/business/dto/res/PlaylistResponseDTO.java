package ufape.dam.harmony.business.dto.res;

import java.time.Duration;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import lombok.Data;
import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Song;

@Data
public class PlaylistResponseDTO {
	private Long id;
    private String title;
    private String description;
    private String urlCover;
    
    private UserResponseDTO author;
    private Set<SongInPlaylistResponseDTO> songs = new HashSet<>();
    
    private Integer numSongs;
    private Duration duration;
    

    public static PlaylistResponseDTO fromEntity(Playlist entity) {
        if (entity == null) return null;
        
        PlaylistResponseDTO dto = new PlaylistResponseDTO();
        
        dto.setId(entity.getId());
        dto.setTitle(entity.getTitle());
        dto.setDescription(entity.getDescription());
        dto.setUrlCover(entity.getUrlCover());
        dto.setNumSongs(entity.getNumSongs());
        dto.setDuration(entity.getDuration());

        if (entity.getAuthor() != null) {
            dto.setAuthor(UserResponseDTO.fromEntity(entity.getAuthor()));
        }
        
        if (entity.getSongs() != null) {
            dto.setSongs(
                entity.getSongs().stream()
                    .map(SongInPlaylistResponseDTO::fromEntity) 
                    .collect(Collectors.toSet())
            );
        }

        return dto;
    }
    
    @Data
    public static class SongInPlaylistResponseDTO {
        private Long id;
        private String title;
        private Duration duration;

        public static SongInPlaylistResponseDTO fromEntity(Song entity) {
            if (entity == null) return null;
            var dto = new SongInPlaylistResponseDTO();
            dto.setId(entity.getId());
            dto.setTitle(entity.getTitle());
            dto.setDuration(entity.getDuration());

            return dto;
        }
    }
    
}
