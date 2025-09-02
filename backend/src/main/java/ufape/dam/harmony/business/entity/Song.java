package ufape.dam.harmony.business.entity;

import java.time.Duration;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import lombok.Data;

@Entity
@Data
public class Song {
	
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

	private String title;
    private Duration duration; // The track's duration in seconds
    private Double bpm; //Beats per minute
    private Double gain; //Signal strength
    
    @ManyToOne(fetch = FetchType.LAZY)
	private Album album;
	
    @ManyToOne(fetch = FetchType.LAZY)
    private Artist artist;
    
}
