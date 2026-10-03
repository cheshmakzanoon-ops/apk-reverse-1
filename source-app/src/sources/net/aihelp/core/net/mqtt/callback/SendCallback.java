package net.aihelp.core.net.mqtt.callback;

import net.aihelp.core.net.mqtt.client.Callback;
import net.aihelp.core.util.logger.AIHelpLogger;
import net.aihelp.utils.TLog;

public class SendCallback implements Callback<Void> {
    @Override
    public void onSuccess(Void r1) {
        TLog.m138d("AIHelp MQTT send message successfully");
    }

    @Override
    public void onFailure(Throwable th) {
        AIHelpLogger.error("mqtt publish failure", th);
    }
}
