package net.aihelp.p007ui.p009cs.util.rpa.factory;

import android.text.TextUtils;
import java.util.regex.Pattern;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.model.rpa.msg.AgentMessage;
import net.aihelp.data.model.rpa.msg.FileMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.utils.RegexDefinition;
import org.json.JSONArray;
import org.json.JSONObject;

public class AgentMessageFactory extends MessageFactory {
    public static Message getAgentMessage(String str, long j, String str2) {
        switch (getAgentMessageType(str)) {
            case 6:
                return getAgentImageMessage(str, j, str2);
            case 7:
                return getAgentVideoMessage(str, j, str2);
            case 8:
                return getAgentRichTextMessage(str, j, str2);
            case 9:
                return getAgentFileMessage(str, j, str2);
            default:
                return getAgentTextMessage(str, j, str2);
        }
    }

    private static int getAgentMessageType(String str) {
        if (isAgentImage(str)) {
            return 6;
        }
        if (isAgentVideo(str)) {
            return 7;
        }
        if (isAgentAttachment(str)) {
            return 9;
        }
        return isAgentRichText(str) ? 8 : 3;
    }

    private static Message getAgentTextMessage(String str, long j, String str2) {
        AgentMessage agentMessage = new AgentMessage(str2);
        agentMessage.setTimestamp(j);
        agentMessage.setContent(getPeeledContent(str));
        agentMessage.setNormalMessage(true);
        return agentMessage;
    }

    private static Message getAgentRichTextMessage(String str, long j, String str2) {
        AgentMessage agentMessage = new AgentMessage(str2);
        agentMessage.setTimestamp(j);
        StringBuilder sb = new StringBuilder(getPeeledContent(str));
        JSONArray jsonArray = JsonHelper.getJsonArray(getContentObject(JsonHelper.getJsonObject(str)), "attachments");
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = JsonHelper.getJsonObject(jsonArray, i);
            sb.append("\n");
            sb.append(JsonHelper.optString(jsonObject, "url"));
        }
        agentMessage.setContent(sb.toString());
        agentMessage.setNormalMessage(true);
        return agentMessage;
    }

    private static Message getAgentImageMessage(String str, long j, String str2) {
        FileMessage fileMessage = new FileMessage(6, getPeeledContent(str));
        if (isAgentAttachment(str)) {
            fileMessage = getAttachmentMessage(str, 6);
        }
        fileMessage.setTimestamp(j);
        fileMessage.setNickname(str2);
        fileMessage.setNormalMessage(true);
        return fileMessage;
    }

    private static Message getAgentVideoMessage(String str, long j, String str2) {
        FileMessage fileMessage = new FileMessage(7, getPeeledContent(str));
        if (isAgentAttachment(str)) {
            fileMessage = getAttachmentMessage(str, 7);
        }
        fileMessage.setTimestamp(j);
        fileMessage.setNickname(str2);
        fileMessage.setNormalMessage(true);
        return fileMessage;
    }

    private static Message getAgentFileMessage(String str, long j, String str2) {
        FileMessage attachmentMessage = getAttachmentMessage(str, 9);
        attachmentMessage.setNickname(str2);
        attachmentMessage.setTimestamp(j);
        attachmentMessage.setNormalMessage(true);
        return attachmentMessage;
    }

    private static boolean isAgentText(String str) {
        return !TextUtils.isEmpty(getPeeledContent(str));
    }

    private static boolean isAgentImage(String str) {
        return Pattern.compile(RegexDefinition.REGEX_IMAGE).matcher(getPeeledContent(str)).matches() || isAttachmentImage(str);
    }

    private static boolean isAgentVideo(String str) {
        return Pattern.compile(RegexDefinition.REGEX_VIDEO).matcher(getPeeledContent(str)).matches() || isAttachmentVideo(str);
    }

    private static boolean isAgentRichText(String str) {
        String peeledContent = getPeeledContent(str);
        if (TextUtils.isEmpty(peeledContent) || !hasAtLeastNAttachments(str, 1)) {
            return TextUtils.isEmpty(peeledContent) && hasAtLeastNAttachments(str, 2);
        }
        return true;
    }

    private static boolean isAgentAttachment(String str) {
        return TextUtils.isEmpty(getPeeledContent(str)) && hasOnlyOneAttachment(str);
    }
}
