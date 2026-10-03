package cz.msebera.android.httpclient.impl.client;

class SystemClock implements Clock {
    SystemClock() {
    }

    @Override
    public long getCurrentTime() {
        return System.currentTimeMillis();
    }
}
