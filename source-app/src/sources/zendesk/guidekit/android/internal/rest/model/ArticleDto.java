package zendesk.guidekit.android.internal.rest.model;

import j$.time.LocalDateTime;
import java.util.List;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
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
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.BooleanSerializer;
import kotlinx.serialization.internal.IntSerializer;
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;
import net.aihelp.common.IntentValues;

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b3\b\u0001\u0018\u0000 X2\u00020\u0001:\u0002YXBõ\u0001\u0012\n\b\u0002\u0010\u0003\u001a\u0004\u0018\u00010\u0002\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u0006\u0012\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\b\u0012\u0010\b\u0002\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\n\u0012\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u0002\u0012\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\b\u0012\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u0006\u0012\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u000f\u0012\n\b\u0002\u0010\u0011\u001a\u0004\u0018\u00010\u000f\u0012\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\b\u0012\n\b\u0002\u0010\u0013\u001a\u0004\u0018\u00010\u0004\u0012\u0006\u0010\u0014\u001a\u00020\u0002\u0012\u0006\u0010\u0015\u001a\u00020\b\u0012\n\b\u0002\u0010\u0016\u001a\u0004\u0018\u00010\b\u0012\n\b\u0002\u0010\u0017\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0002\u0010\u0018\u001a\u0004\u0018\u00010\u000f\u0012\n\b\u0002\u0010\u0019\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0002\u0010\u001a\u001a\u0004\u0018\u00010\b\u0012\n\b\u0002\u0010\u001b\u001a\u0004\u0018\u00010\b¢\u0006\u0004\b\u001c\u0010\u001dBû\u0001\b\u0011\u0012\u0006\u0010\u001e\u001a\u00020\u000f\u0012\n\b\u0001\u0010\u0003\u001a\u0004\u0018\u00010\u0002\u0012\n\b\u0001\u0010\u0005\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0001\u0010\u0007\u001a\u0004\u0018\u00010\u0006\u0012\n\b\u0001\u0010\t\u001a\u0004\u0018\u00010\b\u0012\u0010\b\u0001\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\n\u0012\n\b\u0001\u0010\f\u001a\u0004\u0018\u00010\u0002\u0012\n\b\u0001\u0010\r\u001a\u0004\u0018\u00010\b\u0012\n\b\u0001\u0010\u000e\u001a\u0004\u0018\u00010\u0006\u0012\n\b\u0001\u0010\u0010\u001a\u0004\u0018\u00010\u000f\u0012\n\b\u0001\u0010\u0011\u001a\u0004\u0018\u00010\u000f\u0012\b\u0010\u0012\u001a\u0004\u0018\u00010\b\u0012\b\u0010\u0013\u001a\u0004\u0018\u00010\u0004\u0012\u0006\u0010\u0014\u001a\u00020\u0002\u0012\b\u0010\u0015\u001a\u0004\u0018\u00010\b\u0012\b\u0010\u0016\u001a\u0004\u0018\u00010\b\u0012\b\u0010\u0017\u001a\u0004\u0018\u00010\u0004\u0012\b\u0010\u0018\u001a\u0004\u0018\u00010\u000f\u0012\b\u0010\u0019\u001a\u0004\u0018\u00010\u0004\u0012\b\u0010\u001a\u001a\u0004\u0018\u00010\b\u0012\b\u0010\u001b\u001a\u0004\u0018\u00010\b\u0012\b\u0010 \u001a\u0004\u0018\u00010\u001f¢\u0006\u0004\b\u001c\u0010!J(\u0010*\u001a\u00020'2\u0006\u0010\"\u001a\u00020\u00002\u0006\u0010$\u001a\u00020#2\u0006\u0010&\u001a\u00020%HÁ\u0001¢\u0006\u0004\b(\u0010)R\"\u0010\u0003\u001a\u0004\u0018\u00010\u00028\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u0003\u0010+\u0012\u0004\b.\u0010/\u001a\u0004\b,\u0010-R\"\u0010\u0005\u001a\u0004\u0018\u00010\u00048\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u0005\u00100\u0012\u0004\b3\u0010/\u001a\u0004\b1\u00102R\"\u0010\u0007\u001a\u0004\u0018\u00010\u00068\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u0007\u00104\u0012\u0004\b7\u0010/\u001a\u0004\b5\u00106R\"\u0010\t\u001a\u0004\u0018\u00010\b8\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\t\u00108\u0012\u0004\b;\u0010/\u001a\u0004\b9\u0010:R(\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\n8\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u000b\u0010<\u0012\u0004\b?\u0010/\u001a\u0004\b=\u0010>R\"\u0010\f\u001a\u0004\u0018\u00010\u00028\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\f\u0010+\u0012\u0004\bA\u0010/\u001a\u0004\b@\u0010-R\"\u0010\r\u001a\u0004\u0018\u00010\b8\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\r\u00108\u0012\u0004\bC\u0010/\u001a\u0004\bB\u0010:R\"\u0010\u000e\u001a\u0004\u0018\u00010\u00068\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u000e\u00104\u0012\u0004\bE\u0010/\u001a\u0004\bD\u00106R\"\u0010\u0010\u001a\u0004\u0018\u00010\u000f8\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u0010\u0010F\u0012\u0004\bI\u0010/\u001a\u0004\bG\u0010HR\"\u0010\u0011\u001a\u0004\u0018\u00010\u000f8\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u0011\u0010F\u0012\u0004\bK\u0010/\u001a\u0004\bJ\u0010HR\u0019\u0010\u0012\u001a\u0004\u0018\u00010\b8\u0006¢\u0006\f\n\u0004\b\u0012\u00108\u001a\u0004\bL\u0010:R\u0019\u0010\u0013\u001a\u0004\u0018\u00010\u00048\u0006¢\u0006\f\n\u0004\b\u0013\u00100\u001a\u0004\bM\u00102R\u0017\u0010\u0014\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\u0014\u0010N\u001a\u0004\bO\u0010PR\u0017\u0010\u0015\u001a\u00020\b8\u0006¢\u0006\f\n\u0004\b\u0015\u00108\u001a\u0004\bQ\u0010:R\u0019\u0010\u0016\u001a\u0004\u0018\u00010\b8\u0006¢\u0006\f\n\u0004\b\u0016\u00108\u001a\u0004\bR\u0010:R\u0019\u0010\u0017\u001a\u0004\u0018\u00010\u00048\u0006¢\u0006\f\n\u0004\b\u0017\u00100\u001a\u0004\bS\u00102R\u0019\u0010\u0018\u001a\u0004\u0018\u00010\u000f8\u0006¢\u0006\f\n\u0004\b\u0018\u0010F\u001a\u0004\bT\u0010HR\u0019\u0010\u0019\u001a\u0004\u0018\u00010\u00048\u0006¢\u0006\f\n\u0004\b\u0019\u00100\u001a\u0004\bU\u00102R\u0019\u0010\u001a\u001a\u0004\u0018\u00010\b8\u0006¢\u0006\f\n\u0004\b\u001a\u00108\u001a\u0004\bV\u0010:R\u0019\u0010\u001b\u001a\u0004\u0018\u00010\b8\u0006¢\u0006\f\n\u0004\b\u001b\u00108\u001a\u0004\bW\u0010:¨\u0006Z"}, m18d2 = {"Lzendesk/guidekit/android/internal/rest/model/ArticleDto;", "", "", "authorId", "", "commentsDisabled", "j$/time/LocalDateTime", "createdAt", "", "htmlUrl", "", "labelNames", "sectionId", "sourceLocale", "updatedAt", "", "voteCount", "voteSum", "body", "draft", "id", "locale", "name", "outdated", "position", "promoted", "title", "url", "<init>", "(Ljava/lang/Long;Ljava/lang/Boolean;Lj$/time/LocalDateTime;Ljava/lang/String;Ljava/util/List;Ljava/lang/Long;Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/String;Ljava/lang/Boolean;JLjava/lang/String;Ljava/lang/String;Ljava/lang/Boolean;Ljava/lang/Integer;Ljava/lang/Boolean;Ljava/lang/String;Ljava/lang/String;)V", "seen1", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "serializationConstructorMarker", "(ILjava/lang/Long;Ljava/lang/Boolean;Lj$/time/LocalDateTime;Ljava/lang/String;Ljava/util/List;Ljava/lang/Long;Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/String;Ljava/lang/Boolean;JLjava/lang/String;Ljava/lang/String;Ljava/lang/Boolean;Ljava/lang/Integer;Ljava/lang/Boolean;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "self", "Lkotlinx/serialization/encoding/CompositeEncoder;", "output", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "serialDesc", "", "write$Self$zendesk_guidekit_guidekit_android", "(Lzendesk/guidekit/android/internal/rest/model/ArticleDto;Lkotlinx/serialization/encoding/CompositeEncoder;Lkotlinx/serialization/descriptors/SerialDescriptor;)V", "write$Self", "Ljava/lang/Long;", "getAuthorId", "()Ljava/lang/Long;", "getAuthorId$annotations", "()V", "Ljava/lang/Boolean;", "getCommentsDisabled", "()Ljava/lang/Boolean;", "getCommentsDisabled$annotations", "Lj$/time/LocalDateTime;", "getCreatedAt", "()Lj$/time/LocalDateTime;", "getCreatedAt$annotations", "Ljava/lang/String;", "getHtmlUrl", "()Ljava/lang/String;", "getHtmlUrl$annotations", "Ljava/util/List;", "getLabelNames", "()Ljava/util/List;", "getLabelNames$annotations", "getSectionId", "getSectionId$annotations", "getSourceLocale", "getSourceLocale$annotations", "getUpdatedAt", "getUpdatedAt$annotations", "Ljava/lang/Integer;", "getVoteCount", "()Ljava/lang/Integer;", "getVoteCount$annotations", "getVoteSum", "getVoteSum$annotations", "getBody", "getDraft", "J", "getId", "()J", "getLocale", "getName", "getOutdated", "getPosition", "getPromoted", "getTitle", "getUrl", "Companion", "$serializer", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ArticleDto {
    private final Long authorId;
    private final String body;
    private final Boolean commentsDisabled;
    private final LocalDateTime createdAt;
    private final Boolean draft;
    private final String htmlUrl;
    private final long id;
    private final List<String> labelNames;
    private final String locale;
    private final String name;
    private final Boolean outdated;
    private final Integer position;
    private final Boolean promoted;
    private final Long sectionId;
    private final String sourceLocale;
    private final String title;
    private final LocalDateTime updatedAt;
    private final String url;
    private final Integer voteCount;
    private final Integer voteSum;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, new ContextualSerializer(Reflection.getOrCreateKotlinClass(LocalDateTime.class), null, new KSerializer[0]), null, new ArrayListSerializer(StringSerializer.INSTANCE), null, null, new ContextualSerializer(Reflection.getOrCreateKotlinClass(LocalDateTime.class), null, new KSerializer[0]), null, null, null, null, null, null, null, null, null, null, null, null};

    @SerialName("author_id")
    public static void getAuthorId$annotations() {
    }

    @SerialName("comments_disabled")
    public static void getCommentsDisabled$annotations() {
    }

    @SerialName("created_at")
    public static void getCreatedAt$annotations() {
    }

    @SerialName("html_url")
    public static void getHtmlUrl$annotations() {
    }

    @SerialName("label_names")
    public static void getLabelNames$annotations() {
    }

    @SerialName(IntentValues.SECTION_ID)
    public static void getSectionId$annotations() {
    }

    @SerialName("source_locale")
    public static void getSourceLocale$annotations() {
    }

    @SerialName("updated_at")
    public static void getUpdatedAt$annotations() {
    }

    @SerialName("vote_count")
    public static void getVoteCount$annotations() {
    }

    @SerialName("vote_sum")
    public static void getVoteSum$annotations() {
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/guidekit/android/internal/rest/model/ArticleDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/guidekit/android/internal/rest/model/ArticleDto;", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ArticleDto> serializer() {
            return ArticleDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ArticleDto(int i, @SerialName("author_id") Long l, @SerialName("comments_disabled") Boolean bool, @SerialName("created_at") LocalDateTime localDateTime, @SerialName("html_url") String str, @SerialName("label_names") List list, @SerialName(IntentValues.SECTION_ID) Long l2, @SerialName("source_locale") String str2, @SerialName("updated_at") LocalDateTime localDateTime2, @SerialName("vote_count") Integer num, @SerialName("vote_sum") Integer num2, String str3, Boolean bool2, long j, String str4, String str5, Boolean bool3, Integer num3, Boolean bool4, String str6, String str7, SerializationConstructorMarker serializationConstructorMarker) {
        if (12288 != (i & 12288)) {
            PluginExceptionsKt.throwMissingFieldException(i, 12288, ArticleDto$$serializer.INSTANCE.getDescriptor());
        }
        if ((i & 1) == 0) {
            this.authorId = null;
        } else {
            this.authorId = l;
        }
        if ((i & 2) == 0) {
            this.commentsDisabled = null;
        } else {
            this.commentsDisabled = bool;
        }
        if ((i & 4) == 0) {
            this.createdAt = null;
        } else {
            this.createdAt = localDateTime;
        }
        if ((i & 8) == 0) {
            this.htmlUrl = null;
        } else {
            this.htmlUrl = str;
        }
        if ((i & 16) == 0) {
            this.labelNames = null;
        } else {
            this.labelNames = list;
        }
        if ((i & 32) == 0) {
            this.sectionId = null;
        } else {
            this.sectionId = l2;
        }
        if ((i & 64) == 0) {
            this.sourceLocale = null;
        } else {
            this.sourceLocale = str2;
        }
        if ((i & 128) == 0) {
            this.updatedAt = null;
        } else {
            this.updatedAt = localDateTime2;
        }
        if ((i & 256) == 0) {
            this.voteCount = null;
        } else {
            this.voteCount = num;
        }
        if ((i & 512) == 0) {
            this.voteSum = null;
        } else {
            this.voteSum = num2;
        }
        if ((i & 1024) == 0) {
            this.body = null;
        } else {
            this.body = str3;
        }
        if ((i & 2048) == 0) {
            this.draft = null;
        } else {
            this.draft = bool2;
        }
        this.id = j;
        this.locale = str4;
        if ((i & 16384) == 0) {
            this.name = null;
        } else {
            this.name = str5;
        }
        if ((32768 & i) == 0) {
            this.outdated = null;
        } else {
            this.outdated = bool3;
        }
        if ((65536 & i) == 0) {
            this.position = null;
        } else {
            this.position = num3;
        }
        if ((131072 & i) == 0) {
            this.promoted = null;
        } else {
            this.promoted = bool4;
        }
        if ((262144 & i) == 0) {
            this.title = null;
        } else {
            this.title = str6;
        }
        if ((i & 524288) == 0) {
            this.url = null;
        } else {
            this.url = str7;
        }
    }

    public ArticleDto(Long l, Boolean bool, LocalDateTime localDateTime, String str, List<String> list, Long l2, String str2, LocalDateTime localDateTime2, Integer num, Integer num2, String str3, Boolean bool2, long j, String locale, String str4, Boolean bool3, Integer num3, Boolean bool4, String str5, String str6) {
        Intrinsics.checkNotNullParameter(locale, "locale");
        this.authorId = l;
        this.commentsDisabled = bool;
        this.createdAt = localDateTime;
        this.htmlUrl = str;
        this.labelNames = list;
        this.sectionId = l2;
        this.sourceLocale = str2;
        this.updatedAt = localDateTime2;
        this.voteCount = num;
        this.voteSum = num2;
        this.body = str3;
        this.draft = bool2;
        this.id = j;
        this.locale = locale;
        this.name = str4;
        this.outdated = bool3;
        this.position = num3;
        this.promoted = bool4;
        this.title = str5;
        this.url = str6;
    }

    @JvmStatic
    public static final void write$Self$zendesk_guidekit_guidekit_android(ArticleDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        if (output.shouldEncodeElementDefault(serialDesc, 0) || self.authorId != null) {
            output.encodeNullableSerializableElement(serialDesc, 0, LongSerializer.INSTANCE, self.authorId);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 1) || self.commentsDisabled != null) {
            output.encodeNullableSerializableElement(serialDesc, 1, BooleanSerializer.INSTANCE, self.commentsDisabled);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.createdAt != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, kSerializerArr[2], self.createdAt);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 3) || self.htmlUrl != null) {
            output.encodeNullableSerializableElement(serialDesc, 3, StringSerializer.INSTANCE, self.htmlUrl);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 4) || self.labelNames != null) {
            output.encodeNullableSerializableElement(serialDesc, 4, kSerializerArr[4], self.labelNames);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 5) || self.sectionId != null) {
            output.encodeNullableSerializableElement(serialDesc, 5, LongSerializer.INSTANCE, self.sectionId);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 6) || self.sourceLocale != null) {
            output.encodeNullableSerializableElement(serialDesc, 6, StringSerializer.INSTANCE, self.sourceLocale);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 7) || self.updatedAt != null) {
            output.encodeNullableSerializableElement(serialDesc, 7, kSerializerArr[7], self.updatedAt);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 8) || self.voteCount != null) {
            output.encodeNullableSerializableElement(serialDesc, 8, IntSerializer.INSTANCE, self.voteCount);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 9) || self.voteSum != null) {
            output.encodeNullableSerializableElement(serialDesc, 9, IntSerializer.INSTANCE, self.voteSum);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 10) || self.body != null) {
            output.encodeNullableSerializableElement(serialDesc, 10, StringSerializer.INSTANCE, self.body);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 11) || self.draft != null) {
            output.encodeNullableSerializableElement(serialDesc, 11, BooleanSerializer.INSTANCE, self.draft);
        }
        output.encodeLongElement(serialDesc, 12, self.id);
        output.encodeStringElement(serialDesc, 13, self.locale);
        if (output.shouldEncodeElementDefault(serialDesc, 14) || self.name != null) {
            output.encodeNullableSerializableElement(serialDesc, 14, StringSerializer.INSTANCE, self.name);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 15) || self.outdated != null) {
            output.encodeNullableSerializableElement(serialDesc, 15, BooleanSerializer.INSTANCE, self.outdated);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 16) || self.position != null) {
            output.encodeNullableSerializableElement(serialDesc, 16, IntSerializer.INSTANCE, self.position);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 17) || self.promoted != null) {
            output.encodeNullableSerializableElement(serialDesc, 17, BooleanSerializer.INSTANCE, self.promoted);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 18) || self.title != null) {
            output.encodeNullableSerializableElement(serialDesc, 18, StringSerializer.INSTANCE, self.title);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 19) && self.url == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 19, StringSerializer.INSTANCE, self.url);
    }

    public ArticleDto(Long l, Boolean bool, LocalDateTime localDateTime, String str, List list, Long l2, String str2, LocalDateTime localDateTime2, Integer num, Integer num2, String str3, Boolean bool2, long j, String str4, String str5, Boolean bool3, Integer num3, Boolean bool4, String str6, String str7, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : l, (i & 2) != 0 ? null : bool, (i & 4) != 0 ? null : localDateTime, (i & 8) != 0 ? null : str, (i & 16) != 0 ? null : list, (i & 32) != 0 ? null : l2, (i & 64) != 0 ? null : str2, (i & 128) != 0 ? null : localDateTime2, (i & 256) != 0 ? null : num, (i & 512) != 0 ? null : num2, (i & 1024) != 0 ? null : str3, (i & 2048) != 0 ? null : bool2, j, str4, (i & 16384) != 0 ? null : str5, (32768 & i) != 0 ? null : bool3, (65536 & i) != 0 ? null : num3, (131072 & i) != 0 ? null : bool4, (262144 & i) != 0 ? null : str6, (i & 524288) != 0 ? null : str7);
    }

    public final Long getAuthorId() {
        return this.authorId;
    }

    public final Boolean getCommentsDisabled() {
        return this.commentsDisabled;
    }

    public final LocalDateTime getCreatedAt() {
        return this.createdAt;
    }

    public final String getHtmlUrl() {
        return this.htmlUrl;
    }

    public final List<String> getLabelNames() {
        return this.labelNames;
    }

    public final Long getSectionId() {
        return this.sectionId;
    }

    public final String getSourceLocale() {
        return this.sourceLocale;
    }

    public final LocalDateTime getUpdatedAt() {
        return this.updatedAt;
    }

    public final Integer getVoteCount() {
        return this.voteCount;
    }

    public final Integer getVoteSum() {
        return this.voteSum;
    }

    public final String getBody() {
        return this.body;
    }

    public final Boolean getDraft() {
        return this.draft;
    }

    public final long getId() {
        return this.id;
    }

    public final String getLocale() {
        return this.locale;
    }

    public final String getName() {
        return this.name;
    }

    public final Boolean getOutdated() {
        return this.outdated;
    }

    public final Integer getPosition() {
        return this.position;
    }

    public final Boolean getPromoted() {
        return this.promoted;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getUrl() {
        return this.url;
    }
}
