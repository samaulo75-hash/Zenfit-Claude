package com.zenfit;

import com.zenfit.auth.jwt.JwtProperties;
import com.zenfit.config.CorsProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties({JwtProperties.class, CorsProperties.class})
public class ZenfitApplication {

    public static void main(String[] args) {
        SpringApplication.run(ZenfitApplication.class, args);
    }
}
