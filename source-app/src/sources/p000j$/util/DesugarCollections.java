package p000j$.util;

import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.function.Predicate;

public class DesugarCollections {
    private static final Field COLLECTION_FIELD;
    private static final Field MUTEX_FIELD;
    public static final Class SYNCHRONIZED_COLLECTION;
    private static final Constructor SYNCHRONIZED_COLLECTION_CONSTRUCTOR;
    static final Class SYNCHRONIZED_LIST;
    private static final Constructor SYNCHRONIZED_SET_CONSTRUCTOR;

    static {
        Class<?> cls = Collections.synchronizedCollection(new ArrayList()).getClass();
        SYNCHRONIZED_COLLECTION = cls;
        SYNCHRONIZED_LIST = Collections.synchronizedList(new LinkedList()).getClass();
        Field field = getField(cls, "mutex");
        MUTEX_FIELD = field;
        if (field != null) {
            field.setAccessible(true);
        }
        Field field2 = getField(cls, "c");
        COLLECTION_FIELD = field2;
        if (field2 != null) {
            field2.setAccessible(true);
        }
        Constructor constructor = getConstructor(Collections.synchronizedSet(new HashSet()).getClass(), Set.class, Object.class);
        SYNCHRONIZED_SET_CONSTRUCTOR = constructor;
        if (constructor != null) {
            constructor.setAccessible(true);
        }
        Constructor constructor2 = getConstructor(cls, Collection.class, Object.class);
        SYNCHRONIZED_COLLECTION_CONSTRUCTOR = constructor2;
        if (constructor2 != null) {
            constructor2.setAccessible(true);
        }
    }

    private static Field getField(Class cls, String str) {
        try {
            return cls.getDeclaredField(str);
        } catch (NoSuchFieldException unused) {
            return null;
        }
    }

    private static Constructor getConstructor(Class cls, Class... clsArr) {
        try {
            return cls.getDeclaredConstructor(clsArr);
        } catch (NoSuchMethodException unused) {
            return null;
        }
    }

    static boolean removeIf(Collection collection, Predicate predicate) {
        boolean zRemoveIf;
        Field field = MUTEX_FIELD;
        if (field == null) {
            try {
                return Collection.EL.removeIf((Collection) COLLECTION_FIELD.get(collection), predicate);
            } catch (IllegalAccessException e) {
                throw new Error("Runtime illegal access in synchronized collection removeIf fall-back.", e);
            }
        }
        try {
            synchronized (field.get(collection)) {
                zRemoveIf = Collection.EL.removeIf((Collection) COLLECTION_FIELD.get(collection), predicate);
            }
            return zRemoveIf;
        } catch (IllegalAccessException e2) {
            throw new Error("Runtime illegal access in synchronized collection removeIf.", e2);
        }
    }

    public static <K, V> Map<K, V> synchronizedMap(Map<K, V> map) {
        return new SynchronizedMap(map);
    }

    private static class SynchronizedMap implements Map, Serializable, Map {
        private static final long serialVersionUID = 1978198479659022715L;
        private transient Set entrySet;
        private transient Set keySet;

        private final Map f1379m;
        final Object mutex = this;
        private transient Collection values;

        SynchronizedMap(Map map) {
            this.f1379m = (Map) Objects.requireNonNull(map);
        }

        @Override
        public int size() {
            int size;
            synchronized (this.mutex) {
                size = this.f1379m.size();
            }
            return size;
        }

        @Override
        public boolean isEmpty() {
            boolean zIsEmpty;
            synchronized (this.mutex) {
                zIsEmpty = this.f1379m.isEmpty();
            }
            return zIsEmpty;
        }

        @Override
        public boolean containsKey(Object obj) {
            boolean zContainsKey;
            synchronized (this.mutex) {
                zContainsKey = this.f1379m.containsKey(obj);
            }
            return zContainsKey;
        }

        @Override
        public boolean containsValue(Object obj) {
            boolean zContainsValue;
            synchronized (this.mutex) {
                zContainsValue = this.f1379m.containsValue(obj);
            }
            return zContainsValue;
        }

        @Override
        public Object get(Object obj) {
            Object obj2;
            synchronized (this.mutex) {
                obj2 = this.f1379m.get(obj);
            }
            return obj2;
        }

        @Override
        public Object put(Object obj, Object obj2) {
            Object objPut;
            synchronized (this.mutex) {
                objPut = this.f1379m.put(obj, obj2);
            }
            return objPut;
        }

        @Override
        public Object remove(Object obj) {
            Object objRemove;
            synchronized (this.mutex) {
                objRemove = this.f1379m.remove(obj);
            }
            return objRemove;
        }

        @Override
        public void putAll(Map map) {
            synchronized (this.mutex) {
                this.f1379m.putAll(map);
            }
        }

        @Override
        public void clear() {
            synchronized (this.mutex) {
                this.f1379m.clear();
            }
        }

        private Set instantiateSet(Set set, Object obj) {
            if (DesugarCollections.SYNCHRONIZED_SET_CONSTRUCTOR == null) {
                return Collections.synchronizedSet(set);
            }
            try {
                return (Set) DesugarCollections.SYNCHRONIZED_SET_CONSTRUCTOR.newInstance(set, obj);
            } catch (IllegalAccessException | InstantiationException | InvocationTargetException e) {
                throw new Error("Unable to instantiate a synchronized list.", e);
            }
        }

