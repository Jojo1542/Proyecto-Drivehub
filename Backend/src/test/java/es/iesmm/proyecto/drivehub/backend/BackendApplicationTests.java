package es.iesmm.proyecto.drivehub.backend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

@SpringBootTest
class BackendApplicationTests {

	@Test
	void contextLoads() {
	}

	@Test
	void getHoursOfTimeStamp() {
		Timestamp start = Timestamp.from(Instant.now());
		System.out.println(start.getTime());

		Timestamp end = Timestamp.from(Instant.now().plus(15, ChronoUnit.SECONDS));
		System.out.println(end.getTime());

		System.out.println("Diferencia: " + (end.getTime() - start.getTime()) + " ms");

		// Round up only
		int hours = (int) Math.ceil((end.getTime() - start.getTime()) / 3600000.0);

		System.out.println("Horas: " + hours + " horas");

		Timestamp timestamp = Timestamp.from(
				Instant.now()
						.plus(2, ChronoUnit.HOURS)
						.plus(30, ChronoUnit.MINUTES)
		);

		System.out.println(timestamp.getTime());

		hours = (int) Math.ceil((timestamp.getTime() - start.getTime()) / 3600000.0);

		System.out.println("Horas: " + hours + " horas");
	}

}
