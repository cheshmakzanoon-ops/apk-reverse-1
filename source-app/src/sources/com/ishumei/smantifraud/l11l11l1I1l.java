package com.ishumei.smantifraud;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.Set;

public class l11l11l1I1l<E> {
    public final Queue<l1111l111111Il<E, Integer>> l1111l111111Il = new LinkedList();
    public final int l111l11111lIl;

    public static class l1111l111111Il<T1, T2> {
        public final T1 l1111l111111Il;
        public T2 l111l11111lIl;

        public l1111l111111Il(T1 t1, T2 t2) {
            this.l1111l111111Il = t1;
            this.l111l11111lIl = t2;
        }
    }

    public l11l11l1I1l(int i) {
        this.l111l11111lIl = i;
    }

    public synchronized List<E> l1111l111111Il() {
        ArrayList arrayList;
        arrayList = new ArrayList(this.l1111l111111Il.size() + 1);
        Iterator<l1111l111111Il<E, Integer>> it = this.l1111l111111Il.iterator();
        while (it.hasNext()) {
            arrayList.add(it.next().l1111l111111Il);
        }
        return arrayList;
    }

    public synchronized List<E> l1111l111111Il(int... iArr) {
        try {
            if (iArr == null) {
                return new ArrayList();
            }
            ArrayList arrayList = new ArrayList(this.l1111l111111Il.size() + 1);
            for (l1111l111111Il<E, Integer> l1111l111111il : this.l1111l111111Il) {
                for (int i : iArr) {
                    if (l1111l111111il.l111l11111lIl.intValue() == i) {
                        arrayList.add(l1111l111111il.l1111l111111Il);
                    }
                }
            }
            return arrayList;
        } catch (Throwable th) {
            throw th;
        }
    }

    public synchronized void l1111l111111Il(Set<E> set) {
        Iterator<l1111l111111Il<E, Integer>> it = this.l1111l111111Il.iterator();
        while (it.hasNext()) {
            if (set.contains(it.next().l1111l111111Il)) {
                it.remove();
            }
        }
    }

    public synchronized void l1111l111111Il(Set<E> set, int i) {
        for (l1111l111111Il<E, Integer> l1111l111111il : this.l1111l111111Il) {
            if (set.contains(l1111l111111il.l1111l111111Il)) {
                l1111l111111il.l111l11111lIl = Integer.valueOf(i);
            }
        }
    }

    public synchronized boolean l1111l111111Il(E e, int i) {
        boolean zAdd;
        zAdd = this.l1111l111111Il.add(new l1111l111111Il<>(e, Integer.valueOf(i)));
        while (this.l1111l111111Il.size() > this.l111l11111lIl) {
            this.l1111l111111Il.remove();
        }
        return zAdd;
    }

    public synchronized int l111l11111lIl(int... iArr) {
        if (iArr == null) {
            return 0;
        }
        int i = 0;
        for (l1111l111111Il<E, Integer> l1111l111111il : this.l1111l111111Il) {
            for (int i2 : iArr) {
                if (l1111l111111il.l111l11111lIl.intValue() == i2) {
                    i++;
                }
            }
        }
        return i;
    }
}
