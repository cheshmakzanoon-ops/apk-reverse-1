package com.appsflyer.internal;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import kotlin.jvm.internal.Intrinsics;

public final class AFh1bSDK extends AFh1cSDK {
    private String AFInAppEventParameterName;
    private Network values;

    public AFh1bSDK(Context context) {
        super(context);
        Intrinsics.checkNotNullParameter(context, "");
        this.AFInAppEventParameterName = "unknown";
        AFa1tSDK aFa1tSDK = new AFa1tSDK();
        ConnectivityManager connectivityManager = this.values;
        if (connectivityManager != null) {
            connectivityManager.registerNetworkCallback(new NetworkRequest.Builder().build(), aFa1tSDK);
        }
    }

    public static final class AFa1tSDK extends ConnectivityManager.NetworkCallback {
        AFa1tSDK() {
        }

        @Override
        public final void onAvailable(Network network) {
            Intrinsics.checkNotNullParameter(network, "");
            AFh1bSDK.this.values = network;
        }

        @Override
        public final void onLost(Network network) {
            Intrinsics.checkNotNullParameter(network, "");
            AFh1bSDK.this.values = network;
            AFh1bSDK.this.AFInAppEventParameterName = "NetworkLost";
        }
    }

    @Override
    protected final String values() {
        Network network = this.values;
        if (network != null) {
            ConnectivityManager connectivityManager = this.values;
            NetworkCapabilities networkCapabilities = connectivityManager != null ? connectivityManager.getNetworkCapabilities(network) : null;
            if (networkCapabilities != null && networkCapabilities != null) {
                if (networkCapabilities.hasTransport(1)) {
                    return "WIFI";
                }
                if (networkCapabilities.hasTransport(0)) {
                    return "MOBILE";
                }
            }
        }
        return "unknown";
    }

    @Override
    public final boolean AFInAppEventType() {
        Network network = this.values;
        if (network == null) {
            return false;
        }
        if (Intrinsics.areEqual(this.AFInAppEventParameterName, "NetworkLost")) {
            network = null;
        }
        if (network == null) {
            return false;
        }
        ConnectivityManager connectivityManager = this.values;
        NetworkCapabilities networkCapabilities = connectivityManager != null ? connectivityManager.getNetworkCapabilities(network) : null;
        if (networkCapabilities != null) {
            return valueOf(networkCapabilities);
        }
        return false;
    }

    private static boolean valueOf(NetworkCapabilities networkCapabilities) {
        return (networkCapabilities == null || !networkCapabilities.hasTransport(4) || networkCapabilities.hasCapability(15)) ? false : true;
    }
}
