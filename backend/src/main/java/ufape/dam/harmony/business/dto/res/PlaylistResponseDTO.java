package ufape.dam.harmony.business.dto.res;

import java.time.Duration;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.business.entity.Usuario;

@Data
public class PlaylistResponseDTO {
	private Long id;
    private String title;
    private String description;
    @JsonProperty("url_cover")
    private String urlCover;
    
    private AuthorInPlaylistResponseDTO author;
    private List<SongInPlaylistResponseDTO> songs;
    
    @JsonProperty("nb_songs")
    private Integer numSongs;
    private Duration duration;
    

    public static PlaylistResponseDTO fromEntity(Playlist entity, Set<Song> songs) {
        if (entity == null) return null;
        
        PlaylistResponseDTO dto = new PlaylistResponseDTO();
        
        dto.setId(entity.getId());
        dto.setTitle(entity.getTitle());
        dto.setDescription(entity.getDescription());
        dto.setUrlCover(entity.getUrlCover());
        dto.setNumSongs(entity.getNumSongs());
        dto.setDuration(entity.getDuration());

        if (entity.getAuthor() != null) {
            dto.setAuthor(AuthorInPlaylistResponseDTO.fromEntity(entity.getAuthor()));
        }
        
        if (songs != null) {
            dto.setSongs(
                songs.stream()
                    .map(SongInPlaylistResponseDTO::fromEntity)
                    .collect(Collectors.toList())
            );
        }


        return dto;
    }
    
    @Data
    public static class AuthorInPlaylistResponseDTO {
    	private Long id;
        private String username;
        
        public static AuthorInPlaylistResponseDTO fromEntity(Usuario entity) {
            if (entity == null) return null;
            var dto = new AuthorInPlaylistResponseDTO();
            
            dto.setId(entity.getId());
            dto.setUsername(entity.getUsername());

            return dto;
        }
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
            dto.setDuration(Duration.ofSeconds(entity.getDuration()));

            return dto;
        }
    }
    
}
