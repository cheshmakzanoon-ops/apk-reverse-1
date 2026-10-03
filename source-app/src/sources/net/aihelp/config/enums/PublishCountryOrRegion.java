package net.aihelp.config.enums;

public enum PublishCountryOrRegion {
    CN,
    IN;

    public static PublishCountryOrRegion fromValue(int i) {
        if (i == 1) {
            return CN;
        }
        if (i != 2) {
            return null;
        }
        return IN;
    }
}
