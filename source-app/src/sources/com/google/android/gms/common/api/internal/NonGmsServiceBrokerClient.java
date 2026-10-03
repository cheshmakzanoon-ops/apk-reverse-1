package com.google.android.gms.common.api.internal;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.Feature;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.Scope;
import com.google.android.gms.common.internal.BaseGmsClient;
import com.google.android.gms.common.internal.GmsClientSupervisor;
import com.google.android.gms.common.internal.IAccountAccessor;
import com.google.android.gms.common.internal.Preconditions;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.Set;

public final class NonGmsServiceBrokerClient implements Api.Client, ServiceConnection {
    private static final String zaa = "NonGmsServiceBrokerClient";
    private final String zab;
    private final String zac;
    private final ComponentName zad;
    private final Context zae;
    private final ConnectionCallbacks zaf;
    private final Handler zag;
    private final OnConnectionFailedListener zah;
    private IBinder zai;
    private boolean zaj;
    private String zak;
    private String zal;

    public NonGmsServiceBrokerClient(Context context, Looper looper, ComponentName componentName, ConnectionCallbacks connectionCallbacks, OnConnectionFailedListener onConnectionFailedListener) {
        this(context, looper, null, null, componentName, connectionCallbacks, onConnectionFailedListener);
    }

    private final void zad() {
        if (Thread.currentThread() != this.zag.getLooper().getThread()) {
            throw new IllegalStateException("This method should only run on the NonGmsServiceBrokerClient's handler thread.");
        }
    }

    @Override
    public final void connect(BaseGmsClient.ConnectionProgressReportCallbacks connectionProgressReportCallbacks) {
        zad();
        String.valueOf(this.zai);
        if (isConnected()) {
            try {
                disconnect("connect() called when already connected");
            } catch (Exception unused) {
            }
        }
        try {
            Intent intent = new Intent();
            ComponentName componentName = this.zad;
            if (componentName != null) {
                intent.setComponent(componentName);
            } else {
                intent.setPackage(this.zab).setAction(this.zac);
            }
            boolean zBindService = this.zae.bindService(intent, this, GmsClientSupervisor.getDefaultBindFlags());
            this.zaj = zBindService;
            if (!zBindService) {
                this.zai = null;
                this.zah.onConnectionFailed(new ConnectionResult(16));
            }
            String.valueOf(this.zai);
        } catch (SecurityException e) {
            this.zaj = false;
            this.zai = null;
            throw e;
        }
    }

    @Override
    public final void disconnect() {
        zad();
        String.valueOf(this.zai);
        try {
            this.zae.unbindService(this);
        } catch (IllegalArgumentException unused) {
        }
        this.zaj = false;
        this.zai = null;
    }

    @Override
    public final void dump(String str, FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
    }

    @Override
    public final Feature[] getAvailableFeatures() {
        return new Feature[0];
    }

    public IBinder getBinder() {
        zad();
        return this.zai;
    }

    @Override
    public final String getEndpointPackageName() {
        String str = this.zab;
        if (str != null) {
            return str;
        }
        Preconditions.checkNotNull(this.zad);
        return this.zad.getPackageName();
    }

    @Override
    public final String getLastDisconnectMessage() {
        return this.zak;
    }

    @Override
    public final int getMinApkVersion() {
        return 0;
    }

    @Override
    public final void getRemoteService(IAccountAccessor iAccountAccessor, Set<Scope> set) {
    }

    @Override
    public final Feature[] getRequiredFeatures() {
        return new Feature[0];
    }

    @Override
    public final Set<Scope> getScopesForConnectionlessNonSignIn() {
        return Collections.emptySet();
    }

    @Override
    public final IBinder getServiceBrokerBinder() {
        return null;
    }

    @Override
    public final Intent getSignInIntent() {
        return new Intent();
    }

    @Override
    public final boolean isConnected() {
        zad();
        return this.zai != null;
    }

    @Override
    public final boolean isConnecting() {
        zad();
        return this.zaj;
    }

    @Override
    public final void onServiceConnected(ComponentName componentName, final IBinder iBinder) {
        this.zag.post(new Runnable() {
            @Override
            public final void run() {
                this.zaa.zaa(iBinder);
            }
        });
    }

    @Override
    public final void onServiceDisconnected(ComponentName componentName) {
        this.zag.post(new Runnable() {
            @Override
            public final void run() {
                this.zaa.zab();
            }
        });
    }

    @Override
    public final void onUserSignOut(BaseGmsClient.SignOutCallbacks signOutCallbacks) {
    }

    @Override
    public final boolean providesSignIn() {
        return false;
    }

    @Override
    public final boolean requiresAccount() {
        return false;
    }

    @Override
    public final boolean requiresGooglePlayServices() {
        return false;
    }

    @Override
    public final boolean requiresSignIn() {
        return false;
    }

    final void zaa(IBinder iBinder) {
        this.zaj = false;
        this.zai = iBinder;
        String.valueOf(iBinder);
        this.zaf.onConnected(new Bundle());
    }

    final void zab() {
        this.zaj = false;
        this.zai = null;
        String.valueOf((Object) null);
        this.zaf.onConnectionSuspended(1);
    }

    public final void zac(String str) {
        this.zal = str;
    }

    private NonGmsServiceBrokerClient(android.content.Context r2, android.os.Looper r3, java.lang.String r4, java.lang.String r5, android.content.ComponentName r6, com.google.android.gms.common.api.internal.ConnectionCallbacks r7, com.google.android.gms.common.api.internal.OnConnectionFailedListener r8) {
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.gms.common.api.internal.NonGmsServiceBrokerClient.<init>(android.content.Context, android.os.Looper, java.lang.String, java.lang.String, android.content.ComponentName, com.google.android.gms.common.api.internal.ConnectionCallbacks, com.google.android.gms.common.api.internal.OnConnectionFailedListener):void");
    }

    public NonGmsServiceBrokerClient(Context context, Looper looper, String str, String str2, ConnectionCallbacks connectionCallbacks, OnConnectionFailedListener onConnectionFailedListener) {
        this(context, looper, str, str2, null, connectionCallbacks, onConnectionFailedListener);
    }

    @Override
    public final void disconnect(String str) {
        zad();
        this.zak = str;
        disconnect();
    }
}
