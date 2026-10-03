package net.aihelp.p007ui.p009cs.util.rpa.helper;

import android.text.TextUtils;
import java.util.ArrayList;
import java.util.List;
import net.aihelp.BuildConfig;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.UserProfile;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.localize.config.FeedbackOpinionHelper;
import net.aihelp.data.logic.UnreadFetchHelper;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.step.RPAStep;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import net.aihelp.p007ui.p009cs.util.rpa.factory.AgentMessageFactory;
import net.aihelp.p007ui.p009cs.util.rpa.factory.BotMessageFactory;
import net.aihelp.p007ui.p009cs.util.rpa.factory.MessageFactory;
import net.aihelp.utils.DeviceInfoUtil;
import org.json.JSONArray;
import org.json.JSONObject;

public class ResponseHelper {
    public static final int RPA_PROCEDURE_AGENT_ALREADY_ASSIGNED = 2001;
    public static final int RPA_PROCEDURE_BOT_NORMAL = 1001;
    public static final int RPA_PROCEDURE_BOT_STOP_AND_WAIT = 1002;
    public static final int RPA_PROCEDURE_TICKET_CREATED = 1;
    public static final int RPA_PROCEDURE_TICKET_RESET = 2;

    public static Message getRPAMessage(String str) {
        if (TextUtils.isEmpty(str)) {
            Message message = new Message(3);
            message.setNormalMessage(false);
            return message;
        }
        try {
            JSONObject jSONObject = new JSONObject(str);
            boolean z = jSONObject.has("usertype") && jSONObject.optInt("usertype") == 0;
            String strOptString = JsonHelper.optString(jSONObject, "nickname");
            long jOptLong = jSONObject.optLong("time");
            if (z) {
                return AgentMessageFactory.getAgentMessage(JsonHelper.optString(jSONObject, "msg"), jOptLong, strOptString);
            }
            return BotMessageFactory.getResponseBotMessage(JsonHelper.getJsonObject(jSONObject, "bot"), jOptLong, strOptString);
        } catch (Exception e) {
            e.printStackTrace();
            Message message2 = new Message(3);
            message2.setNormalMessage(false);
            return message2;
        }
    }

