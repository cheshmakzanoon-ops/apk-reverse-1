package com.google.firebase.crashlytics.internal.model;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.RandomAccess;

public final class ImmutableList<E> implements List<E>, RandomAccess {
    private final List<E> immutableList;

    public static <E> ImmutableList<E> from(E... eArr) {
        return new ImmutableList<>(Arrays.asList(eArr));
    }

    public static <E> ImmutableList<E> from(List<E> list) {
        return new ImmutableList<>(list);
    }

    private ImmutableList(List<E> list) {
        this.immutableList = Collections.unmodifiableList(list);
    }

    @Override
    public int size() {
        return this.immutableList.size();
    }

    @Override
    public boolean isEmpty() {
        return this.immutableList.isEmpty();
    }

    @Override
    public boolean contains(Object obj) {
        return this.immutableList.contains(obj);
    }

    @Override
    public Iterator<E> iterator() {
        return this.immutableList.iterator();
    }

    @Override
    public Object[] toArray() {
        return this.immutableList.toArray();
    }

    @Override
    public <T> T[] toArray(T[] tArr) {
        return (T[]) this.immutableList.toArray(tArr);
    }

    @Override
    public boolean add(E e) {
        return this.immutableList.add(e);
    }

    @Override
    public boolean remove(Object obj) {
        return this.immutableList.remove(obj);
    }

    @Override
    public boolean containsAll(Collection<?> collection) {
        return this.immutableList.containsAll(collection);
    }

    @Override
    public boolean addAll(Collection<? extends E> collection) {
        return this.immutableList.addAll(collection);
    }

    @Override
    public boolean addAll(int i, Collection<? extends E> collection) {
        return this.immutableList.addAll(i, collection);
    }

    @Override
    public boolean removeAll(Collection<?> collection) {
        return this.immutableList.removeAll(collection);
    }

    @Override
    public boolean retainAll(Collection<?> collection) {
        return this.immutableList.retainAll(collection);
    }

    @Override
    public void clear() {
        this.immutableList.clear();
    }

    @Override
    public boolean equals(Object obj) {
        return this.immutableList.equals(obj);
    }

    @Override
    public int hashCode() {
        return this.immutableList.hashCode();
    }

    @Override
    public E get(int i) {
        return this.immutableList.get(i);
    }

    @Override
    public E set(int i, E e) {
        return this.immutableList.set(i, e);
    }

    @Override
    public void add(int i, E e) {
        this.immutableList.add(i, e);
    }

    @Override
    public E remove(int i) {
        return this.immutableList.remove(i);
    }

    @Override
    public int indexOf(Object obj) {
        return this.immutableList.indexOf(obj);
    }

    @Override
    public int lastIndexOf(Object obj) {
        return this.immutableList.lastIndexOf(obj);
    }

    @Override
    public ListIterator<E> listIterator() {
        return this.immutableList.listIterator();
    }

    @Override
    public ListIterator<E> listIterator(int i) {
        return this.immutableList.listIterator(i);
    }

    @Override
    public List<E> subList(int i, int i2) {
        return this.immutableList.subList(i, i2);
    }
}
