package ufape.dam.harmony.business.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Data;

@Data
@Entity
public class Album {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;
	@Column(name = "id_deezer")
	private Long idDeezer;
	private String title;
	private String link;
	private String cover;
	@Column(name = "cover_small")
	private String coverSmall;
	@Column(name = "cover_medium")
	private String coverMedium;
	@Column(name = "cover_big")
	private String coverBig;
	@Column(name = "cover_xl")
	private String coverXl;
	@Column(name = "md5_image")
	private String md5Image;
	@Column(name="genre_deezer_id")
	private Integer DeezerId;
	private Integer fans;
	@Column(name = "release_date")
	private String releasedDate;
	@Column(name = "record_type")
	private String recordType;
	private String tracklist;
	@Column(name = "explicit_lyrics")
	private boolean explicitLyrics;
	private String type;
	
	@ManyToOne
	@JoinColumn(name = "genre_id")
	private Genre genre;
	
	@ManyToOne
	@JoinColumn(name = "artist_id")
	private Artist artist;
//	@OneToMany(mappedBy = "album", cascade = CascadeType.ALL, orphanRemoval = true)
//	private List<Song> songs;
//	
//	@Transient
//	public int getNumSongs() {
//		return this.songs.size();
//	}
//	
//	@Transient
//	public Duration getDuration() {
//		if(this.songs.size() == 0) {
//			return Duration.ZERO;
//		}
//		
//		Duration playlist = Duration.ZERO;
//		
//		for (Song song : this.songs) {
//			Duration songDuration = Duration.ofSeconds(song.getDuration());
//			playlist = playlist.plus(songDuration);
//		}
//		
//		return playlist;
//	}
}
