package ufape.dam.harmony.data;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import ufape.dam.harmony.business.entity.Usuario;


public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    Optional<Usuario> findByUsername(String username);
    Optional<Usuario> findByEmail(String email);

}