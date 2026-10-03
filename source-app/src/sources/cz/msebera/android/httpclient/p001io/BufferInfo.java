package cz.msebera.android.httpclient.p001io;

public interface BufferInfo {
    int available();

    int capacity();

    int length();
}
