package zendesk.android;

import j$.util.Objects;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.TuplesKt;
import kotlin.collections.MapsKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0004\u0018\u0000 \u000e2\u00020\u0001:\u0002\r\u000eB\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0013\u0010\u0007\u001a\u00020\b2\b\u0010\t\u001a\u0004\u0018\u00010\u0001H\u0096\u0002J\b\u0010\n\u001a\u00020\u000bH\u0016J\b\u0010\f\u001a\u00020\u0003H\u0016R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u000f"}, m18d2 = {"Lzendesk/android/ZendeskCredentials;", "", "channelKey", "", "(Ljava/lang/String;)V", "getChannelKey", "()Ljava/lang/String;", "equals", "", "other", "hashCode", "", "toString", "Builder", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ZendeskCredentials {

    public static final Companion INSTANCE = new Companion(null);
    private static final String LOG_TAG = "ZendeskCredentials";
    private final String channelKey;

    public ZendeskCredentials(String str, DefaultConstructorMarker defaultConstructorMarker) {
        this(str);
    }

    @JvmStatic
    public static final Builder builder(String str) {
        return INSTANCE.builder(str);
    }

    private ZendeskCredentials(String str) {
        this.channelKey = str;
    }

    public final String getChannelKey() {
        return this.channelKey;
    }

    public boolean equals(Object other) {
        return (other instanceof ZendeskCredentials) && Intrinsics.areEqual(this.channelKey, ((ZendeskCredentials) other).channelKey);
    }

    public int hashCode() {
        return Objects.hash(new Object[]{this.channelKey});
    }

    public String toString() {
        return "ZendeskCredentials(channelKey='" + this.channelKey + "')";
    }

    @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u0004H\u0007J\u0010\u0010\b\u001a\u0004\u0018\u00010\t2\u0006\u0010\n\u001a\u00020\u0004J\n\u0010\u000b\u001a\u00020\u0004*\u00020\tR\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\f"}, m18d2 = {"Lzendesk/android/ZendeskCredentials$Companion;", "", "()V", "LOG_TAG", "", "builder", "Lzendesk/android/ZendeskCredentials$Builder;", "channelKey", "fromQuery", "Lzendesk/android/ZendeskCredentials;", "query", "toQuery", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @JvmStatic
        public final Builder builder(String channelKey) {
            Intrinsics.checkNotNullParameter(channelKey, "channelKey");
            return new Builder(channelKey);
        }

        public final String toQuery(ZendeskCredentials zendeskCredentials) {
            Intrinsics.checkNotNullParameter(zendeskCredentials, "<this>");
            return "channelKey=" + zendeskCredentials.getChannelKey();
        }

        public final ZendeskCredentials fromQuery(String query) {
            Object[] objArr;
            Intrinsics.checkNotNullParameter(query, "query");
            List listSplit$default = StringsKt.split$default((CharSequence) query, new String[]{"&"}, false, 0, 6, (Object) null);
            ArrayList arrayList = new ArrayList();
            Iterator it = listSplit$default.iterator();
            while (true) {
                Pair pairM25to = null;
                objArr = 0;
                if (!it.hasNext()) {
                    break;
                }
                String str = (String) it.next();
                if (StringsKt.contains$default((CharSequence) str, (CharSequence) "=", false, 2, (Object) null)) {
                    List listSplit$default2 = StringsKt.split$default((CharSequence) str, new String[]{"="}, false, 2, 2, (Object) null);
                    pairM25to = TuplesKt.m25to((String) listSplit$default2.get(0), (String) listSplit$default2.get(1));
                }
                if (pairM25to != null) {
                    arrayList.add(pairM25to);
                }
            }
            String str2 = (String) MapsKt.toMap(arrayList).get("channelKey");
            if (str2 == null) {
                Logger.m225w(ZendeskCredentials.LOG_TAG, "Invalid query provided, unable to obtain an instance of MessagingCredentials.", new Object[0]);
                return null;
            }
            return new ZendeskCredentials(str2, objArr == true ? 1 : 0);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0006\u0010\u0005\u001a\u00020\u0006R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0007"}, m18d2 = {"Lzendesk/android/ZendeskCredentials$Builder;", "", "channelKey", "", "(Ljava/lang/String;)V", "build", "Lzendesk/android/ZendeskCredentials;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        private final String channelKey;

        public Builder(String channelKey) {
            Intrinsics.checkNotNullParameter(channelKey, "channelKey");
            this.channelKey = channelKey;
        }

        public final ZendeskCredentials build() {
            return new ZendeskCredentials(this.channelKey, null);
        }
    }
}
