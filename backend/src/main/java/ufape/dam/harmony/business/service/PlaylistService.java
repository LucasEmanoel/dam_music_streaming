package ufape.dam.harmony.business.service;

import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.EntityNotFoundException;
import ufape.dam.harmony.business.dto.reqs.PlaylistRequestDTO;
import ufape.dam.harmony.business.dto.res.PlaylistResponseDTO;
import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.business.entity.Usuario;
import ufape.dam.harmony.data.PlaylistRepository;
import ufape.dam.harmony.data.SongRepository;
import ufape.dam.harmony.security.SecurityUser;

@Service
public class PlaylistService {

	@Autowired
	private PlaylistRepository playlistRepository;

	@Autowired
	private SongRepository songRepository;

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
	
	


}