package net.aihelp.p007ui.p009cs.util.rpa.factory;

import android.text.TextUtils;
import java.util.regex.Pattern;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.model.rpa.msg.FileMessage;
import net.aihelp.utils.RegexDefinition;
import org.json.JSONArray;
import org.json.JSONObject;

public class MessageFactory {
    public static String getPeeledContent(String str) {
        try {
            return JsonHelper.optString(new JSONObject(JsonHelper.optString(new JSONObject(str), "content")), "reply");
        } catch (Exception unused) {
            return str;
        }
    }

    public static boolean isAgentMsg(String str) {
        try {
            JSONObject jSONObject = new JSONObject(str);
            return jSONObject.optInt("usertype") == 0 && jSONObject.isNull("bot") && !TextUtils.isEmpty(JsonHelper.optString(jSONObject, "msg"));
        } catch (Exception unused) {
            return false;
        }
    }

    protected static JSONObject getContentObject(JSONObject jSONObject) {
        if (JsonHelper.hasKey(jSONObject, "content")) {
            try {
                return new JSONObject(JsonHelper.optString(jSONObject, "content"));
            } catch (Exception unused) {
            }
        }
        return jSONObject == null ? new JSONObject() : jSONObject;
    }

    protected static int getMessageType(JSONObject jSONObject) {
        try {
            return jSONObject.optInt("type");
        } catch (Exception unused) {
            return -1;
        }
    }

    public static FileMessage getAttachmentMessage(String str, int i) {
        String str2 = (String) getAttachmentContent(str, "url", "");
        String str3 = (String) getAttachmentContent(str, "filename", "");
        int iIntValue = ((Integer) getAttachmentContent(str, "size", 0)).intValue();
        FileMessage fileMessage = new FileMessage(i, str2);
        fileMessage.setFileInfo(str3, iIntValue);
        fileMessage.setNormalMessage(true);
        return fileMessage;
    }

    public static <T> T getAttachmentContent(String str, String str2, T t) {
        return (T) getAttachmentContent(str, 0, str2, t);
    }

    public static <T> T getAttachmentContent(String str, int i, String str2, T t) {
        T t2;
        JSONArray jsonArray = JsonHelper.getJsonArray(getContentObject(JsonHelper.getJsonObject(str)), "attachments");
        if (jsonArray.length() <= 0 || i > jsonArray.length() - 1 || (t2 = (T) JsonHelper.getJsonObject(jsonArray, i).opt(str2)) == null) {
            return t;
        }
        return ((t instanceof String) && t2.toString().equals(JSONObject.NULL.toString())) ? t : t2;
    }

    public static boolean isAttachmentImage(String str) {
        if (!hasOnlyOneAttachment(str) || !TextUtils.isEmpty(getPeeledContent(str))) {
            return false;
        }
        return Pattern.compile(RegexDefinition.ANDROID_SUPPORTED_IMAGE_SUFFIX).matcher((String) getAttachmentContent(str, "type", "")).matches();
    }

    public static boolean isAttachmentVideo(String str) {
        if (!hasOnlyOneAttachment(str) || !TextUtils.isEmpty(getPeeledContent(str))) {
            return false;
        }
        return Pattern.compile(RegexDefinition.ANDROID_SUPPORTED_VIDEO_SUFFIX).matcher((String) getAttachmentContent(str, "type", "")).matches();
    }

    private static int sizeOfAttachments(String str) {
        return JsonHelper.getJsonArray(getContentObject(JsonHelper.getJsonObject(str)), "attachments").length();
    }

    public static boolean hasOnlyOneAttachment(String str) {
        return sizeOfAttachments(str) == 1;
    }

    public static boolean hasAtLeastNAttachments(String str, int i) {
        return sizeOfAttachments(str) >= i;
    }
}
