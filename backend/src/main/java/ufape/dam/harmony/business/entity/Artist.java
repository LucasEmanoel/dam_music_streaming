package ufape.dam.harmony.business.entity;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import lombok.Data;

@Data
@Entity
public class Artist {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
	
	@Column(name = "id_deezer")
	private Long IdDeezer;
	private String name;
	private String picture;
	@Column(name = "picture_small")
	private String pictureSmall;
	@Column(name = "picture_medium")
	private String pictureMedium;
	@Column(name = "picture_big")
	private String pictureBig;
	@Column(name = "picture_xl")
	private String pictureXl;
	
	@Column(columnDefinition = "boolean")
	private boolean radio;
	private String tracklist;
	private String type;
    
	@ManyToOne
	@JoinColumn(name = "genre_id")
	private Genre genre;
    
//    @OneToMany(mappedBy = "artist", cascade = CascadeType.ALL, orphanRemoval = true)
//    private List<Album> albums;
//    
    @OneToMany(mappedBy = "artist", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Song> songs;
}
