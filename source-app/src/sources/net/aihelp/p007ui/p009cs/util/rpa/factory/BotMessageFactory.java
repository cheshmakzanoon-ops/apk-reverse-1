package net.aihelp.p007ui.p009cs.util.rpa.factory;

import android.text.TextUtils;
import java.util.ArrayList;
import java.util.List;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.model.rpa.msg.BotMessage;
import net.aihelp.data.model.rpa.msg.bot.Answer;
import net.aihelp.data.model.rpa.msg.bot.ExternalUrl;
import net.aihelp.data.model.rpa.msg.bot.Faq;
import net.aihelp.data.model.rpa.msg.bot.FormUrl;
import net.aihelp.data.model.rpa.msg.bot.SelfService;
import org.json.JSONArray;
import org.json.JSONObject;
import zendesk.faye.internal.Bayeux;

public class BotMessageFactory extends MessageFactory {
    private static final int BOT_REPLY_TYPE_ATTACHMENT = 2;
    private static final int BOT_REPLY_TYPE_EXTERNAL_URL = 3;
    private static final int BOT_REPLY_TYPE_FAQ = 4;
    private static final int BOT_REPLY_TYPE_FORM_CONTENT = 1;
    private static final int BOT_REPLY_TYPE_FORM_URL = 6;
    private static final int BOT_REPLY_TYPE_SELF_SERVICE = 5;
    private static final int BOT_REPLY_TYPE_TEXT = 0;

    public static BotMessage getHistoricBotMessage(String str, long j, String str2, int i) {
        JSONObject jsonObject = JsonHelper.getJsonObject(str);
        BotMessage botMessage = new BotMessage(str2);
        botMessage.setTimestamp(j);
        botMessage.setContent(getPeeledContent(str));
        botMessage.setExternalUrl(getHistoryExternalUrl(jsonObject));
        botMessage.setFaq(getHistoryFaq(jsonObject));
        botMessage.setSelfService(getHistorySelfService(jsonObject));
        botMessage.setBotAnswers(getHistoryBotAnswers(jsonObject, i));
        botMessage.setUserFeedback(getHistoryUserFeedback(jsonObject, i));
        return botMessage;
    }

    public static BotMessage getResponseBotMessage(JSONObject jSONObject, long j, String str) {
        int iOptInt = jSONObject.optInt("status", -1);
        JSONObject jsonObject = JsonHelper.getJsonObject(jSONObject, "reply");
        BotMessage botMessage = new BotMessage(str);
        boolean z = true;
        botMessage.setNormalMessage(iOptInt == 1001);
        if (iOptInt != 1001 && iOptInt != 1002) {
            z = false;
        }
        botMessage.setDuringRPAProcedure(z);
        botMessage.setTimestamp(j);
        botMessage.setContent(getBotContent(jsonObject));
        botMessage.setFormUrl(getFormUrl(jsonObject));
        botMessage.setExternalUrl(getExternalUrl(jsonObject));
        botMessage.setFaq(getRPAFaq(jsonObject, botMessage));
        botMessage.setSelfService(getSelfService(jsonObject));
        botMessage.setBotAnswers(getBotAnswers(jsonObject));
        return botMessage;
    }

    public static <T> T getAttachmentContent(String str, String str2, T t) {
        JSONArray jsonArray = JsonHelper.getJsonArray(getContentObject(JsonHelper.getJsonObject(str)), "attachments");
        return jsonArray.length() > 0 ? (T) JsonHelper.opt(JsonHelper.getJsonObject(jsonArray, 0), str2, t) : t;
    }

    public static String getBotContent(JSONObject jSONObject) {
        return JsonHelper.optString(jSONObject, "botReply");
    }

    public static Faq getHistoryFaq(JSONObject jSONObject) {
        return _getFaq(JsonHelper.getJsonArray(getContentObject(jSONObject), "faqList"), false);
    }

    public static Faq getRPAFaq(JSONObject jSONObject, BotMessage botMessage) {
        JSONObject jsonObject = JsonHelper.getJsonObject(jSONObject, "faqData");
        String strOptString = JsonHelper.optString(jsonObject, "msg");
        if (!TextUtils.isEmpty(strOptString) && TextUtils.isEmpty(botMessage.getContent())) {
            botMessage.setContent(strOptString);
        }
        return _getFaq(JsonHelper.getJsonArray(jsonObject, "reply"), jsonObject.optInt("isSimilarMatch") == 1);
    }

