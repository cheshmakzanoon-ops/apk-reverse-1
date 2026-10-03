package com.unity3d.player;

import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkInfo;

public class NetworkConnectivity extends Activity {

    private final int f256a = 0;

    private final int f257b = 1;

    private final int f258c = 2;

    private int f259d;

    private ConnectivityManager f260e;

    private final ConnectivityManager.NetworkCallback f261f;

    public NetworkConnectivity(Context context) {
        this.f259d = 0;
        ConnectivityManager.NetworkCallback networkCallback = new ConnectivityManager.NetworkCallback() {
            @Override
            public final void onAvailable(Network network) {
                super.onAvailable(network);
            }

            @Override
            public final void onCapabilitiesChanged(Network network, NetworkCapabilities networkCapabilities) {
                NetworkConnectivity networkConnectivity;
                int i;
                super.onCapabilitiesChanged(network, networkCapabilities);
                if (networkCapabilities.hasTransport(0)) {
                    networkConnectivity = NetworkConnectivity.this;
                    i = 1;
                } else {
                    networkConnectivity = NetworkConnectivity.this;
                    i = 2;
                }
                networkConnectivity.f259d = i;
            }

            @Override
            public final void onLost(Network network) {
                super.onLost(network);
                NetworkConnectivity.this.f259d = 0;
            }

            @Override
            public final void onUnavailable() {
                super.onUnavailable();
                NetworkConnectivity.this.f259d = 0;
            }
        };
        this.f261f = networkCallback;
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService("connectivity");
        this.f260e = connectivityManager;
        connectivityManager.registerDefaultNetworkCallback(networkCallback);
        NetworkInfo activeNetworkInfo = this.f260e.getActiveNetworkInfo();
        if (activeNetworkInfo == null || !activeNetworkInfo.isConnected()) {
            return;
        }
        this.f259d = activeNetworkInfo.getType() != 0 ? 2 : 1;
    }

    public final int m475a() {
        return this.f259d;
    }

    public final void m476b() {
        this.f260e.unregisterNetworkCallback(this.f261f);
    }
}
