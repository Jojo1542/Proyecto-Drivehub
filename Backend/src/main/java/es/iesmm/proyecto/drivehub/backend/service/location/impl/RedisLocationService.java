package es.iesmm.proyecto.drivehub.backend.service.location.impl;

import com.google.common.base.Preconditions;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.location.UserLocation;
import es.iesmm.proyecto.drivehub.backend.service.location.LocationService;
import lombok.AllArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.concurrent.TimeUnit;

@Service
@AllArgsConstructor
public class RedisLocationService implements LocationService {

    private final RedisTemplate<String, UserLocation> redisRepository;
    private final String KEY_PREFIX = "user:location:";

    @Override
    public void save(UserModel user, UserLocation location) {
        Preconditions.checkNotNull(user.getId(), "User must have an id");

        // Guardar en redis la localización del usuario por 4 días
        redisRepository.opsForValue().set(KEY_PREFIX + user.getId(), location, 4, TimeUnit.DAYS);
    }

    @Override
    public Optional<UserLocation> findLatestLocation(Long userId) {
        Preconditions.checkNotNull(userId, "User id must not be null");

        return Optional.ofNullable(redisRepository.opsForValue().get(KEY_PREFIX + userId));
    }
}
