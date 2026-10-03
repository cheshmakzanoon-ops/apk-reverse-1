package net.aihelp.p007ui.p009cs.util.rpa.helper;

import android.text.TextUtils;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.model.p005cs.ChatInfoEntity;
import net.aihelp.data.model.rpa.msg.BotMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.p009cs.util.rpa.factory.AgentMessageFactory;
import net.aihelp.p007ui.p009cs.util.rpa.factory.BotMessageFactory;
import net.aihelp.p007ui.p009cs.util.rpa.factory.TimeMessageFactory;
import net.aihelp.p007ui.p009cs.util.rpa.factory.UserMessageFactory;

public class HistoryHelper {
    public static final int HISTORY_TYPE_LOGIN = 1;
    public static final int HISTORY_TYPE_POLL = 3;
    public static final int HISTORY_TYPE_REFRESH = 2;

    private static List<Message> getListFromMsgString(ChatInfoEntity chatInfoEntity, int i) {
        int msgType = chatInfoEntity.getMsgType();
        long timeStamp = chatInfoEntity.getTimeStamp();
        String message = chatInfoEntity.getMessage();
        ArrayList arrayList = new ArrayList();
        if (msgType != 1) {
            if (msgType == 3) {
                chatInfoEntity.setUserId(JsonHelper.getJsonObject(message).optInt("customerId"));
                ChatInfoHelper.prepareNickname(chatInfoEntity);
                BotMessage historicBotMessage = BotMessageFactory.getHistoricBotMessage(message, timeStamp, chatInfoEntity.getAgentNickname(), i);
                if (historicBotMessage.hasSelfService() && historicBotMessage.getSelfService().isEnableSend()) {
                    return arrayList;
                }
                arrayList.add(historicBotMessage);
            } else if (msgType == 4) {
                ChatInfoHelper.prepareNickname(chatInfoEntity);
                arrayList.add(AgentMessageFactory.getAgentMessage(message, timeStamp, chatInfoEntity.getAgentNickname()));
            } else {
                arrayList.addAll(UserMessageFactory.getUserMessage(message, timeStamp));
            }
        } else if (i != 3) {
            arrayList.add(TimeMessageFactory.getTimeMessage(timeStamp));
        }
        return arrayList;
    }

    public static List<Message> getHistoryList(String str, int i) {
        ArrayList arrayList = new ArrayList();
        if (!TextUtils.isEmpty(str)) {
            Iterator<ChatInfoEntity> it = ChatInfoHelper.getChatInfoList(str, i).iterator();
            while (it.hasNext()) {
                arrayList.addAll(getListFromMsgString(it.next(), i));
            }
        }
        return arrayList;
    }
}
