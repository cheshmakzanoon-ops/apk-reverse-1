package net.aihelp.p007ui.p009cs.util.rpa.factory;

import android.text.TextUtils;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.aihelp.data.model.rpa.msg.FileMessage;
import net.aihelp.data.model.rpa.msg.UserMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.utils.RegexDefinition;

public class UserMessageFactory extends MessageFactory {
    public static List<Message> getUserMessage(String str, long j) {
        int userMessageType = getUserMessageType(str);
        if (userMessageType == 11) {
            return getUserImageMessage(str, j);
        }
        if (userMessageType == 12) {
            return getUserVideoMessage(str, j);
        }
        if (userMessageType == 14) {
            return getUserFileMessage(str, j);
        }
        return getUserTextMessage(str, j);
    }

    private static int getUserMessageType(String str) {
        if (isUserImage(str)) {
            return 11;
        }
        if (isUserVideo(str)) {
            return 12;
        }
        return isUserAttachment(str) ? 14 : 10;
    }

    private static List<Message> getUserTextMessage(String str, long j) {
        ArrayList arrayList = new ArrayList();
        UserMessage userMessage = new UserMessage();
        String peeledContent = getPeeledContent(str);
        userMessage.setTimestamp(j);
        userMessage.setContent(peeledContent);
        arrayList.add(userMessage);
        replaceMediaUrls(peeledContent, arrayList, userMessage);
        return arrayList;
    }

    private static List<Message> getUserImageMessage(String str, long j) {
        ArrayList arrayList = new ArrayList();
        FileMessage fileMessage = new FileMessage(11, str);
        if (isUserAttachment(str)) {
            fileMessage = getAttachmentMessage(str, 11);
        }
        fileMessage.setTimestamp(j);
        arrayList.add(fileMessage);
        return arrayList;
    }

    private static List<Message> getUserVideoMessage(String str, long j) {
        ArrayList arrayList = new ArrayList();
        FileMessage fileMessage = new FileMessage(12, str);
        if (isUserAttachment(str)) {
            fileMessage = getAttachmentMessage(str, 12);
        }
        fileMessage.setTimestamp(j);
        arrayList.add(fileMessage);
        return arrayList;
    }

    private static List<Message> getUserFileMessage(String str, long j) {
        ArrayList arrayList = new ArrayList();
        FileMessage attachmentMessage = getAttachmentMessage(str, 14);
        attachmentMessage.setTimestamp(j);
        attachmentMessage.setNormalMessage(true);
        arrayList.add(attachmentMessage);
        return arrayList;
    }

    private static boolean isUserText(String str) {
        return !TextUtils.isEmpty(getPeeledContent(str));
    }

    private static boolean isUserImage(String str) {
        return Pattern.compile(RegexDefinition.REGEX_IMAGE).matcher(str).matches() || isAttachmentImage(str);
    }

    private static boolean isUserVideo(String str) {
        return Pattern.compile(RegexDefinition.REGEX_VIDEO).matcher(str).matches() || isAttachmentVideo(str);
    }

    private static boolean isUserAttachment(String str) {
        return hasOnlyOneAttachment(str);
    }

    public static List<Message> getUserFormMsgList(String str) {
        ArrayList arrayList = new ArrayList();
        UserMessage userMessage = new UserMessage();
        userMessage.setContent(str);
        arrayList.add(userMessage);
        replaceMediaUrls(str, arrayList, userMessage);
        return arrayList;
    }

    private static void replaceMediaUrls(String str, ArrayList<Message> arrayList, Message message) {
        int i = 10;
        for (String str2 : str.split(";")) {
            Matcher matcher = Pattern.compile(RegexDefinition.REGEX_IMAGE).matcher(str2.trim());
            while (matcher.find()) {
                String strGroup = matcher.group();
                FileMessage fileMessage = new FileMessage(11, strGroup);
                fileMessage.setTimestamp(message.getTimestamp() + ((long) i));
                arrayList.add(fileMessage);
                str = str.replace(strGroup, "");
                i++;
            }
            Matcher matcher2 = Pattern.compile(RegexDefinition.REGEX_VIDEO).matcher(str);
            while (matcher2.find()) {
                String strGroup2 = matcher2.group();
                FileMessage fileMessage2 = new FileMessage(12, strGroup2);
                fileMessage2.setTimestamp(message.getTimestamp() + ((long) i));
                arrayList.add(fileMessage2);
                str = str.replace(strGroup2, "");
                i++;
            }
        }
    }
}
