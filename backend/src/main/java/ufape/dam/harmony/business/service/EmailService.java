package ufape.dam.harmony.business.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${frontend.reset.url}")
    private String resetBaseUrl;

    @Value("${spring.mail.username}")
    private String emailFrom;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void sendResetLink(String email, String token) {
    String subject = "Redefinição de senha";
    String link = resetBaseUrl + "?token=" + token;

    String htmlContent = """
        <html>
            <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;">
                <div style="max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <h2 style="color: #333;">Redefinição de senha</h2>
                    <p style="font-size: 16px; color: #555;">
                        Olá, recebemos uma solicitação para redefinir sua senha.
                        Clique no botão abaixo para prosseguir:
                    </p>
                    <a href="%s" style="display: inline-block; margin: 20px 0; padding: 12px 24px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 5px; font-weight: bold;">
                        Redefinir senha
                    </a>
                    <p style="font-size: 14px; color: #999;">
                        Se você não solicitou essa alteração, pode ignorar este e-mail.
                    </p>
                    <hr style="border: none; border-top: 1px solid #eee;">
                    <p style="font-size: 12px; color: #bbb;">Equipe Playce</p>
                </div>
            </body>
        </html>
    """.formatted(link);

    try {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, "UTF-8");
        helper.setTo(email);
        helper.setSubject(subject);
        helper.setText(htmlContent, true);
        mailSender.send(message);
    } catch (MessagingException e) {
        throw new RuntimeException("Erro ao enviar email", e);
    }
}
}