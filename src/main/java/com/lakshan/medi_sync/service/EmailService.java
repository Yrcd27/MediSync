package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.FastingBloodSugar;
import com.lakshan.medi_sync.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@Service
public class EmailService {

    @Value("${resend.api.key}")
    private String resendApiKey;

    private final RestTemplate restTemplate;
    private final Logger logger = Logger.getLogger(EmailService.class.getName());
    private final ApplicationContext applicationContext;

    @Autowired
    public EmailService(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
        this.restTemplate = new RestTemplate();
    }

    @Async
    public void sendTestReminderEmail(String recipientEmail, String subject, String body) {
        try {
            String url = "https://api.resend.com/emails";

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(resendApiKey);

            Map<String, Object> emailData = new HashMap<>();
            emailData.put("from", "onboarding@resend.dev");
            emailData.put("to", recipientEmail);
            emailData.put("subject", subject);
            emailData.put("text", body);

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(emailData, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);

            if (response.getStatusCode().is2xxSuccessful()) {
                logger.log(Level.INFO, "Email sent to {0}", recipientEmail);
            } else {
                logger.log(Level.SEVERE, "Email failed: {0}", response.getStatusCode());
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception while sending email: {0}", e.getMessage());
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
                "3. Update your record in the app after completing the test.\n\n" +
                "Regular testing every 6 months helps monitor your health effectively and detect potential issues early.\n\n" +
                "Need help? Contact our support team at medisync.app.team@gmail.com.\n" +
                "Best regards,\n" +
                "MediSync App Team";
    }
}