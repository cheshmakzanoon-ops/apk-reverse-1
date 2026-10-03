package net.aihelp.core.net.mqtt.callback;

import androidx.fragment.app.Fragment;

public interface IMqttCallback {
    void dismissMqttLoading();

    void onMqttConnected();

    void onMqttDisconnected();

    void onMqttFailure();

    void onMqttResponse(String str, String str2);

    void onMqttSubscribed(int i);

    void showMqttLoading();

    void updateHostView(Fragment fragment);
}
