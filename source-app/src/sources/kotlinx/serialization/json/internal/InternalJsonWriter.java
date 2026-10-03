package kotlinx.serialization.json.internal;

import kotlin.Metadata;

@JsonFriendModuleApi
@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\f\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0002\bg\u0018\u00002\u00020\u0001J\b\u0010\u0002\u001a\u00020\u0003H&J\u0010\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u0006H&J\u0010\u0010\u0007\u001a\u00020\u00032\u0006\u0010\b\u001a\u00020\tH&J\u0010\u0010\n\u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\fH&J\u0010\u0010\r\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u0006H&¨\u0006\u000e"}, m18d2 = {"Lkotlinx/serialization/json/internal/InternalJsonWriter;", "", "release", "", "write", "text", "", "writeChar", "char", "", "writeLong", "value", "", "writeQuoted", "kotlinx-serialization-json"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface InternalJsonWriter {
    void release();

    void write(String text);

    void writeChar(char c);

    void writeLong(long value);

    void writeQuoted(String text);
}
