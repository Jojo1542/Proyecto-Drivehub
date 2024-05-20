package es.iesmm.proyecto.drivehub.backend.repository;

import es.iesmm.proyecto.drivehub.backend.model.trip.TripModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TripRepository extends JpaRepository<TripModel, Long> {

    @Query("SELECT t FROM TripModel t WHERE status = :status")
    List<TripModel> findByStatus(String status);

    // Find By Driver
    @Query("SELECT t FROM TripModel t WHERE driver = :driver_id")
    List<TripModel> findByDriver(Long driver_id);

    // Find By Passenger
    @Query("SELECT t FROM TripModel t WHERE passenger = :passenger_id")
    List<TripModel> findByPassenger(Long passenger_id);
}
