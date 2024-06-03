package es.iesmm.proyecto.drivehub.backend.model.http.request.user;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.balance.type.BalanceChangeType;

public record UserBalanceModificationRequest(double amount, BalanceChangeType type) {

    public void applyToUser(UserModel user) {
        switch (type) {
            case DEPOSIT -> user.deposit(amount);
            case WITHDRAW -> user.withdraw(amount);
        }
    }

}
