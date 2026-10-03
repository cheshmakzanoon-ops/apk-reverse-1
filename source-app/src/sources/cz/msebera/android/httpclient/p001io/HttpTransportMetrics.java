package cz.msebera.android.httpclient.p001io;

public interface HttpTransportMetrics {
    long getBytesTransferred();

    void reset();
}
