package ufape.dam.harmony.business.entity;

import java.util.Map;
import java.util.Set;

import org.springframework.stereotype.Component;

@Component
public class WeatherMapGenre {
	
	public final Map<Weather, Set<String>> mapWeatherGenre = Map.of(
			Weather.CLEAR, Set.of("pop", "dance", "reggae"),
			Weather.CLOUDS, Set.of("rock", "indie", "alternative"),
			Weather.SNOW, Set.of("classical", "ambient"),
			Weather.RAIN, Set.of("mpb", "jazz", "blues"),
			Weather.DRIZZLE, Set.of("acoustic", "lofi"),
			Weather.THUNDERSTORM, Set.of("metal", "drum_and_bass", "industrial")
	);
		
	private WeatherMapGenre() {}
}
