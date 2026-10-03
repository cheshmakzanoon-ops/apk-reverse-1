package net.aihelp.data.model.init;

public class InitEntity {
    private String cdnUrl;
    private String configBusiness;
    private String configFaq;
    private String configFileName;
    private String configProcess;
    private String configStyle;
    private String configText;
    private String correctLanguage;
    private PrivacyControlEntity customInformation;
    private boolean distinguishUserByDevice;
    private String faqAimlFileName;
    private String faqFileName;
    private String faqYYdata;
    private String faqdata;
    private String faqdataForm;
    private int initPeriod;
    private boolean isLocalizeFAQViaInit;
    private boolean isOpenPushServer;
    private boolean isOpenUploadLogFile;
    private boolean isOpenVideoUpload;
    private boolean isSetCrmToken;
    private boolean isTranslates;
    private boolean isUnreadMessage;
    private String localeFile;
    private NetworkCheckSettingBean networkCheckSetting;
    private String operateFileName;
    private String point;
    private String pushServer;
    private int requestLimit = -1;
    private String satisfyFeedback;
    private String sdkCustomUpload;
    private String showfaq;
    private String storyAimlFileName;
    private String svrip;
    private String svrport;
    private boolean tls;
    private String topic;
    private int unreadMessageTime;
    private String upload;
    private String uploadFile;
    private String uploadLog;
    private String uploadVideo;
    private int videoUploadSizeLimit;
    private String vipChatDomain;

    public String getUploadFile() {
        return this.uploadFile;
    }

    public void setUploadFile(String str) {
        this.uploadFile = str;
    }

    public String getSdkCustomUpload() {
        return this.sdkCustomUpload;
    }

    public void setSdkCustomUpload(String str) {
        this.sdkCustomUpload = str;
    }

    public boolean isDistinguishUserByDevice() {
        return this.distinguishUserByDevice;
    }

    public void setDistinguishUserByDevice(boolean z) {
        this.distinguishUserByDevice = z;
    }

    public String getConfigStyle() {
        return this.configStyle;
    }

    public void setConfigStyle(String str) {
        this.configStyle = str;
    }

    public String getConfigBusiness() {
        return this.configBusiness;
    }

    public void setConfigBusiness(String str) {
        this.configBusiness = str;
    }

    public String getSatisfyFeedback() {
        return this.satisfyFeedback;
    }

    public void setSatisfyFeedback(String str) {
        this.satisfyFeedback = str;
    }

    public String getConfigFaq() {
        return this.configFaq;
    }

    public void setConfigFaq(String str) {
        this.configFaq = str;
    }

    public String getConfigProcess() {
        return this.configProcess;
    }

    public void setConfigProcess(String str) {
        this.configProcess = str;
    }

    public String getConfigText() {
        return this.configText;
    }

    public void setConfigText(String str) {
        this.configText = str;
    }

    public boolean isTranslates() {
        return this.isTranslates;
    }

    public void setTranslates(boolean z) {
        this.isTranslates = z;
    }

    public String getLocaleFile() {
        return this.localeFile;
    }

    public void setLocaleFile(String str) {
        this.localeFile = str;
    }

    public boolean isTls() {
        return this.tls;
    }

    public void setTls(boolean z) {
        this.tls = z;
    }

    public String getCorrectLanguage() {
        return this.correctLanguage;
    }

    public void setCorrectLanguage(String str) {
        this.correctLanguage = str;
    }

    public String getConfigFileName() {
        return this.configFileName;
    }

    public void setConfigFileName(String str) {
        this.configFileName = str;
    }

    public boolean isLocalizeFAQViaInit() {
        return this.isLocalizeFAQViaInit;
    }

    public void setLocalizeFAQViaInit(boolean z) {
        this.isLocalizeFAQViaInit = z;
    }

    public int getRequestLimit() {
        return this.requestLimit;
    }

    public void setRequestLimit(int i) {
        this.requestLimit = i;
    }

    public boolean isOpenVideoUpload() {
        return this.isOpenVideoUpload;
    }

    public void setOpenVideoUpload(boolean z) {
        this.isOpenVideoUpload = z;
    }

    public boolean isSetCrmToken() {
        return this.isSetCrmToken;
    }

    public void setSetCrmToken(boolean z) {
        this.isSetCrmToken = z;
    }

    public boolean isOpenUploadLogFile() {
        return this.isOpenUploadLogFile;
    }

