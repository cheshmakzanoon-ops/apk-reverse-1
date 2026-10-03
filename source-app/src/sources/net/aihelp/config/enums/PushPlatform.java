package net.aihelp.config.enums;

public enum PushPlatform {
    APNS(1),
    FIREBASE(2),
    JPUSH(3),
    GETUI(4),
    HUAWEI(6),
    ONE_SIGNAL(7);

    private int value;

    PushPlatform(int i) {
        this.value = i;
    }

    public int getValue() {
        return this.value;
    }

    public static PushPlatform fromValue(int i) {
        if (i == 1) {
            return APNS;
        }
        if (i == 2) {
            return FIREBASE;
        }
        if (i == 3) {
            return JPUSH;
        }
        if (i == 4) {
            return GETUI;
        }
        if (i == 6) {
            return HUAWEI;
        }
        if (i != 7) {
            return null;
        }
        return ONE_SIGNAL;
    }
}
