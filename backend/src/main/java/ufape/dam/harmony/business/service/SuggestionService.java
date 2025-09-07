package ufape.dam.harmony.business.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ufape.dam.harmony.business.dto.res.PlaylistResponseDTO;
import ufape.dam.harmony.business.dto.res.SongResponseDTO;
import ufape.dam.harmony.business.dto.res.SuggestionResponseDTO;
import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.business.entity.Weather;
import ufape.dam.harmony.business.entity.WeatherMapGenre;
import ufape.dam.harmony.data.PlaylistRepository;
import ufape.dam.harmony.data.SongRepository;

@Service
public class SuggestionService {

	@Autowired
	private PlaylistRepository playlistRepository;

	@Autowired
	private SongRepository songRepository;
	
	@Autowired
	private WeatherMapGenre weatherMapGenre;
	
	@Transactional
	public SuggestionResponseDTO getPlaylistsAndSongsByWeather(Weather weather) { // ficou muito verboso, vou refatorar
		// a ideia aqui é fazer uma media de bpm e gain da playlist
		// falta essa informacao nas entities
		Set<String> preferredGenres = weatherMapGenre.mapWeatherGenre.get(weather); 																		
		// System.out.println(preferredGenres.toString());
		// List<Playlist> playlists = playlistRepository.findAll();
		// Map<Playlist, Long> filteredPlaylists = new HashMap<Playlist, Long>(); // a
		// contagem de generos de frio/calor a cada playlist

		Pageable topPlaylists = PageRequest.of(0, 5);
		Pageable topSongs = PageRequest.of(0, 10);

		Page<Playlist> playlists = playlistRepository.findBySongsGenreName(preferredGenres, topPlaylists);
		Page<Song> songs = songRepository.findByGenreName(preferredGenres, topSongs);
		/*
		 * for(Playlist p : playlists) { long genCount = 0;
		 * System.out.println(p.getTitle()); for (Song s : p.getSongs()) {
		 * 
		 * if(preferredGenres.contains(s.getGenre().getName())) { genCount++; }
		 * 
		 * if (genCount > 0) { filteredPlaylists.put(p, genCount); } }
		 * 
		 * System.out.println(p.getDescription()); System.out.println(genCount); }
		 * 
		 * List<Map.Entry<Playlist, Long>> sortedEntries = new
		 * ArrayList<>(filteredPlaylists.entrySet()); Collections.sort(sortedEntries,
		 * (entry1, entry2) -> Long.compare(entry2.getValue(), entry1.getValue()));
		 * 
		 * List<PlaylistResponseDTO> result = new ArrayList<>();
		 */

		// for (Map.Entry<Playlist, Long> entry : sortedEntries) {
		// result.add(PlaylistResponseDTO.fromEntity(entry.getKey(), null));
		// }

		SuggestionResponseDTO result = SuggestionResponseDTO.fromEntity(playlists.getContent(), songs.getContent());
		
		return result;

	}
}
