package ufape.dam.harmony.business.entity;

import java.time.Duration;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Data;

@Entity
@Data
public class Song {
	
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

//	private String title;
//    private Duration duration; // The track's duration in seconds
//    private Double bpm; //Beats per minute
//    private Double gain; //Signal strength
	
	private int idDeezer;
	private boolean readable;
	private String title;
	private String titleShort;
	private String titleVersion;
	private String isrc;
	private String link;
	private int duration;
	private int trackPosition;
	private int diskNumber;
	private int rank;
	private boolean explicitLyrics;
	private int explicitContentLyrics;
	private int explicitContentCover;
	@Column(columnDefinition = "text")
	private String preview;
	@Column(name = "md5_image")
	private String md5Image;
	private String type;
	private String downloadUrl;
	
//	@ManyToOne(fetch = FetchType.LAZY)
	@ManyToOne
	private Genre genre;
	
//    @ManyToOne(fetch = FetchType.LAZY)
	@ManyToOne
    private Artist artist;
    
//    @ManyToOne(fetch = FetchType.LAZY)
	@ManyToOne
	private Album album;
	
	
}
