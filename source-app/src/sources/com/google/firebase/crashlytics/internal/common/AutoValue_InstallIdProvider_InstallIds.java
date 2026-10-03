package com.google.firebase.crashlytics.internal.common;

final class AutoValue_InstallIdProvider_InstallIds extends InstallIdProvider.InstallIds {
    private final String crashlyticsInstallId;
    private final String firebaseInstallationId;

    AutoValue_InstallIdProvider_InstallIds(String str, String str2) {
        if (str == null) {
            throw new NullPointerException("Null crashlyticsInstallId");
        }
        this.crashlyticsInstallId = str;
        this.firebaseInstallationId = str2;
    }

    @Override
    public String getCrashlyticsInstallId() {
        return this.crashlyticsInstallId;
    }

    @Override
    public String getFirebaseInstallationId() {
        return this.firebaseInstallationId;
    }

    public String toString() {
        return "InstallIds{crashlyticsInstallId=" + this.crashlyticsInstallId + ", firebaseInstallationId=" + this.firebaseInstallationId + "}";
    }

    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof InstallIdProvider.InstallIds)) {
            return false;
        }
        InstallIdProvider.InstallIds installIds = (InstallIdProvider.InstallIds) obj;
        if (this.crashlyticsInstallId.equals(installIds.getCrashlyticsInstallId())) {
            String str = this.firebaseInstallationId;
            if (str == null) {
                if (installIds.getFirebaseInstallationId() == null) {
                    return true;
                }
            } else if (str.equals(installIds.getFirebaseInstallationId())) {
                return true;
            }
        }
        return false;
    }

    public int hashCode() {
        int iHashCode = (this.crashlyticsInstallId.hashCode() ^ 1000003) * 1000003;
        String str = this.firebaseInstallationId;
        return iHashCode ^ (str == null ? 0 : str.hashCode());
    }
}
