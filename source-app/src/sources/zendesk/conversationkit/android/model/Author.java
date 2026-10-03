package zendesk.conversationkit.android.model;

import java.util.List;
import java.util.UUID;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 -2\u00020\u0001:\u0002,-BQ\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u000e\u0010\b\u001a\n\u0012\u0004\u0012\u00020\n\u0018\u00010\t\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u000e¢\u0006\u0002\u0010\u000fBA\b\u0000\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007\u0012\u000e\b\u0002\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\t\u0012\b\b\u0002\u0010\u000b\u001a\u00020\u0005\u0012\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0010J\t\u0010\u0019\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0007HÆ\u0003J\u000f\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\n0\tHÆ\u0003J\t\u0010\u001c\u001a\u00020\u0005HÆ\u0003J\u000b\u0010\u001d\u001a\u0004\u0018\u00010\u0005HÆ\u0003JC\u0010\u001e\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u000e\b\u0002\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\t2\b\b\u0002\u0010\u000b\u001a\u00020\u00052\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u0005HÆ\u0001J\u0013\u0010\u001f\u001a\u00020 2\b\u0010!\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\"\u001a\u00020\u0003HÖ\u0001J\t\u0010#\u001a\u00020\u0005HÖ\u0001J&\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020\u00002\u0006\u0010'\u001a\u00020(2\u0006\u0010)\u001a\u00020*HÁ\u0001¢\u0006\u0002\b+R\u0013\u0010\f\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0011\u0010\u000b\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0012R\u0017\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\t¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0012¨\u0006."}, m18d2 = {"Lzendesk/conversationkit/android/model/Author;", "", "seen1", "", "userId", "", "type", "Lzendesk/conversationkit/android/model/AuthorType;", "subtypes", "", "Lzendesk/conversationkit/android/model/AuthorSubtype;", "displayName", "avatarUrl", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Lzendesk/conversationkit/android/model/AuthorType;Ljava/util/List;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/AuthorType;Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V", "getAvatarUrl", "()Ljava/lang/String;", "getDisplayName", "getSubtypes", "()Ljava/util/List;", "getType", "()Lzendesk/conversationkit/android/model/AuthorType;", "getUserId", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class Author {
    private final String avatarUrl;
    private final String displayName;
    private final List<AuthorSubtype> subtypes;
    private final AuthorType type;
    private final String userId;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, AuthorType.INSTANCE.serializer(), new ArrayListSerializer(AuthorSubtype.INSTANCE.serializer()), null, null};

    public Author() {
        this((String) null, (AuthorType) null, (List) null, (String) null, (String) null, 31, (DefaultConstructorMarker) null);
    }

    public static Author copy$default(Author author, String str, AuthorType authorType, List list, String str2, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            str = author.userId;
        }
        if ((i & 2) != 0) {
            authorType = author.type;
        }
        AuthorType authorType2 = authorType;
        if ((i & 4) != 0) {
            list = author.subtypes;
        }
        List list2 = list;
        if ((i & 8) != 0) {
            str2 = author.displayName;
        }
        String str4 = str2;
        if ((i & 16) != 0) {
            str3 = author.avatarUrl;
        }
        return author.copy(str, authorType2, list2, str4, str3);
    }

    public final String getUserId() {
        return this.userId;
    }

    public final AuthorType getType() {
        return this.type;
    }

    public final List<AuthorSubtype> component3() {
        return this.subtypes;
    }

    public final String getDisplayName() {
        return this.displayName;
    }

    public final String getAvatarUrl() {
        return this.avatarUrl;
    }

    public final Author copy(String userId, AuthorType type, List<? extends AuthorSubtype> subtypes, String displayName, String avatarUrl) {
        Intrinsics.checkNotNullParameter(userId, "userId");
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(subtypes, "subtypes");
        Intrinsics.checkNotNullParameter(displayName, "displayName");
        return new Author(userId, type, subtypes, displayName, avatarUrl);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Author)) {
            return false;
        }
        Author author = (Author) other;
        return Intrinsics.areEqual(this.userId, author.userId) && this.type == author.type && Intrinsics.areEqual(this.subtypes, author.subtypes) && Intrinsics.areEqual(this.displayName, author.displayName) && Intrinsics.areEqual(this.avatarUrl, author.avatarUrl);
    }

    public int hashCode() {
        int iHashCode = ((((((this.userId.hashCode() * 31) + this.type.hashCode()) * 31) + this.subtypes.hashCode()) * 31) + this.displayName.hashCode()) * 31;
        String str = this.avatarUrl;
        return iHashCode + (str == null ? 0 : str.hashCode());
    }

    public String toString() {
        return "Author(userId=" + this.userId + ", type=" + this.type + ", subtypes=" + this.subtypes + ", displayName=" + this.displayName + ", avatarUrl=" + this.avatarUrl + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/Author$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/Author;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<Author> serializer() {
            return Author$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public Author(int i, String str, AuthorType authorType, List list, String str2, String str3, SerializationConstructorMarker serializationConstructorMarker) {
        if ((i & 1) == 0) {
            str = UUID.randomUUID().toString();
            Intrinsics.checkNotNullExpressionValue(str, "toString(...)");
        }
        this.userId = str;
        if ((i & 2) == 0) {
            this.type = AuthorType.USER;
        } else {
            this.type = authorType;
        }
        if ((i & 4) == 0) {
            this.subtypes = CollectionsKt.emptyList();
        } else {
            this.subtypes = list;
        }
        if ((i & 8) == 0) {
            this.displayName = "";
        } else {
            this.displayName = str2;
        }
        if ((i & 16) == 0) {
            this.avatarUrl = null;
        } else {
            this.avatarUrl = str3;
        }
    }

    public Author(String userId, AuthorType type, List<? extends AuthorSubtype> subtypes, String displayName, String str) {
        Intrinsics.checkNotNullParameter(userId, "userId");
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(subtypes, "subtypes");
        Intrinsics.checkNotNullParameter(displayName, "displayName");
        this.userId = userId;
        this.type = type;
        this.subtypes = subtypes;
        this.displayName = displayName;
        this.avatarUrl = str;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(Author self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        if (output.shouldEncodeElementDefault(serialDesc, 0)) {
            output.encodeStringElement(serialDesc, 0, self.userId);
        } else {
            String str = self.userId;
            String string = UUID.randomUUID().toString();
            Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
            if (!Intrinsics.areEqual(str, string)) {
                output.encodeStringElement(serialDesc, 0, self.userId);
            }
        }
        if (output.shouldEncodeElementDefault(serialDesc, 1) || self.type != AuthorType.USER) {
            output.encodeSerializableElement(serialDesc, 1, kSerializerArr[1], self.type);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 2) || !Intrinsics.areEqual(self.subtypes, CollectionsKt.emptyList())) {
            output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.subtypes);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 3) || !Intrinsics.areEqual(self.displayName, "")) {
            output.encodeStringElement(serialDesc, 3, self.displayName);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 4) && self.avatarUrl == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 4, StringSerializer.INSTANCE, self.avatarUrl);
    }

    public Author(String str, AuthorType authorType, List list, String str2, String str3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        if ((i & 1) != 0) {
            str = UUID.randomUUID().toString();
            Intrinsics.checkNotNullExpressionValue(str, "toString(...)");
        }
        this(str, (i & 2) != 0 ? AuthorType.USER : authorType, (i & 4) != 0 ? CollectionsKt.emptyList() : list, (i & 8) != 0 ? "" : str2, (i & 16) != 0 ? null : str3);
    }

    public final String getUserId() {
        return this.userId;
    }

    public final AuthorType getType() {
        return this.type;
    }

    public final List<AuthorSubtype> getSubtypes() {
        return this.subtypes;
    }

    public final String getDisplayName() {
        return this.displayName;
    }

    public final String getAvatarUrl() {
        return this.avatarUrl;
    }
}
