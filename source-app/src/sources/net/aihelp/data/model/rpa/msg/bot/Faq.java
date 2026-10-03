package net.aihelp.data.model.rpa.msg.bot;

import android.text.TextUtils;
import java.util.List;
import net.aihelp.BuildConfig;
import net.aihelp.common.Const;
import net.aihelp.common.UserProfile;

public class Faq {
    public static final int FAQ_SOURCE_ANSWER_BOT = 2;
    public static final int FAQ_SOURCE_RPA = 1;
    private final List<FaqData> faqDataList;

    public Faq(boolean z, List<FaqData> list) {
        this.faqDataList = list;
    }

    public List<FaqData> getFaqDataList() {
        return this.faqDataList;
    }

    public static class FaqData {
        private final long contentId;
        private final String faqContent;
        private int faqSource;
        private final String faqTitle;
        private final String formTitle;
        private final String formUrl;
        private boolean isFaqEvaluated;
        private boolean isFaqViewed;
        private final boolean isShowMore;
        private final boolean isSimilarMatch;
        private final long mainId;
        private final String template;

        public FaqData(int i, long j, long j2, String str, String str2, String str3, String str4, String str5, boolean z, boolean z2) {
            this.faqSource = i;
            this.mainId = j;
            this.contentId = j2;
            this.faqTitle = str;
            this.faqContent = str2;
            this.template = TextUtils.isEmpty(str3) ? "" : str3.trim();
            this.formUrl = Faq.getFormattedFormUrl(str4);
            this.formTitle = str5;
            this.isSimilarMatch = z;
            this.isShowMore = z2;
        }

        public boolean isFaqEvaluated() {
            return this.isFaqEvaluated;
        }

        public void setFaqEvaluated(boolean z) {
            this.isFaqEvaluated = z;
        }

        public boolean isFaqViewed() {
            return this.isFaqViewed;
        }

        public void setFaqViewed(boolean z) {
            this.isFaqViewed = z;
        }

        public long getMainId() {
            return this.mainId;
        }

        public long getContentId() {
            return this.contentId;
        }

        public String getFaqContent() {
            return this.faqContent;
        }

        public String getFaqTitle() {
            return this.faqTitle;
        }

        public String getTemplate() {
            return this.template;
        }

        public String getFormUrl() {
            return this.formUrl;
        }

        public String getFormTitle() {
            return this.formTitle;
        }

        public boolean hasAttachedForm() {
            return (TextUtils.isEmpty(this.formUrl) || TextUtils.isEmpty(this.formTitle)) ? false : true;
        }

        public boolean isSimilarMatch() {
            return this.isSimilarMatch;
        }

        public boolean isShowMore() {
            return this.isShowMore;
        }

        public int getFaqSource() {
            return this.faqSource;
        }

        public void setFaqSource(int i) {
            this.faqSource = i;
        }
    }

    public static String getFormattedFormUrl(String str) {
        if (!TextUtils.isEmpty(str)) {
            return String.format("%s&appId=%s&userId=%s&serverId=%s&platform=%s&sdkVersion=%s&isTicket=1&hasPermission=%s&fromSdk=1&isCustom=1", str, Const.APP_ID, UserProfile.USER_ID, UserProfile.SERVER_ID, 2, BuildConfig.SDK_VERSION, 0);
        }
        return "";
    }
}
