package net.aihelp.data.model.init;

import java.util.List;
import net.aihelp.core.net.json.GenericType;

public class SDKConfigEntity {
    private SdkConfigBean SdkConfig;
    private SdkConfigImgBean SdkConfigImg;

    @GenericType(SdkConfigTopicBean.class)
    private List<SdkConfigTopicBean> SdkConfigTopic;
    private SdkTextBean SdkText;

    public SdkConfigImgBean getSdkConfigImg() {
        return this.SdkConfigImg;
    }

    public void setSdkConfigImg(SdkConfigImgBean sdkConfigImgBean) {
        this.SdkConfigImg = sdkConfigImgBean;
    }

    public SdkConfigBean getSdkConfig() {
        return this.SdkConfig;
    }

    public void setSdkConfig(SdkConfigBean sdkConfigBean) {
        this.SdkConfig = sdkConfigBean;
    }

    public SdkTextBean getSdkText() {
        return this.SdkText;
    }

    public void setSdkText(SdkTextBean sdkTextBean) {
        this.SdkText = sdkTextBean;
    }

    public List<SdkConfigTopicBean> getSdkConfigTopic() {
        return this.SdkConfigTopic;
    }

    public void setSdkConfigTopic(List<SdkConfigTopicBean> list) {
        this.SdkConfigTopic = list;
    }

    public static class SdkConfigBean {
        private int Avatar_Enable;
        private int Is_Output_Nike;
        private int Is_Player_Eval_Customer;
        private int Is_Player_Eval_Faq;
        private int Is_Psee_Chat_History;
        private int PlayerEvalFaqDetail = 1;
        private int PlayerEvalFaqReply = 1;
        private int PlayerSeeChatTime = 1;
        private int isOpenOperationEvaluation = 1;

        public void setPlayerEvalFaqDetail(int i) {
            this.PlayerEvalFaqDetail = i;
        }

        public void setPlayerEvalFaqReply(int i) {
            this.PlayerEvalFaqReply = i;
        }

        public void setPlayerSeeChatTime(int i) {
            this.PlayerSeeChatTime = i;
        }

        public boolean getPlayerEvalFaqDetail() {
            return this.PlayerEvalFaqDetail == 1;
        }

        public boolean getPlayerEvalFaqReply() {
            return this.PlayerEvalFaqReply == 1;
        }

        public boolean getPlayerSeeChatTime() {
            return this.PlayerSeeChatTime == 1;
        }

        public boolean getAvatar_Enable() {
            return this.Avatar_Enable == 1;
        }

        public void setAvatar_Enable(int i) {
            this.Avatar_Enable = i;
        }

        public boolean getIs_Player_Eval_Customer() {
            return this.Is_Player_Eval_Customer == 1;
        }

        public void setIs_Player_Eval_Customer(int i) {
            this.Is_Player_Eval_Customer = i;
        }

        public boolean getIs_Psee_Chat_History() {
            return this.Is_Psee_Chat_History == 1;
        }

        public void setIs_Psee_Chat_History(int i) {
            this.Is_Psee_Chat_History = i;
        }

        public boolean getIs_Player_Eval_Faq() {
            return this.Is_Player_Eval_Faq == 1;
        }

        public void setIs_Player_Eval_Faq(int i) {
            this.Is_Player_Eval_Faq = i;
        }

        public boolean getIs_Output_Nike() {
            return this.Is_Output_Nike == 1;
        }

        public void setIs_Output_Nike(int i) {
            this.Is_Output_Nike = i;
        }

        public boolean getIsOpenOperationEvaluation() {
            return this.isOpenOperationEvaluation == 1;
        }

        public void setIsOpenOperationEvaluation(int i) {
            this.isOpenOperationEvaluation = i;
        }
    }

    public static class SdkTextBean {
        private String PhoneWel;
        private String ShowAppName;

        public String getShowAppName() {
            return this.ShowAppName;
        }

        public void setShowAppName(String str) {
            this.ShowAppName = str;
        }

        public String getPhoneWel() {
            return this.PhoneWel;
        }

        public void setPhoneWel(String str) {
            this.PhoneWel = str;
        }
    }

    public static class SdkConfigImgBean {
        private String Customer_Avatar;
        private String Player_Avatar;
        private String Robot_Avatar;

        public String getRobot_Avatar() {
            return this.Robot_Avatar;
        }

        public void setRobot_Avatar(String str) {
            this.Robot_Avatar = str;
        }

        public String getCustomer_Avatar() {
            return this.Customer_Avatar;
        }

        public void setCustomer_Avatar(String str) {
            this.Customer_Avatar = str;
        }

        public String getPlayer_Avatar() {
            return this.Player_Avatar;
        }

        public void setPlayer_Avatar(String str) {
            this.Player_Avatar = str;
        }
    }

    public static class SdkConfigTopicBean {
        private String Topic_Content;
        private int Topic_Type;

        public SdkConfigTopicBean(int i, String str) {
            this.Topic_Type = i;
            this.Topic_Content = str;
        }

        public SdkConfigTopicBean() {
        }

        public int getTopic_Type() {
            return this.Topic_Type;
        }

        public void setTopic_Type(int i) {
            this.Topic_Type = i;
        }

        public String getTopic_Content() {
            return this.Topic_Content;
        }

        public void setTopic_Content(String str) {
            this.Topic_Content = str;
        }
    }
}
