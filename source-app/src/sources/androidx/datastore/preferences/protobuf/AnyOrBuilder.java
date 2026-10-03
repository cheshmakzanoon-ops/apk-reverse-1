package androidx.datastore.preferences.protobuf;

public interface AnyOrBuilder extends MessageLiteOrBuilder {
    String getTypeUrl();

    ByteString getTypeUrlBytes();

    ByteString getValue();
}
