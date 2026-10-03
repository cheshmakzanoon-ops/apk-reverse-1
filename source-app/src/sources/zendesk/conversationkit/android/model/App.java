package zendesk.conversationkit.android.model;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u000e\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\t\u0010\u000e\u001a\u00020\u0003HÆ\u0003J\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0007HÆ\u0003J1\u0010\u0012\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u0013\u001a\u00020\u00072\b\u0010\u0014\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001J\t\u0010\u0017\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u000bR\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\nR\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\n¨\u0006\u0018"}, m18d2 = {"Lzendesk/conversationkit/android/model/App;", "", "id", "", "status", "name", "isMultiConvoEnabled", "", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V", "getId", "()Ljava/lang/String;", "()Z", "getName", "getStatus", "component1", "component2", "component3", "component4", "copy", "equals", "other", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class App {
    private final String id;
    private final boolean isMultiConvoEnabled;
    private final String name;
    private final String status;

    public static App copy$default(App app, String str, String str2, String str3, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            str = app.id;
        }
        if ((i & 2) != 0) {
            str2 = app.status;
        }
        if ((i & 4) != 0) {
            str3 = app.name;
        }
        if ((i & 8) != 0) {
            z = app.isMultiConvoEnabled;
        }
        return app.copy(str, str2, str3, z);
    }

    public final String getId() {
        return this.id;
    }

    public final String getStatus() {
        return this.status;
    }

    public final String getName() {
        return this.name;
    }

    public final boolean getIsMultiConvoEnabled() {
        return this.isMultiConvoEnabled;
    }

    public final App copy(String id, String status, String name, boolean isMultiConvoEnabled) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(name, "name");
        return new App(id, status, name, isMultiConvoEnabled);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof App)) {
            return false;
        }
        App app = (App) other;
        return Intrinsics.areEqual(this.id, app.id) && Intrinsics.areEqual(this.status, app.status) && Intrinsics.areEqual(this.name, app.name) && this.isMultiConvoEnabled == app.isMultiConvoEnabled;
    }

    public int hashCode() {
        return (((((this.id.hashCode() * 31) + this.status.hashCode()) * 31) + this.name.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isMultiConvoEnabled);
    }

    public String toString() {
        return "App(id=" + this.id + ", status=" + this.status + ", name=" + this.name + ", isMultiConvoEnabled=" + this.isMultiConvoEnabled + ')';
    }

    public App(String id, String status, String name, boolean z) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(name, "name");
        this.id = id;
        this.status = status;
        this.name = name;
        this.isMultiConvoEnabled = z;
    }

    public final String getId() {
        return this.id;
    }

    public final String getStatus() {
        return this.status;
    }

    public final String getName() {
        return this.name;
    }

    public final boolean isMultiConvoEnabled() {
        return this.isMultiConvoEnabled;
    }
}
