package com.sdkmanager.notify;

import android.util.Log;
import com.sdkmanager.utils.HttpRequester;
import java.util.HashMap;

public class RecordHttpUtil {
    private static final String FCM_RECEIVE_URL = "http://analyse-aps.readygo.tech/postback.php";
    private static final String HTTP_URL = "http://analyse-aps.readygo.tech/clientevent.php";

    public void recordFCMNew(HashMap<String, String> map) {
    }

    public void recordFCMrecive(String str) {
        try {
            HttpRequester.post("http://analyse-aps.readygo.tech/postback.php?param=" + str, null, 3000, 3000, "UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void recordHttp(final String str) {
        Log.d(">>>lsz url: ", "http://analyse-aps.readygo.tech/clientevent.php?param=" + str);
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    HttpRequester.post("http://analyse-aps.readygo.tech/clientevent.php?param=" + str, null, 3000, 3000, "UTF-8");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }
}
