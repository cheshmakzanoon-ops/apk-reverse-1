package net.aihelp.data.model.rpa.msg.bot;

public class Answer {
    public static final int ANSWER_TYPE_FAQ = 1;
    public static final int ANSWER_TYPE_RPA = 2;
    private Faq.FaqData faqData;
    private String title;
    private int type;

    public Answer(int i, String str) {
        this.type = i;
        this.title = str;
    }

    public int getType() {
        return this.type;
    }

    public void setType(int i) {
        this.type = i;
    }

    public String getTitle() {
        return this.title;
    }

    public void setTitle(String str) {
        this.title = str;
    }

    public Faq.FaqData getFaqData() {
        return this.faqData;
    }

    public void setFaqData(Faq.FaqData faqData) {
        if (this.type == 1) {
            this.faqData = faqData;
        }
    }
}
