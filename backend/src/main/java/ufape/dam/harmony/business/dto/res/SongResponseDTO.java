package ufape.dam.harmony.business.dto.res;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SongResponseDTO {

    private Long id;
    private Long apiId;
    private String title;
    private String artist;


    private Long artistApiId;

    @JsonProperty("md5_image")
    private String md5Image;
}
