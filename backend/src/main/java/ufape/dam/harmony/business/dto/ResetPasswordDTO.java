package ufape.dam.harmony.business.dto;

import lombok.Data;

@Data
public class ResetPasswordDTO {

    private String token;
    private String newPassword;

}