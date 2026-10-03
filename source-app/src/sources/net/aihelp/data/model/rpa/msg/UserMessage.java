package net.aihelp.data.model.rpa.msg;

import android.webkit.MimeTypeMap;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.utils.RegexDefinition;
import org.json.JSONArray;
import org.json.JSONObject;

public class UserMessage extends Message {
    public static final int INPUT_FORMAT_ATTACHMENT = 4;
    public static final int INPUT_FORMAT_BUTTON = 2;
    public static final int INPUT_FORMAT_DATE = 3;
    public static final int INPUT_FORMAT_INTENT = 5;
    public static final int INPUT_FORMAT_TEXT = 1;
    public static final int INPUT_SOURCE_ACTION = 2;
    public static final int INPUT_SOURCE_ANSWER_BOT = 6;
    public static final int INPUT_SOURCE_DATE = 3;
    public static final int INPUT_SOURCE_INPUT = 1;
    public static final int INPUT_SOURCE_INTENT = 8;
    public static final int INPUT_SOURCE_RPA_FAQ = 5;
    public static final int INPUT_SOURCE_SELF_SERVICE = 4;
    public static final int INPUT_SOURCE_SKIP = 7;

    @Override
    public void setContent(String str) {
        if (":aihelp-faq-helpful:".equals(str) || ":aihelp-faq-unhelpful:".equals(str)) {
            super.setContent(str);
            setMsgType(13);
            return;
        }
        if (Pattern.compile(".*?\\.(zip|json|xlsx)").matcher(str).matches()) {
            super.setContent(str);
            setMsgType(14);
            return;
        }
        Matcher matcher = Pattern.compile(RegexDefinition.REGEX_IMAGE).matcher(str);
        Matcher matcher2 = Pattern.compile(RegexDefinition.REGEX_VIDEO).matcher(str);
        if (!matcher.matches() && !matcher2.matches()) {
            while (matcher.find()) {
                str = str.replace(matcher.group(), "");
            }
            Matcher matcher3 = Pattern.compile(RegexDefinition.REGEX_VIDEO).matcher(str);
            while (matcher3.find()) {
                str = str.replace(matcher3.group(), "");
            }
            super.setContent(str.replace(";", ""));
            setMsgType(10);
        }
        setMsgStatus(1);
    }

    public void setRequestParams(String str, int i, int i2) {
        super.setRequestParams(getRequestParams(str, i, i2));
    }

    public void setRequestParams(String str, boolean z, int i, String str2, int i2) {
        super.setRequestParams(getRequestParams(str, z, i, str2, i2));
    }

    public static JSONObject getRequestParams(String str, int i, int i2) {
        return getRequestParams(str, false, i, "", i2);
    }

    public static JSONObject getRequestParams(String str, boolean z, int i, String str2, int i2) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("input", str);
            jSONObject.put("skip", z);
            jSONObject.put("inputFormat", i);
            jSONObject.put("inputData", str2);
            jSONObject.put("inputSource", i2);
            jSONObject.put("eventId", UUID.randomUUID().toString().replace("-", ""));
            return jSONObject;
        } catch (Exception unused) {
            return new JSONObject();
        }
    }

    public static JSONObject getRequestParams(String str, String str2, long j, float f, float f2) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("input", "");
            jSONObject.put("skip", false);
            jSONObject.put("inputFormat", 4);
            jSONObject.put("inputData", "");
            jSONObject.put("eventId", UUID.randomUUID().toString().replace("-", ""));
            JSONArray jSONArray = new JSONArray();
            JSONObject jSONObject2 = new JSONObject();
            jSONObject2.put("url", str);
            jSONObject2.put("filename", str2);
            jSONObject2.put("size", j);
            jSONObject2.put("width", f);
            jSONObject2.put("height", f2);
            jSONObject2.put("type", MimeTypeMap.getFileExtensionFromUrl(str));
            jSONArray.put(jSONObject2);
            jSONObject.put("attachments", jSONArray);
            return jSONObject;
        } catch (Exception unused) {
            return new JSONObject();
        }
    }
}
