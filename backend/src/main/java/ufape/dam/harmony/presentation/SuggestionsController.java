package ufape.dam.harmony.presentation;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.geo.Point;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import ufape.dam.harmony.business.dto.res.PlaylistResponseDTO;
import ufape.dam.harmony.business.entity.Weather;
import ufape.dam.harmony.business.service.PlaylistService;
import ufape.dam.harmony.security.SecurityUser;

@RestController
@RequestMapping("/suggestions")
public class SuggestionsController {
	
	@Autowired
	public PlaylistService service;
	
	@GetMapping
	public ResponseEntity<List<PlaylistResponseDTO>> getSuggestionsByWeather(@AuthenticationPrincipal SecurityUser user, @RequestParam String weather) { //@AuthenticationPrincipal SecurityUser user, aqui nao vou usar auth
		// oq vou fazer
		// 1. receber um clima, tipo frio/calor
		// 2. pegar uma lista de playlists que tenham: media de bpm/ganho altos - simboliza uma playlist animada
		// 3. pegar umas 10 musicas com muitos bpm tbm, só nao sei se vou agrupar pelo genero
		
		
		List<PlaylistResponseDTO> userPlaylists = service.getPlaylistsByWeather(Weather.valueOf(weather)); //depois faco um dto caso seja mais complexo a comunicacao
		
		
		return ResponseEntity.ok(userPlaylists);
	}
	
}
