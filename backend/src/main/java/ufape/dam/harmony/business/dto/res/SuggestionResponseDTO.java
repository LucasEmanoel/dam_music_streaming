package ufape.dam.harmony.business.dto.res;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import lombok.Data;
import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Song;

@Data
public class SuggestionResponseDTO {
	private List<PlaylistResponseDTO> playlists;
    private List<SongResponseDTO> songs;
    
    public static SuggestionResponseDTO fromEntity(List<Playlist> playlists, List<Song> songs) {
        SuggestionResponseDTO dto = new SuggestionResponseDTO();

        if (playlists != null) {
            dto.setPlaylists(playlists.stream()
                .map(p -> PlaylistResponseDTO.fromEntity(p, p.getSongs()))
                .collect(Collectors.toList()));
        }

        if (songs != null) {
            dto.setSongs(songs.stream()
                .map(s -> SongResponseDTO.fromEntity(s))
                .collect(Collectors.toList()));
        }

        return dto;
    }
    
}
