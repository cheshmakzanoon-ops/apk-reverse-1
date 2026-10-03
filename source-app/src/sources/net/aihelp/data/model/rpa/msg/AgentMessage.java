package net.aihelp.data.model.rpa.msg;

import android.text.TextUtils;
import java.util.regex.Pattern;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.utils.RegexDefinition;

public class AgentMessage extends Message {
    public AgentMessage(String str) {
        setNickname(str);
    }

    @Override
    public void setContent(String str) {
        int i;
        super.setContent(str);
        if (TextUtils.isEmpty(str)) {
            i = 3;
        } else if (Pattern.compile(RegexDefinition.REGEX_IMAGE).matcher(str).matches()) {
            i = 6;
        } else if (Pattern.compile(RegexDefinition.REGEX_VIDEO).matcher(str).matches()) {
            i = 7;
        } else if (Pattern.compile(RegexDefinition.REGEX_RICH_TEXT).matcher(str).find()) {
            i = 8;
        } else {
            i = 3;
        }
        setMsgType(i);
        setMsgStatus(1);
    }
}
