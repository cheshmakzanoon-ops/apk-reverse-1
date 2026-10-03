package net.aihelp.p007ui.helper;

import java.util.LinkedList;
import net.aihelp.core.net.json.JsonHelper;
import org.json.JSONArray;
import org.json.JSONObject;

public class LogoutMqttHelper {
    public static final String LOGOUT_TYPE_ACTION_DISPLAY = "6";
    public static final String LOGOUT_TYPE_BOT_STUPID = "3";
    public static final String LOGOUT_TYPE_FAQ_DISPLAY = "5";
    public static final String LOGOUT_TYPE_FAQ_HELPFUL = "1";
    public static final String LOGOUT_TYPE_FAQ_UNHELPFUL = "2";
    public static final String LOGOUT_TYPE_FORM_DISPLAY = "4";
    public static final String LOGOUT_TYPE_FORM_GOTO_PAGE = "7";
    public static final String LOGOUT_TYPE_FORM_SUBMIT = "8";
    private static final LinkedList<String> sortedTypes = new LinkedList<>();
    private static final String LOGOUT_TYPE_DEFAULT = "0";
    private static String logoutType = LOGOUT_TYPE_DEFAULT;

    private static LinkedList<String> getPriorityTypes() {
        LinkedList<String> linkedList = sortedTypes;
        if (linkedList.size() == 0) {
            linkedList.add(LOGOUT_TYPE_DEFAULT);
            linkedList.add(LOGOUT_TYPE_ACTION_DISPLAY);
            linkedList.add("4");
            linkedList.add(LOGOUT_TYPE_FAQ_DISPLAY);
            linkedList.add("1");
            linkedList.add(LOGOUT_TYPE_FORM_SUBMIT);
            linkedList.add("2");
            linkedList.add("3");
            linkedList.add(LOGOUT_TYPE_FORM_GOTO_PAGE);
        }
        return linkedList;
    }

    public static void updateType(String str) {
        LinkedList<String> priorityTypes = getPriorityTypes();
        if (priorityTypes.indexOf(str) > priorityTypes.indexOf(logoutType)) {
            logoutType = str;
        }
    }

    public static String getLogoutType() {
        return logoutType;
    }

    public static void resetTypeWhenLogout() {
        logoutType = LOGOUT_TYPE_DEFAULT;
    }

    public static JSONArray getTagsFromMessageList(JSONArray jSONArray) {
        JSONArray jSONArray2 = new JSONArray();
        for (int i = 0; i < jSONArray.length(); i++) {
            JSONObject jsonObject = JsonHelper.getJsonObject(jSONArray, i);
            if (jsonObject.has("tags")) {
                JSONArray jsonArray = JsonHelper.getJsonArray(jsonObject, "tags");
                for (int i2 = 0; i2 < jsonArray.length(); i2++) {
                    jSONArray2.put(jsonArray.optJSONObject(i2));
                }
            }
        }
        return jSONArray2;
    }
}
