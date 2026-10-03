package net.aihelp.data.model.config;

public class StyleSheetEntity {
    private GeneralEntity general;
    private HelpEntity help;
    private OnLineEntity onLine;

    public GeneralEntity getGeneral() {
        return this.general;
    }

    public void setGeneral(GeneralEntity generalEntity) {
        this.general = generalEntity;
    }

    public HelpEntity getHelp() {
        return this.help;
    }

    public void setHelp(HelpEntity helpEntity) {
        this.help = helpEntity;
    }

    public OnLineEntity getOnLine() {
        return this.onLine;
    }

    public void setOnLine(OnLineEntity onLineEntity) {
        this.onLine = onLineEntity;
    }

    public static class GeneralEntity {
        private String backButton;
        private String buttonColor;
        private FrontColorEntity frontColor;
        private String highlightColor;
        private String horizontal;
        private String horizontalImgUrl;
        private NavBarEntity navBar;
        private String textColor;
        private String vertical;
        private String verticalImgUrl;

        public NavBarEntity getNavBar() {
            return this.navBar;
        }

        public void setNavBar(NavBarEntity navBarEntity) {
            this.navBar = navBarEntity;
        }

        public String getHorizontal() {
            return this.horizontal;
        }

        public void setHorizontal(String str) {
            this.horizontal = str;
        }

        public String getVertical() {
            return this.vertical;
        }

        public void setVertical(String str) {
            this.vertical = str;
        }

        public String getHorizontalImgUrl() {
            return this.horizontalImgUrl;
        }

        public void setHorizontalImgUrl(String str) {
            this.horizontalImgUrl = str;
        }

        public String getVerticalImgUrl() {
            return this.verticalImgUrl;
        }

        public void setVerticalImgUrl(String str) {
            this.verticalImgUrl = str;
        }

        public FrontColorEntity getFrontColor() {
            return this.frontColor;
        }

        public void setFrontColor(FrontColorEntity frontColorEntity) {
            this.frontColor = frontColorEntity;
        }

        public String getTextColor() {
            return this.textColor;
        }

        public void setTextColor(String str) {
            this.textColor = str;
        }

        public String getHighlightColor() {
            return this.highlightColor;
        }

        public void setHighlightColor(String str) {
            this.highlightColor = str;
        }

        public String getButtonColor() {
            return this.buttonColor;
        }

        public void setButtonColor(String str) {
            this.buttonColor = str;
        }

        public String getBackButton() {
            return this.backButton;
        }

        public void setBackButton(String str) {
            this.backButton = str;
        }

        public static class NavBarEntity {
            private String color;
            private double transparency;

            public String getColor() {
                return this.color;
            }

            public void setColor(String str) {
                this.color = str;
            }

            public double getTransparency() {
                return this.transparency;
            }

            public void setTransparency(double d) {
                this.transparency = d;
            }
        }

        public static class FrontColorEntity {
            private String color;
            private double transparency;

            public String getColor() {
                return this.color;
            }

            public void setColor(String str) {
                this.color = str;
            }

            public double getTransparency() {
                return this.transparency;
            }

            public void setTransparency(double d) {
                this.transparency = d;
            }
        }
    }

    public static class HelpEntity {
        private String faqList;
        private String faqSectionList;
        private String navBar;
        private String noticeBar;

        public String getNavBar() {
            return this.navBar;
        }

        public void setNavBar(String str) {
            this.navBar = str;
        }

        public String getNoticeBar() {
            return this.noticeBar;
        }

        public void setNoticeBar(String str) {
            this.noticeBar = str;
        }

        public String getFaqList() {
            return this.faqList;
        }

        public void setFaqList(String str) {
            this.faqList = str;
        }

        public String getFaqSectionList() {
            return this.faqSectionList;
        }

        public void setFaqSectionList(String str) {
            this.faqSectionList = str;
        }
    }

    public static class OnLineEntity {
        private String bgColor;
        private String customerImgUrl;
        private String foreColor;
        private String navBar;
        private String robotImgUrl;
        private String userImgUrl;

        public String getNavBar() {
            return this.navBar;
        }

        public void setNavBar(String str) {
            this.navBar = str;
        }

        public String getRobotImgUrl() {
            return this.robotImgUrl;
        }

        public void setRobotImgUrl(String str) {
            this.robotImgUrl = str;
        }

        public String getCustomerImgUrl() {
            return this.customerImgUrl;
        }

        public void setCustomerImgUrl(String str) {
            this.customerImgUrl = str;
        }

        public String getUserImgUrl() {
            return this.userImgUrl;
        }

        public void setUserImgUrl(String str) {
            this.userImgUrl = str;
        }

        public String getBgColor() {
            return this.bgColor;
        }

        public void setBgColor(String str) {
            this.bgColor = str;
        }

        public String getForeColor() {
            return this.foreColor;
        }

        public void setForeColor(String str) {
            this.foreColor = str;
        }
    }
}
