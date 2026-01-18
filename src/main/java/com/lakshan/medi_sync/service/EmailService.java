package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.FastingBloodSugar;
import com.lakshan.medi_sync.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.logging.Level;
import java.util.logging.Logger;

@Service
public class EmailService {

    private final JavaMailSender javaMailSender;
    private final Logger logger = Logger.getLogger(EmailService.class.getName());
    private final ApplicationContext applicationContext;

    @Value("${spring.mail.username}")
    private String senderEmail;

    @Autowired
    public EmailService(JavaMailSender javaMailSender, ApplicationContext applicationContext) {
        this.javaMailSender = javaMailSender;
        this.applicationContext = applicationContext;
    }

    @Async
    public void sendTestReminderEmail(String recipientEmail, String subject, String body) {
        logger.log(Level.FINE, "Preparing to send email to {0} with subject " +
                        "\"{1}\" (body length: {2} chars)",
                new Object[]{recipientEmail, subject, body == null ? 0 : body.length()});

        try {
            SimpleMailMessage simpleMailMessage = new SimpleMailMessage();
            simpleMailMessage.setFrom(senderEmail);
            simpleMailMessage.setTo(recipientEmail);
            simpleMailMessage.setSubject(subject);
            simpleMailMessage.setText(body);

            javaMailSender.send(simpleMailMessage);
            logger.log(Level.INFO, "Email sent to {0} with subject \"{1}\"",
                    new Object[]{recipientEmail, subject});

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to send email to {0} with subject \"{1}\"",
                    new Object[]{recipientEmail, subject});
            logger.log(Level.SEVERE, "Exception while sending email", e);
        }

    }

    public void createEmailFormat(FastingBloodSugar fastingBloodSugar) {
        LocalDate nextTestDate = fastingBloodSugar.getTestDate().plusMonths(6);
        User user = fastingBloodSugar.getUser();

        String subject = "Medical Test Reminder";
        String body = buildEmailBody(nextTestDate);

        EmailService proxy = applicationContext.getBean(EmailService.class);
        proxy.sendTestReminderEmail(user.getEmail(), subject, body);
    }

    private String buildEmailBody(LocalDate nextTestDate) {
        return "Dear User,\n\n" +
                "This is a friendly reminder to schedule your next medical test on " +
                nextTestDate.toString() + ".\n\n" +
                "What you need to do:\n" +
                "1. Contact your healthcare provider to book an appointment.\n" +
                "2. Follow any pre-test instructions provided by your healthcare provider.\n" +
                "3. Update your record in the app after completing the test." + "\n\n" +
                "Regular testing every 6 months helps monitor your health effectively and detect potential issues early."
                + "\n\n" +

                "Need help? Contact our support team at medisync.app.team@gmail.com.\n" +
                "Best regards,\n" +
                "MediSync App Team";

    }


}
