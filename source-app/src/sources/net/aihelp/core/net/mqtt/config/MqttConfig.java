package net.aihelp.core.net.mqtt.config;

import android.text.TextUtils;
import java.net.URI;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;
import kotlin.UByte;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.UserProfile;
import net.aihelp.core.net.mqtt.AIHelpMqtt;
import net.aihelp.core.net.mqtt.client.CallbackConnection;
import net.aihelp.core.net.mqtt.client.MQTT;
import net.aihelp.core.net.mqtt.client.QoS;
import net.aihelp.core.net.mqtt.client.Topic;
import net.aihelp.utils.TLog;

public class MqttConfig {
    public static final int TYPE_CONNECTION_LOGIN = 1;
    public static final int TYPE_CONNECTION_RECONNECT = 2;
    public static final int TYPE_CONVERSATION = 2;
    public static final int TYPE_ELVA_BOT = 1;
    public static final int TYPE_FAQ = 3;
    public static final int TYPE_RPA = 4;
    private int loginType;
    private StringBuilder mqConfig;

    public int getLoginType() {
        return this.loginType;
    }

    public void setLoginType(int i) {
        this.loginType = i;
    }

    public boolean isConnected() {
        return AIHelpMqtt.getInstance().isConnected();
    }

    public CallbackConnection getMqttConnection(boolean z, int i) {
        int i2;
        MQTT mqtt = new MQTT();
        try {
            this.mqConfig = new StringBuilder();
            String str = z ? API.MQTT_FAQ_IP : API.MQTT_IP;
            String str2 = "1883";
            if (z) {
                if (!TextUtils.isEmpty(API.MQTT_FAQ_PORT)) {
                    str2 = API.MQTT_FAQ_PORT;
                }
                i2 = Integer.parseInt(str2);
            } else {
                if (!TextUtils.isEmpty(API.MQTT_PORT)) {
                    str2 = API.MQTT_PORT;
                }
                i2 = Integer.parseInt(str2);
            }
            if (Const.TOGGLE_MQTT_TLS) {
                mqtt.setHost(new URI(String.format("tls://%s:%s", str, Integer.valueOf(i2))));
            } else {
                mqtt.setHost(str, i2);
            }
            this.mqConfig.append(String.format("%s:%s, ", str, Integer.valueOf(i2)));
            mqtt.setWillQos(QoS.AT_MOST_ONCE);
            mqtt.setUserName(Const.APP_ID);
            mqtt.setPassword(md5(Const.APP_ID));
            this.mqConfig.append(String.format("userName:%s, pwd: %s, ", Const.APP_ID, md5(Const.APP_ID)));
            String str3 = "android_" + UUID.randomUUID();
            if (z) {
                str3 = str3 + "_faq";
            }
            mqtt.setClientId(str3);
            this.mqConfig.append(String.format("clientId:%s", str3));
            mqtt.setConnectAttemptsMax(5L);
            mqtt.setReconnectAttemptsMax(5L);
            TLog.m138d("mqConfig: " + this.mqConfig.toString());
        } catch (Exception unused) {
        }
        CallbackConnection callbackConnection = mqtt.callbackConnection();
        callbackConnection.setIdentifier(i);
        return callbackConnection;
    }

    public Topic[] getTopic(boolean z) {
        return z ? new Topic[]{new Topic(String.format("elva/%s/%s/%s/%s", API.MQTT_TOPIC, Const.APP_ID, UserProfile.USER_ID, API.TOPIC_FAQ_NOTIFICATION), QoS.AT_MOST_ONCE)} : getNormalTopics();
    }

    private Topic[] getNormalTopics() {
        String[] strArr = {API.TOPIC_CONVERSATION_RECEIVE, API.TOPIC_CONVERSATION_FINISHED, API.TOPIC_SUBMIT_FORM, API.TOPIC_WITHDRAW, API.TOPIC_TICKET_REJECTED, API.TOPIC_NOTIFICATION};
        Topic[] topicArr = new Topic[6];
        for (int i = 0; i < 6; i++) {
            topicArr[i] = new Topic(String.format("elva/%s/%s/%s/%s", API.MQTT_TOPIC, Const.APP_ID, UserProfile.USER_ID, strArr[i]), QoS.AT_MOST_ONCE);
        }
        return topicArr;
    }

    public static String newTopic(String str) {
        return String.format("%s/%s/%s/%s", API.MQTT_TOPIC, Const.APP_ID, UserProfile.USER_ID, str);
    }

    private String md5(String str) {
        if (!TextUtils.isEmpty(str)) {
            try {
                byte[] bArrDigest = MessageDigest.getInstance("MD5").digest(str.getBytes(Charset.forName("UTF-8")));
                StringBuilder sb = new StringBuilder(bArrDigest.length * 2);
                for (byte b : bArrDigest) {
                    int i = b & UByte.MAX_VALUE;
                    if (i < 16) {
                        sb.append("0");
                    }
                    sb.append(Integer.toHexString(i));
                }
                return sb.toString();
            } catch (NoSuchAlgorithmException e) {
                TLog.m138d("RuntimeException Huh, MD5 should be supported? " + e.toString());
                return str;
            }
        }
        return "";
    }

    public String getMqConfig() {
        return this.mqConfig.toString();
    }

    private MqttConfig() {
        this.mqConfig = new StringBuilder();
    }

    public static MqttConfig getInstance() {
        return Holder.INSTANCE;
    }

    private static class Holder {
        private static final MqttConfig INSTANCE = new MqttConfig();

        private Holder() {
        }
    }
}
