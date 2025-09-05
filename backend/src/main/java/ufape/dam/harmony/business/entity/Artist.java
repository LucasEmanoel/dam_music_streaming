package ufape.dam.harmony.business.entity;

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
import lombok.Data;

@Data
@Entity
public class Artist {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
	
//	private String name;
//    private String pictureUrl;
	
	private int IdDeezer;
	private String name;
	private String picture;
	private String pictureSmall;
	private String pictureMedium;
	private String pictureBig;
	private String pictureXl;
	
	@Column(columnDefinition = "boolean")
	private boolean radio;
	private String tracklist;
	private String type;
    
	@ManyToOne
	private Genre genre;
    
    @OneToMany(mappedBy = "artist", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Album> albums;
    
    @OneToMany(mappedBy = "artist", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Song> songs;
}
