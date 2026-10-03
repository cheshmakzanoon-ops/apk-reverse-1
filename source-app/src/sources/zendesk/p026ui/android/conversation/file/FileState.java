package zendesk.p026ui.android.conversation.file;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0010\b\n\u0002\b\u001e\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001,BE\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0003\u0010\b\u001a\u00020\u0007\u0012\b\b\u0003\u0010\t\u001a\u00020\u0007\u0012\n\b\u0003\u0010\n\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\u000bJ\u000e\u0010\u0017\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0018J\u000e\u0010\u0019\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\u001aJ\u000e\u0010\u001b\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\b\u001cJ\u000e\u0010\u001d\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\b\u001eJ\u000e\u0010\u001f\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\b J\u0012\u0010!\u001a\u0004\u0018\u00010\u0007HÀ\u0003¢\u0006\u0004\b\"\u0010\u000fJL\u0010#\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0003\u0010\u0006\u001a\u00020\u00072\b\b\u0003\u0010\b\u001a\u00020\u00072\b\b\u0003\u0010\t\u001a\u00020\u00072\n\b\u0003\u0010\n\u001a\u0004\u0018\u00010\u0007HÆ\u0001¢\u0006\u0002\u0010$J\u0013\u0010%\u001a\u00020&2\b\u0010'\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010(\u001a\u00020\u0007HÖ\u0001J\u0006\u0010)\u001a\u00020*J\t\u0010+\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\t\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0018\u0010\n\u001a\u0004\u0018\u00010\u0007X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0010\u001a\u0004\b\u000e\u0010\u000fR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0014\u0010\b\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\rR\u0014\u0010\u0006\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\r¨\u0006-"}, m18d2 = {"Lzendesk/ui/android/conversation/file/FileState;", "", "fileName", "", "fileSize", "", "textColor", "", "iconColor", "backgroundColor", "backgroundDrawable", "(Ljava/lang/String;JIIILjava/lang/Integer;)V", "getBackgroundColor$zendesk_ui_ui_android", "()I", "getBackgroundDrawable$zendesk_ui_ui_android", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getFileName$zendesk_ui_ui_android", "()Ljava/lang/String;", "getFileSize$zendesk_ui_ui_android", "()J", "getIconColor$zendesk_ui_ui_android", "getTextColor$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "copy", "(Ljava/lang/String;JIIILjava/lang/Integer;)Lzendesk/ui/android/conversation/file/FileState;", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/file/FileState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FileState {
    public static final int $stable = 0;
    private final int backgroundColor;
    private final Integer backgroundDrawable;
    private final String fileName;
    private final long fileSize;
    private final int iconColor;
    private final int textColor;

    public FileState() {
        this(null, 0L, 0, 0, 0, null, 63, null);
    }

    public static FileState copy$default(FileState fileState, String str, long j, int i, int i2, int i3, Integer num, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            str = fileState.fileName;
        }
        if ((i4 & 2) != 0) {
            j = fileState.fileSize;
        }
        long j2 = j;
        if ((i4 & 4) != 0) {
            i = fileState.textColor;
        }
        int i5 = i;
        if ((i4 & 8) != 0) {
            i2 = fileState.iconColor;
        }
        int i6 = i2;
        if ((i4 & 16) != 0) {
            i3 = fileState.backgroundColor;
        }
        int i7 = i3;
        if ((i4 & 32) != 0) {
            num = fileState.backgroundDrawable;
        }
        return fileState.copy(str, j2, i5, i6, i7, num);
    }

    public final String getFileName() {
        return this.fileName;
    }

    public final long getFileSize() {
        return this.fileSize;
    }

    public final int getTextColor() {
        return this.textColor;
    }

    public final int getIconColor() {
        return this.iconColor;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final Integer getBackgroundDrawable() {
        return this.backgroundDrawable;
    }

    public final FileState copy(String fileName, long fileSize, int textColor, int iconColor, int backgroundColor, Integer backgroundDrawable) {
        Intrinsics.checkNotNullParameter(fileName, "fileName");
        return new FileState(fileName, fileSize, textColor, iconColor, backgroundColor, backgroundDrawable);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof FileState)) {
            return false;
        }
        FileState fileState = (FileState) other;
        return Intrinsics.areEqual(this.fileName, fileState.fileName) && this.fileSize == fileState.fileSize && this.textColor == fileState.textColor && this.iconColor == fileState.iconColor && this.backgroundColor == fileState.backgroundColor && Intrinsics.areEqual(this.backgroundDrawable, fileState.backgroundDrawable);
    }

    public int hashCode() {
        int iHashCode = ((((((((this.fileName.hashCode() * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.fileSize)) * 31) + this.textColor) * 31) + this.iconColor) * 31) + this.backgroundColor) * 31;
        Integer num = this.backgroundDrawable;
        return iHashCode + (num == null ? 0 : num.hashCode());
    }

    public String toString() {
        return "FileState(fileName=" + this.fileName + ", fileSize=" + this.fileSize + ", textColor=" + this.textColor + ", iconColor=" + this.iconColor + ", backgroundColor=" + this.backgroundColor + ", backgroundDrawable=" + this.backgroundDrawable + ')';
    }

    public FileState(String fileName, long j, int i, int i2, int i3, Integer num) {
        Intrinsics.checkNotNullParameter(fileName, "fileName");
        this.fileName = fileName;
        this.fileSize = j;
        this.textColor = i;
        this.iconColor = i2;
        this.backgroundColor = i3;
        this.backgroundDrawable = num;
    }

    public FileState(String str, long j, int i, int i2, int i3, Integer num, int i4, DefaultConstructorMarker defaultConstructorMarker) {
        this((i4 & 1) != 0 ? "" : str, (i4 & 2) != 0 ? 0L : j, (i4 & 4) != 0 ? 0 : i, (i4 & 8) != 0 ? 0 : i2, (i4 & 16) != 0 ? 0 : i3, (i4 & 32) != 0 ? null : num);
    }

    public final String getFileName$zendesk_ui_ui_android() {
        return this.fileName;
    }

    public final long getFileSize$zendesk_ui_ui_android() {
        return this.fileSize;
    }

    public final int getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final int getIconColor$zendesk_ui_ui_android() {
        return this.iconColor;
    }

    public final int getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final Integer getBackgroundDrawable$zendesk_ui_ui_android() {
        return this.backgroundDrawable;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0010\u0010\u0006\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0017\u0010\t\u001a\u00020\u00002\n\b\u0001\u0010\n\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\u000bJ\u0006\u0010\f\u001a\u00020\u0003J\u000e\u0010\r\u001a\u00020\u00002\u0006\u0010\u000e\u001a\u00020\u000fJ\u000e\u0010\u0010\u001a\u00020\u00002\u0006\u0010\u0011\u001a\u00020\u0012J\u0010\u0010\u0013\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0010\u0010\u0014\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0015"}, m18d2 = {"Lzendesk/ui/android/conversation/file/FileState$Builder;", "", "state", "Lzendesk/ui/android/conversation/file/FileState;", "(Lzendesk/ui/android/conversation/file/FileState;)V", "()V", "backgroundColor", "color", "", "backgroundDrawable", "drawable", "(Ljava/lang/Integer;)Lzendesk/ui/android/conversation/file/FileState$Builder;", "build", "fileName", "name", "", "fileSize", "size", "", "iconColor", "textColor", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private FileState state;

        public Builder() {
            this.state = new FileState(null, 0L, 0, 0, 0, null, 63, null);
        }

        public Builder(FileState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder fileName(String name) {
            Intrinsics.checkNotNullParameter(name, "name");
            this.state = FileState.copy$default(this.state, name, 0L, 0, 0, 0, null, 62, null);
            return this;
        }

        public final Builder fileSize(long size) {
            this.state = FileState.copy$default(this.state, null, size, 0, 0, 0, null, 61, null);
            return this;
        }

        public final Builder textColor(int color) {
            this.state = FileState.copy$default(this.state, null, 0L, color, 0, 0, null, 59, null);
            return this;
        }

        public final Builder iconColor(int color) {
            this.state = FileState.copy$default(this.state, null, 0L, 0, color, 0, null, 55, null);
            return this;
        }

        public final Builder backgroundColor(int color) {
            this.state = FileState.copy$default(this.state, null, 0L, 0, 0, color, null, 47, null);
            return this;
        }

        public final Builder backgroundDrawable(Integer drawable) {
            this.state = FileState.copy$default(this.state, null, 0L, 0, 0, 0, drawable, 31, null);
            return this;
        }

        public final FileState getState() {
            return this.state;
        }
    }
}