        private Collection instantiateCollection(Collection collection, Object obj) {
            if (DesugarCollections.SYNCHRONIZED_COLLECTION_CONSTRUCTOR == null) {
                return Collections.synchronizedCollection(collection);
            }
            try {
                return (Collection) DesugarCollections.SYNCHRONIZED_COLLECTION_CONSTRUCTOR.newInstance(collection, obj);
            } catch (IllegalAccessException | InstantiationException | InvocationTargetException e) {
                throw new Error("Unable to instantiate a synchronized list.", e);
            }
        }

        @Override
        public Set keySet() {
            Set set;
            synchronized (this.mutex) {
                try {
                    if (this.keySet == null) {
                        this.keySet = instantiateSet(this.f1379m.keySet(), this.mutex);
                    }
                    set = this.keySet;
                } catch (Throwable th) {
                    throw th;
                }
            }
            return set;
        }

        @Override
        public Set entrySet() {
            Set set;
            synchronized (this.mutex) {
                try {
                    if (this.entrySet == null) {
                        this.entrySet = instantiateSet(this.f1379m.entrySet(), this.mutex);
                    }
                    set = this.entrySet;
                } catch (Throwable th) {
                    throw th;
                }
            }
            return set;
        }

        @Override
        public Collection values() {
            Collection collection;
            synchronized (this.mutex) {
                try {
                    if (this.values == null) {
                        this.values = instantiateCollection(this.f1379m.values(), this.mutex);
                    }
                    collection = this.values;
                } catch (Throwable th) {
                    throw th;
                }
            }
            return collection;
        }

        @Override
        public boolean equals(Object obj) {
            boolean zEquals;
            if (this == obj) {
                return true;
            }
            synchronized (this.mutex) {
                zEquals = this.f1379m.equals(obj);
            }
            return zEquals;
        }

        @Override
        public int hashCode() {
            int iHashCode;
            synchronized (this.mutex) {
                iHashCode = this.f1379m.hashCode();
            }
            return iHashCode;
        }

        public String toString() {
            String string;
            synchronized (this.mutex) {
                string = this.f1379m.toString();
            }
            return string;
        }

        @Override
        public Object getOrDefault(Object obj, Object obj2) {
            Object orDefault;
            synchronized (this.mutex) {
                orDefault = Map.EL.getOrDefault(this.f1379m, obj, obj2);
            }
            return orDefault;
        }

        @Override
        public void forEach(BiConsumer biConsumer) {
            synchronized (this.mutex) {
                Map.EL.forEach(this.f1379m, biConsumer);
            }
        }

        @Override
        public void replaceAll(BiFunction biFunction) {
            synchronized (this.mutex) {
                Map.EL.replaceAll(this.f1379m, biFunction);
            }
        }

        @Override
        public Object putIfAbsent(Object obj, Object obj2) {
            Object objPutIfAbsent;
            synchronized (this.mutex) {
                objPutIfAbsent = Map.EL.putIfAbsent(this.f1379m, obj, obj2);
            }
            return objPutIfAbsent;
        }

        @Override
        public boolean remove(Object obj, Object obj2) {
            boolean zRemove;
            synchronized (this.mutex) {
                zRemove = Map.EL.remove(this.f1379m, obj, obj2);
            }
            return zRemove;
        }

        @Override
        public boolean replace(Object obj, Object obj2, Object obj3) {
            boolean zReplace;
            synchronized (this.mutex) {
                zReplace = Map.EL.replace(this.f1379m, obj, obj2, obj3);
            }
            return zReplace;
        }

        @Override
        public Object replace(Object obj, Object obj2) {
            Object objReplace;
            synchronized (this.mutex) {
                objReplace = Map.EL.replace(this.f1379m, obj, obj2);
            }
            return objReplace;
        }

        @Override
        public Object computeIfAbsent(Object obj, Function function) {
            Object objComputeIfAbsent;
            synchronized (this.mutex) {
                objComputeIfAbsent = Map.EL.computeIfAbsent(this.f1379m, obj, function);
            }
            return objComputeIfAbsent;
        }

        @Override
        public Object computeIfPresent(Object obj, BiFunction biFunction) {
            Object objComputeIfPresent;
            synchronized (this.mutex) {
                objComputeIfPresent = Map.EL.computeIfPresent(this.f1379m, obj, biFunction);
            }
            return objComputeIfPresent;
        }

        @Override
        public Object compute(Object obj, BiFunction biFunction) {
            Object objCompute;
            synchronized (this.mutex) {
                objCompute = Map.EL.compute(this.f1379m, obj, biFunction);
            }
            return objCompute;
        }

        @Override
        public Object merge(Object obj, Object obj2, BiFunction biFunction) {
            Object objMerge;
            synchronized (this.mutex) {
                objMerge = Map.EL.merge(this.f1379m, obj, obj2, biFunction);
            }
            return objMerge;
        }

        private void writeObject(ObjectOutputStream objectOutputStream) {
            synchronized (this.mutex) {
                objectOutputStream.defaultWriteObject();
            }
        }
    }
}
