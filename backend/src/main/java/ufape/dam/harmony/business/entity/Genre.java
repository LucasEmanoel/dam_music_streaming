package ufape.dam.harmony.business.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Entity
@Data
public class Genre {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
	
	@Column(name = "id_deezer")
	private Long idDeezer;
	private String name;
	
//    @OneToMany(mappedBy = "genre", cascade = CascadeType.ALL, orphanRemoval = true)
//    private List<Artist> artists;
//	
//    @OneToMany(mappedBy = "genre", cascade = CascadeType.ALL, orphanRemoval = true)
//    private List<Album> albums;
//	
//	@OneToMany(mappedBy = "genre", cascade = CascadeType.ALL, orphanRemoval = true)
//	private List<Song> songs;
}
