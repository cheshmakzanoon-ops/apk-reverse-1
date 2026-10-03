package com.facebook.gamingservices.cloudgaming.internal;

public enum SDKShareIntentEnum {
    INVITE("INVITE"),
    REQUEST("REQUEST"),
    CHALLENGE("CHALLENGE"),
    SHARE("SHARE");

    private final String mStringValue;

    SDKShareIntentEnum(String stringValue) {
        this.mStringValue = stringValue;
    }

    @Override
    public String toString() {
        return this.mStringValue;
    }

    public static String validate(String intentType) {
        for (SDKShareIntentEnum sDKShareIntentEnum : values()) {
            if (sDKShareIntentEnum.toString().equals(intentType)) {
                return intentType;
            }
        }
        return null;
    }

    public static SDKShareIntentEnum fromString(String intentType) {
        for (SDKShareIntentEnum sDKShareIntentEnum : values()) {
            if (sDKShareIntentEnum.toString().equals(intentType)) {
                return sDKShareIntentEnum;
            }
        }
        return null;
    }
}
