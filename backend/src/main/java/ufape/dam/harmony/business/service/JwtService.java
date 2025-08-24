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
            .claim("username", user.getNomeReal())
            .claim("role", role)
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
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(),
                    JacksonFactory.getDefaultInstance()
            )
            .setAudience(Collections.singletonList(googleClientId))
            .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);

            return idToken != null ? idToken.getPayload() : null;

        } catch (Exception e) {
            e.printStackTrace();
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
                .setSubject(email)
                .claim("username", user.getUsername())
                .claim("role", role)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }


}