    private static Faq _getFaq(JSONArray jSONArray, boolean z) {
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < jSONArray.length(); i++) {
            arrayList.add(getFaqData(JsonHelper.getJsonObject(jSONArray, i), 1));
        }
        return new Faq(z, arrayList);
    }

    public static Faq.FaqData getFaqData(JSONObject jSONObject, int i) {
        long jOptLong = jSONObject.optLong("mainId");
        long jOptLong2 = jSONObject.optLong("contentId");
        String strOptString = JsonHelper.optString(jSONObject, "faqTitle");
        String strOptString2 = JsonHelper.optString(jSONObject, "faqContent");
        String strOptString3 = JsonHelper.optString(jSONObject, "template");
        JSONObject jsonObject = JsonHelper.getJsonObject(jSONObject, "form");
        return new Faq.FaqData(i, jOptLong, jOptLong2, strOptString, strOptString2, strOptString3, JsonHelper.optString(jsonObject, "url"), JsonHelper.optString(jsonObject, "title"), jsonObject.optBoolean("isSimilarMatch"), jSONObject.optBoolean("isShowMore", false));
    }

    public static SelfService getHistorySelfService(JSONObject jSONObject) {
        JSONObject contentObject = getContentObject(jSONObject);
        return new SelfService(contentObject.optInt("allowSend") == 1, getSelfServiceData(JsonHelper.getJsonArray(contentObject, "apiData")));
    }

    public static SelfService getSelfService(JSONObject jSONObject) {
        JSONObject jsonObject = JsonHelper.getJsonObject(jSONObject, "apiData");
        return new SelfService(jsonObject.optInt("allowSend") == 1, getSelfServiceData(JsonHelper.getJsonArray(jsonObject, "rows")));
    }

    public static String getSelfServiceData(JSONArray jSONArray) {
        JSONArray jSONArray2 = new JSONArray();
        for (int i = 0; i < jSONArray.length(); i++) {
            JSONArray jsonArray = JsonHelper.getJsonArray(JsonHelper.getJsonObject(jSONArray, i), "row");
            try {
                JSONObject jSONObject = new JSONObject();
                for (int i2 = 0; i2 < jsonArray.length(); i2++) {
                    JSONObject jsonObject = JsonHelper.getJsonObject(jsonArray, i2);
                    jSONObject.put(JsonHelper.optString(jsonObject, "key"), jsonObject.opt("value"));
                }
                jSONArray2.put(jSONObject);
            } catch (Exception unused) {
            }
        }
        return jSONArray2.toString();
    }

    public static FormUrl getHistoryFormUrl(JSONObject jSONObject) {
        JSONObject contentObject = getContentObject(jSONObject);
        try {
            contentObject.put("msgType", 1);
        } catch (Exception unused) {
        }
        if (getMessageType(jSONObject) == 6) {
            return getFormUrl(contentObject);
        }
        return null;
    }

    public static FormUrl getFormUrl(JSONObject jSONObject) {
        boolean z = jSONObject.optInt("msgType") == 1;
        String strOptString = JsonHelper.optString(jSONObject, "title");
        String strOptString2 = JsonHelper.optString(jSONObject, "url");
        if (z) {
            return new FormUrl(strOptString, strOptString2);
        }
        return null;
    }

    public static ExternalUrl getHistoryExternalUrl(JSONObject jSONObject) {
        JSONObject contentObject = getContentObject(jSONObject);
        if (getMessageType(jSONObject) == 3) {
            return getExternalUrl(contentObject);
        }
        return null;
    }

    public static ExternalUrl getExternalUrl(JSONObject jSONObject) {
        boolean z = jSONObject.optInt("msgType") != 1;
        String strOptString = JsonHelper.optString(jSONObject, "title");
        String strOptString2 = JsonHelper.optString(jSONObject, "url");
        if (z) {
            return new ExternalUrl(strOptString, strOptString2);
        }
        return null;
    }

    public static List<Answer> getHistoryBotAnswers(JSONObject jSONObject, int i) {
        ArrayList arrayList = new ArrayList();
        JSONArray jsonArray = JsonHelper.getJsonArray(getContentObject(jSONObject), "answerData");
        for (int i2 = 0; i2 < jsonArray.length(); i2++) {
            JSONObject jsonObject = JsonHelper.getJsonObject(jsonArray, i2);
            Answer answer = new Answer(jsonObject.optInt("type"), JsonHelper.optString(jsonObject, "answerTitle"));
            answer.setFaqData(getFaqData(JsonHelper.getJsonObject(jsonObject, Bayeux.KEY_DATA), 2));
            arrayList.add(answer);
        }
        return arrayList;
    }

    public static List<Answer> getBotAnswers(JSONObject jSONObject) {
        ArrayList arrayList = new ArrayList();
        JSONArray jsonArray = JsonHelper.getJsonArray(jSONObject, "answerData");
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = JsonHelper.getJsonObject(jsonArray, i);
            Answer answer = new Answer(jsonObject.optInt("type"), JsonHelper.optString(jsonObject, "answerTitle"));
            answer.setFaqData(getFaqData(JsonHelper.getJsonObject(jsonObject, Bayeux.KEY_DATA), 2));
            arrayList.add(answer);
        }
        return arrayList;
    }

    public static int getHistoryUserFeedback(JSONObject jSONObject, int i) {
        int iOptInt = jSONObject.optInt("feedback");
        if (i == 2 && iOptInt == 0) {
            return -1;
        }
        return iOptInt;
    }
}
