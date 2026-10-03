package zendesk.android.internal.frontendevents.pageviewevents.model;

import cz.msebera.android.httpclient.cookie.ClientCookie;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import zendesk.android.internal.frontendevents.FrontendEventsStorage;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u001c\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 82\u00020\u0001:\u000278Bm\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u000b\u001a\u0004\u0018\u00010\f\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u000e¢\u0006\u0002\u0010\u000fB=\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0006\u0010\t\u001a\u00020\u0005\u0012\u0006\u0010\n\u001a\u00020\u0005\u0012\u0006\u0010\u000b\u001a\u00020\f¢\u0006\u0002\u0010\u0010J\t\u0010\"\u001a\u00020\u0005HÆ\u0003J\t\u0010#\u001a\u00020\u0005HÆ\u0003J\t\u0010$\u001a\u00020\u0005HÆ\u0003J\t\u0010%\u001a\u00020\u0005HÆ\u0003J\t\u0010&\u001a\u00020\u0005HÆ\u0003J\t\u0010'\u001a\u00020\u0005HÆ\u0003J\t\u0010(\u001a\u00020\fHÆ\u0003JO\u0010)\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\u00052\b\b\u0002\u0010\t\u001a\u00020\u00052\b\b\u0002\u0010\n\u001a\u00020\u00052\b\b\u0002\u0010\u000b\u001a\u00020\fHÆ\u0001J\u0013\u0010*\u001a\u00020+2\b\u0010,\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010-\u001a\u00020\u0003HÖ\u0001J\t\u0010.\u001a\u00020\u0005HÖ\u0001J&\u0010/\u001a\u0002002\u0006\u00101\u001a\u00020\u00002\u0006\u00102\u001a\u0002032\u0006\u00104\u001a\u000205HÁ\u0001¢\u0006\u0002\b6R\u001c\u0010\u0006\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0011\u0010\u0012\u001a\u0004\b\u0013\u0010\u0014R\u001c\u0010\u0007\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0015\u0010\u0012\u001a\u0004\b\u0016\u0010\u0014R\u001c\u0010\u000b\u001a\u00020\f8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0017\u0010\u0012\u001a\u0004\b\u0018\u0010\u0019R\u001c\u0010\n\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001a\u0010\u0012\u001a\u0004\b\u001b\u0010\u0014R\u001c\u0010\t\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001c\u0010\u0012\u001a\u0004\b\u001d\u0010\u0014R\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001e\u0010\u0012\u001a\u0004\b\u001f\u0010\u0014R\u001c\u0010\b\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b \u0010\u0012\u001a\u0004\b!\u0010\u0014¨\u00069"}, m18d2 = {"Lzendesk/android/internal/frontendevents/pageviewevents/model/PageViewEventDto;", "", "seen1", "", "url", "", "buid", Bayeux.KEY_CHANNEL, ClientCookie.VERSION_ATTR, "timestamp", FrontendEventsStorage.KEY_SUID, "pageView", "Lzendesk/android/internal/frontendevents/pageviewevents/model/PageViewDto;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/android/internal/frontendevents/pageviewevents/model/PageViewDto;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/android/internal/frontendevents/pageviewevents/model/PageViewDto;)V", "getBuid$annotations", "()V", "getBuid", "()Ljava/lang/String;", "getChannel$annotations", "getChannel", "getPageView$annotations", "getPageView", "()Lzendesk/android/internal/frontendevents/pageviewevents/model/PageViewDto;", "getSuid$annotations", "getSuid", "getTimestamp$annotations", "getTimestamp", "getUrl$annotations", "getUrl", "getVersion$annotations", "getVersion", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class PageViewEventDto {

    public static final Companion INSTANCE = new Companion(null);
    private final String buid;
    private final String channel;
    private final PageViewDto pageView;
    private final String suid;
    private final String timestamp;
    private final String url;
    private final String version;

    public static PageViewEventDto copy$default(PageViewEventDto pageViewEventDto, String str, String str2, String str3, String str4, String str5, String str6, PageViewDto pageViewDto, int i, Object obj) {
        if ((i & 1) != 0) {
            str = pageViewEventDto.url;
        }
        if ((i & 2) != 0) {
            str2 = pageViewEventDto.buid;
        }
        String str7 = str2;
        if ((i & 4) != 0) {
            str3 = pageViewEventDto.channel;
        }
        String str8 = str3;
        if ((i & 8) != 0) {
            str4 = pageViewEventDto.version;
        }
        String str9 = str4;
        if ((i & 16) != 0) {
            str5 = pageViewEventDto.timestamp;
        }
        String str10 = str5;
        if ((i & 32) != 0) {
            str6 = pageViewEventDto.suid;
        }
        String str11 = str6;
        if ((i & 64) != 0) {
            pageViewDto = pageViewEventDto.pageView;
        }
        return pageViewEventDto.copy(str, str7, str8, str9, str10, str11, pageViewDto);
    }

    @SerialName("buid")
    public static void getBuid$annotations() {
    }

    @SerialName(Bayeux.KEY_CHANNEL)
    public static void getChannel$annotations() {
    }

    @SerialName("pageView")
    public static void getPageView$annotations() {
    }

    @SerialName(FrontendEventsStorage.KEY_SUID)
    public static void getSuid$annotations() {
    }

    @SerialName("timestamp")
    public static void getTimestamp$annotations() {
    }

    @SerialName("url")
    public static void getUrl$annotations() {
    }

    @SerialName(ClientCookie.VERSION_ATTR)
    public static void getVersion$annotations() {
    }

    public final String getUrl() {
        return this.url;
    }

    public final String getBuid() {
        return this.buid;
    }

    public final String getChannel() {
        return this.channel;
    }

    public final String getVersion() {
        return this.version;
    }

    public final String getTimestamp() {
        return this.timestamp;
    }

    public final String getSuid() {
        return this.suid;
    }

    public final PageViewDto getPageView() {
        return this.pageView;
    }

    public final PageViewEventDto copy(String url, String buid, String channel, String version, String timestamp, String suid, PageViewDto pageView) {
        Intrinsics.checkNotNullParameter(url, "url");
        Intrinsics.checkNotNullParameter(buid, "buid");
        Intrinsics.checkNotNullParameter(channel, "channel");
        Intrinsics.checkNotNullParameter(version, "version");
        Intrinsics.checkNotNullParameter(timestamp, "timestamp");
        Intrinsics.checkNotNullParameter(suid, "suid");
        Intrinsics.checkNotNullParameter(pageView, "pageView");
        return new PageViewEventDto(url, buid, channel, version, timestamp, suid, pageView);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof PageViewEventDto)) {
            return false;
        }
        PageViewEventDto pageViewEventDto = (PageViewEventDto) other;
        return Intrinsics.areEqual(this.url, pageViewEventDto.url) && Intrinsics.areEqual(this.buid, pageViewEventDto.buid) && Intrinsics.areEqual(this.channel, pageViewEventDto.channel) && Intrinsics.areEqual(this.version, pageViewEventDto.version) && Intrinsics.areEqual(this.timestamp, pageViewEventDto.timestamp) && Intrinsics.areEqual(this.suid, pageViewEventDto.suid) && Intrinsics.areEqual(this.pageView, pageViewEventDto.pageView);
    }

    public int hashCode() {
        return (((((((((((this.url.hashCode() * 31) + this.buid.hashCode()) * 31) + this.channel.hashCode()) * 31) + this.version.hashCode()) * 31) + this.timestamp.hashCode()) * 31) + this.suid.hashCode()) * 31) + this.pageView.hashCode();
    }

    public String toString() {
        return "PageViewEventDto(url=" + this.url + ", buid=" + this.buid + ", channel=" + this.channel + ", version=" + this.version + ", timestamp=" + this.timestamp + ", suid=" + this.suid + ", pageView=" + this.pageView + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/frontendevents/pageviewevents/model/PageViewEventDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/frontendevents/pageviewevents/model/PageViewEventDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<PageViewEventDto> serializer() {
            return PageViewEventDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public PageViewEventDto(int i, @SerialName("url") String str, @SerialName("buid") String str2, @SerialName(Bayeux.KEY_CHANNEL) String str3, @SerialName(ClientCookie.VERSION_ATTR) String str4, @SerialName("timestamp") String str5, @SerialName(FrontendEventsStorage.KEY_SUID) String str6, @SerialName("pageView") PageViewDto pageViewDto, SerializationConstructorMarker serializationConstructorMarker) {
        if (127 != (i & 127)) {
            PluginExceptionsKt.throwMissingFieldException(i, 127, PageViewEventDto$$serializer.INSTANCE.getDescriptor());
        }
        this.url = str;
        this.buid = str2;
        this.channel = str3;
        this.version = str4;
        this.timestamp = str5;
        this.suid = str6;
        this.pageView = pageViewDto;
    }

    public PageViewEventDto(String url, String buid, String channel, String version, String timestamp, String suid, PageViewDto pageView) {
        Intrinsics.checkNotNullParameter(url, "url");
        Intrinsics.checkNotNullParameter(buid, "buid");
        Intrinsics.checkNotNullParameter(channel, "channel");
        Intrinsics.checkNotNullParameter(version, "version");
        Intrinsics.checkNotNullParameter(timestamp, "timestamp");
        Intrinsics.checkNotNullParameter(suid, "suid");
        Intrinsics.checkNotNullParameter(pageView, "pageView");
        this.url = url;
        this.buid = buid;
        this.channel = channel;
        this.version = version;
        this.timestamp = timestamp;
        this.suid = suid;
        this.pageView = pageView;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(PageViewEventDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.url);
        output.encodeStringElement(serialDesc, 1, self.buid);
        output.encodeStringElement(serialDesc, 2, self.channel);
        output.encodeStringElement(serialDesc, 3, self.version);
        output.encodeStringElement(serialDesc, 4, self.timestamp);
        output.encodeStringElement(serialDesc, 5, self.suid);
        output.encodeSerializableElement(serialDesc, 6, PageViewDto$$serializer.INSTANCE, self.pageView);
    }

    public final String getUrl() {
        return this.url;
    }

    public final String getBuid() {
        return this.buid;
    }

    public final String getChannel() {
        return this.channel;
    }

    public final String getVersion() {
        return this.version;
    }

    public final String getTimestamp() {
        return this.timestamp;
    }

    public final String getSuid() {
        return this.suid;
    }

    public final PageViewDto getPageView() {
        return this.pageView;
    }
}
