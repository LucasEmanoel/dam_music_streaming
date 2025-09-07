package ufape.dam.harmony.business.service;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import ufape.dam.harmony.business.entity.Usuario;
import ufape.dam.harmony.data.UsuarioRepository;
import ufape.dam.harmony.security.SecurityUser;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;

import java.security.Key;
import java.util.Base64;
import java.util.Collections;
import java.util.Date;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class JwtService {

    private final UsuarioRepository usuarioRepository;
    
    @Value("${jwt.secret.key}")
    private String secretKey;

    private static final String WEB_CLIENT_ID =
            "940448057923-jbu82iq5eutmg54kfiphcgl9q8kfgrr5.apps.googleusercontent.com";

    private static final NetHttpTransport transport = new NetHttpTransport();
    private static final JacksonFactory jsonFactory = JacksonFactory.getDefaultInstance();

    @Value("${jwt.secret}")
    private String SECRET;
    private final long EXPIRATION = 1000L * 60 * 60 * 24 * 90; // 3 MESES

    @Value("${google.clientId}")
    private String googleClientId;

    public JwtService(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    private Key getSigningKey() {
        byte[] keyBytes = Base64.getDecoder().decode(SECRET);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public String generateToken(Authentication auth) {
    SecurityUser user = (SecurityUser) auth.getPrincipal();
    String role = user.getAuthorities().stream()
            .map(authority -> authority.getAuthority().replace("ROLE_", ""))
            .collect(Collectors.joining(","));

    return Jwts.builder()
            .setSubject(user.getUsername())
            .claim("fullName", user.getFullName())
            .claim("username", user.getRealUsername())
            .claim("email", user.getEmail())
            .claim("role", role)
            .claim("id", user.getId())
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION))
            .signWith(getSigningKey(), SignatureAlgorithm.HS256)
            .compact();
}


    public String extractUsername(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getSubject();
    }

    public boolean isValid(String token, UserDetails user) {
        String username = extractUsername(token);
        return username.equals(user.getUsername()) && !isExpired(token);
    }

    private boolean isExpired(String token) {
        Date exp = Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getExpiration();
        return exp.before(new Date());
    }

    public GoogleIdToken.Payload verifyToken(String idTokenString) {
        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(transport, jsonFactory)
                    .setAudience(Collections.singletonList(WEB_CLIENT_ID))
                    .setIssuer("https://accounts.google.com")
                    .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken == null) {
                return null;
            }
            return idToken.getPayload();
        } catch (Exception e) {
            return null;
        }
    }

    public String generateTokenFromEmail(String email) {
        Optional<Usuario> optionalUsuario = usuarioRepository.findByEmail(email);

        if (optionalUsuario.isEmpty()) {
            throw new UsernameNotFoundException("Usuário não encontrado com e-mail: " + email);
        }

        Usuario user = optionalUsuario.get();
        String role = user.getRole();

        return Jwts.builder()
                .setSubject(user.getUsername())
                .claim("fullName", user.getFullName())
                .claim("username", user.getUsername())
                .claim("email", user.getEmail())
                .claim("role", role)
                .claim("id", user.getId())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }


}
