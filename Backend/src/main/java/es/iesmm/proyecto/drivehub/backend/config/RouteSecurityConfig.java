package es.iesmm.proyecto.drivehub.backend.config;

import es.iesmm.proyecto.drivehub.backend.util.filter.JwtAuthenticationFilter;
import jakarta.servlet.DispatcherType;
import lombok.AllArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@AllArgsConstructor
public class RouteSecurityConfig {

    public final JwtAuthenticationFilter jwtFilter;
    public final AuthenticationProvider authProvider;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        // Disable logout
        return http
                .csrf(AbstractHttpConfigurer::disable)

                .authorizeHttpRequests(
                        authorizeRequests -> authorizeRequests
                                .dispatcherTypeMatchers(DispatcherType.ASYNC).permitAll()
                                .requestMatchers("/auth/**").permitAll()
                                .requestMatchers("/status/**").permitAll()
                                .anyRequest().authenticated()
                )
                // Disable session management
                .sessionManagement(sessionManagement -> sessionManagement.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                // Use our custom authentication provider
                .authenticationProvider(authProvider)
                // Add JWT filter before UsernamePasswordAuthenticationFilter
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
                .exceptionHandling(
                        exceptionHandling -> exceptionHandling
                                .authenticationEntryPoint((request, response, authException) -> {
                                    if (response.isCommitted()) {
                                        return;
                                    }

                                    response.setStatus(401);
                                })
                                .accessDeniedHandler((request, response, accessDeniedException) -> {
                                    if (response.isCommitted()) {
                                        return;
                                    }

                                    response.setStatus(403);
                                })
                )
                .logout(AbstractHttpConfigurer::disable)
                .build();
    }

    /*@Bean
    public HttpExchangeRepository httpTraceRepository() {
        return new InMemoryHttpExchangeRepository();
    }*/

}
