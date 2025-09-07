package ufape.dam.harmony.business.dto.reqs;

import lombok.Data;

@Data
public class UpdateUserRequestDTO {
	private String fullName;
	private String username;
	private String profilePictureUrl;
}
