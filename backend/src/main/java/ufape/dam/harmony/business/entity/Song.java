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
	@Column(name = "id_deezer")
	private Long idDeezer;
	private boolean readable;
	private String title;
	@Column(name = "title_short")
	private String titleShort;
	@Column(name = "title_version")
	private String titleVersion;
	private String isrc;
	private String link;
	private Integer duration;
	@Column(name = "track_position")
	private Integer trackPosition;
	@Column(name = "disk_number")
	private int diskNumber;
	private int rank;
	@Column(name = "explicit_lyrics")
	private boolean explicitLyrics;
	@Column(name = "explicit_content_lyrics")
	private Integer explicitContentLyrics;
	@Column(name = "explicit_content_cover")
	private Integer explicitContentCover;
	@Column(columnDefinition = "text")
	private String preview;
	@Column(name = "md5_image")
	private String md5Image;
	private String type;
	@Column(name = "download_url")
	private String downloadUrl;
	
//	@ManyToOne(fetch = FetchType.LAZY)
	@ManyToOne
	@JoinColumn(name = "genre_id")
	private Genre genre;
	
//    @ManyToOne(fetch = FetchType.LAZY)
	@ManyToOne
	@JoinColumn(name = "artist_id")
    private Artist artist;
    
//    @ManyToOne(fetch = FetchType.LAZY)
	@ManyToOne
	@JoinColumn(name = "album_id")
	private Album album;
	
	
}
