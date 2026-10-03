package zendesk.p026ui.android.conversation.articleviewer.articlecontent;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;

@Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0018\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u0004H\u0002J\u001e\u0010\u0007\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u0004¨\u0006\t"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleHTMLGenerator;", "", "()V", "createCss", "", "textColor", "backgroundColor", "createHTML", "body", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleHTMLGenerator {
    public static final int $stable = 0;
    public static final ArticleHTMLGenerator INSTANCE = new ArticleHTMLGenerator();

    private ArticleHTMLGenerator() {
    }

    private final String createCss(String textColor, String backgroundColor) {
        return StringsKt.trimIndent("\n    /* Reset and General Styling */\n    * {\n        margin: 0;\n        padding: 0;\n        border: 0;\n        font: inherit;\n        vertical-align: baseline;\n        box-sizing: border-box;\n    }\n\n    article, aside, details, figcaption, figure, footer, header, hgroup, menu, nav, section {\n        display: block;\n    }\n\n    body {\n        -webkit-font-smoothing: antialiased;\n        text-rendering: optimizeLegibility;\n        font-family: \"Roboto\", sans-serif;\n        font-feature-settings: 'clig' off, 'liga' off;\n        font-size: 14px;\n        font-style: normal;\n        font-weight: 400;\n        line-height: 20px;\n        letter-spacing: -0.154px;\n        color: #" + textColor + ";\n        background-color: #" + backgroundColor + ";\n        margin: 16px;\n    }\n\n    a {\n        color: #" + textColor + ";\n        text-decoration: underline;\n    }\n\n    p {\n        margin-bottom: 16px;\n    }\n\n    strong {\n        font-weight: bold;\n    }\n\n    h1, h2, h3, h4, h5, h6 {\n        color: #" + textColor + ";\n        font-weight: bold;\n        margin-bottom: 20px;\n        line-height: 1.25em;\n    }\n\n    h1 { font-size: 1.728em; }\n    h2 { font-size: 1.44em; }\n    h3 { font-size: 1.2em; }\n    h4, h5, h6 { font-size: 1em; }\n\n    span {\n        font-size: 1em !important;\n    }\n\n    ul, ol {\n        margin-bottom: 40px;\n        margin-left: 20px;\n    }\n\n    li {\n    \tmargin-bottom: 8px;\n    }\n\n    em { font-style: italic; }\n\n    .hidden {\n        display: none;\n    }\n\n    /* Clearfix */\n    .group::before,\n    .group::after {\n        content: \"\";\n        display: table;\n    }\n\n    .group::after {\n        clear: both;\n    }\n\n    .group {\n        zoom: 1;\n    }\n\n    /* Table-related styles */\n    table {\n        border-collapse: collapse;\n        border-spacing: 0;\n        width: 100%;\n    }\n\n    th, td {\n        border: 1px solid #" + textColor + ";\n    }\n\n    blockquote, q {\n        quotes: none;\n    }\n\n    blockquote::before, blockquote::after,\n    q::before, q::after {\n        content: '';\n    }\n\n    /* Image-related styles */\n    img {\n        max-width: 100%;\n        height: auto;\n        display: block; /* remove space below images */\n    }\n\n    iframe {\n        max-width:100%;\n        height: auto;\n        display: block;\n    }\n\n");
    }

    public final String createHTML(String textColor, String backgroundColor, String body) {
        Intrinsics.checkNotNullParameter(textColor, "textColor");
        Intrinsics.checkNotNullParameter(backgroundColor, "backgroundColor");
        Intrinsics.checkNotNullParameter(body, "body");
        return StringsKt.trimIndent("\n            <HTML dir=\"auto\">\n            <HEAD>\n                <STYLE> " + createCss(textColor, backgroundColor) + " </STYLE>\n            </HEAD>\n            <body>\n            " + body + "\n            </body>\n            </HTML>\n        ");
    }
}
