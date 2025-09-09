package ufape.dam.harmony.business.entity;

import java.util.Map;
import java.util.Set;

import org.springframework.stereotype.Component;

@Component
public class WeatherMapGenre {
	
	public final Map<Weather, Set<String>> mapWeatherGenre = Map.of(
			Weather.CLEAR, Set.of("pop", "alt"),
			Weather.CLOUDS, Set.of("pop", "alt"),
			
			Weather.SNOW, Set.of("classical", "ambient"), //vou deixar de exemplo mas nunca vai cair mesmo
			
			Weather.RAIN, Set.of("rock", "mpb", "rAndb"),
			Weather.DRIZZLE, Set.of("rock", "mpb", "lofi"),
			Weather.THUNDERSTORM, Set.of("rock", "metal")
	);
		
	private WeatherMapGenre() {}
}
