package cz.msebera.android.httpclient;

import java.util.Iterator;

public interface HeaderIterator extends Iterator<Object> {
    @Override
    boolean hasNext();

    Header nextHeader();
}
