package zendesk.guidekit.android.internal.rest.model;

import j$.time.LocalDateTime;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlinx.serialization.ContextualSerializer;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.BooleanSerializer;
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b9\b\u0081\b\u0018\u0000 U2\u00020\u0001:\u0002VUB\u008f\u0001\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\r\u001a\u00020\u0002\u0012\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u000e\u0012\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u0002\u0012\n\b\u0002\u0010\u0011\u001a\u0004\u0018\u00010\u0004¢\u0006\u0004\b\u0012\u0010\u0013B\u009f\u0001\b\u0011\u0012\u0006\u0010\u0015\u001a\u00020\u0014\u0012\b\b\u0001\u0010\u0003\u001a\u00020\u0002\u0012\n\b\u0001\u0010\u0005\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0001\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0001\u0010\t\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0001\u0010\n\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0001\u0010\u000b\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0001\u0010\f\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\r\u001a\u00020\u0002\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u000e\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0011\u001a\u0004\u0018\u00010\u0004\u0012\b\u0010\u0017\u001a\u0004\u0018\u00010\u0016¢\u0006\u0004\b\u0012\u0010\u0018J(\u0010!\u001a\u00020\u001e2\u0006\u0010\u0019\u001a\u00020\u00002\u0006\u0010\u001b\u001a\u00020\u001a2\u0006\u0010\u001d\u001a\u00020\u001cHÁ\u0001¢\u0006\u0004\b\u001f\u0010 J\u0010\u0010\"\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b\"\u0010#J\u0012\u0010$\u001a\u0004\u0018\u00010\u0004HÆ\u0003¢\u0006\u0004\b$\u0010%J\u0012\u0010&\u001a\u0004\u0018\u00010\u0004HÆ\u0003¢\u0006\u0004\b&\u0010%J\u0012\u0010'\u001a\u0004\u0018\u00010\u0007HÆ\u0003¢\u0006\u0004\b'\u0010(J\u0012\u0010)\u001a\u0004\u0018\u00010\u0004HÆ\u0003¢\u0006\u0004\b)\u0010%J\u0012\u0010*\u001a\u0004\u0018\u00010\u0004HÆ\u0003¢\u0006\u0004\b*\u0010%J\u0012\u0010+\u001a\u0004\u0018\u00010\u0004HÆ\u0003¢\u0006\u0004\b+\u0010%J\u0012\u0010,\u001a\u0004\u0018\u00010\u0007HÆ\u0003¢\u0006\u0004\b,\u0010(J\u0010\u0010-\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b-\u0010#J\u0012\u0010.\u001a\u0004\u0018\u00010\u000eHÆ\u0003¢\u0006\u0004\b.\u0010/J\u0012\u00100\u001a\u0004\u0018\u00010\u0002HÆ\u0003¢\u0006\u0004\b0\u00101J\u0012\u00102\u001a\u0004\u0018\u00010\u0004HÆ\u0003¢\u0006\u0004\b2\u0010%J\u009c\u0001\u00103\u001a\u00020\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00022\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00042\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00042\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00072\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u00042\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u00042\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u00042\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\r\u001a\u00020\u00022\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00022\n\b\u0002\u0010\u0011\u001a\u0004\u0018\u00010\u0004HÆ\u0001¢\u0006\u0004\b3\u00104J\u0010\u00105\u001a\u00020\u0004HÖ\u0001¢\u0006\u0004\b5\u0010%J\u0010\u00106\u001a\u00020\u0014HÖ\u0001¢\u0006\u0004\b6\u00107J\u001a\u00109\u001a\u00020\u000e2\b\u00108\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b9\u0010:R \u0010\u0003\u001a\u00020\u00028\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u0003\u0010;\u0012\u0004\b=\u0010>\u001a\u0004\b<\u0010#R\"\u0010\u0005\u001a\u0004\u0018\u00010\u00048\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u0005\u0010?\u0012\u0004\bA\u0010>\u001a\u0004\b@\u0010%R\"\u0010\u0006\u001a\u0004\u0018\u00010\u00048\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u0006\u0010?\u0012\u0004\bC\u0010>\u001a\u0004\bB\u0010%R\"\u0010\b\u001a\u0004\u0018\u00010\u00078\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\b\u0010D\u0012\u0004\bF\u0010>\u001a\u0004\bE\u0010(R\"\u0010\t\u001a\u0004\u0018\u00010\u00048\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\t\u0010?\u0012\u0004\bH\u0010>\u001a\u0004\bG\u0010%R\"\u0010\n\u001a\u0004\u0018\u00010\u00048\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\n\u0010?\u0012\u0004\bJ\u0010>\u001a\u0004\bI\u0010%R\"\u0010\u000b\u001a\u0004\u0018\u00010\u00048\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u000b\u0010?\u0012\u0004\bL\u0010>\u001a\u0004\bK\u0010%R\"\u0010\f\u001a\u0004\u0018\u00010\u00078\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\f\u0010D\u0012\u0004\bN\u0010>\u001a\u0004\bM\u0010(R\u0017\u0010\r\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\r\u0010;\u001a\u0004\bO\u0010#R\u0019\u0010\u000f\u001a\u0004\u0018\u00010\u000e8\u0006¢\u0006\f\n\u0004\b\u000f\u0010P\u001a\u0004\bQ\u0010/R\u0019\u0010\u0010\u001a\u0004\u0018\u00010\u00028\u0006¢\u0006\f\n\u0004\b\u0010\u0010R\u001a\u0004\bS\u00101R\u0019\u0010\u0011\u001a\u0004\u0018\u00010\u00048\u0006¢\u0006\f\n\u0004\b\u0011\u0010?\u001a\u0004\bT\u0010%¨\u0006W"}, m18d2 = {"Lzendesk/guidekit/android/internal/rest/model/AttachmentDto;", "", "", "articleId", "", "contentType", "contentUrl", "j$/time/LocalDateTime", "createdAt", "displayFileName", "fileName", "relativePath", "updatedAt", "id", "", "inline", "size", "url", "<init>", "(JLjava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;JLjava/lang/Boolean;Ljava/lang/Long;Ljava/lang/String;)V", "", "seen1", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "serializationConstructorMarker", "(IJLjava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;JLjava/lang/Boolean;Ljava/lang/Long;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "self", "Lkotlinx/serialization/encoding/CompositeEncoder;", "output", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "serialDesc", "", "write$Self$zendesk_guidekit_guidekit_android", "(Lzendesk/guidekit/android/internal/rest/model/AttachmentDto;Lkotlinx/serialization/encoding/CompositeEncoder;Lkotlinx/serialization/descriptors/SerialDescriptor;)V", "write$Self", "component1", "()J", "component2", "()Ljava/lang/String;", "component3", "component4", "()Lj$/time/LocalDateTime;", "component5", "component6", "component7", "component8", "component9", "component10", "()Ljava/lang/Boolean;", "component11", "()Ljava/lang/Long;", "component12", "copy", "(JLjava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;JLjava/lang/Boolean;Ljava/lang/Long;Ljava/lang/String;)Lzendesk/guidekit/android/internal/rest/model/AttachmentDto;", "toString", "hashCode", "()I", "other", "equals", "(Ljava/lang/Object;)Z", "J", "getArticleId", "getArticleId$annotations", "()V", "Ljava/lang/String;", "getContentType", "getContentType$annotations", "getContentUrl", "getContentUrl$annotations", "Lj$/time/LocalDateTime;", "getCreatedAt", "getCreatedAt$annotations", "getDisplayFileName", "getDisplayFileName$annotations", "getFileName", "getFileName$annotations", "getRelativePath", "getRelativePath$annotations", "getUpdatedAt", "getUpdatedAt$annotations", "getId", "Ljava/lang/Boolean;", "getInline", "Ljava/lang/Long;", "getSize", "getUrl", "Companion", "$serializer", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class AttachmentDto {
    private final long articleId;
    private final String contentType;
    private final String contentUrl;
    private final LocalDateTime createdAt;
    private final String displayFileName;
    private final String fileName;
    private final long id;
    private final Boolean inline;
    private final String relativePath;
    private final Long size;
    private final LocalDateTime updatedAt;
    private final String url;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, null, new ContextualSerializer(Reflection.getOrCreateKotlinClass(LocalDateTime.class), null, new KSerializer[0]), null, null, null, new ContextualSerializer(Reflection.getOrCreateKotlinClass(LocalDateTime.class), null, new KSerializer[0]), null, null, null, null};

    @SerialName("article_id")
    public static void getArticleId$annotations() {
    }

    @SerialName("content_type")
    public static void getContentType$annotations() {
    }

    @SerialName("content_url")
    public static void getContentUrl$annotations() {
    }

    @SerialName("created_at")
    public static void getCreatedAt$annotations() {
    }

    @SerialName("display_file_name")
    public static void getDisplayFileName$annotations() {
    }

    @SerialName("file_name")
    public static void getFileName$annotations() {
    }

    @SerialName("relative_path")
    public static void getRelativePath$annotations() {
    }

    @SerialName("updated_at")
    public static void getUpdatedAt$annotations() {
    }

    public final long getArticleId() {
        return this.articleId;
    }

    public final Boolean getInline() {
        return this.inline;
    }

    public final Long getSize() {
        return this.size;
    }

    public final String getUrl() {
        return this.url;
    }

    public final String getContentType() {
        return this.contentType;
    }

    public final String getContentUrl() {
        return this.contentUrl;
    }

    public final LocalDateTime getCreatedAt() {
        return this.createdAt;
    }

    public final String getDisplayFileName() {
        return this.displayFileName;
    }

    public final String getFileName() {
        return this.fileName;
    }

    public final String getRelativePath() {
        return this.relativePath;
    }

    public final LocalDateTime getUpdatedAt() {
        return this.updatedAt;
    }

    public final long getId() {
        return this.id;
    }

    public final AttachmentDto copy(long articleId, String contentType, String contentUrl, LocalDateTime createdAt, String displayFileName, String fileName, String relativePath, LocalDateTime updatedAt, long id, Boolean inline, Long size, String url) {
        return new AttachmentDto(articleId, contentType, contentUrl, createdAt, displayFileName, fileName, relativePath, updatedAt, id, inline, size, url);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AttachmentDto)) {
            return false;
        }
        AttachmentDto attachmentDto = (AttachmentDto) other;
        return this.articleId == attachmentDto.articleId && Intrinsics.areEqual(this.contentType, attachmentDto.contentType) && Intrinsics.areEqual(this.contentUrl, attachmentDto.contentUrl) && Intrinsics.areEqual(this.createdAt, attachmentDto.createdAt) && Intrinsics.areEqual(this.displayFileName, attachmentDto.displayFileName) && Intrinsics.areEqual(this.fileName, attachmentDto.fileName) && Intrinsics.areEqual(this.relativePath, attachmentDto.relativePath) && Intrinsics.areEqual(this.updatedAt, attachmentDto.updatedAt) && this.id == attachmentDto.id && Intrinsics.areEqual(this.inline, attachmentDto.inline) && Intrinsics.areEqual(this.size, attachmentDto.size) && Intrinsics.areEqual(this.url, attachmentDto.url);
    }

    public int hashCode() {
        int iM27m = UByte$$ExternalSyntheticBackport0.m27m(this.articleId) * 31;
        String str = this.contentType;
        int iHashCode = (iM27m + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.contentUrl;
        int iHashCode2 = (iHashCode + (str2 == null ? 0 : str2.hashCode())) * 31;
        LocalDateTime localDateTime = this.createdAt;
        int iHashCode3 = (iHashCode2 + (localDateTime == null ? 0 : localDateTime.hashCode())) * 31;
        String str3 = this.displayFileName;
        int iHashCode4 = (iHashCode3 + (str3 == null ? 0 : str3.hashCode())) * 31;
        String str4 = this.fileName;
        int iHashCode5 = (iHashCode4 + (str4 == null ? 0 : str4.hashCode())) * 31;
        String str5 = this.relativePath;
        int iHashCode6 = (iHashCode5 + (str5 == null ? 0 : str5.hashCode())) * 31;
        LocalDateTime localDateTime2 = this.updatedAt;
        int iHashCode7 = (((iHashCode6 + (localDateTime2 == null ? 0 : localDateTime2.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.id)) * 31;
        Boolean bool = this.inline;
        int iHashCode8 = (iHashCode7 + (bool == null ? 0 : bool.hashCode())) * 31;
        Long l = this.size;
        int iHashCode9 = (iHashCode8 + (l == null ? 0 : l.hashCode())) * 31;
        String str6 = this.url;
        return iHashCode9 + (str6 != null ? str6.hashCode() : 0);
    }

    public String toString() {
        return "AttachmentDto(articleId=" + this.articleId + ", contentType=" + this.contentType + ", contentUrl=" + this.contentUrl + ", createdAt=" + this.createdAt + ", displayFileName=" + this.displayFileName + ", fileName=" + this.fileName + ", relativePath=" + this.relativePath + ", updatedAt=" + this.updatedAt + ", id=" + this.id + ", inline=" + this.inline + ", size=" + this.size + ", url=" + this.url + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/guidekit/android/internal/rest/model/AttachmentDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/guidekit/android/internal/rest/model/AttachmentDto;", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<AttachmentDto> serializer() {
            return AttachmentDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public AttachmentDto(int i, @SerialName("article_id") long j, @SerialName("content_type") String str, @SerialName("content_url") String str2, @SerialName("created_at") LocalDateTime localDateTime, @SerialName("display_file_name") String str3, @SerialName("file_name") String str4, @SerialName("relative_path") String str5, @SerialName("updated_at") LocalDateTime localDateTime2, long j2, Boolean bool, Long l, String str6, SerializationConstructorMarker serializationConstructorMarker) {
        if (257 != (i & 257)) {
            PluginExceptionsKt.throwMissingFieldException(i, 257, AttachmentDto$$serializer.INSTANCE.getDescriptor());
        }
        this.articleId = j;
        if ((i & 2) == 0) {
            this.contentType = null;
        } else {
            this.contentType = str;
        }
        if ((i & 4) == 0) {
            this.contentUrl = null;
        } else {
            this.contentUrl = str2;
        }
        if ((i & 8) == 0) {
            this.createdAt = null;
        } else {
            this.createdAt = localDateTime;
        }
        if ((i & 16) == 0) {
            this.displayFileName = null;
        } else {
            this.displayFileName = str3;
        }
        if ((i & 32) == 0) {
            this.fileName = null;
        } else {
            this.fileName = str4;
        }
        if ((i & 64) == 0) {
            this.relativePath = null;
        } else {
            this.relativePath = str5;
        }
        if ((i & 128) == 0) {
            this.updatedAt = null;
        } else {
            this.updatedAt = localDateTime2;
        }
        this.id = j2;
        if ((i & 512) == 0) {
            this.inline = null;
        } else {
            this.inline = bool;
        }
        if ((i & 1024) == 0) {
            this.size = null;
        } else {
            this.size = l;
        }
        if ((i & 2048) == 0) {
            this.url = null;
        } else {
            this.url = str6;
        }
    }

    public AttachmentDto(long j, String str, String str2, LocalDateTime localDateTime, String str3, String str4, String str5, LocalDateTime localDateTime2, long j2, Boolean bool, Long l, String str6) {
        this.articleId = j;
        this.contentType = str;
        this.contentUrl = str2;
        this.createdAt = localDateTime;
        this.displayFileName = str3;
        this.fileName = str4;
        this.relativePath = str5;
        this.updatedAt = localDateTime2;
        this.id = j2;
        this.inline = bool;
        this.size = l;
        this.url = str6;
    }

    @JvmStatic
    public static final void write$Self$zendesk_guidekit_guidekit_android(AttachmentDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeLongElement(serialDesc, 0, self.articleId);
        if (output.shouldEncodeElementDefault(serialDesc, 1) || self.contentType != null) {
            output.encodeNullableSerializableElement(serialDesc, 1, StringSerializer.INSTANCE, self.contentType);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.contentUrl != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.contentUrl);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 3) || self.createdAt != null) {
            output.encodeNullableSerializableElement(serialDesc, 3, kSerializerArr[3], self.createdAt);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 4) || self.displayFileName != null) {
            output.encodeNullableSerializableElement(serialDesc, 4, StringSerializer.INSTANCE, self.displayFileName);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 5) || self.fileName != null) {
            output.encodeNullableSerializableElement(serialDesc, 5, StringSerializer.INSTANCE, self.fileName);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 6) || self.relativePath != null) {
            output.encodeNullableSerializableElement(serialDesc, 6, StringSerializer.INSTANCE, self.relativePath);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 7) || self.updatedAt != null) {
            output.encodeNullableSerializableElement(serialDesc, 7, kSerializerArr[7], self.updatedAt);
        }
        output.encodeLongElement(serialDesc, 8, self.id);
        if (output.shouldEncodeElementDefault(serialDesc, 9) || self.inline != null) {
            output.encodeNullableSerializableElement(serialDesc, 9, BooleanSerializer.INSTANCE, self.inline);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 10) || self.size != null) {
            output.encodeNullableSerializableElement(serialDesc, 10, LongSerializer.INSTANCE, self.size);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 11) && self.url == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 11, StringSerializer.INSTANCE, self.url);
    }

    public AttachmentDto(long j, String str, String str2, LocalDateTime localDateTime, String str3, String str4, String str5, LocalDateTime localDateTime2, long j2, Boolean bool, Long l, String str6, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, (i & 2) != 0 ? null : str, (i & 4) != 0 ? null : str2, (i & 8) != 0 ? null : localDateTime, (i & 16) != 0 ? null : str3, (i & 32) != 0 ? null : str4, (i & 64) != 0 ? null : str5, (i & 128) != 0 ? null : localDateTime2, j2, (i & 512) != 0 ? null : bool, (i & 1024) != 0 ? null : l, (i & 2048) != 0 ? null : str6);
    }

    public final long getArticleId() {
        return this.articleId;
    }

    public final String getContentType() {
        return this.contentType;
    }

    public final String getContentUrl() {
        return this.contentUrl;
    }

    public final LocalDateTime getCreatedAt() {
        return this.createdAt;
    }

    public final String getDisplayFileName() {
        return this.displayFileName;
    }

    public final String getFileName() {
        return this.fileName;
    }

    public final String getRelativePath() {
        return this.relativePath;
    }

    public final LocalDateTime getUpdatedAt() {
        return this.updatedAt;
    }

    public final long getId() {
        return this.id;
    }

    public final Boolean getInline() {
        return this.inline;
    }

    public final Long getSize() {
        return this.size;
    }

    public final String getUrl() {
        return this.url;
    }
}
