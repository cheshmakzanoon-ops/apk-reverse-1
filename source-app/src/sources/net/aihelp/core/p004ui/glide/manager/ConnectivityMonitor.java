package net.aihelp.core.p004ui.glide.manager;

public interface ConnectivityMonitor extends LifecycleListener {

    public interface ConnectivityListener {
        void onConnectivityChanged(boolean z);
    }
}
