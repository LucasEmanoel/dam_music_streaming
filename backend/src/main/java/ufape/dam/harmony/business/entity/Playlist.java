package ufape.dam.harmony.business.entity;



import java.time.Duration;
import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Transient;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Data
public class Playlist {
	
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
	
	private String title;
	private String description;
	private String urlCover;
	
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "author_id")
	private Usuario author;
	
	@ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "playlist_songs", 
        joinColumns = @JoinColumn(name = "playlist_id"), 
        inverseJoinColumns = @JoinColumn(name = "song_id")
    )
    private Set<Song> songs = new HashSet<>();

	
	@Transient
    public Integer getNumSongs() {
        return this.songs.size();
    }
	
	@Transient
	public Duration getDuration() {
		if(this.songs.size() == 0) {
			return Duration.ZERO;
		}
		
		Duration playlist = Duration.ZERO;
		
		for (Song song : this.songs) {
			playlist = playlist.plus(song.getDuration());
		}
		
		return playlist;
	}

}
