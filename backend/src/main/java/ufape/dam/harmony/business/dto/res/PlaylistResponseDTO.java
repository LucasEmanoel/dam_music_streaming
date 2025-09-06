package ufape.dam.harmony.business.dto.res;

import java.time.Duration;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Artist;
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
       
        private AlbumInSongPlaylistResponseDTO album;
        private ArtistInSongPlaylistResponseDTO artist;
        
        public static SongInPlaylistResponseDTO fromEntity(Song entity) {
            if (entity == null) return null;
            
            var dto = new SongInPlaylistResponseDTO();
            
            dto.setId(entity.getId());
            dto.setTitle(entity.getTitle());
            dto.setAlbum(AlbumInSongPlaylistResponseDTO.fromEntity(entity.getAlbum()));
            dto.setArtist(ArtistInSongPlaylistResponseDTO.fromEntity(entity.getArtist()));
            dto.setDuration(Duration.ofSeconds(entity.getDuration()));

            return dto;
        }
    }
    
    @Data
    public static class AlbumInSongPlaylistResponseDTO {
        private Long id;
        private String title;
        @JsonProperty("url_cover")
    	private String coverMedium;
        
        public static AlbumInSongPlaylistResponseDTO fromEntity(Album entity) {
            if (entity == null) return null;
            var dto = new AlbumInSongPlaylistResponseDTO();
            dto.setId(entity.getId());
            dto.setCoverMedium(entity.getCoverMedium());
            dto.setTitle(entity.getTitle());

            return dto;
        }
    }
    
    @Data
    public static class ArtistInSongPlaylistResponseDTO {
        private Long id;
        private String name;
        
        public static ArtistInSongPlaylistResponseDTO fromEntity(Artist entity) {
            if (entity == null) return null;
            var dto = new ArtistInSongPlaylistResponseDTO();
            dto.setId(entity.getId());
            dto.setName(entity.getName());

            return dto;
        }
    }
    
}
