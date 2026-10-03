package net.aihelp.data.logic;

import android.text.TextUtils;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.SpKeys;
import net.aihelp.common.UserProfile;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.utils.SpUtil;
import org.json.JSONObject;

public class UnreadFetchHelper {

    public interface Callback {
        void onFetched(int i, int i2);
    }

    public static void fetchUnreadMessageCount(final Callback callback) {
        JSONObject jsonObject = JsonHelper.getJsonObject();
        JsonHelper.put(jsonObject, "appid", Const.APP_ID);
        JsonHelper.put(jsonObject, "uid", UserProfile.USER_ID);
        JsonHelper.put(jsonObject, "unreadMessageToken", getCachedMessageToken());
        AIHelpRequest.getInstance().requestGetByAsync(API.FETCH_NEW_MSG, jsonObject, new ReqCallback<String>() {
            @Override
            public void onReqSuccess(String str) {
                JSONObject jsonObject2 = JsonHelper.getJsonObject(str);
                Const.TOGGLE_FETCH_MESSAGE = jsonObject2.optBoolean("isHaveChat");
                int iOptInt = jsonObject2.optInt("cs_message_count");
                int iOptInt2 = jsonObject2.optInt("unreadMessageCount", -1);
                UnreadFetchHelper.cacheUnreadToken(jsonObject2.optString("unreadMessageToken"));
                UnreadFetchHelper.migrateUnreadCount();
                if (iOptInt2 < 0) {
                    iOptInt2 = Math.max(0, iOptInt - Math.max(0, SpUtil.getInstance().getInt(Const.UNREAD_MESSAGE_TOKEN)));
                }
                Callback callback2 = callback;
                if (callback2 != null) {
                    callback2.onFetched(iOptInt, iOptInt2);
                }
            }
        });
    }

    public static void onMessageCountArrived(int i) {
        if (Const.sMessageListener != null) {
            Const.sMessageListener.onMessageCountArrived(i);
        }
    }

    public static void cacheUnreadToken(String str) {
        if (TextUtils.equals(str, Const.UNREAD_MESSAGE_TOKEN)) {
            return;
        }
        Const.UNREAD_MESSAGE_TOKEN = str;
        SpUtil.getInstance().put(getCachedTokenKey(), str);
    }

    public static void migrateUnreadCount() {
        int i = SpUtil.getInstance().getInt(UserProfile.USER_ID, -1);
        if (i > 0) {
            SpUtil.getInstance().put(Const.UNREAD_MESSAGE_TOKEN, Integer.valueOf(i));
            SpUtil.getInstance().remove(UserProfile.USER_ID);
        }
    }

    private static String getCachedMessageToken() {
        String string = SpUtil.getInstance().getString(getCachedTokenKey());
        return TextUtils.isEmpty(string) ? "-1" : string;
    }

    private static String getCachedTokenKey() {
        return String.format("%s_%s", UserProfile.USER_ID, SpKeys.UNREAD_TOKEN);
    }
}
