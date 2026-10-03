package zendesk.conversationkit.android.internal.rest.model;

import androidx.compose.animation.core.ComplexDouble$;
import java.util.List;
import java.util.Map;
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
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000\u008c\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\b\u0003\n\u0002\u0010\u0006\n\u0002\b\u0006\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\bK\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 \u0081\u00012\u00020\u0001:\u0004\u0080\u0001\u0081\u0001BÆ\u0002\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\t\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\f\u001a\u00020\r\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0011\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0012\u001a\u0004\u0018\u00010\u0005\u0012\u0019\u0010\u0013\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0015\u0018\u00010\u0014\u0012\b\u0010\u0016\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0017\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0018\u001a\u0004\u0018\u00010\u0019\u0012\b\u0010\u001a\u001a\u0004\u0018\u00010\u001b\u0012\b\u0010\u001c\u001a\u0004\u0018\u00010\u001d\u0012\u000e\u0010\u001e\u001a\n\u0012\u0004\u0012\u00020\u001f\u0018\u00010\t\u0012\u000e\u0010 \u001a\n\u0012\u0004\u0012\u00020!\u0018\u00010\t\u0012\b\u0010\"\u001a\u0004\u0018\u00010#\u0012\b\u0010$\u001a\u0004\u0018\u00010%\u0012\u000e\u0010&\u001a\n\u0012\u0004\u0012\u00020'\u0018\u00010\t\u0012\b\u0010(\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010)\u001a\u0004\u0018\u00010*\u0012\b\u0010+\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010,\u001a\u0004\u0018\u00010-¢\u0006\u0002\u0010.B¨\u0002\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u000e\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\t\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u0005\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0011\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0012\u001a\u0004\u0018\u00010\u0005\u0012\u0019\u0010\u0013\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0015\u0018\u00010\u0014\u0012\b\u0010\u0016\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0017\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0018\u001a\u0004\u0018\u00010\u0019\u0012\b\u0010\u001a\u001a\u0004\u0018\u00010\u001b\u0012\b\u0010\u001c\u001a\u0004\u0018\u00010\u001d\u0012\u000e\u0010\u001e\u001a\n\u0012\u0004\u0012\u00020\u001f\u0018\u00010\t\u0012\u000e\u0010 \u001a\n\u0012\u0004\u0012\u00020!\u0018\u00010\t\u0012\b\u0010\"\u001a\u0004\u0018\u00010#\u0012\b\u0010$\u001a\u0004\u0018\u00010%\u0012\u000e\u0010&\u001a\n\u0012\u0004\u0012\u00020'\u0018\u00010\t\u0012\b\u0010(\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010)\u001a\u0004\u0018\u00010*\u0012\b\u0010+\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010/J\t\u0010X\u001a\u00020\u0005HÆ\u0003J\u000b\u0010Y\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010Z\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010[\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u001c\u0010\\\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0015\u0018\u00010\u0014HÆ\u0003J\u000b\u0010]\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010^\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u0010\u0010_\u001a\u0004\u0018\u00010\u0019HÆ\u0003¢\u0006\u0002\u0010FJ\u000b\u0010`\u001a\u0004\u0018\u00010\u001bHÆ\u0003J\u000b\u0010a\u001a\u0004\u0018\u00010\u001dHÆ\u0003J\u0011\u0010b\u001a\n\u0012\u0004\u0012\u00020\u001f\u0018\u00010\tHÆ\u0003J\t\u0010c\u001a\u00020\u0005HÆ\u0003J\u0011\u0010d\u001a\n\u0012\u0004\u0012\u00020!\u0018\u00010\tHÆ\u0003J\u000b\u0010e\u001a\u0004\u0018\u00010#HÆ\u0003J\u0010\u0010f\u001a\u0004\u0018\u00010%HÆ\u0003¢\u0006\u0002\u00108J\u0011\u0010g\u001a\n\u0012\u0004\u0012\u00020'\u0018\u00010\tHÆ\u0003J\u000b\u0010h\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010i\u001a\u0004\u0018\u00010*HÆ\u0003J\u000b\u0010j\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010k\u001a\u00020\u0005HÆ\u0003J\u0011\u0010l\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\tHÆ\u0003J\u000b\u0010m\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010n\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010o\u001a\u00020\rHÆ\u0003J\t\u0010p\u001a\u00020\u0005HÆ\u0003J\u000b\u0010q\u001a\u0004\u0018\u00010\u0005HÆ\u0003Jå\u0002\u0010r\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\u0010\b\u0002\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\t2\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u00052\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0011\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00052\u001b\b\u0002\u0010\u0013\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0015\u0018\u00010\u00142\n\b\u0002\u0010\u0016\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0017\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0018\u001a\u0004\u0018\u00010\u00192\n\b\u0002\u0010\u001a\u001a\u0004\u0018\u00010\u001b2\n\b\u0002\u0010\u001c\u001a\u0004\u0018\u00010\u001d2\u0010\b\u0002\u0010\u001e\u001a\n\u0012\u0004\u0012\u00020\u001f\u0018\u00010\t2\u0010\b\u0002\u0010 \u001a\n\u0012\u0004\u0012\u00020!\u0018\u00010\t2\n\b\u0002\u0010\"\u001a\u0004\u0018\u00010#2\n\b\u0002\u0010$\u001a\u0004\u0018\u00010%2\u0010\b\u0002\u0010&\u001a\n\u0012\u0004\u0012\u00020'\u0018\u00010\t2\n\b\u0002\u0010(\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010)\u001a\u0004\u0018\u00010*2\n\b\u0002\u0010+\u001a\u0004\u0018\u00010\u0005HÆ\u0001¢\u0006\u0002\u0010sJ\u0013\u0010t\u001a\u00020%2\b\u0010u\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010v\u001a\u00020\u0003HÖ\u0001J\t\u0010w\u001a\u00020\u0005HÖ\u0001J&\u0010x\u001a\u00020y2\u0006\u0010z\u001a\u00020\u00002\u0006\u0010{\u001a\u00020|2\u0006\u0010}\u001a\u00020~HÁ\u0001¢\u0006\u0002\b\u007fR\u0019\u0010\u001e\u001a\n\u0012\u0004\u0012\u00020\u001f\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\b0\u00101R\u0013\u0010\u0011\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b2\u00103R\u0013\u0010+\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b4\u00103R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b5\u00103R\u0013\u0010\u000b\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b6\u00103R\u0015\u0010$\u001a\u0004\u0018\u00010%¢\u0006\n\n\u0002\u00109\u001a\u0004\b7\u00108R\u0013\u0010\u001a\u001a\u0004\u0018\u00010\u001b¢\u0006\b\n\u0000\u001a\u0004\b:\u0010;R\u0013\u0010\"\u001a\u0004\u0018\u00010#¢\u0006\b\n\u0000\u001a\u0004\b<\u0010=R\u0019\u0010&\u001a\n\u0012\u0004\u0012\u00020'\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\b>\u00101R\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b?\u0010@\u001a\u0004\bA\u00103R\u0019\u0010 \u001a\n\u0012\u0004\u0012\u00020!\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\bB\u00101R\u0013\u0010\u001c\u001a\u0004\u0018\u00010\u001d¢\u0006\b\n\u0000\u001a\u0004\bC\u0010DR\u0015\u0010\u0018\u001a\u0004\u0018\u00010\u0019¢\u0006\n\n\u0002\u0010G\u001a\u0004\bE\u0010FR\u0013\u0010\u0017\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\bH\u00103R\u0013\u0010\u0016\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\bI\u00103R$\u0010\u0013\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0015\u0018\u00010\u0014¢\u0006\b\n\u0000\u001a\u0004\bJ\u0010KR\u0013\u0010\n\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\bL\u00103R\u0013\u0010\u0012\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\bM\u00103R\u0013\u0010(\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\bN\u00103R\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\bO\u0010PR\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\bQ\u00103R\u0013\u0010)\u001a\u0004\u0018\u00010*¢\u0006\b\n\u0000\u001a\u0004\bR\u0010SR\u0019\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\bT\u00101R\u0013\u0010\u000f\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\bU\u00103R\u0013\u0010\u0010\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\bV\u00103R\u0011\u0010\u000e\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\bW\u00103¨\u0006\u0082\u0001"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "", "seen1", "", "id", "", "authorId", "role", "subroles", "", "name", "avatarUrl", "received", "", "type", "text", "textFallback", "altText", "payload", "metadata", "", "Lkotlinx/serialization/Contextual;", "mediaUrl", "mediaType", "mediaSize", "", "coordinates", "Lzendesk/conversationkit/android/internal/rest/model/CoordinatesDto;", "location", "Lzendesk/conversationkit/android/internal/rest/model/LocationDto;", "actions", "Lzendesk/conversationkit/android/internal/rest/model/MessageActionDto;", "items", "Lzendesk/conversationkit/android/internal/rest/model/MessageItemDto;", "displaySettings", "Lzendesk/conversationkit/android/internal/rest/model/DisplaySettingsDto;", "blockChatInput", "", "fields", "Lzendesk/conversationkit/android/internal/rest/model/MessageFieldDto;", "quotedMessageId", "source", "Lzendesk/conversationkit/android/internal/rest/model/MessageSourceDto;", "attachmentId", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Ljava/lang/String;Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Long;Lzendesk/conversationkit/android/internal/rest/model/CoordinatesDto;Lzendesk/conversationkit/android/internal/rest/model/LocationDto;Ljava/util/List;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/DisplaySettingsDto;Ljava/lang/Boolean;Ljava/util/List;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/MessageSourceDto;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Ljava/lang/String;Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Long;Lzendesk/conversationkit/android/internal/rest/model/CoordinatesDto;Lzendesk/conversationkit/android/internal/rest/model/LocationDto;Ljava/util/List;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/DisplaySettingsDto;Ljava/lang/Boolean;Ljava/util/List;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/MessageSourceDto;Ljava/lang/String;)V", "getActions", "()Ljava/util/List;", "getAltText", "()Ljava/lang/String;", "getAttachmentId", "getAuthorId", "getAvatarUrl", "getBlockChatInput", "()Ljava/lang/Boolean;", "Ljava/lang/Boolean;", "getCoordinates", "()Lzendesk/conversationkit/android/internal/rest/model/CoordinatesDto;", "getDisplaySettings", "()Lzendesk/conversationkit/android/internal/rest/model/DisplaySettingsDto;", "getFields", "getId$annotations", "()V", "getId", "getItems", "getLocation", "()Lzendesk/conversationkit/android/internal/rest/model/LocationDto;", "getMediaSize", "()Ljava/lang/Long;", "Ljava/lang/Long;", "getMediaType", "getMediaUrl", "getMetadata", "()Ljava/util/Map;", "getName", "getPayload", "getQuotedMessageId", "getReceived", "()D", "getRole", "getSource", "()Lzendesk/conversationkit/android/internal/rest/model/MessageSourceDto;", "getSubroles", "getText", "getTextFallback", "getType", "component1", "component10", "component11", "component12", "component13", "component14", "component15", "component16", "component17", "component18", "component19", "component2", "component20", "component21", "component22", "component23", "component24", "component25", "component26", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Ljava/lang/String;Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Long;Lzendesk/conversationkit/android/internal/rest/model/CoordinatesDto;Lzendesk/conversationkit/android/internal/rest/model/LocationDto;Ljava/util/List;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/DisplaySettingsDto;Ljava/lang/Boolean;Ljava/util/List;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/MessageSourceDto;Ljava/lang/String;)Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class MessageDto {
    private final List<MessageActionDto> actions;
    private final String altText;
    private final String attachmentId;
    private final String authorId;
    private final String avatarUrl;
    private final Boolean blockChatInput;
    private final CoordinatesDto coordinates;
    private final DisplaySettingsDto displaySettings;
    private final List<MessageFieldDto> fields;
    private final String id;
    private final List<MessageItemDto> items;
    private final LocationDto location;
    private final Long mediaSize;
    private final String mediaType;
    private final String mediaUrl;
    private final Map<String, Object> metadata;
    private final String name;
    private final String payload;
    private final String quotedMessageId;
    private final double received;
    private final String role;
    private final MessageSourceDto source;
    private final List<String> subroles;
    private final String text;
    private final String textFallback;
    private final String type;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, null, new ArrayListSerializer(StringSerializer.INSTANCE), null, null, null, null, null, null, null, null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, null, null, null, null, new ArrayListSerializer(MessageActionDto$$serializer.INSTANCE), new ArrayListSerializer(MessageItemDto$$serializer.INSTANCE), null, null, new ArrayListSerializer(MessageFieldDto$$serializer.INSTANCE), null, null, null};

    @SerialName("_id")
    public static void getId$annotations() {
    }

    public final String getId() {
        return this.id;
    }

    public final String getTextFallback() {
        return this.textFallback;
    }

    public final String getAltText() {
        return this.altText;
    }

    public final String getPayload() {
        return this.payload;
    }

    public final Map<String, Object> component13() {
        return this.metadata;
    }

    public final String getMediaUrl() {
        return this.mediaUrl;
    }

    public final String getMediaType() {
        return this.mediaType;
    }

    public final Long getMediaSize() {
        return this.mediaSize;
    }

    public final CoordinatesDto getCoordinates() {
        return this.coordinates;
    }

    public final LocationDto getLocation() {
        return this.location;
    }

    public final List<MessageActionDto> component19() {
        return this.actions;
    }

    public final String getAuthorId() {
        return this.authorId;
    }

    public final List<MessageItemDto> component20() {
        return this.items;
    }

    public final DisplaySettingsDto getDisplaySettings() {
        return this.displaySettings;
    }

    public final Boolean getBlockChatInput() {
        return this.blockChatInput;
    }

    public final List<MessageFieldDto> component23() {
        return this.fields;
    }

    public final String getQuotedMessageId() {
        return this.quotedMessageId;
    }

    public final MessageSourceDto getSource() {
        return this.source;
    }

    public final String getAttachmentId() {
        return this.attachmentId;
    }

    public final String getRole() {
        return this.role;
    }

    public final List<String> component4() {
        return this.subroles;
    }

    public final String getName() {
        return this.name;
    }

    public final String getAvatarUrl() {
        return this.avatarUrl;
    }

    public final double getReceived() {
        return this.received;
    }

    public final String getType() {
        return this.type;
    }

    public final String getText() {
        return this.text;
    }

    public final MessageDto copy(String id, String authorId, String role, List<String> subroles, String name, String avatarUrl, double received, String type, String text, String textFallback, String altText, String payload, Map<String, ? extends Object> metadata, String mediaUrl, String mediaType, Long mediaSize, CoordinatesDto coordinates, LocationDto location, List<MessageActionDto> actions, List<MessageItemDto> items, DisplaySettingsDto displaySettings, Boolean blockChatInput, List<MessageFieldDto> fields, String quotedMessageId, MessageSourceDto source, String attachmentId) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(authorId, "authorId");
        Intrinsics.checkNotNullParameter(role, "role");
        Intrinsics.checkNotNullParameter(type, "type");
        return new MessageDto(id, authorId, role, subroles, name, avatarUrl, received, type, text, textFallback, altText, payload, metadata, mediaUrl, mediaType, mediaSize, coordinates, location, actions, items, displaySettings, blockChatInput, fields, quotedMessageId, source, attachmentId);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessageDto)) {
            return false;
        }
        MessageDto messageDto = (MessageDto) other;
        return Intrinsics.areEqual(this.id, messageDto.id) && Intrinsics.areEqual(this.authorId, messageDto.authorId) && Intrinsics.areEqual(this.role, messageDto.role) && Intrinsics.areEqual(this.subroles, messageDto.subroles) && Intrinsics.areEqual(this.name, messageDto.name) && Intrinsics.areEqual(this.avatarUrl, messageDto.avatarUrl) && Double.compare(this.received, messageDto.received) == 0 && Intrinsics.areEqual(this.type, messageDto.type) && Intrinsics.areEqual(this.text, messageDto.text) && Intrinsics.areEqual(this.textFallback, messageDto.textFallback) && Intrinsics.areEqual(this.altText, messageDto.altText) && Intrinsics.areEqual(this.payload, messageDto.payload) && Intrinsics.areEqual(this.metadata, messageDto.metadata) && Intrinsics.areEqual(this.mediaUrl, messageDto.mediaUrl) && Intrinsics.areEqual(this.mediaType, messageDto.mediaType) && Intrinsics.areEqual(this.mediaSize, messageDto.mediaSize) && Intrinsics.areEqual(this.coordinates, messageDto.coordinates) && Intrinsics.areEqual(this.location, messageDto.location) && Intrinsics.areEqual(this.actions, messageDto.actions) && Intrinsics.areEqual(this.items, messageDto.items) && Intrinsics.areEqual(this.displaySettings, messageDto.displaySettings) && Intrinsics.areEqual(this.blockChatInput, messageDto.blockChatInput) && Intrinsics.areEqual(this.fields, messageDto.fields) && Intrinsics.areEqual(this.quotedMessageId, messageDto.quotedMessageId) && Intrinsics.areEqual(this.source, messageDto.source) && Intrinsics.areEqual(this.attachmentId, messageDto.attachmentId);
    }

    public int hashCode() {
        int iHashCode = ((((this.id.hashCode() * 31) + this.authorId.hashCode()) * 31) + this.role.hashCode()) * 31;
        List<String> list = this.subroles;
        int iHashCode2 = (iHashCode + (list == null ? 0 : list.hashCode())) * 31;
        String str = this.name;
        int iHashCode3 = (iHashCode2 + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.avatarUrl;
        int iHashCode4 = (((((iHashCode3 + (str2 == null ? 0 : str2.hashCode())) * 31) + ComplexDouble$.ExternalSyntheticBackport0.m(this.received)) * 31) + this.type.hashCode()) * 31;
        String str3 = this.text;
        int iHashCode5 = (iHashCode4 + (str3 == null ? 0 : str3.hashCode())) * 31;
        String str4 = this.textFallback;
        int iHashCode6 = (iHashCode5 + (str4 == null ? 0 : str4.hashCode())) * 31;
        String str5 = this.altText;
        int iHashCode7 = (iHashCode6 + (str5 == null ? 0 : str5.hashCode())) * 31;
        String str6 = this.payload;
        int iHashCode8 = (iHashCode7 + (str6 == null ? 0 : str6.hashCode())) * 31;
        Map<String, Object> map = this.metadata;
        int iHashCode9 = (iHashCode8 + (map == null ? 0 : map.hashCode())) * 31;
        String str7 = this.mediaUrl;
        int iHashCode10 = (iHashCode9 + (str7 == null ? 0 : str7.hashCode())) * 31;
        String str8 = this.mediaType;
        int iHashCode11 = (iHashCode10 + (str8 == null ? 0 : str8.hashCode())) * 31;
        Long l = this.mediaSize;
        int iHashCode12 = (iHashCode11 + (l == null ? 0 : l.hashCode())) * 31;
        CoordinatesDto coordinatesDto = this.coordinates;
        int iHashCode13 = (iHashCode12 + (coordinatesDto == null ? 0 : coordinatesDto.hashCode())) * 31;
        LocationDto locationDto = this.location;
        int iHashCode14 = (iHashCode13 + (locationDto == null ? 0 : locationDto.hashCode())) * 31;
        List<MessageActionDto> list2 = this.actions;
        int iHashCode15 = (iHashCode14 + (list2 == null ? 0 : list2.hashCode())) * 31;
        List<MessageItemDto> list3 = this.items;
        int iHashCode16 = (iHashCode15 + (list3 == null ? 0 : list3.hashCode())) * 31;
        DisplaySettingsDto displaySettingsDto = this.displaySettings;
        int iHashCode17 = (iHashCode16 + (displaySettingsDto == null ? 0 : displaySettingsDto.hashCode())) * 31;
        Boolean bool = this.blockChatInput;
        int iHashCode18 = (iHashCode17 + (bool == null ? 0 : bool.hashCode())) * 31;
        List<MessageFieldDto> list4 = this.fields;
        int iHashCode19 = (iHashCode18 + (list4 == null ? 0 : list4.hashCode())) * 31;
        String str9 = this.quotedMessageId;
        int iHashCode20 = (iHashCode19 + (str9 == null ? 0 : str9.hashCode())) * 31;
        MessageSourceDto messageSourceDto = this.source;
        int iHashCode21 = (iHashCode20 + (messageSourceDto == null ? 0 : messageSourceDto.hashCode())) * 31;
        String str10 = this.attachmentId;
        return iHashCode21 + (str10 != null ? str10.hashCode() : 0);
    }

    public String toString() {
        return "MessageDto(id=" + this.id + ", authorId=" + this.authorId + ", role=" + this.role + ", subroles=" + this.subroles + ", name=" + this.name + ", avatarUrl=" + this.avatarUrl + ", received=" + this.received + ", type=" + this.type + ", text=" + this.text + ", textFallback=" + this.textFallback + ", altText=" + this.altText + ", payload=" + this.payload + ", metadata=" + this.metadata + ", mediaUrl=" + this.mediaUrl + ", mediaType=" + this.mediaType + ", mediaSize=" + this.mediaSize + ", coordinates=" + this.coordinates + ", location=" + this.location + ", actions=" + this.actions + ", items=" + this.items + ", displaySettings=" + this.displaySettings + ", blockChatInput=" + this.blockChatInput + ", fields=" + this.fields + ", quotedMessageId=" + this.quotedMessageId + ", source=" + this.source + ", attachmentId=" + this.attachmentId + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/MessageDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<MessageDto> serializer() {
            return MessageDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public MessageDto(int i, @SerialName("_id") String str, String str2, String str3, List list, String str4, String str5, double d, String str6, String str7, String str8, String str9, String str10, Map map, String str11, String str12, Long l, CoordinatesDto coordinatesDto, LocationDto locationDto, List list2, List list3, DisplaySettingsDto displaySettingsDto, Boolean bool, List list4, String str13, MessageSourceDto messageSourceDto, String str14, SerializationConstructorMarker serializationConstructorMarker) {
        if (67108863 != (i & 67108863)) {
            PluginExceptionsKt.throwMissingFieldException(i, 67108863, MessageDto$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        this.authorId = str2;
        this.role = str3;
        this.subroles = list;
        this.name = str4;
        this.avatarUrl = str5;
        this.received = d;
        this.type = str6;
        this.text = str7;
        this.textFallback = str8;
        this.altText = str9;
        this.payload = str10;
        this.metadata = map;
        this.mediaUrl = str11;
        this.mediaType = str12;
        this.mediaSize = l;
        this.coordinates = coordinatesDto;
        this.location = locationDto;
        this.actions = list2;
        this.items = list3;
        this.displaySettings = displaySettingsDto;
        this.blockChatInput = bool;
        this.fields = list4;
        this.quotedMessageId = str13;
        this.source = messageSourceDto;
        this.attachmentId = str14;
    }

    public MessageDto(String id, String authorId, String role, List<String> list, String str, String str2, double d, String type, String str3, String str4, String str5, String str6, Map<String, ? extends Object> map, String str7, String str8, Long l, CoordinatesDto coordinatesDto, LocationDto locationDto, List<MessageActionDto> list2, List<MessageItemDto> list3, DisplaySettingsDto displaySettingsDto, Boolean bool, List<MessageFieldDto> list4, String str9, MessageSourceDto messageSourceDto, String str10) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(authorId, "authorId");
        Intrinsics.checkNotNullParameter(role, "role");
        Intrinsics.checkNotNullParameter(type, "type");
        this.id = id;
        this.authorId = authorId;
        this.role = role;
        this.subroles = list;
        this.name = str;
        this.avatarUrl = str2;
        this.received = d;
        this.type = type;
        this.text = str3;
        this.textFallback = str4;
        this.altText = str5;
        this.payload = str6;
        this.metadata = map;
        this.mediaUrl = str7;
        this.mediaType = str8;
        this.mediaSize = l;
        this.coordinates = coordinatesDto;
        this.location = locationDto;
        this.actions = list2;
        this.items = list3;
        this.displaySettings = displaySettingsDto;
        this.blockChatInput = bool;
        this.fields = list4;
        this.quotedMessageId = str9;
        this.source = messageSourceDto;
        this.attachmentId = str10;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(MessageDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.id);
        output.encodeStringElement(serialDesc, 1, self.authorId);
        output.encodeStringElement(serialDesc, 2, self.role);
        output.encodeNullableSerializableElement(serialDesc, 3, kSerializerArr[3], self.subroles);
        output.encodeNullableSerializableElement(serialDesc, 4, StringSerializer.INSTANCE, self.name);
        output.encodeNullableSerializableElement(serialDesc, 5, StringSerializer.INSTANCE, self.avatarUrl);
        output.encodeDoubleElement(serialDesc, 6, self.received);
        output.encodeStringElement(serialDesc, 7, self.type);
        output.encodeNullableSerializableElement(serialDesc, 8, StringSerializer.INSTANCE, self.text);
        output.encodeNullableSerializableElement(serialDesc, 9, StringSerializer.INSTANCE, self.textFallback);
        output.encodeNullableSerializableElement(serialDesc, 10, StringSerializer.INSTANCE, self.altText);
        output.encodeNullableSerializableElement(serialDesc, 11, StringSerializer.INSTANCE, self.payload);
        output.encodeNullableSerializableElement(serialDesc, 12, kSerializerArr[12], self.metadata);
        output.encodeNullableSerializableElement(serialDesc, 13, StringSerializer.INSTANCE, self.mediaUrl);
        output.encodeNullableSerializableElement(serialDesc, 14, StringSerializer.INSTANCE, self.mediaType);
        output.encodeNullableSerializableElement(serialDesc, 15, LongSerializer.INSTANCE, self.mediaSize);
        output.encodeNullableSerializableElement(serialDesc, 16, CoordinatesDto$$serializer.INSTANCE, self.coordinates);
        output.encodeNullableSerializableElement(serialDesc, 17, LocationDto$$serializer.INSTANCE, self.location);
        output.encodeNullableSerializableElement(serialDesc, 18, kSerializerArr[18], self.actions);
        output.encodeNullableSerializableElement(serialDesc, 19, kSerializerArr[19], self.items);
        output.encodeNullableSerializableElement(serialDesc, 20, DisplaySettingsDto$$serializer.INSTANCE, self.displaySettings);
        output.encodeNullableSerializableElement(serialDesc, 21, BooleanSerializer.INSTANCE, self.blockChatInput);
        output.encodeNullableSerializableElement(serialDesc, 22, kSerializerArr[22], self.fields);
        output.encodeNullableSerializableElement(serialDesc, 23, StringSerializer.INSTANCE, self.quotedMessageId);
        output.encodeNullableSerializableElement(serialDesc, 24, MessageSourceDto$$serializer.INSTANCE, self.source);
        output.encodeNullableSerializableElement(serialDesc, 25, StringSerializer.INSTANCE, self.attachmentId);
    }

    public final String getId() {
        return this.id;
    }

    public final String getAuthorId() {
        return this.authorId;
    }

    public final String getRole() {
        return this.role;
    }

    public final List<String> getSubroles() {
        return this.subroles;
    }

    public final String getName() {
        return this.name;
    }

    public final String getAvatarUrl() {
        return this.avatarUrl;
    }

    public final double getReceived() {
        return this.received;
    }

    public final String getType() {
        return this.type;
    }

    public final String getText() {
        return this.text;
    }

    public final String getTextFallback() {
        return this.textFallback;
    }

    public final String getAltText() {
        return this.altText;
    }

    public final String getPayload() {
        return this.payload;
    }

    public final Map<String, Object> getMetadata() {
        return this.metadata;
    }

    public final String getMediaUrl() {
        return this.mediaUrl;
    }

    public final String getMediaType() {
        return this.mediaType;
    }

    public final Long getMediaSize() {
        return this.mediaSize;
    }

    public final CoordinatesDto getCoordinates() {
        return this.coordinates;
    }

    public final LocationDto getLocation() {
        return this.location;
    }

    public final List<MessageActionDto> getActions() {
        return this.actions;
    }

    public final List<MessageItemDto> getItems() {
        return this.items;
    }

    public final DisplaySettingsDto getDisplaySettings() {
        return this.displaySettings;
    }

    public final Boolean getBlockChatInput() {
        return this.blockChatInput;
    }

    public final List<MessageFieldDto> getFields() {
        return this.fields;
    }

    public final String getQuotedMessageId() {
        return this.quotedMessageId;
    }

    public final MessageSourceDto getSource() {
        return this.source;
    }

    public final String getAttachmentId() {
        return this.attachmentId;
    }
}
