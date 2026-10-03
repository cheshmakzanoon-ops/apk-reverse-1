package com.google.firebase.crashlytics.internal.common;

public enum DeliveryMechanism {
    DEVELOPER(1),
    USER_SIDELOAD(2),
    TEST_DISTRIBUTION(3),
    APP_STORE(4);


    private final int f169id;

    DeliveryMechanism(int i) {
        this.f169id = i;
    }

    public int getId() {
        return this.f169id;
    }

    @Override
    public String toString() {
        return Integer.toString(this.f169id);
    }

    public static DeliveryMechanism determineFrom(String str) {
        return str != null ? APP_STORE : DEVELOPER;
    }
}
