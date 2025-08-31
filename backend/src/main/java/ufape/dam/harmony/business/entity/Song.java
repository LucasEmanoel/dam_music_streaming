package ufape.dam.harmony.business.entity;

import java.time.Duration;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Entity
@Data
public class Song {
	
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
	
	@Column(nullable = false)
    private String apiId; // The track's Deezer id
	private String title;
	
    private Duration duration; // The track's duration in seconds
    private Double bpm; //Beats per minute
    private Double gain; //Signal strength
    
	private Long albumApiId;
	private Long artistApiId;
    
	//@ManyToOne
	//private Album album;
}
