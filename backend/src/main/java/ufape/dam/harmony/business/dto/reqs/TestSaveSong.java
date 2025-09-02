package ufape.dam.harmony.business.dto.reqs;

import lombok.Data;

@Data
public class TestSaveSong {
    private Long id; 
    
    private String title;
    
    // É comum receber a duração em segundos (inteiro) de uma API
    private int duration; 
    
    private Double bpm;
    private Double gain;
    
    // IDs das entidades relacionadas que já devem existir no seu banco
    private Long albumId; 
    private Long artistId;
}
