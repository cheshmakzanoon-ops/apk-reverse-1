package com.ishumei.smantifraud;

public abstract class l1l1l11I1l {
    protected VDataListener mListener;

    public void register(VDataListener vDataListener) {
        this.mListener = vDataListener;
    }

    public void unregister() {
        this.mListener = null;
    }
}
