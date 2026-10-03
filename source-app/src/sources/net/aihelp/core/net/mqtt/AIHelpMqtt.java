package net.aihelp.core.net.mqtt;

import android.os.Handler;
import android.os.Message;
import net.aihelp.core.net.mqtt.callback.ConnectCallback;
import net.aihelp.core.net.mqtt.callback.IMqttCallback;
import net.aihelp.core.net.mqtt.callback.ReceiveListener;
import net.aihelp.core.net.mqtt.callback.SubscribeCallback;
import net.aihelp.core.net.mqtt.client.CallbackConnection;
import net.aihelp.core.net.mqtt.config.MqttConfig;

public class AIHelpMqtt {
    private static ConnectingHandler mConnectingMonitor;
    private int connectionId;
    private int connectionType;
    private CallbackConnection faqMqttConnection;
    private CallbackConnection mqttConnection;

    public static class ConnectingHandler extends Handler {
        @Override
        public void handleMessage(Message message) {
        }
    }

    public int getMqttConnectionId() {
        return this.connectionId;
    }

    public void prepare(IMqttCallback iMqttCallback, int i) {
        this.connectionType = i;
        prepare(4, iMqttCallback);
    }

    public void prepare(int i, IMqttCallback iMqttCallback) {
        boolean z = i == 3;
        this.connectionId++;
        CallbackConnection mqttConnection = MqttConfig.getInstance().getMqttConnection(z, this.connectionId);
        this.mqttConnection = mqttConnection;
        mqttConnection.connect(new ConnectCallback(z, iMqttCallback, this.connectionId));
        this.mqttConnection.listener(new ReceiveListener(z, iMqttCallback, this.connectionId));
        this.mqttConnection.subscribe(MqttConfig.getInstance().getTopic(z), new SubscribeCallback(z, iMqttCallback, this.connectionId, this.connectionType));
        if (z) {
            onFaqDestroy();
            this.faqMqttConnection = this.mqttConnection;
        }
    }

    public void onFaqDestroy() {
        CallbackConnection callbackConnection = this.faqMqttConnection;
        if (callbackConnection != null) {
            callbackConnection.unregisterListener();
            this.faqMqttConnection.disconnect(null);
            this.faqMqttConnection = null;
        }
    }

    public void disconnect() {
        CallbackConnection callbackConnection = this.mqttConnection;
        if (callbackConnection == null || callbackConnection.getIdentifier() != this.connectionId) {
            return;
        }
        this.mqttConnection.unregisterListener();
        this.mqttConnection.disconnect(null);
        this.mqttConnection = null;
    }

    public boolean isConnected() {
        CallbackConnection callbackConnection = this.mqttConnection;
        return callbackConnection != null && callbackConnection.getIdentifier() == this.connectionId && this.mqttConnection.transport() != null && this.mqttConnection.transport().isConnected();
    }

    public CallbackConnection getMqttConnection() {
        return this.mqttConnection;
    }

    public static AIHelpMqtt getInstance() {
        return Holder.INSTANCE;
    }

    private static class Holder {
        private static final AIHelpMqtt INSTANCE = new AIHelpMqtt();

        private Holder() {
        }
    }

    private AIHelpMqtt() {
        mConnectingMonitor = new ConnectingHandler();
    }
}
