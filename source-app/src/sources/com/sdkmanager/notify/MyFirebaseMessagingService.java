package com.sdkmanager.notify;

import android.app.NotificationManager;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.sdkmanager.FireBaseController;
import com.unity3d.player.C1087R;
import org.json.JSONObject;

public class MyFirebaseMessagingService extends FirebaseMessagingService {
    private static final String TAG = "LF-Unity";

    private void scheduleJob() {
    }

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        Log.d(TAG, "From: " + remoteMessage.getFrom());
        if (remoteMessage.getData().size() == 0) {
            return;
        }
        Intent intent = new Intent();
        try {
            JSONObject jSONObject = new JSONObject(remoteMessage.getData());
            String string = jSONObject.has(LocalNotificationManager.PUSH_MSG) ? jSONObject.getString(LocalNotificationManager.PUSH_MSG) : "";
            if (string != null && !TextUtils.isEmpty(string)) {
                String string2 = jSONObject.has(LocalNotificationManager.PUSH_PLAYER_MARK) ? jSONObject.getString(LocalNotificationManager.PUSH_PLAYER_MARK) : "";
                String string3 = jSONObject.has(LocalNotificationManager.PUSH_TAG) ? jSONObject.getString(LocalNotificationManager.PUSH_TAG) : "";
                String string4 = jSONObject.has("pushId") ? jSONObject.getString("pushId") : "";
                String string5 = jSONObject.has("uid") ? jSONObject.getString("uid") : "";
                String string6 = getString(C1087R.string.app_name);
                intent.putExtra(LocalNotificationManager.BODY, string.trim());
                intent.putExtra(LocalNotificationManager.PUSH_TAG, string3);
                intent.putExtra(LocalNotificationManager.PUSH_ID, string4);
                intent.putExtra(LocalNotificationManager.PUSH_TIME, String.valueOf(System.currentTimeMillis()));
                intent.putExtra(LocalNotificationManager.TITLE, string6);
                intent.putExtra(LocalNotificationManager.ICON_RESOURCE, C1087R.drawable.app_icon);
                intent.putExtra(LocalNotificationManager.MAIN_ACTIVITY_CLASS_NAME_KEY, LocalNotificationManager.MAIN_ACTIVITY_CLASS_NAME);
                intent.setAction(LocalNotificationManager.MAIN_ACTIVITY_CLASS_NAME);
                if (jSONObject.has("clearall")) {
                    ((NotificationManager) getSystemService("notification")).cancelAll();
                }
                new PushRecordManager(this).RecordToHttp("fcm", string5, string3, string2, string4);
                new LocalNotificationManager(this).fireNotificationNew(this, intent);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onNewToken(String str) {
        Log.d(TAG, "Refreshed token: " + str);
        sendRegistrationToServer(str);
    }

    private void handleNow() {
        Log.d(TAG, "Short lived task is done.");
    }

    private void sendRegistrationToServer(String str) {
        try {
            FireBaseController.getInstance().ChangeToken(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
