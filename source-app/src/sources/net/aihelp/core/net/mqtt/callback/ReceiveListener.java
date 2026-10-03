package net.aihelp.core.net.mqtt.callback;

import net.aihelp.core.net.mqtt.AIHelpMqtt;
import net.aihelp.core.net.mqtt.client.Listener;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.utils.TLog;

public class ReceiveListener implements Listener {
    private final IMqttCallback callback;
    private final int connectionId;
    private final boolean isFaq;

    public ReceiveListener(boolean z, IMqttCallback iMqttCallback, int i) {
        this.isFaq = z;
        this.callback = iMqttCallback;
        this.connectionId = i;
    }

    @Override
    public void onConnected() {
        if (this.connectionId == AIHelpMqtt.getInstance().getMqttConnectionId()) {
            this.callback.onMqttConnected();
        }
    }

    @Override
    public void onDisconnected() {
        if (this.connectionId == AIHelpMqtt.getInstance().getMqttConnectionId()) {
            AIHelpMqtt.getInstance().disconnect();
            this.callback.onMqttDisconnected();
        }
    }

    @Override
    public void onPublish(UTF8Buffer uTF8Buffer, Buffer buffer, Runnable runnable) {
        if (this.isFaq || this.connectionId == AIHelpMqtt.getInstance().getMqttConnectionId()) {
            if (this.callback != null) {
                String[] strArrSplit = uTF8Buffer.toString().split("/");
                final String str = strArrSplit[strArrSplit.length - 1];
                final String strTrim = new String(buffer.toByteArray()).trim();
                TLog.json(String.format("MQTT %s [onResponse] %s", toString().replace(getClass().getName(), getClass().getSimpleName()), str), strTrim);
                ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        ReceiveListener.this.callback.onMqttResponse(str, strTrim);
                    }
                });
            }
            runnable.run();
        }
    }

    @Override
    public void onFailure(Throwable th) {
        IMqttCallback iMqttCallback;
        if (this.connectionId != AIHelpMqtt.getInstance().getMqttConnectionId() || (iMqttCallback = this.callback) == null) {
            return;
        }
        iMqttCallback.onMqttFailure();
    }
}
