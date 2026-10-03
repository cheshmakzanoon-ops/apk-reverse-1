package net.aihelp.core.net.mqtt.callback;

import net.aihelp.core.net.mqtt.AIHelpMqtt;
import net.aihelp.core.net.mqtt.client.Callback;

public class SubscribeCallback implements Callback<byte[]> {
    private final int connectionId;
    private final int connectionType;
    private final boolean isFaqRequest;
    private final IMqttCallback mqttCallback;

    public SubscribeCallback(boolean z, IMqttCallback iMqttCallback, int i, int i2) {
        this.isFaqRequest = z;
        this.mqttCallback = iMqttCallback;
        this.connectionId = i;
        this.connectionType = i2;
    }

    @Override
    public void onSuccess(byte[] bArr) {
        if (!this.isFaqRequest && this.connectionId == AIHelpMqtt.getInstance().getMqttConnectionId()) {
            this.mqttCallback.dismissMqttLoading();
            this.mqttCallback.onMqttSubscribed(this.connectionType);
        }
    }

    @Override
    public void onFailure(Throwable th) {
        IMqttCallback iMqttCallback;
        if (this.connectionId != AIHelpMqtt.getInstance().getMqttConnectionId() || (iMqttCallback = this.mqttCallback) == null) {
            return;
        }
        iMqttCallback.onMqttFailure();
    }
}
