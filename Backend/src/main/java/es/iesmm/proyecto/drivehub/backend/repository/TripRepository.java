package es.iesmm.proyecto.drivehub.backend.repository;

import es.iesmm.proyecto.drivehub.backend.model.trip.TripModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TripRepository extends JpaRepository<TripModel, Long> {

    @Query("SELECT t FROM TripModel t WHERE status = :status")
    List<TripModel> findByStatus(String status);

    // Find By Driver
    @Query("SELECT t FROM TripModel t WHERE driver.id = :driver_id")
    List<TripModel> findByDriver(Long driver_id);

    // Find By Passenger
    @Query("SELECT t FROM TripModel t WHERE passenger.id = :passenger_id")
    List<TripModel> findByPassenger(Long passenger_id);

    @Query("SELECT t FROM TripModel t WHERE driver.id = :driverId")
    List<TripModel> findByDriverId(Long driverId);

    @Query("SELECT t FROM TripModel t WHERE passenger.id = :passengerId")
    List<TripModel> findByPassengerId(Long passengerId);

    @Query("SELECT t FROM TripModel t WHERE (status = 'PENDING' OR status = 'ACCEPTED') AND driver.id = :driverId")
    Optional<TripModel> findActiveByDriverId(Long driverId);

    @Query("SELECT t FROM TripModel t WHERE (status = 'PENDING' OR status = 'ACCEPTED') AND passenger.id = :passengerId")
    Optional<TripModel> findActiveByPassengerId(Long passengerId);
}
