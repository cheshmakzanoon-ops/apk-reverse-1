package com.appsflyer.internal;

public class AFe1tSDK {
    public final long AFKeystoreWrapper;

    public AFe1tSDK(long j) {
        this.AFKeystoreWrapper = j;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        return obj != null && getClass() == obj.getClass() && this.AFKeystoreWrapper == ((AFe1tSDK) obj).AFKeystoreWrapper;
    }

    public int hashCode() {
        long j = this.AFKeystoreWrapper;
        return (int) (j ^ (j >>> 32));
    }
}
