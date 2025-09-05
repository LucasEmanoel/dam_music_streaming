package ufape.dam.harmony.business.entity;

import java.time.Duration;
import java.util.Date;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Transient;
import lombok.Data;

@Data
@Entity
public class Album {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
//	private String title;
//	private String urlCover;
    
//	private Duration duration; // The album's duration (seconds)
//	private Date release_date; //The album's release date
	
	private int idDeezer;
	private String title;
	private String link;
	private String cover;
	private String coverSmall;
	private String coverMedium;
	private String coverBig;
	private String coverXl;
	@Column(name = "md5_image")
	private String md5Image;
	private int genreDeezerId;
	private int fans;
	private String releasedDate;
	private String recordType;
	private String tracklist;
	private String explicitLyrics;
	private String type;
	
	@ManyToOne
	private Genre genre;
	
	@ManyToOne
	private Artist artist;

	@OneToMany(mappedBy = "album", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<Song> songs;
	
	@Transient
	public int getNumSongs() {
		return this.songs.size();
	}
	
	@Transient
	public Duration getDuration() {
		if(this.songs.size() == 0) {
			return Duration.ZERO;
		}
		
		Duration playlist = Duration.ZERO;
		
		for (Song song : this.songs) {
			Duration songDuration = Duration.ofSeconds(song.getDuration());
			playlist = playlist.plus(songDuration);
		}
		
		return playlist;
	}
}
