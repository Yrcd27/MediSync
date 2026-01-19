package com.lakshan.medi_sync;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class MediSyncApplication {

    public static void main(String[] args) {
        SpringApplication.run(MediSyncApplication.class, args);
    }

}
