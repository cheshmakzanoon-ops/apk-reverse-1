package com.gme.liteav.base.networkbinder;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.LinkProperties;
import android.net.Network;
import android.net.NetworkRequest;
import android.os.Handler;
import android.os.Looper;
import android.os.ParcelFileDescriptor;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.system.LiteavSystemInfo;
import com.gme.liteav.base.util.LiteavLog;

@JNINamespace("liteav")
public class NetworkBinder {
    public static final int CELLULAR = 2;
    public static final int DEFAULT = 0;
    private static final String TAG = "NetworkBinder";
    public static final int WIFI = 1;
    private static boolean isPrint = true;
    private final Handler mHandler;
    private long mNativeNetworkBinderJni;
    private final Object mLocker = new Object();
    private boolean mIsActivatingNetwork = false;
    private boolean mIsNetworkAvailable = false;
    private int mNetworkType = 0;
    private ConnectivityManager.NetworkCallback mNetworkCallback = null;
    private final Runnable mTimeoutRunnable = new Runnable() {
        @Override
        public final void run() {
            synchronized (NetworkBinder.this.mLocker) {
                if (NetworkBinder.this.mIsActivatingNetwork && NetworkBinder.this.checkNativeValid()) {
                    NetworkBinder.nativeOnNetworkAvailable(NetworkBinder.this.mNativeNetworkBinderJni, "", false);
                    LiteavLog.m994e(NetworkBinder.TAG, "[BindSocket]:activate network timeout");
                    NetworkBinder.this.mIsActivatingNetwork = false;
                    NetworkBinder.this.mIsNetworkAvailable = false;
                    NetworkBinder.this.deactivateNetworkAdapter();
                }
            }
        }
    };

    public static native void nativeOnNetworkAvailable(long j, String str, boolean z);

    public NetworkBinder(long j) {
        Handler handler = null;
        try {
            this.mNativeNetworkBinderJni = j;
            handler = new Handler(Looper.getMainLooper());
        } catch (Throwable th) {
            LiteavLog.m995e(TAG, "NetworkBinder failed.", th);
        }
        this.mHandler = handler;
    }

    public void destroy() {
        try {
            synchronized (this.mLocker) {
                this.mIsActivatingNetwork = false;
                this.mIsNetworkAvailable = false;
                deactivateNetworkAdapter();
                cancleTimeoutRunnable();
                this.mNativeNetworkBinderJni = -1L;
            }
        } catch (Throwable th) {
            LiteavLog.m995e(TAG, "destroy failed.", th);
        }
    }

    public void cancleTimeoutRunnable() {
        if (this.mHandler != null) {
            Log.m949i(TAG, "[BindSocket]:remove cancel last request network runnable", new Object[0]);
            this.mHandler.removeCallbacks(this.mTimeoutRunnable);
        }
    }

    private ConnectivityManager.NetworkCallback createNetworkCallback() {
        final ConnectivityManager connectivityManager;
        synchronized (this.mLocker) {
            ConnectivityManager.NetworkCallback networkCallback = this.mNetworkCallback;
            if (networkCallback != null) {
                return networkCallback;
            }
            if (!checkSystemVersionValid() || (connectivityManager = getConnectivityManager()) == null) {
                return null;
            }
            ConnectivityManager.NetworkCallback networkCallback2 = new ConnectivityManager.NetworkCallback() {
                @Override
                public final void onAvailable(Network network) {
                    super.onAvailable(network);
                    if (network == null) {
                        Log.m948e(NetworkBinder.TAG, "[BindSocket]:onAvailable, network is null", new Object[0]);
                        return;
                    }
                    LinkProperties linkProperties = connectivityManager.getLinkProperties(network);
                    synchronized (NetworkBinder.this.mLocker) {
                        if (NetworkBinder.this.mIsActivatingNetwork) {
                            NetworkBinder.this.mIsActivatingNetwork = false;
                            NetworkBinder.this.mIsNetworkAvailable = true;
                            if (linkProperties != null && NetworkBinder.this.checkNativeValid()) {
                                String interfaceName = linkProperties.getInterfaceName();
                                NetworkBinder.nativeOnNetworkAvailable(NetworkBinder.this.mNativeNetworkBinderJni, interfaceName, true);
                                Log.m949i(NetworkBinder.TAG, "[BindSocket]:start network succ, network name=".concat(String.valueOf(interfaceName)), new Object[0]);
                            }
                            NetworkBinder.this.cancleTimeoutRunnable();
                        }
                    }
                }

                @Override
                public final void onLost(Network network) {
                    super.onLost(network);
                    synchronized (NetworkBinder.this.mLocker) {
                        if (NetworkBinder.this.mIsNetworkAvailable && !NetworkBinder.this.mIsActivatingNetwork) {
                            NetworkBinder.this.mIsNetworkAvailable = false;
                            if (NetworkBinder.this.checkNativeValid()) {
                                NetworkBinder.nativeOnNetworkAvailable(NetworkBinder.this.mNativeNetworkBinderJni, "", false);
                                Log.m949i(NetworkBinder.TAG, "[BindSocket]:network onLost", new Object[0]);
                            }
                            NetworkBinder.this.deactivateNetworkAdapter();
                        }
                    }
                }
            };
            synchronized (this.mLocker) {
                this.mNetworkCallback = networkCallback2;
            }
            return networkCallback2;
        }
    }

