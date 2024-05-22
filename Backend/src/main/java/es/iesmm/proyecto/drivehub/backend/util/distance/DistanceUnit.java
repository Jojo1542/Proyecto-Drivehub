package es.iesmm.proyecto.drivehub.backend.util.distance;

public enum DistanceUnit {

    METERS(1),
    KILOMETERS(1000);

    private final double meters;

    DistanceUnit(double meters) {
        this.meters = meters;
    }

    public double toMeters(double value) {
        return value * meters;
    }

    public double fromMeters(double meters) {
        return meters / this.meters;
    }

    public double convert(double value, DistanceUnit unit) {
        return unit.fromMeters(toMeters(value));
    }

}