    public static RPAStep getRPAStep(String str) {
        RPAStep rPAStep = new RPAStep();
        boolean z = true;
        boolean z2 = TicketStatusTracker.isTicketFinished && (TicketStatusTracker.isTicketWaitForAskingResolveStatus || TicketStatusTracker.isTicketWaitForRating);
        if (MessageFactory.isAgentMsg(str) || z2) {
            rPAStep.setNextStep(104);
            return rPAStep;
        }
        try {
            JSONObject jSONObject = new JSONObject(str);
            JSONObject jsonObject = JsonHelper.getJsonObject(jSONObject, "welcomeBot");
            if (jsonObject.length() == 0) {
                jsonObject = JsonHelper.getJsonObject(jSONObject, "bot");
            }
            int iOptInt = jsonObject.optInt("status", -1);
            if (iOptInt != 1) {
                if (iOptInt == 2) {
                    rPAStep.setNextStep(102);
                } else if (iOptInt == 1002) {
                    rPAStep.setNextStep(103);
                } else if (iOptInt != 2001) {
                    JSONObject jsonObject2 = JsonHelper.getJsonObject(jsonObject, "step");
                    if (jsonObject2.keys().hasNext()) {
                        rPAStep.setStepId(JsonHelper.optString(jsonObject2, "stepId"));
                        rPAStep.setEnablePrevStep(jsonObject2.optInt("allowBack") == 1);
                        rPAStep.setEnableSkip(jsonObject2.optInt("allowSkip") == 1);
                        rPAStep.setEnableUpload(jsonObject2.optInt("autoUpload") == 1);
                        rPAStep.setNextStep(jsonObject2.optInt("nextAction"));
                        rPAStep.setSkipHint(JsonHelper.optString(jsonObject2, "skipLabel"));
                        rPAStep.setPrevStepHint(JsonHelper.optString(jsonObject2, "backLabel"));
                        if (jsonObject2.optInt("allowInputBox") != 1) {
                            z = false;
                        }
                        rPAStep.setEnableActionInput(z);
                        rPAStep.setAttachmentTypes(JsonHelper.optString(jsonObject2, "attachmentsTypes"));
                        JSONArray jsonArray = JsonHelper.getJsonArray(jsonObject2, "buttons");
                        ArrayList arrayList = new ArrayList();
                        for (int i = 0; i < jsonArray.length(); i++) {
                            JSONObject jsonObject3 = JsonHelper.getJsonObject(jsonArray, i);
                            arrayList.add(RPAStep.Action.getInstance(jsonObject3.optInt("order"), JsonHelper.optString(jsonObject3, "id"), JsonHelper.optString(jsonObject3, "value")));
                        }
                        rPAStep.setActionList(arrayList);
                    }
                }
                return rPAStep;
            }
            Const.TOGGLE_FETCH_MESSAGE = true;
            TicketStatusTracker.isTicketActive = true;
            TicketStatusTracker.currentTicketId = JsonHelper.optString(jSONObject, "ticketId");
            UnreadFetchHelper.cacheUnreadToken(JsonHelper.optString(jSONObject, "unreadMessageToken"));
            rPAStep.setNextStep(104);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rPAStep;
    }

    public static void notifyMqttPush(String str) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("timestamp", System.currentTimeMillis());
            if (!TextUtils.isEmpty(str)) {
                jSONObject.put("responseId", JsonHelper.optString(new JSONObject(str), "responseId"));
            }
            AIHelpRequest.getInstance().requestGetByAsync(API.NOTIFY_MQTT_PUSH, jSONObject, null);
        } catch (Exception unused) {
        }
    }

    public static List<Message> getLoginResponse(String str) {
        ArrayList arrayList = new ArrayList();
        JSONObject jsonObject = JsonHelper.getJsonObject(str);
        arrayList.add(Message.getDefaultMessage());
        TicketStatusTracker.firstMessageTimeStampInList = System.currentTimeMillis();
        List<Message> historyMessageList = getHistoryMessageList(str, 1);
        TicketStatusTracker.setFirstMessageTimeStampInList(historyMessageList);
        arrayList.addAll(historyMessageList);
        updateTicketStatusTracker(str);
        if (JsonHelper.hasKey(jsonObject, "evaluation")) {
            String strOptString = JsonHelper.optString(jsonObject, "evaluation");
            if (!TextUtils.isEmpty(strOptString)) {
                FeedbackOpinionHelper.INSTANCE.prepareDataSource(JsonHelper.getJsonArray(strOptString));
            }
        }
        if (JsonHelper.hasKey(jsonObject, "expandField")) {
            TicketStatusTracker.ticketPollInterval = JsonHelper.getJsonObject(jsonObject, "expandField").optInt("ticketPollInterval", 60);
        }
        return arrayList;
    }

    public static List<Message> getPollResponse(String str) {
        updateTicketStatusTracker(str);
        return getHistoryMessageList(str, 3);
    }

    private static List<Message> getHistoryMessageList(String str, int i) {
        JSONObject jsonObject = JsonHelper.getJsonObject(str);
        if (JsonHelper.hasKey(jsonObject, "chatHistoryContent")) {
            return HistoryHelper.getHistoryList(JsonHelper.optString(jsonObject, "chatHistoryContent"), i);
        }
        return new ArrayList();
    }

    private static void updateTicketStatusTracker(String str) {
        JSONObject jsonObject = JsonHelper.getJsonObject(str);
        if (JsonHelper.hasKey(jsonObject, "chatExtraInfo")) {
            JSONObject jsonObject2 = JsonHelper.getJsonObject(jsonObject.optString("chatExtraInfo"));
            TicketStatusTracker.updateAssignTypeWithActiveStatus(jsonObject2.optBoolean("hasTicket"), jsonObject2.optInt("assignType"));
            TicketStatusTracker.isTicketFinished = jsonObject2.optBoolean("isEvaluate");
            TicketStatusTracker.isTicketWaitForAskingResolveStatus = jsonObject2.optBoolean("isShowResolve");
            TicketStatusTracker.isAppRatable = jsonObject2.optBoolean("isStoreReview");
            TicketStatusTracker.isTicketWaitForRating = CustomConfig.CustomerService.isTicketRatingEnable;
            TicketStatusTracker.isTicketRejected = jsonObject2.optInt("status") == 9;
            TicketStatusTracker.currentTicketId = JsonHelper.optString(jsonObject2, "ticketId");
        }
    }

    public static JSONObject getLoginParams() {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("appId", Const.APP_ID);
            jSONObject.put("userId", UserProfile.USER_ID);
            jSONObject.put("userName", UserProfile.USER_NAME);
            jSONObject.put("type", 1);
            jSONObject.put("lan", Const.CORRECT_LANGUAGE);
            jSONObject.put("sdkVersion", BuildConfig.SDK_VERSION);
            jSONObject.put("source", "android");
            jSONObject.put("gameInfo", DeviceInfoUtil.getInstance().getGameInfo().toString());
            jSONObject.put("extendData", AIHelpEventTracker.getInstance().getExtendDataForLogin());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jSONObject;
    }
}
