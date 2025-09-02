package ufape.dam.harmony.business.dto.res;

import lombok.Data;
import ufape.dam.harmony.business.entity.Artist;

@Data
public class ArtistResponseDTO {
	private Long id;
    private String name;
    private String pictureUrl;
    
    public static ArtistResponseDTO fromEntity(Artist entity) {
        ArtistResponseDTO dto = new ArtistResponseDTO();
        
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setPictureUrl(entity.getPictureUrl());
        
        return dto;
    }
}