    private static ConnectivityManager getConnectivityManager() {
        Context applicationContext = ContextUtils.getApplicationContext();
        if (applicationContext == null) {
            return null;
        }
        return (ConnectivityManager) applicationContext.getSystemService("connectivity");
    }

    private static boolean checkSystemVersionValid() {
        if (LiteavSystemInfo.getSystemOSVersionInt() >= 23) {
            return true;
        }
        if (isPrint) {
            LiteavLog.m994e(TAG, "[BindSocket]:The android version is too low and does not support network binding");
            isPrint = false;
        }
        return false;
    }

    public boolean checkNativeValid() {
        boolean z;
        synchronized (this.mLocker) {
            z = this.mNativeNetworkBinderJni != -1;
        }
        return z;
    }

    public void resumeDefaultNetworkAdapter() {
        try {
            this.mNetworkType = 0;
            deactivateNetworkAdapter();
        } catch (Throwable th) {
            LiteavLog.m995e(TAG, "resumeDefaultNetworkAdapter failed.", th);
        }
    }

    public boolean activateNetworkAdapter(int i) {
        if (i != 1 && i != 2) {
            return false;
        }
        try {
            synchronized (this.mLocker) {
                if (this.mIsActivatingNetwork) {
                    LiteavLog.m994e(TAG, "[BindSocket]:mIsActivatingNetwork is true");
                    return false;
                }
                this.mIsActivatingNetwork = true;
                this.mIsNetworkAvailable = false;
                if (this.mNetworkType != i) {
                    deactivateNetworkAdapter();
                }
                this.mNetworkType = i;
                if (doActivateNetworkAdapter(i)) {
                    synchronized (this.mLocker) {
                        Handler handler = this.mHandler;
                        if (handler != null) {
                            handler.postDelayed(this.mTimeoutRunnable, 2000L);
                        }
                    }
                    return true;
                }
                return false;
            }
        } catch (Exception unused) {
            LiteavLog.m994e(TAG, "[BindSocket]:activateNetworkAdapter in java encountered an exception, networkType:".concat(String.valueOf(i)));
        }
    }

    public boolean doActivateNetworkAdapter(int i) {
        int i2;
        ConnectivityManager connectivityManager;
        ConnectivityManager.NetworkCallback networkCallbackCreateNetworkCallback;
        if (i != 1) {
            if (i == 2) {
                i2 = 0;
            }
            return false;
        }
        i2 = 1;
        try {
            if (!checkSystemVersionValid() || (connectivityManager = getConnectivityManager()) == null || (networkCallbackCreateNetworkCallback = createNetworkCallback()) == null) {
                return false;
            }
            connectivityManager.requestNetwork(new NetworkRequest.Builder().addCapability(12).addTransportType(i2).build(), networkCallbackCreateNetworkCallback);
            return true;
        } catch (Exception unused) {
            LiteavLog.m994e(TAG, "[BindSocket]:requestNetwork in java encountered an exception, networkType:".concat(String.valueOf(i)));
        }
    }

    public void deactivateNetworkAdapter() {
        ConnectivityManager connectivityManager;
        try {
            if (checkSystemVersionValid() && (connectivityManager = getConnectivityManager()) != null) {
                synchronized (this.mLocker) {
                    if (this.mNetworkCallback != null) {
                        Log.m949i(TAG, "[BindSocket]:deactivat network adapter", new Object[0]);
                        connectivityManager.unregisterNetworkCallback(this.mNetworkCallback);
                    }
                }
            }
        } catch (Exception unused) {
            LiteavLog.m994e(TAG, "[BindSocket]:deactivateNetworkAdapter in java encountered an exception");
        }
    }

    public static Network findNetwork(String str) {
        ConnectivityManager connectivityManager;
        if (!checkSystemVersionValid() || (connectivityManager = getConnectivityManager()) == null) {
            return null;
        }
        for (Network network : connectivityManager.getAllNetworks()) {
            LinkProperties linkProperties = connectivityManager.getLinkProperties(network);
            if (linkProperties != null && linkProperties.getInterfaceName().equals(str)) {
                return network;
            }
        }
        return null;
    }

    public static boolean bindSocket(String str, int i) {
        if (str != null && !str.isEmpty() && i != -1) {
            try {
                if (!checkSystemVersionValid()) {
                    return false;
                }
                Network networkFindNetwork = findNetwork(str);
                if (networkFindNetwork == null) {
                    LiteavLog.m994e(TAG, "[BindSocket]:NetworkBinder bindSocket can not find network:".concat(String.valueOf(str)));
                    return false;
                }
                networkFindNetwork.bindSocket(ParcelFileDescriptor.fromFd(i).getFileDescriptor());
                LiteavLog.m998i(TAG, "[BindSocket]:NetworkBinder bindSocket succ, name:" + str + " socket:" + i);
                return true;
            } catch (Throwable th) {
                LiteavLog.m995e(TAG, "[BindSocket]:bindSocket in java encountered an exception, name:" + str + " socket:" + i, th);
            }
        }
        return false;
    }
}