    public void setOpenUploadLogFile(boolean z) {
        this.isOpenUploadLogFile = z;
    }

    public boolean isUnreadMessage() {
        return this.isUnreadMessage;
    }

    public void setUnreadMessage(boolean z) {
        this.isUnreadMessage = z;
    }

    public boolean isOpenPushServer() {
        return this.isOpenPushServer;
    }

    public void setOpenPushServer(boolean z) {
        this.isOpenPushServer = z;
    }

    public int getUnreadMessageTime() {
        return this.unreadMessageTime;
    }

    public void setUnreadMessageTime(int i) {
        this.unreadMessageTime = i;
    }

    public int getVideoUploadSizeLimit() {
        return this.videoUploadSizeLimit;
    }

    public void setVideoUploadSizeLimit(int i) {
        this.videoUploadSizeLimit = i;
    }

    public int getInitPeriod() {
        return this.initPeriod;
    }

    public void setInitPeriod(int i) {
        this.initPeriod = i;
    }

    public PrivacyControlEntity getCustomInformation() {
        return this.customInformation;
    }

    public void setCustomInformation(PrivacyControlEntity privacyControlEntity) {
        this.customInformation = privacyControlEntity;
    }

    public NetworkCheckSettingBean getNetworkCheckSetting() {
        return this.networkCheckSetting;
    }

    public void setNetworkCheckSetting(NetworkCheckSettingBean networkCheckSettingBean) {
        this.networkCheckSetting = networkCheckSettingBean;
    }

    public String getSvrip() {
        return this.svrip;
    }

    public void setSvrip(String str) {
        this.svrip = str;
    }

    public String getSvrport() {
        return this.svrport;
    }

    public void setSvrport(String str) {
        this.svrport = str;
    }

    public String getVipChatDomain() {
        return this.vipChatDomain;
    }

    public void setVipChatDomain(String str) {
        this.vipChatDomain = str;
    }

    public String getPushServer() {
        return this.pushServer;
    }

    public void setPushServer(String str) {
        this.pushServer = str;
    }

    public String getTopic() {
        return this.topic;
    }

    public void setTopic(String str) {
        this.topic = str;
    }

    public String getUpload() {
        return this.upload;
    }

    public void setUpload(String str) {
        this.upload = str;
    }

    public String getUploadVideo() {
        return this.uploadVideo;
    }

    public void setUploadVideo(String str) {
        this.uploadVideo = str;
    }

    public String getUploadLog() {
        return this.uploadLog;
    }

    public void setUploadLog(String str) {
        this.uploadLog = str;
    }

    public String getPoint() {
        return this.point;
    }

    public void setPoint(String str) {
        this.point = str;
    }

    public String getFaqdata() {
        return this.faqdata;
    }

    public void setFaqdata(String str) {
        this.faqdata = str;
    }

    public String getFaqYYdata() {
        return this.faqYYdata;
    }

    public void setFaqYYdata(String str) {
        this.faqYYdata = str;
    }

    public String getFaqdataForm() {
        return this.faqdataForm;
    }

    public void setFaqdataForm(String str) {
        this.faqdataForm = str;
    }

    public String getCdnUrl() {
        return this.cdnUrl;
    }

    public void setCdnUrl(String str) {
        this.cdnUrl = str;
    }

    public String getFaqAimlFileName() {
        return this.faqAimlFileName;
    }

    public void setFaqAimlFileName(String str) {
        this.faqAimlFileName = str;
    }

    public String getStoryAimlFileName() {
        return this.storyAimlFileName;
    }

    public void setStoryAimlFileName(String str) {
        this.storyAimlFileName = str;
    }

    public String getFaqFileName() {
        return this.faqFileName;
    }

    public void setFaqFileName(String str) {
        this.faqFileName = str;
    }

    public String getOperateFileName() {
        return this.operateFileName;
    }

    public void setOperateFileName(String str) {
        this.operateFileName = str;
    }

    public String getShowfaq() {
        return this.showfaq;
    }

    public void setShowfaq(String str) {
        this.showfaq = str;
    }

    public static class NetworkCheckSettingBean {
        private String ping;
        private String traceroute;

        public String getPing() {
            return this.ping;
        }

        public void setPing(String str) {
            this.ping = str;
        }

        public String getTraceroute() {
            return this.traceroute;
        }

        public void setTraceroute(String str) {
            this.traceroute = str;
        }
    }
}
