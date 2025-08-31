package ufape.dam.harmony.business.dto.reqs;

import lombok.Data;

@Data
public class LoginRequest {

    private String email;
    private String password;

}
