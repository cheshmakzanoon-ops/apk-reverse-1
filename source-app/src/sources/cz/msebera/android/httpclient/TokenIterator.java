package cz.msebera.android.httpclient;

import java.util.Iterator;

public interface TokenIterator extends Iterator<Object> {
    @Override
    boolean hasNext();

    String nextToken();
}
