package ufape.dam.harmony.security;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import ufape.dam.harmony.business.entity.Usuario;


public class SecurityUser implements UserDetails  {
	
    private final Usuario user;

    public SecurityUser(Usuario appUser) {
        this.user = appUser;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        String role = user.getRole();
        String prefixedRole = role.startsWith("ROLE_") ? role : "ROLE_" + role;
        return List.of(new SimpleGrantedAuthority(prefixedRole));
    }

    @Override
    public String getPassword() {
        return user.getPassword();
    }

    @Override
    public String getUsername() {
        return user.getEmail();
    }
    
    public String getRealUsername() {
    	return user.getUsername();
    }

    public String getFullName() {
        return user.getFullName();
    }
    
    public String getEmail() {
    	return user.getEmail();
    }
    
    public Usuario getUsuario() {
        return this.user;
    }
    
    public long getId() {
    	return this.user.getId();
    }
    
    @Override public boolean isAccountNonExpired() { return true; }
    @Override public boolean isAccountNonLocked() { return true; }
    @Override public boolean isCredentialsNonExpired() { return true; }
    @Override public boolean isEnabled() { return true; }
}
