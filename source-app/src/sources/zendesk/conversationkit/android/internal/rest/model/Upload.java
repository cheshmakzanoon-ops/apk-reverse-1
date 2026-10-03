package zendesk.conversationkit.android.internal.rest.model;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u000e\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\u0003¢\u0006\u0002\u0010\bJ\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0006HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0003HÆ\u0003J1\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0018HÖ\u0001J\t\u0010\u0019\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0007\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\nR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\n¨\u0006\u001a"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/Upload;", "", "uri", "", "name", "size", "", "mimeType", "(Ljava/lang/String;Ljava/lang/String;JLjava/lang/String;)V", "getMimeType", "()Ljava/lang/String;", "getName", "getSize", "()J", "getUri", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class Upload {
    private final String mimeType;
    private final String name;
    private final long size;
    private final String uri;

    public static Upload copy$default(Upload upload, String str, String str2, long j, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            str = upload.uri;
        }
        if ((i & 2) != 0) {
            str2 = upload.name;
        }
        String str4 = str2;
        if ((i & 4) != 0) {
            j = upload.size;
        }
        long j2 = j;
        if ((i & 8) != 0) {
            str3 = upload.mimeType;
        }
        return upload.copy(str, str4, j2, str3);
    }

    public final String getUri() {
        return this.uri;
    }

    public final String getName() {
        return this.name;
    }

    public final long getSize() {
        return this.size;
    }

    public final String getMimeType() {
        return this.mimeType;
    }

    public final Upload copy(String uri, String name, long size, String mimeType) {
        Intrinsics.checkNotNullParameter(uri, "uri");
        Intrinsics.checkNotNullParameter(name, "name");
        Intrinsics.checkNotNullParameter(mimeType, "mimeType");
        return new Upload(uri, name, size, mimeType);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Upload)) {
            return false;
        }
        Upload upload = (Upload) other;
        return Intrinsics.areEqual(this.uri, upload.uri) && Intrinsics.areEqual(this.name, upload.name) && this.size == upload.size && Intrinsics.areEqual(this.mimeType, upload.mimeType);
    }

    public int hashCode() {
        return (((((this.uri.hashCode() * 31) + this.name.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.size)) * 31) + this.mimeType.hashCode();
    }

    public String toString() {
        return "Upload(uri=" + this.uri + ", name=" + this.name + ", size=" + this.size + ", mimeType=" + this.mimeType + ')';
    }

    public Upload(String uri, String name, long j, String mimeType) {
        Intrinsics.checkNotNullParameter(uri, "uri");
        Intrinsics.checkNotNullParameter(name, "name");
        Intrinsics.checkNotNullParameter(mimeType, "mimeType");
        this.uri = uri;
        this.name = name;
        this.size = j;
        this.mimeType = mimeType;
    }

    public final String getUri() {
        return this.uri;
    }

    public final String getName() {
        return this.name;
    }

    public final long getSize() {
        return this.size;
    }

    public final String getMimeType() {
        return this.mimeType;
    }
}
