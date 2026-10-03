package net.aihelp.core.net.mqtt.callback;

import net.aihelp.core.net.mqtt.AIHelpMqtt;
import net.aihelp.core.net.mqtt.client.Callback;
import net.aihelp.core.util.logger.AIHelpLogger;

public class ConnectCallback implements Callback<Void> {
    private final IMqttCallback callback;
    private final int connectionId;
    private final boolean isFaq;

    public ConnectCallback(boolean z, IMqttCallback iMqttCallback, int i) {
        this.isFaq = z;
        this.callback = iMqttCallback;
        this.connectionId = i;
    }

    @Override
    public void onSuccess(Void r2) {
        IMqttCallback iMqttCallback;
        if (this.connectionId != AIHelpMqtt.getInstance().getMqttConnectionId() || this.isFaq || (iMqttCallback = this.callback) == null) {
            return;
        }
        iMqttCallback.onMqttConnected();
    }

    @Override
    public void onFailure(Throwable th) {
        IMqttCallback iMqttCallback;
        if (this.connectionId == AIHelpMqtt.getInstance().getMqttConnectionId()) {
            AIHelpLogger.error("mqtt connect failure", th);
            if (this.isFaq || (iMqttCallback = this.callback) == null) {
                return;
            }
            iMqttCallback.onMqttFailure();
        }
    }
}
