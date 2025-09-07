package ufape.dam.harmony.business.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import org.checkerframework.checker.units.qual.K;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.EntityNotFoundException;
import ufape.dam.harmony.business.dto.reqs.PlaylistRequestDTO;
import ufape.dam.harmony.business.dto.res.PlaylistResponseDTO;
import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.business.entity.Usuario;
import ufape.dam.harmony.business.entity.Weather;
import ufape.dam.harmony.business.entity.WeatherMapGenre;
import ufape.dam.harmony.data.PlaylistRepository;
import ufape.dam.harmony.data.SongRepository;
import ufape.dam.harmony.security.SecurityUser;

@Service
public class PlaylistService {

	@Autowired
	private PlaylistRepository playlistRepository;

	@Autowired
	private SongRepository songRepository;
	
	@Autowired
	private WeatherMapGenre weatherMapGenre;

	@Transactional
	public PlaylistResponseDTO createPlaylist(PlaylistRequestDTO request, SecurityUser user) {
		Usuario userEntity = user.getUsuario();
		Playlist newPlaylist = PlaylistRequestDTO.toEntity(request, userEntity); 
		Playlist savedPlaylist = playlistRepository.save(newPlaylist);

		return PlaylistResponseDTO.fromEntity(savedPlaylist, Set.of());
	}


	@Transactional(readOnly = true)
	public List<PlaylistResponseDTO> listPlaylistsByUser(SecurityUser user) {
		Usuario userEntity = user.getUsuario();
		List<Playlist> playlists = playlistRepository.findByAuthorId(userEntity.getId());
		
		return playlists.stream()
			.map(playlist -> PlaylistResponseDTO.fromEntity(playlist, null))
			.collect(Collectors.toList());
	}

	@Transactional
	public PlaylistResponseDTO updatePlaylist(Long playlistId, PlaylistRequestDTO request, SecurityUser user) {
		Usuario userEntity = user.getUsuario();
		Playlist playlist = findPlaylistByIdAndEnsureOwnership(playlistId, userEntity);

		playlist.setTitle(request.getTitle());
		playlist.setDescription(request.getDescription());
		playlist.setUrlCover(request.getUrlCover());

		Playlist updatedPlaylist = playlistRepository.save(playlist);

		return PlaylistResponseDTO.fromEntity(updatedPlaylist, updatedPlaylist.getSongs());
	}


	@Transactional
	public void deletePlaylist(Long playlistId, SecurityUser user) {
		Usuario userEntity = user.getUsuario();
		Playlist playlist = findPlaylistByIdAndEnsureOwnership(playlistId, userEntity);
		playlistRepository.delete(playlist);
	}
	



	

	private Playlist findPlaylistByIdAndEnsureOwnership(Long playlistId, Usuario user) {
		Playlist playlist = playlistRepository.findById(playlistId)
				.orElseThrow(() -> new EntityNotFoundException("Playlist não encontrada com o ID: " + playlistId));
		
		if (!Objects.equals(playlist.getAuthor().getId(), user.getId())) {
			throw new SecurityException("Acesso negado: você não é o proprietário desta playlist.");
		}
		return playlist;
	}

	@Transactional(readOnly = true)
    public PlaylistResponseDTO findPlaylistByIdWithSongs(Long id) {

        Playlist playlist = playlistRepository.findByIdWithSongs(id)
				.orElseThrow(() -> new EntityNotFoundException("Playlist não encontrada com o ID: " + id));
		
		return PlaylistResponseDTO.fromEntity(playlist, playlist.getSongs());
    }

	@Transactional
	public PlaylistResponseDTO addSongsToPlaylist(SecurityUser user, Long playlistId, List<Long> songIds) {
		Playlist playlist = findPlaylistByIdAndEnsureOwnership(playlistId, user.getUsuario());
		
		List<Song> songsToAdd = songRepository.findAllById(songIds);
		Set<Song> currentSongs = playlist.getSongs();
		currentSongs.addAll(songsToAdd);
		playlist.setSongs(currentSongs);
		
		
		Playlist updatedPlaylist = playlistRepository.save(playlist);
		return PlaylistResponseDTO.fromEntity(updatedPlaylist, updatedPlaylist.getSongs());
	}
	
	@Transactional
	public void removeSongFromPlaylist(Long playlistId, Long songId, SecurityUser user) {
		Usuario userEntity = user.getUsuario();
		Playlist playlist = findPlaylistByIdAndEnsureOwnership(playlistId, userEntity);
		
		Song song = songRepository.findById(songId)
			.orElseThrow(() -> new EntityNotFoundException("Música não encontrada com o ID: " + songId));
		
		playlist.getSongs().remove(song);
		playlistRepository.save(playlist);
		
	}
	
	@Transactional
	public List<PlaylistResponseDTO> getPlaylistsByWeather(Weather weather){
		// a ideia aqui é fazer uma media de bpm e gain da playlist
		// falta essa informacao nas entities
		Set<String> preferredGenres = weatherMapGenre.mapWeatherGenre.get(weather); //ficou muito verboso mas quero deixar fora mesmo
		System.out.println(preferredGenres.toString());
		List<Playlist> playlists = playlistRepository.findAll();
		Map<Playlist, Long> filteredPlaylists = new HashMap<Playlist, Long>(); // a contagem de generos de frio/calor a cada playlist
		
		for(Playlist p : playlists) {
			long genCount = 0;
			System.out.println(p.getTitle());
			for (Song s : p.getSongs()) {
				
				if(preferredGenres.contains(s.getGenre().getName())) { 
					genCount++;
				}
				
				if (genCount > 0) {
					filteredPlaylists.put(p, genCount);
				}
			}
			
			System.out.println(p.getDescription());
			System.out.println(genCount);
		}
		
        List<Map.Entry<Playlist, Long>> sortedEntries = new ArrayList<>(filteredPlaylists.entrySet());		
        Collections.sort(sortedEntries, (entry1, entry2) -> Long.compare(entry2.getValue(), entry1.getValue()));
        
        List<PlaylistResponseDTO> result = new ArrayList<>();
        System.out.println(result);
        for (Map.Entry<Playlist, Long> entry : sortedEntries) {
            result.add(PlaylistResponseDTO.fromEntity(entry.getKey(), null));
        }
        
        return result;
        
        
	}	
	


}