package ufape.dam.harmony.business.dto.reqs;

import lombok.Data;

@Data
public class RegisterRequest {

    private String username;
    private String email;
    private String password;

}
