package net.aihelp.p007ui.p009cs.util.rpa.helper;

import android.text.TextUtils;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Pattern;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.model.p005cs.ChatInfoEntity;
import org.json.JSONArray;
import org.json.JSONObject;

public class ChatInfoHelper {
    private static final int CUSTOMER_TYPE_AGENT = 0;
    private static final int CUSTOMER_TYPE_BOT = 1;
    private static final int MESSAGE_FROM_AGENT_OR_BOT = 2;
    private static final int MESSAGE_FROM_USER = 1;
    private static String assigneeInfo;

    private static List<ChatInfoEntity> getListForLoginAndPoll(String str) {
        ArrayList arrayList = new ArrayList();
        Pattern patternCompile = Pattern.compile("[0-9]*");
        JSONObject jsonObject = JsonHelper.getJsonObject(str);
        Iterator<String> itKeys = jsonObject.keys();
        while (itKeys.hasNext()) {
            String next = itKeys.next();
            if ("assigneeinfo".equals(next)) {
                assigneeInfo = jsonObject.optString("assigneeinfo");
            } else if (CustomConfig.CustomerService.isMessageTimestampVisible && "chatTimestamp".equals(next)) {
                prepareTimeStampMessageForLogin(arrayList, jsonObject.optString("chatTimestamp"));
            } else {
                String[] strArrSplit = next.split("\\|");
                if (patternCompile.matcher(strArrSplit[0]).matches()) {
                    ChatInfoEntity chatInfoEntity = new ChatInfoEntity();
                    chatInfoEntity.setTimeStamp(Long.parseLong(strArrSplit[0]));
                    if (strArrSplit.length == 2) {
                        String str2 = strArrSplit[1];
                        chatInfoEntity.setMsgType("Bot".equals(str2) ? 3 : 4);
                        chatInfoEntity.setAgentName(str2);
                    } else {
                        chatInfoEntity.setMsgType(2);
                        chatInfoEntity.setAgentName("");
                    }
                    chatInfoEntity.setMessage(jsonObject.optString(getConversationJSONObjectKey(chatInfoEntity)));
                    arrayList.add(chatInfoEntity);
                }
            }
        }
        Collections.sort(arrayList);
        return arrayList;
    }

    public static void prepareTimeStampMessageForLogin(ArrayList<ChatInfoEntity> arrayList, String str) {
        if (TextUtils.isEmpty(str)) {
            return;
        }
        for (String str2 : str.split(",")) {
            if (Pattern.compile("[0-9]*").matcher(str2).matches()) {
                ChatInfoEntity chatInfoEntity = new ChatInfoEntity();
                chatInfoEntity.setMsgType(1);
                chatInfoEntity.setTimeStamp(Long.parseLong(str2) - 1);
                arrayList.add(chatInfoEntity);
            }
        }
    }

    public static void prepareNickname(ChatInfoEntity chatInfoEntity) {
        int i;
        if (TextUtils.isEmpty(assigneeInfo)) {
            return;
        }
        try {
            JSONArray jSONArray = new JSONArray(assigneeInfo);
            if (jSONArray.length() > 0) {
                while (i < jSONArray.length()) {
                    JSONObject jSONObject = jSONArray.getJSONObject(i);
                    i = (chatInfoEntity.getUserId() == jSONObject.optInt("userid") || jSONObject.optString("username").equals(chatInfoEntity.getAgentName())) ? 0 : i + 1;
                    chatInfoEntity.setAgentNickname(JsonHelper.optString(jSONObject, "nickname"));
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String getConversationJSONObjectKey(ChatInfoEntity chatInfoEntity) {
        String strValueOf = String.valueOf(chatInfoEntity.getTimeStamp());
        if (TextUtils.isEmpty(chatInfoEntity.getAgentName())) {
            return strValueOf;
        }
        return strValueOf + "|" + chatInfoEntity.getAgentName();
    }

    private static List<ChatInfoEntity> getListForRefresh(String str) {
        ArrayList arrayList = new ArrayList();
        JSONArray jsonArray = JsonHelper.getJsonArray(str);
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = JsonHelper.getJsonObject(jsonArray, i);
            if (!jsonObject.optBoolean("isWithdraw")) {
                if (jsonObject.optBoolean("isShowTimeLine")) {
                    ChatInfoEntity chatInfoEntity = new ChatInfoEntity();
                    chatInfoEntity.setMsgType(1);
                    chatInfoEntity.setTimeStamp(jsonObject.optLong("messageTime", 0L) - 1);
                    arrayList.add(chatInfoEntity);
                }
                ChatInfoEntity chatInfoEntity2 = new ChatInfoEntity();
                chatInfoEntity2.setTimeStamp(jsonObject.optLong("messageTime", 0L));
                chatInfoEntity2.setAgentNickname(JsonHelper.optString(jsonObject, "customer"));
                chatInfoEntity2.setUserId(jsonObject.optInt("customerId", 0));
                chatInfoEntity2.setMessage(getMessageString(jsonObject));
                chatInfoEntity2.setMsgType(getMessageType(jsonObject));
                arrayList.add(chatInfoEntity2);
            }
        }
        Collections.sort(arrayList);
        return arrayList;
    }

    private static String getMessageString(JSONObject jSONObject) {
        JSONObject jSONObject2 = new JSONObject();
        try {
            jSONObject2.put("content", JsonHelper.optString(jSONObject, "message"));
            jSONObject2.put("type", JsonHelper.opt(jSONObject, "messageType", -1));
            jSONObject2.put("feedback", jSONObject.optInt("feedback"));
        } catch (Exception unused) {
        }
        return jSONObject2.toString();
    }

    private static int getMessageType(JSONObject jSONObject) {
        int iOptInt = jSONObject.optInt("messageFrom");
        if (iOptInt == 1) {
            return 2;
        }
        if (iOptInt != 2) {
            return 1;
        }
        return jSONObject.optInt("customerType") == 0 ? 4 : 3;
    }

    public static List<ChatInfoEntity> getChatInfoList(String str, int i) {
        if (i != 1) {
            if (i == 2) {
                return getListForRefresh(str);
            }
            if (i != 3) {
                return new ArrayList();
            }
        }
        return getListForLoginAndPoll(str);
    }
}
