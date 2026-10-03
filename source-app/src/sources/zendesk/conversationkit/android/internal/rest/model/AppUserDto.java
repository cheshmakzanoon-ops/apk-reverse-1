package zendesk.conversationkit.android.internal.rest.model;

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
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000T\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0007\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u001d\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 ?2\u00020\u0001:\u0002>?B\u009c\u0001\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\r\u0012\u000e\u0010\u000f\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\r\u0012\u0019\u0010\u0010\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0012\u0018\u00010\u0011\u0012\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014¢\u0006\u0002\u0010\u0015B~\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r\u0012\f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r\u0012\u0017\u0010\u0010\u001a\u0013\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u00120\u0011¢\u0006\u0002\u0010\u0016J\t\u0010&\u001a\u00020\u0005HÆ\u0003J\u001a\u0010'\u001a\u0013\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u00120\u0011HÆ\u0003J\u000b\u0010(\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010)\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010*\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010+\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010,\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010-\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000f\u0010.\u001a\b\u0012\u0004\u0012\u00020\u000e0\rHÆ\u0003J\u000f\u0010/\u001a\b\u0012\u0004\u0012\u00020\u000e0\rHÆ\u0003J\u0096\u0001\u00100\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u00052\u000e\b\u0002\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r2\u000e\b\u0002\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r2\u0019\b\u0002\u0010\u0010\u001a\u0013\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u00120\u0011HÆ\u0001J\u0013\u00101\u001a\u0002022\b\u00103\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u00104\u001a\u00020\u0003HÖ\u0001J\t\u00105\u001a\u00020\u0005HÖ\u0001J&\u00106\u001a\u0002072\u0006\u00108\u001a\u00020\u00002\u0006\u00109\u001a\u00020:2\u0006\u0010;\u001a\u00020<HÁ\u0001¢\u0006\u0002\b=R\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0013\u0010\t\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0013\u0010\u0007\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001aR\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001c\u0010\u001d\u001a\u0004\b\u001e\u0010\u001aR\u0013\u0010\n\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u001aR\u0017\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u0018R\"\u0010\u0010\u001a\u0013\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u00120\u0011¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\"R\u0013\u0010\u000b\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b#\u0010\u001aR\u0013\u0010\b\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u001aR\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b%\u0010\u001a¨\u0006@"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;", "", "seen1", "", "id", "", "userId", "givenName", "surname", "email", "locale", "signedUpAt", "clients", "", "Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "pendingClients", "properties", "", "Lkotlinx/serialization/Contextual;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Ljava/util/List;Ljava/util/Map;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Ljava/util/List;Ljava/util/Map;)V", "getClients", "()Ljava/util/List;", "getEmail", "()Ljava/lang/String;", "getGivenName", "getId$annotations", "()V", "getId", "getLocale", "getPendingClients", "getProperties", "()Ljava/util/Map;", "getSignedUpAt", "getSurname", "getUserId", "component1", "component10", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class AppUserDto {
    private final List<ClientDto> clients;
    private final String email;
    private final String givenName;
    private final String id;
    private final String locale;
    private final List<ClientDto> pendingClients;
    private final Map<String, Object> properties;
    private final String signedUpAt;
    private final String surname;
    private final String userId;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, null, null, null, null, null, new ArrayListSerializer(ClientDto$$serializer.INSTANCE), new ArrayListSerializer(ClientDto$$serializer.INSTANCE), new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0]))};

    @SerialName("_id")
    public static void getId$annotations() {
    }

    public final String getId() {
        return this.id;
    }

    public final Map<String, Object> component10() {
        return this.properties;
    }

    public final String getUserId() {
        return this.userId;
    }

    public final String getGivenName() {
        return this.givenName;
    }

    public final String getSurname() {
        return this.surname;
    }

    public final String getEmail() {
        return this.email;
    }

    public final String getLocale() {
        return this.locale;
    }

    public final String getSignedUpAt() {
        return this.signedUpAt;
    }

    public final List<ClientDto> component8() {
        return this.clients;
    }

    public final List<ClientDto> component9() {
        return this.pendingClients;
    }

    public final AppUserDto copy(String id, String userId, String givenName, String surname, String email, String locale, String signedUpAt, List<ClientDto> clients, List<ClientDto> pendingClients, Map<String, ? extends Object> properties) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(clients, "clients");
        Intrinsics.checkNotNullParameter(pendingClients, "pendingClients");
        Intrinsics.checkNotNullParameter(properties, "properties");
        return new AppUserDto(id, userId, givenName, surname, email, locale, signedUpAt, clients, pendingClients, properties);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AppUserDto)) {
            return false;
        }
        AppUserDto appUserDto = (AppUserDto) other;
        return Intrinsics.areEqual(this.id, appUserDto.id) && Intrinsics.areEqual(this.userId, appUserDto.userId) && Intrinsics.areEqual(this.givenName, appUserDto.givenName) && Intrinsics.areEqual(this.surname, appUserDto.surname) && Intrinsics.areEqual(this.email, appUserDto.email) && Intrinsics.areEqual(this.locale, appUserDto.locale) && Intrinsics.areEqual(this.signedUpAt, appUserDto.signedUpAt) && Intrinsics.areEqual(this.clients, appUserDto.clients) && Intrinsics.areEqual(this.pendingClients, appUserDto.pendingClients) && Intrinsics.areEqual(this.properties, appUserDto.properties);
    }

    public int hashCode() {
        int iHashCode = this.id.hashCode() * 31;
        String str = this.userId;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.givenName;
        int iHashCode3 = (iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31;
        String str3 = this.surname;
        int iHashCode4 = (iHashCode3 + (str3 == null ? 0 : str3.hashCode())) * 31;
        String str4 = this.email;
        int iHashCode5 = (iHashCode4 + (str4 == null ? 0 : str4.hashCode())) * 31;
        String str5 = this.locale;
        int iHashCode6 = (iHashCode5 + (str5 == null ? 0 : str5.hashCode())) * 31;
        String str6 = this.signedUpAt;
        return ((((((iHashCode6 + (str6 != null ? str6.hashCode() : 0)) * 31) + this.clients.hashCode()) * 31) + this.pendingClients.hashCode()) * 31) + this.properties.hashCode();
    }

    public String toString() {
        return "AppUserDto(id=" + this.id + ", userId=" + this.userId + ", givenName=" + this.givenName + ", surname=" + this.surname + ", email=" + this.email + ", locale=" + this.locale + ", signedUpAt=" + this.signedUpAt + ", clients=" + this.clients + ", pendingClients=" + this.pendingClients + ", properties=" + this.properties + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/AppUserDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<AppUserDto> serializer() {
            return AppUserDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public AppUserDto(int i, @SerialName("_id") String str, String str2, String str3, String str4, String str5, String str6, String str7, List list, List list2, Map map, SerializationConstructorMarker serializationConstructorMarker) {
        if (1023 != (i & 1023)) {
            PluginExceptionsKt.throwMissingFieldException(i, 1023, AppUserDto$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        this.userId = str2;
        this.givenName = str3;
        this.surname = str4;
        this.email = str5;
        this.locale = str6;
        this.signedUpAt = str7;
        this.clients = list;
        this.pendingClients = list2;
        this.properties = map;
    }

    public AppUserDto(String id, String str, String str2, String str3, String str4, String str5, String str6, List<ClientDto> clients, List<ClientDto> pendingClients, Map<String, ? extends Object> properties) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(clients, "clients");
        Intrinsics.checkNotNullParameter(pendingClients, "pendingClients");
        Intrinsics.checkNotNullParameter(properties, "properties");
        this.id = id;
        this.userId = str;
        this.givenName = str2;
        this.surname = str3;
        this.email = str4;
        this.locale = str5;
        this.signedUpAt = str6;
        this.clients = clients;
        this.pendingClients = pendingClients;
        this.properties = properties;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(AppUserDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.id);
        output.encodeNullableSerializableElement(serialDesc, 1, StringSerializer.INSTANCE, self.userId);
        output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.givenName);
        output.encodeNullableSerializableElement(serialDesc, 3, StringSerializer.INSTANCE, self.surname);
        output.encodeNullableSerializableElement(serialDesc, 4, StringSerializer.INSTANCE, self.email);
        output.encodeNullableSerializableElement(serialDesc, 5, StringSerializer.INSTANCE, self.locale);
        output.encodeNullableSerializableElement(serialDesc, 6, StringSerializer.INSTANCE, self.signedUpAt);
        output.encodeSerializableElement(serialDesc, 7, kSerializerArr[7], self.clients);
        output.encodeSerializableElement(serialDesc, 8, kSerializerArr[8], self.pendingClients);
        output.encodeSerializableElement(serialDesc, 9, kSerializerArr[9], self.properties);
    }

    public final String getId() {
        return this.id;
    }

    public final String getUserId() {
        return this.userId;
    }

    public final String getGivenName() {
        return this.givenName;
    }

    public final String getSurname() {
        return this.surname;
    }

    public final String getEmail() {
        return this.email;
    }

    public final String getLocale() {
        return this.locale;
    }

    public final String getSignedUpAt() {
        return this.signedUpAt;
    }

    public final List<ClientDto> getClients() {
        return this.clients;
    }

    public final List<ClientDto> getPendingClients() {
        return this.pendingClients;
    }

    public final Map<String, Object> getProperties() {
        return this.properties;
    }
}
