package ufape.dam.harmony.data;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

import ufape.dam.harmony.business.entity.PasswordResetToken;

public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, Long> {

    Optional<PasswordResetToken> findByToken(String token);

}
