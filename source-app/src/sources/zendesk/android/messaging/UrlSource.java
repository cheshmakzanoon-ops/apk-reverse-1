package zendesk.android.messaging;

import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\t\b\u0086\u0081\u0002\u0018\u0000 \t2\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\tB\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005j\u0002\b\u0006j\u0002\b\u0007j\u0002\b\b¨\u0006\n"}, m18d2 = {"Lzendesk/android/messaging/UrlSource;", "", "(Ljava/lang/String;I)V", "TEXT", "CAROUSEL", "FILE", "IMAGE", "LINK_MESSAGE_ACTION", "WEBVIEW_MESSAGE_ACTION", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public enum UrlSource {
    TEXT,
    CAROUSEL,
    FILE,
    IMAGE,
    LINK_MESSAGE_ACTION,
    WEBVIEW_MESSAGE_ACTION;

    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static final Companion INSTANCE = new Companion(null);

    public static EnumEntries<UrlSource> getEntries() {
        return $ENTRIES;
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u0004\u0018\u00010\u00042\u0006\u0010\u0005\u001a\u00020\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/android/messaging/UrlSource$Companion;", "", "()V", "findByValue", "Lzendesk/android/messaging/UrlSource;", "value", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final UrlSource findByValue(String value) {
            Intrinsics.checkNotNullParameter(value, "value");
            switch (value.hashCode()) {
                case -280175948:
                    if (value.equals("WEBVIEW_MESSAGE_ACTION")) {
                        return UrlSource.WEBVIEW_MESSAGE_ACTION;
                    }
                    return null;
                case 2157948:
                    if (value.equals("FILE")) {
                        return UrlSource.FILE;
                    }
                    return null;
                case 2571565:
                    if (value.equals("TEXT")) {
                        return UrlSource.TEXT;
                    }
                    return null;
                case 69775675:
                    if (value.equals("IMAGE")) {
                        return UrlSource.IMAGE;
                    }
                    return null;
                case 785535328:
                    if (value.equals("CAROUSEL")) {
                        return UrlSource.CAROUSEL;
                    }
                    return null;
                case 1432458355:
                    if (value.equals("LINK_MESSAGE_ACTION")) {
                        return UrlSource.LINK_MESSAGE_ACTION;
                    }
                    return null;
                default:
                    return null;
            }
        }
    }
}
