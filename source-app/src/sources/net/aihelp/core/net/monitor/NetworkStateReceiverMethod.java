package net.aihelp.core.net.monitor;

import java.lang.reflect.Method;

public class NetworkStateReceiverMethod {
    private Method method;
    private NetworkState[] networkState = {NetworkState.CELLULAR, NetworkState.WIFI, NetworkState.NONE};
    private Object object;

    public Method getMethod() {
        return this.method;
    }

    public void setMethod(Method method) {
        this.method = method;
    }

    public Object getObject() {
        return this.object;
    }

    public void setObject(Object obj) {
        this.object = obj;
    }

    public NetworkState[] getNetworkState() {
        return this.networkState;
    }

    public void setNetworkState(NetworkState[] networkStateArr) {
        this.networkState = networkStateArr;
    }
}
