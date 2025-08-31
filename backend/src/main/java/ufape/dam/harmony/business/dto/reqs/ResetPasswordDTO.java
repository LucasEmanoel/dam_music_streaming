package ufape.dam.harmony.business.dto.reqs;

import lombok.Data;

@Data
public class ResetPasswordDTO {

    private String token;
    private String newPassword;

}