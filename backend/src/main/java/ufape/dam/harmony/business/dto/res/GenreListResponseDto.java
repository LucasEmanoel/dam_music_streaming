package ufape.dam.harmony.business.dto.res;

import java.util.List;
import java.util.stream.Collectors;

import lombok.Data;
import ufape.dam.harmony.business.dto.res.ArtistResponseDTO.AlbumInArtistResponseDTO;
import ufape.dam.harmony.business.dto.res.ArtistResponseDTO.SongInArtistResponseDTO;
import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Artist;
import ufape.dam.harmony.business.entity.Genre;

@Data
public class GenreListResponseDto {
    private Long id;
    private String name;
	
    public static GenreListResponseDto fromEntity(Genre entity) {
        if (entity == null) return null;
        var dto = new GenreListResponseDto();
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        return dto;
    }

}
