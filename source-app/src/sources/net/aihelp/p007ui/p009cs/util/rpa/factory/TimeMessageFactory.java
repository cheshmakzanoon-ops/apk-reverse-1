package net.aihelp.p007ui.p009cs.util.rpa.factory;

import net.aihelp.data.model.rpa.msg.base.Message;

public class TimeMessageFactory extends MessageFactory {
    public static Message getTimeMessage(long j) {
        Message message = new Message();
        message.setTimestamp(j);
        message.setMsgType(1);
        message.setMsgStatus(1);
        message.setContent(String.valueOf(j));
        return message;
    }
}
