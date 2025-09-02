package ufape.dam.harmony.business.entity;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.Data;

@Data
@Entity
public class Artist {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
	
	private String name;
    private String pictureUrl;
    
    @OneToMany(mappedBy = "artist", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Album> albums;
    
    @OneToMany(mappedBy = "artist", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Song> songs;
    
}
