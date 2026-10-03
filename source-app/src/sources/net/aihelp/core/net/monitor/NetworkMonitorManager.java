package net.aihelp.core.net.monitor;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.LinkProperties;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkInfo;
import android.net.NetworkRequest;
import android.os.Build;
import android.telephony.TelephonyManager;
import com.unity3d.player.l$a$;
import j$.util.concurrent.ConcurrentHashMap;
import java.lang.ref.WeakReference;
import java.lang.reflect.Method;
import java.util.Iterator;
import java.util.Map;
import kotlin.UByte$$ExternalSyntheticBackport0;
import net.aihelp.utils.TLog;

public class NetworkMonitorManager {
    private static final String ANDROID_NET_CHANGE_ACTION = "android.net.conn.CONNECTIVITY_CHANGE";
    public static final String TAG = "NetWorkMonitor >>> : ";
    private static NetworkMonitorManager ourInstance;
    private boolean isFirstReceived;
    private WeakReference<Context> mContext;
    private Map<Object, NetworkStateReceiverMethod> netWorkStateChangedMethodMap = new ConcurrentHashMap();
    private BroadcastReceiver receiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            NetworkState networkState;
            if (!NetworkMonitorManager.this.isFirstReceived && NetworkMonitorManager.ANDROID_NET_CHANGE_ACTION.equalsIgnoreCase(intent.getAction())) {
                int aPNType = NetworkMonitorManager.getAPNType(context);
                if (aPNType == 0) {
                    networkState = NetworkState.NONE;
                } else if (aPNType == 1) {
                    networkState = NetworkState.WIFI;
                } else {
                    networkState = NetworkState.CELLULAR;
                }
                NetworkMonitorManager.this.postNetState(networkState);
            }
        }
    };
    private NetworkCallback mNetworkCallback = new NetworkCallback();

    private void onDestroy() {
    }

    public static NetworkMonitorManager getInstance() {
        synchronized (NetworkMonitorManager.class) {
            if (ourInstance == null) {
                ourInstance = new NetworkMonitorManager();
            }
        }
        return ourInstance;
    }

    private NetworkMonitorManager() {
    }

    public void init(Context context) {
        if (context == null) {
            TLog.m138d("NetworkMonitorManager init Context can not be null");
        } else {
            this.mContext = new WeakReference<>(context.getApplicationContext());
        }
    }

    private void initMonitor() {
        ConnectivityManager connectivityManager;
        WeakReference<Context> weakReference = this.mContext;
        if (weakReference == null || weakReference.get() == null || (connectivityManager = (ConnectivityManager) this.mContext.get().getSystemService("connectivity")) == null || this.mNetworkCallback == null) {
            return;
        }
        if (Build.VERSION.SDK_INT >= 26) {
            l$a$.ExternalSyntheticApiModelOutline0.m(connectivityManager, this.mNetworkCallback);
        } else {
            connectivityManager.registerNetworkCallback(new NetworkRequest.Builder().build(), this.mNetworkCallback);
        }
    }

    public void register(Object obj) {
        try {
            WeakReference<Context> weakReference = this.mContext;
            if (weakReference == null || weakReference.get() == null) {
                return;
            }
            ConnectivityManager connectivityManager = (ConnectivityManager) this.mContext.get().getSystemService("connectivity");
            if (connectivityManager != null && this.mNetworkCallback != null) {
                if (Build.VERSION.SDK_INT >= 26) {
                    l$a$.ExternalSyntheticApiModelOutline0.m(connectivityManager, this.mNetworkCallback);
                } else {
                    connectivityManager.registerNetworkCallback(new NetworkRequest.Builder().build(), this.mNetworkCallback);
                }
            }
            if (obj != null) {
                Class<?> clsMoveToSuperclass = obj.getClass();
                while (clsMoveToSuperclass != null) {
                    NetworkStateReceiverMethod networkStateReceiverMethodFindMethod = findMethod(obj, clsMoveToSuperclass);
                    if (networkStateReceiverMethodFindMethod != null) {
                        this.netWorkStateChangedMethodMap.put(obj, networkStateReceiverMethodFindMethod);
                    }
                    clsMoveToSuperclass = moveToSuperclass(clsMoveToSuperclass);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void unregister(Object obj) {
        Map<Object, NetworkStateReceiverMethod> map;
        try {
            WeakReference<Context> weakReference = this.mContext;
            if (weakReference == null || weakReference.get() == null) {
                return;
            }
            if (obj != null && (map = this.netWorkStateChangedMethodMap) != null) {
                map.remove(obj);
            }
            ConnectivityManager connectivityManager = (ConnectivityManager) this.mContext.get().getSystemService("connectivity");
            if (connectivityManager == null || this.mNetworkCallback == null) {
                return;
            }
            connectivityManager.unregisterNetworkCallback(this.mNetworkCallback);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Class moveToSuperclass(Class cls) {
        if (cls == null) {
            return null;
        }
        Class superclass = cls.getSuperclass();
        if (superclass != null) {
            String name = superclass.getName();
            if (name.startsWith("java.") || name.startsWith("javax.") || name.startsWith("android.") || name.startsWith("androidx.")) {
                return null;
            }
        }
        return superclass;
    }

    public void postNetState(NetworkState networkState) {
        try {
            Iterator<Object> it = this.netWorkStateChangedMethodMap.keySet().iterator();
            while (it.hasNext()) {
                invokeMethod(this.netWorkStateChangedMethodMap.get(it.next()), networkState);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void invokeMethod(NetworkStateReceiverMethod networkStateReceiverMethod, NetworkState networkState) {
        if (networkStateReceiverMethod != null) {
            try {
                for (NetworkState networkState2 : networkStateReceiverMethod.getNetworkState()) {
                    if (networkState2 == networkState) {
                        networkStateReceiverMethod.getMethod().invoke(networkStateReceiverMethod.getObject(), networkState);
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private NetworkStateReceiverMethod findMethod(Object obj, Class cls) {
        for (Method method : cls.getDeclaredMethods()) {
            if (Build.VERSION.SDK_INT < 26 || UByte$$ExternalSyntheticBackport0.m29m(method) == 1) {
                Class<?>[] parameterTypes = method.getParameterTypes();
                if (parameterTypes.length == 1 && parameterTypes[0].getName().equals(NetworkState.class.getName())) {
                    NetworkMonitor networkMonitor = (NetworkMonitor) method.getAnnotation(NetworkMonitor.class);
                    NetworkStateReceiverMethod networkStateReceiverMethod = new NetworkStateReceiverMethod();
                    if (networkMonitor != null) {
                        networkStateReceiverMethod.setNetworkState(networkMonitor.monitorFilter());
                    }
                    networkStateReceiverMethod.setMethod(method);
                    networkStateReceiverMethod.setObject(obj);
                    return networkStateReceiverMethod;
                }
            }
        }
        return null;
    }

    private class NetworkCallback extends ConnectivityManager.NetworkCallback {
        private NetworkCallback() {
        }

        @Override
        public void onAvailable(Network network) {
            NetworkState networkState;
            super.onAvailable(network);
            if (NetworkMonitorManager.this.mContext == null || NetworkMonitorManager.this.mContext.get() == null) {
                return;
            }
            int aPNType = NetworkMonitorManager.getAPNType((Context) NetworkMonitorManager.this.mContext.get());
            if (aPNType == 0) {
                networkState = NetworkState.NONE;
            } else if (aPNType == 1) {
                networkState = NetworkState.WIFI;
            } else {
                networkState = NetworkState.CELLULAR;
            }
            NetworkMonitorManager.this.postNetState(networkState);
        }

        @Override
        public void onLost(Network network) {
            super.onLost(network);
            NetworkMonitorManager.this.postNetState(NetworkState.NONE);
        }

        @Override
        public void onLosing(Network network, int i) {
            super.onLosing(network, i);
        }

        @Override
        public void onCapabilitiesChanged(Network network, NetworkCapabilities networkCapabilities) {
            super.onCapabilitiesChanged(network, networkCapabilities);
        }

        @Override
        public void onLinkPropertiesChanged(Network network, LinkProperties linkProperties) {
            super.onLinkPropertiesChanged(network, linkProperties);
        }

        @Override
        public void onUnavailable() {
            super.onUnavailable();
        }
    }

    public static int getAPNType(Context context) {
        if (context == null) {
            return 0;
        }
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService("connectivity");
        NetworkInfo activeNetworkInfo = connectivityManager != null ? connectivityManager.getActiveNetworkInfo() : null;
        if (activeNetworkInfo == null) {
            return 0;
        }
        int type = activeNetworkInfo.getType();
        if (type == 1) {
            return 1;
        }
        if (type != 0) {
            return 0;
        }
        int subtype = activeNetworkInfo.getSubtype();
        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService("phone");
        if (telephonyManager == null) {
            return 0;
        }
        if (subtype == 13 && !telephonyManager.isNetworkRoaming()) {
            return 4;
        }
        if (subtype == 3 || subtype == 8) {
            return 3;
        }
        if (subtype == 5 && !telephonyManager.isNetworkRoaming()) {
            return 3;
        }
        if (subtype == 1 || subtype == 2 || subtype != 4) {
            return 2;
        }
        telephonyManager.isNetworkRoaming();
        return 2;
    }
}
