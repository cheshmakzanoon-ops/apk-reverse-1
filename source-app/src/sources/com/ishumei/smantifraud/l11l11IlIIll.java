package com.ishumei.smantifraud;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class l11l11IlIIll {
    public static final Comparator<byte[]> l111l1111l1Il = new l1111l111111Il();
    public final int l111l11111Il;
    public final List<byte[]> l1111l111111Il = new ArrayList();
    public final List<byte[]> l111l11111lIl = new ArrayList(64);
    public int l111l11111I1l = 0;

    public class l1111l111111Il implements Comparator<byte[]> {
        @Override
        public int compare(byte[] bArr, byte[] bArr2) {
            return bArr.length - bArr2.length;
        }
    }

    public l11l11IlIIll(int i) {
        this.l111l11111Il = i;
    }

    public final synchronized void l1111l111111Il() {
        while (this.l111l11111I1l > this.l111l11111Il) {
            byte[] bArrRemove = this.l1111l111111Il.remove(0);
            this.l111l11111lIl.remove(bArrRemove);
            this.l111l11111I1l -= bArrRemove.length;
        }
    }

    public synchronized void l1111l111111Il(byte[] bArr) {
        if (bArr != null) {
            if (bArr.length <= this.l111l11111Il) {
                this.l1111l111111Il.add(bArr);
                int iBinarySearch = Collections.binarySearch(this.l111l11111lIl, bArr, l111l1111l1Il);
                if (iBinarySearch < 0) {
                    iBinarySearch = (-iBinarySearch) - 1;
                }
                this.l111l11111lIl.add(iBinarySearch, bArr);
                this.l111l11111I1l += bArr.length;
                l1111l111111Il();
            }
        }
    }

    public synchronized byte[] l1111l111111Il(int i) {
        for (int i2 = 0; i2 < this.l111l11111lIl.size(); i2++) {
            byte[] bArr = this.l111l11111lIl.get(i2);
            if (bArr.length >= i) {
                this.l111l11111I1l -= bArr.length;
                this.l111l11111lIl.remove(i2);
                this.l1111l111111Il.remove(bArr);
                return bArr;
            }
        }
        return new byte[i];
    }
}
