package ufape.dam.harmony.presentation;

import java.util.Optional;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;

import jakarta.transaction.Transactional;
import ufape.dam.harmony.business.dto.JwtResponse;
import ufape.dam.harmony.business.dto.LoginRequest;
import ufape.dam.harmony.business.dto.RegisterRequest;
import ufape.dam.harmony.business.dto.ResetPasswordDTO;
import ufape.dam.harmony.business.dto.ResetRequestDTO;
import ufape.dam.harmony.business.entity.PasswordResetToken;
import ufape.dam.harmony.business.entity.Usuario;
import ufape.dam.harmony.business.service.EmailService;
import ufape.dam.harmony.business.service.JwtService;
import ufape.dam.harmony.data.PasswordResetTokenRepository;
import ufape.dam.harmony.data.UsuarioRepository;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthenticationManager authManager;
    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    
    private final JwtService jwtService;
    private final PasswordResetTokenRepository tokenRepository;
    private final EmailService emailService;

    public AuthController(AuthenticationManager authManager, JwtService jwtService, UsuarioRepository usuarioRepository, PasswordEncoder passwordEncoder,
        PasswordResetTokenRepository tokenRepository, EmailService emailService) {
        this.authManager = authManager;
        this.jwtService = jwtService;
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.tokenRepository = tokenRepository;
        this.emailService = emailService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
	try {
		Authentication auth = authManager.authenticate(
			new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
		);

		String token = jwtService.generateToken(auth);

		return ResponseEntity.ok(new JwtResponse(token));
	} catch (BadCredentialsException ex){
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Bad credentials.");
	}
    }

    @PostMapping("/google")
    @Transactional
    public ResponseEntity<?> authenticateWithGoogle(@RequestBody String idTokenString) {
        GoogleIdToken.Payload payload = jwtService.verifyToken(idTokenString);

        if (payload == null) {
            return ResponseEntity.status(401).body("ID Token inválido");
        }

        String email = payload.getEmail();
        String name = (String) payload.get("name");

        Optional<Usuario> userOpt = usuarioRepository.findByEmail(email);

        Usuario user = userOpt.orElseGet(() -> {
            Usuario novo = new Usuario();
            novo.setEmail(email);
            novo.setUsername(name);
            novo.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
            novo.setRole("USER");
            return usuarioRepository.save(novo);
        });

        String token = jwtService.generateTokenFromEmail(user.getEmail());
        return ResponseEntity.ok(new JwtResponse(token));
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
        if (usuarioRepository.findByEmail(request.getEmail()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Este e-mail já está sendo utilizado.");
        }

        Usuario newUser = new Usuario();
        newUser.setUsername(request.getUsername());
        newUser.setEmail(request.getEmail());
        newUser.setPassword(passwordEncoder.encode(request.getPassword()));
        newUser.setRole("USER");

        usuarioRepository.save(newUser);
        Authentication auth = authManager.authenticate(
            new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        String token = jwtService.generateToken(auth);
        return ResponseEntity.ok(new JwtResponse(token));
    }


    @PostMapping("/reset-request")
    public ResponseEntity<?> requestReset(@RequestBody ResetRequestDTO request) {
        Optional<Usuario> userOpt = usuarioRepository.findByEmail(request.getEmail());

        if (userOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email não encontrado.");
        }

        Usuario user = userOpt.get();
        String token = UUID.randomUUID().toString();

        PasswordResetToken resetToken = new PasswordResetToken(token, user);
        tokenRepository.save(resetToken);

        emailService.sendResetLink(user.getEmail(), token);

        return ResponseEntity.ok("Link de redefinição enviado.");
    }

    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody ResetPasswordDTO request) {
        PasswordResetToken tokenObj = tokenRepository.findByToken(request.getToken())
            .orElseThrow(() -> new RuntimeException("Token inválido"));

        if (tokenObj.isExpired()) {
            return ResponseEntity.status(HttpStatus.GONE).body("Token expirado.");
        }

        Usuario user = tokenObj.getUsuario();
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        usuarioRepository.save(user);

        tokenRepository.delete(tokenObj);

        return ResponseEntity.ok("Senha redefinida com sucesso.");
    }
}