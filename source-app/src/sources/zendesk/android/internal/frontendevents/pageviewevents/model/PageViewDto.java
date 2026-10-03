package zendesk.android.internal.frontendevents.pageviewevents.model;

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

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 &2\u00020\u0001:\u0002%&B=\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB\u001d\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005¢\u0006\u0002\u0010\u000bJ\t\u0010\u0014\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0016\u001a\u00020\u0005HÆ\u0003J'\u0010\u0017\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0018\u001a\u00020\u00192\b\u0010\u001a\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001b\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001c\u001a\u00020\u0005HÖ\u0001J&\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u00002\u0006\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020#HÁ\u0001¢\u0006\u0002\b$R\u001c\u0010\u0006\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\f\u0010\r\u001a\u0004\b\u000e\u0010\u000fR\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0010\u0010\r\u001a\u0004\b\u0011\u0010\u000fR\u001c\u0010\u0007\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0012\u0010\r\u001a\u0004\b\u0013\u0010\u000f¨\u0006'"}, m18d2 = {"Lzendesk/android/internal/frontendevents/pageviewevents/model/PageViewDto;", "", "seen1", "", "pageTitle", "", "navigatorLanguage", "userAgent", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getNavigatorLanguage$annotations", "()V", "getNavigatorLanguage", "()Ljava/lang/String;", "getPageTitle$annotations", "getPageTitle", "getUserAgent$annotations", "getUserAgent", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class PageViewDto {

    public static final Companion INSTANCE = new Companion(null);
    private final String navigatorLanguage;
    private final String pageTitle;
    private final String userAgent;

    public static PageViewDto copy$default(PageViewDto pageViewDto, String str, String str2, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            str = pageViewDto.pageTitle;
        }
        if ((i & 2) != 0) {
            str2 = pageViewDto.navigatorLanguage;
        }
        if ((i & 4) != 0) {
            str3 = pageViewDto.userAgent;
        }
        return pageViewDto.copy(str, str2, str3);
    }

    @SerialName("navigatorLanguage")
    public static void getNavigatorLanguage$annotations() {
    }

    @SerialName("pageTitle")
    public static void getPageTitle$annotations() {
    }

    @SerialName("userAgent")
    public static void getUserAgent$annotations() {
    }

    public final String getPageTitle() {
        return this.pageTitle;
    }

    public final String getNavigatorLanguage() {
        return this.navigatorLanguage;
    }

    public final String getUserAgent() {
        return this.userAgent;
    }

    public final PageViewDto copy(String pageTitle, String navigatorLanguage, String userAgent) {
        Intrinsics.checkNotNullParameter(pageTitle, "pageTitle");
        Intrinsics.checkNotNullParameter(navigatorLanguage, "navigatorLanguage");
        Intrinsics.checkNotNullParameter(userAgent, "userAgent");
        return new PageViewDto(pageTitle, navigatorLanguage, userAgent);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof PageViewDto)) {
            return false;
        }
        PageViewDto pageViewDto = (PageViewDto) other;
        return Intrinsics.areEqual(this.pageTitle, pageViewDto.pageTitle) && Intrinsics.areEqual(this.navigatorLanguage, pageViewDto.navigatorLanguage) && Intrinsics.areEqual(this.userAgent, pageViewDto.userAgent);
    }

    public int hashCode() {
        return (((this.pageTitle.hashCode() * 31) + this.navigatorLanguage.hashCode()) * 31) + this.userAgent.hashCode();
    }

    public String toString() {
        return "PageViewDto(pageTitle=" + this.pageTitle + ", navigatorLanguage=" + this.navigatorLanguage + ", userAgent=" + this.userAgent + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/frontendevents/pageviewevents/model/PageViewDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/frontendevents/pageviewevents/model/PageViewDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<PageViewDto> serializer() {
            return PageViewDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public PageViewDto(int i, @SerialName("pageTitle") String str, @SerialName("navigatorLanguage") String str2, @SerialName("userAgent") String str3, SerializationConstructorMarker serializationConstructorMarker) {
        if (7 != (i & 7)) {
            PluginExceptionsKt.throwMissingFieldException(i, 7, PageViewDto$$serializer.INSTANCE.getDescriptor());
        }
        this.pageTitle = str;
        this.navigatorLanguage = str2;
        this.userAgent = str3;
    }

    public PageViewDto(String pageTitle, String navigatorLanguage, String userAgent) {
        Intrinsics.checkNotNullParameter(pageTitle, "pageTitle");
        Intrinsics.checkNotNullParameter(navigatorLanguage, "navigatorLanguage");
        Intrinsics.checkNotNullParameter(userAgent, "userAgent");
        this.pageTitle = pageTitle;
        this.navigatorLanguage = navigatorLanguage;
        this.userAgent = userAgent;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(PageViewDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.pageTitle);
        output.encodeStringElement(serialDesc, 1, self.navigatorLanguage);
        output.encodeStringElement(serialDesc, 2, self.userAgent);
    }

    public final String getPageTitle() {
        return this.pageTitle;
    }

    public final String getNavigatorLanguage() {
        return this.navigatorLanguage;
    }

    public final String getUserAgent() {
        return this.userAgent;
    }
}
