package p000j$.util.concurrent;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.ObjectStreamField;
import java.io.Serializable;
import java.lang.reflect.Array;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.AbstractMap;
import java.util.Arrays;
import java.util.Collection;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.locks.LockSupport;
import java.util.concurrent.locks.ReentrantLock;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Consumer;
import java.util.function.IntFunction;
import java.util.function.Predicate;
import p000j$.sun.misc.DesugarUnsafe;
import p000j$.util.Spliterator;
import p000j$.util.stream.Stream;
import p000j$.util.stream.StreamSupport;

public class ConcurrentHashMap<K, V> extends AbstractMap<K, V> implements ConcurrentMap<K, V>, Serializable, ConcurrentMap<K, V> {
    private static final int ABASE;
    private static final int ASHIFT;
    private static final long BASECOUNT;
    private static final long CELLSBUSY;
    private static final long CELLVALUE;
    static final int NCPU = Runtime.getRuntime().availableProcessors();
    private static final long SIZECTL;
    private static final long TRANSFERINDEX;

    private static final DesugarUnsafe f1381U;
    private static final ObjectStreamField[] serialPersistentFields;
    private static final long serialVersionUID = 7249069246763182397L;
    private volatile transient long baseCount;
    private volatile transient int cellsBusy;
    private volatile transient CounterCell[] counterCells;
    private transient EntrySetView entrySet;
    private transient KeySetView keySet;
    private volatile transient Node[] nextTable;
    private volatile transient int sizeCtl;
    volatile transient Node[] table;
    private volatile transient int transferIndex;
    private transient ValuesView values;

    static final int spread(int i) {
        return (i ^ (i >>> 16)) & Integer.MAX_VALUE;
    }

    static {
        ObjectStreamField objectStreamField = new ObjectStreamField("segments", Segment[].class);
        Class cls = Integer.TYPE;
        serialPersistentFields = new ObjectStreamField[]{objectStreamField, new ObjectStreamField("segmentMask", cls), new ObjectStreamField("segmentShift", cls)};
        DesugarUnsafe unsafe = DesugarUnsafe.getUnsafe();
        f1381U = unsafe;
        SIZECTL = unsafe.objectFieldOffset(ConcurrentHashMap.class, "sizeCtl");
        TRANSFERINDEX = unsafe.objectFieldOffset(ConcurrentHashMap.class, "transferIndex");
        BASECOUNT = unsafe.objectFieldOffset(ConcurrentHashMap.class, "baseCount");
        CELLSBUSY = unsafe.objectFieldOffset(ConcurrentHashMap.class, "cellsBusy");
        CELLVALUE = unsafe.objectFieldOffset(CounterCell.class, "value");
        ABASE = unsafe.arrayBaseOffset(Node[].class);
        int iArrayIndexScale = unsafe.arrayIndexScale(Node[].class);
        if (((iArrayIndexScale - 1) & iArrayIndexScale) != 0) {
            throw new ExceptionInInitializerError("array index scale not a power of two");
        }
        ASHIFT = 31 - Integer.numberOfLeadingZeros(iArrayIndexScale);
    }

    static class Node implements Map.Entry {
        final int hash;
        final Object key;
        volatile Node next;
        volatile Object val;

        Node(int i, Object obj, Object obj2) {
            this.hash = i;
            this.key = obj;
            this.val = obj2;
        }

        Node(int i, Object obj, Object obj2, Node node) {
            this(i, obj, obj2);
            this.next = node;
        }

        @Override
        public final Object getKey() {
            return this.key;
        }

        @Override
        public final Object getValue() {
            return this.val;
        }

        @Override
        public final int hashCode() {
            return this.key.hashCode() ^ this.val.hashCode();
        }

        public final String toString() {
            return Helpers.mapEntryToString(this.key, this.val);
        }

        @Override
        public final Object setValue(Object obj) {
            throw new UnsupportedOperationException();
        }

        @Override
        public final boolean equals(Object obj) {
            Map.Entry entry;
            Object key;
            Object value;
            Object obj2;
            Object obj3;
            return (obj instanceof Map.Entry) && (key = (entry = (Map.Entry) obj).getKey()) != null && (value = entry.getValue()) != null && (key == (obj2 = this.key) || key.equals(obj2)) && (value == (obj3 = this.val) || value.equals(obj3));
        }

        Node find(int i, Object obj) {
            Object obj2;
            if (obj == null) {
                return null;
            }
            Node node = this;
            do {
                if (node.hash == i && ((obj2 = node.key) == obj || (obj2 != null && obj.equals(obj2)))) {
                    return node;
                }
                node = node.next;
            } while (node != null);
            return null;
        }
    }

    private static final int tableSizeFor(int i) {
        int iNumberOfLeadingZeros = (-1) >>> Integer.numberOfLeadingZeros(i - 1);
        if (iNumberOfLeadingZeros < 0) {
            return 1;
        }
        if (iNumberOfLeadingZeros >= 1073741824) {
            return 1073741824;
        }
        return 1 + iNumberOfLeadingZeros;
    }

    static Class comparableClassFor(Object obj) {
        Type[] actualTypeArguments;
        if (!(obj instanceof Comparable)) {
            return null;
        }
        Class<?> cls = obj.getClass();
        if (cls == String.class) {
            return cls;
        }
        Type[] genericInterfaces = cls.getGenericInterfaces();
        if (genericInterfaces == null) {
            return null;
        }
        for (Type type : genericInterfaces) {
            if (type instanceof ParameterizedType) {
                ParameterizedType parameterizedType = (ParameterizedType) type;
                if (parameterizedType.getRawType() == Comparable.class && (actualTypeArguments = parameterizedType.getActualTypeArguments()) != null && actualTypeArguments.length == 1 && actualTypeArguments[0] == cls) {
                    return cls;
                }
            }
        }
        return null;
    }

    static int compareComparables(Class cls, Object obj, Object obj2) {
        if (obj2 == null || obj2.getClass() != cls) {
            return 0;
        }
        return ((Comparable) obj).compareTo(obj2);
    }

    static final Node tabAt(Node[] nodeArr, int i) {
        return (Node) f1381U.getObjectAcquire(nodeArr, (((long) i) << ASHIFT) + ((long) ABASE));
    }

    static final boolean casTabAt(Node[] nodeArr, int i, Node node, Node node2) {
        return f1381U.compareAndSetObject(nodeArr, (((long) i) << ASHIFT) + ((long) ABASE), node, node2);
    }

    static final void setTabAt(Node[] nodeArr, int i, Node node) {
        f1381U.putObjectRelease(nodeArr, (((long) i) << ASHIFT) + ((long) ABASE), node);
    }

    public ConcurrentHashMap() {
    }

    public ConcurrentHashMap(int i) {
        this(i, 0.75f, 1);
    }

    public ConcurrentHashMap(Map<? extends K, ? extends V> map) {
        this.sizeCtl = 16;
        putAll(map);
    }

    public ConcurrentHashMap(int i, float f, int i2) {
        if (f <= 0.0f || i < 0 || i2 <= 0) {
            throw new IllegalArgumentException();
        }
        long j = (long) (((double) ((i < i2 ? i2 : i) / f)) + 1.0d);
        this.sizeCtl = j >= 1073741824 ? 1073741824 : tableSizeFor((int) j);
    }

    @Override
    public int size() {
        long jSumCount = sumCount();
        if (jSumCount < 0) {
            return 0;
        }
        if (jSumCount > 2147483647L) {
            return Integer.MAX_VALUE;
        }
        return (int) jSumCount;
    }

    @Override
    public boolean isEmpty() {
        return sumCount() <= 0;
    }

    @Override
    public V get(Object obj) {
        int length;
        Node nodeTabAt;
        Object obj2;
        int iSpread = spread(obj.hashCode());
        Node[] nodeArr = this.table;
        if (nodeArr != null && (length = nodeArr.length) > 0 && (nodeTabAt = tabAt(nodeArr, (length - 1) & iSpread)) != null) {
            int i = nodeTabAt.hash;
            if (i == iSpread) {
                Object obj3 = nodeTabAt.key;
                if (obj3 == obj || (obj3 != null && obj.equals(obj3))) {
                    return (V) nodeTabAt.val;
                }
            } else if (i < 0) {
                Node nodeFind = nodeTabAt.find(iSpread, obj);
                if (nodeFind != null) {
                    return (V) nodeFind.val;
                }
                return null;
            }
            while (true) {
                nodeTabAt = nodeTabAt.next;
                if (nodeTabAt == null) {
                    break;
                }
                if (nodeTabAt.hash == iSpread && ((obj2 = nodeTabAt.key) == obj || (obj2 != null && obj.equals(obj2)))) {
                    return (V) nodeTabAt.val;
                }
            }
        }
        return null;
    }

    @Override
    public boolean containsKey(Object obj) {
        return get(obj) != null;
    }

    @Override
    public boolean containsValue(Object obj) {
        obj.getClass();
        Node[] nodeArr = this.table;
        if (nodeArr != null) {
            Traverser traverser = new Traverser(nodeArr, nodeArr.length, 0, nodeArr.length);
            while (true) {
                Node nodeAdvance = traverser.advance();
                if (nodeAdvance == null) {
                    break;
                }
                Object obj2 = nodeAdvance.val;
                if (obj2 == obj) {
                    return true;
                }
                if (obj2 != null && obj.equals(obj2)) {
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public V put(K k, V v) {
        return (V) putVal(k, v, false);
    }

    final Object putVal(Object obj, Object obj2, boolean z) {
        Object obj3;
        Object obj4;
        Object obj5;
        Object obj6;
        if (obj == null || obj2 == null) {
            throw null;
        }
        int iSpread = spread(obj.hashCode());
        Node[] nodeArrInitTable = this.table;
        int i = 0;
        while (true) {
            if (nodeArrInitTable != null) {
                int length = nodeArrInitTable.length;
                if (length != 0) {
                    int i2 = (length - 1) & iSpread;
                    Node nodeTabAt = tabAt(nodeArrInitTable, i2);
                    if (nodeTabAt == null) {
                        if (casTabAt(nodeArrInitTable, i2, null, new Node(iSpread, obj, obj2))) {
                            break;
                        }
                    } else {
                        int i3 = nodeTabAt.hash;
                        if (i3 == -1) {
                            nodeArrInitTable = helpTransfer(nodeArrInitTable, nodeTabAt);
                        } else {
                            if (z && i3 == iSpread && (((obj5 = nodeTabAt.key) == obj || (obj5 != null && obj.equals(obj5))) && (obj6 = nodeTabAt.val) != null)) {
                                return obj6;
                            }
                            synchronized (nodeTabAt) {
                                try {
                                    if (tabAt(nodeArrInitTable, i2) != nodeTabAt) {
                                        obj3 = null;
                                    } else if (i3 >= 0) {
                                        i = 1;
                                        Node node = nodeTabAt;
                                        while (true) {
                                            if (node.hash == iSpread && ((obj4 = node.key) == obj || (obj4 != null && obj.equals(obj4)))) {
                                                obj3 = node.val;
                                                if (!z) {
                                                    node.val = obj2;
                                                }
                                            } else {
                                                Node node2 = node.next;
                                                if (node2 == null) {
                                                    node.next = new Node(iSpread, obj, obj2);
                                                    obj3 = null;
                                                } else {
                                                    i++;
                                                    node = node2;
                                                }
                                            }
                                        }
                                    } else if (nodeTabAt instanceof TreeBin) {
                                        TreeNode treeNodePutTreeVal = ((TreeBin) nodeTabAt).putTreeVal(iSpread, obj, obj2);
                                        if (treeNodePutTreeVal != null) {
                                            Object obj7 = treeNodePutTreeVal.val;
                                            if (!z) {
                                                treeNodePutTreeVal.val = obj2;
                                            }
                                            obj3 = obj7;
                                        } else {
                                            obj3 = null;
                                        }
                                        i = 2;
                                    } else {
                                        if (nodeTabAt instanceof ReservationNode) {
                                            throw new IllegalStateException("Recursive update");
                                        }
                                        obj3 = null;
                                    }
                                } catch (Throwable th) {
                                    throw th;
                                }
                            }
                            if (i != 0) {
                                if (i >= 8) {
                                    treeifyBin(nodeArrInitTable, i2);
                                }
                                if (obj3 == null) {
                                    break;
                                }
                                return obj3;
                            }
                        }
                    }
                }
            }
            nodeArrInitTable = initTable();
        }
        addCount(1L, i);
        return null;
    }

    @Override
    public void putAll(Map<? extends K, ? extends V> map) {
        tryPresize(map.size());
        for (Map.Entry<? extends K, ? extends V> entry : map.entrySet()) {
            putVal(entry.getKey(), entry.getValue(), false);
        }
    }

    @Override
    public V remove(Object obj) {
        return (V) replaceNode(obj, null, null);
    }

    final Object replaceNode(Object obj, Object obj2, Object obj3) {
        int length;
        int i;
        Node nodeTabAt;
        boolean z;
        Object obj4;
        TreeNode treeNodeFindTreeNode;
        Object obj5;
        int iSpread = spread(obj.hashCode());
        Node[] nodeArrHelpTransfer = this.table;
        while (nodeArrHelpTransfer != null && (length = nodeArrHelpTransfer.length) != 0 && (nodeTabAt = tabAt(nodeArrHelpTransfer, (i = (length - 1) & iSpread))) != null) {
            int i2 = nodeTabAt.hash;
            if (i2 == -1) {
                nodeArrHelpTransfer = helpTransfer(nodeArrHelpTransfer, nodeTabAt);
            } else {
                synchronized (nodeTabAt) {
                    try {
                        if (tabAt(nodeArrHelpTransfer, i) == nodeTabAt) {
                            z = true;
                            if (i2 >= 0) {
                                Node node = null;
                                Node node2 = nodeTabAt;
                                while (true) {
                                    if (node2.hash == iSpread && ((obj5 = node2.key) == obj || (obj5 != null && obj.equals(obj5)))) {
                                        obj4 = node2.val;
                                        if (obj3 == null || obj3 == obj4 || (obj4 != null && obj3.equals(obj4))) {
                                            if (obj2 != null) {
                                                node2.val = obj2;
                                            } else if (node != null) {
                                                node.next = node2.next;
                                            } else {
                                                setTabAt(nodeArrHelpTransfer, i, node2.next);
                                            }
                                        }
                                    } else {
                                        Node node3 = node2.next;
                                        if (node3 != null) {
                                            node = node2;
                                            node2 = node3;
                                        }
                                    }
                                    obj4 = null;
                                }
                            } else if (nodeTabAt instanceof TreeBin) {
                                TreeBin treeBin = (TreeBin) nodeTabAt;
                                TreeNode treeNode = treeBin.root;
                                if (treeNode == null || (treeNodeFindTreeNode = treeNode.findTreeNode(iSpread, obj, null)) == null) {
                                    obj4 = null;
                                } else {
                                    obj4 = treeNodeFindTreeNode.val;
                                    if (obj3 != null && obj3 != obj4 && (obj4 == null || !obj3.equals(obj4))) {
                                        obj4 = null;
                                    } else if (obj2 != null) {
                                        treeNodeFindTreeNode.val = obj2;
                                    } else if (treeBin.removeTreeNode(treeNodeFindTreeNode)) {
                                        setTabAt(nodeArrHelpTransfer, i, untreeify(treeBin.first));
                                    }
                                }
                            } else {
                                if (nodeTabAt instanceof ReservationNode) {
                                    throw new IllegalStateException("Recursive update");
                                }
                                z = false;
                                obj4 = null;
                            }
                        } else {
                            z = false;
                            obj4 = null;
                        }
                    } catch (Throwable th) {
                        throw th;
                    }
                }
                if (z) {
                    if (obj4 == null) {
                        break;
                    }
                    if (obj2 == null) {
                        addCount(-1L, -1);
                    }
                    return obj4;
                }
            }
        }
        return null;
    }

    @Override
    public void clear() {
        Node nodeTabAt;
        Node node;
        Node[] nodeArrHelpTransfer = this.table;
        long j = 0;
        loop0: while (true) {
            int i = 0;
            while (true) {
                if (nodeArrHelpTransfer == null || i >= nodeArrHelpTransfer.length) {
                    break loop0;
                }
                nodeTabAt = tabAt(nodeArrHelpTransfer, i);
                if (nodeTabAt == null) {
                    i++;
                } else {
                    int i2 = nodeTabAt.hash;
                    if (i2 == -1) {
                        break;
                    }
                    synchronized (nodeTabAt) {
                        try {
                            if (tabAt(nodeArrHelpTransfer, i) == nodeTabAt) {
                                if (i2 >= 0) {
                                    node = nodeTabAt;
                                } else {
                                    node = nodeTabAt instanceof TreeBin ? ((TreeBin) nodeTabAt).first : null;
                                }
                                while (node != null) {
                                    j--;
                                    node = node.next;
                                }
                                setTabAt(nodeArrHelpTransfer, i, null);
                                i++;
                            }
                        } catch (Throwable th) {
                            throw th;
                        }
                    }
                }
            }
            nodeArrHelpTransfer = helpTransfer(nodeArrHelpTransfer, nodeTabAt);
        }
        if (j != 0) {
            addCount(j, -1);
        }
    }

    @Override
    public Set<K> keySet() {
        KeySetView keySetView = this.keySet;
        if (keySetView != null) {
            return keySetView;
        }
        KeySetView keySetView2 = new KeySetView(this, null);
        this.keySet = keySetView2;
        return keySetView2;
    }

    @Override
    public Collection<V> values() {
        ValuesView valuesView = this.values;
        if (valuesView != null) {
            return valuesView;
        }
        ValuesView valuesView2 = new ValuesView(this);
        this.values = valuesView2;
        return valuesView2;
    }

    @Override
    public Set<Map.Entry<K, V>> entrySet() {
        EntrySetView entrySetView = this.entrySet;
        if (entrySetView != null) {
            return entrySetView;
        }
        EntrySetView entrySetView2 = new EntrySetView(this);
        this.entrySet = entrySetView2;
        return entrySetView2;
    }

    @Override
    public int hashCode() {
        Node[] nodeArr = this.table;
        int iHashCode = 0;
        if (nodeArr != null) {
            Traverser traverser = new Traverser(nodeArr, nodeArr.length, 0, nodeArr.length);
            while (true) {
                Node nodeAdvance = traverser.advance();
                if (nodeAdvance == null) {
                    break;
                }
                iHashCode += nodeAdvance.val.hashCode() ^ nodeAdvance.key.hashCode();
            }
        }
        return iHashCode;
    }

    @Override
    public String toString() {
        Node[] nodeArr = this.table;
        int length = nodeArr == null ? 0 : nodeArr.length;
        Traverser traverser = new Traverser(nodeArr, length, 0, length);
        StringBuilder sb = new StringBuilder();
        sb.append('{');
        Node nodeAdvance = traverser.advance();
        if (nodeAdvance != null) {
            while (true) {
                Object obj = nodeAdvance.key;
                Object obj2 = nodeAdvance.val;
                if (obj == this) {
                    obj = "(this Map)";
                }
                sb.append(obj);
                sb.append('=');
                if (obj2 == this) {
                    obj2 = "(this Map)";
                }
                sb.append(obj2);
                nodeAdvance = traverser.advance();
                if (nodeAdvance == null) {
                    break;
                }
                sb.append(',');
                sb.append(' ');
            }
        }
        sb.append('}');
        return sb.toString();
    }

    @Override
    public boolean equals(Object obj) {
        V value;
        V v;
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof Map)) {
            return false;
        }
        Map map = (Map) obj;
        Node[] nodeArr = this.table;
        int length = nodeArr == null ? 0 : nodeArr.length;
        Traverser traverser = new Traverser(nodeArr, length, 0, length);
        while (true) {
            Node nodeAdvance = traverser.advance();
            if (nodeAdvance != null) {
                Object obj2 = nodeAdvance.val;
                Object obj3 = map.get(nodeAdvance.key);
                if (obj3 == null || (obj3 != obj2 && !obj3.equals(obj2))) {
                    break;
                }
            } else {
                for (Map.Entry<K, V> entry : map.entrySet()) {
                    K key = entry.getKey();
                    if (key == null || (value = entry.getValue()) == null || (v = get(key)) == null || (value != v && !value.equals(v))) {
                        return false;
                    }
                }
                return true;
            }
        }
        return false;
    }

    static class Segment extends ReentrantLock implements Serializable {
        private static final long serialVersionUID = 2249069246763182397L;
        final float loadFactor;

        Segment(float f) {
            this.loadFactor = f;
        }
    }

    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        int i = 0;
        int i2 = 1;
        while (i2 < 16) {
            i++;
            i2 <<= 1;
        }
        int i3 = 32 - i;
        int i4 = i2 - 1;
        Segment[] segmentArr = new Segment[16];
        for (int i5 = 0; i5 < 16; i5++) {
            segmentArr[i5] = new Segment(0.75f);
        }
        ObjectOutputStream.PutField putFieldPutFields = objectOutputStream.putFields();
        putFieldPutFields.put("segments", segmentArr);
        putFieldPutFields.put("segmentShift", i3);
        putFieldPutFields.put("segmentMask", i4);
        objectOutputStream.writeFields();
        Node[] nodeArr = this.table;
        if (nodeArr != null) {
            Traverser traverser = new Traverser(nodeArr, nodeArr.length, 0, nodeArr.length);
            while (true) {
                Node nodeAdvance = traverser.advance();
                if (nodeAdvance == null) {
                    break;
                }
                objectOutputStream.writeObject(nodeAdvance.key);
                objectOutputStream.writeObject(nodeAdvance.val);
            }
        }
        objectOutputStream.writeObject(null);
        objectOutputStream.writeObject(null);
    }

    private void readObject(ObjectInputStream objectInputStream) throws ClassNotFoundException, IOException {
        long j;
        boolean z;
        boolean z2;
        Object obj;
        this.sizeCtl = -1;
        objectInputStream.defaultReadObject();
        long j2 = 0;
        long j3 = 0;
        Node node = null;
        while (true) {
            Object object = objectInputStream.readObject();
            Object object2 = objectInputStream.readObject();
            j = 1;
            if (object == null || object2 == null) {
                break;
            }
            j3++;
            node = new Node(spread(object.hashCode()), object, object2, node);
        }
        if (j3 == 0) {
            this.sizeCtl = 0;
            return;
        }
        long j4 = (long) (((double) (j3 / 0.75f)) + 1.0d);
        int iTableSizeFor = j4 >= 1073741824 ? 1073741824 : tableSizeFor((int) j4);
        Node[] nodeArr = new Node[iTableSizeFor];
        int i = iTableSizeFor - 1;
        while (node != null) {
            Node node2 = node.next;
            int i2 = node.hash;
            int i3 = i2 & i;
            Node nodeTabAt = tabAt(nodeArr, i3);
            if (nodeTabAt == null) {
                z2 = true;
            } else {
                Object obj2 = node.key;
                if (nodeTabAt.hash >= 0) {
                    Node node3 = nodeTabAt;
                    int i4 = 0;
                    while (true) {
                        if (node3 == null) {
                            z = true;
                            break;
                        }
                        if (node3.hash == i2 && ((obj = node3.key) == obj2 || (obj != null && obj2.equals(obj)))) {
                            z = false;
                            break;
                        } else {
                            i4++;
                            node3 = node3.next;
                        }
                    }
                    if (!z || i4 < 8) {
                        z2 = z;
                    } else {
                        long j5 = j2 + 1;
                        node.next = nodeTabAt;
                        Node node4 = node;
                        TreeNode treeNode = null;
                        TreeNode treeNode2 = null;
                        while (node4 != null) {
                            long j6 = j5;
                            TreeNode treeNode3 = new TreeNode(node4.hash, node4.key, node4.val, null, null);
                            treeNode3.prev = treeNode2;
                            if (treeNode2 == null) {
                                treeNode = treeNode3;
                            } else {
                                treeNode2.next = treeNode3;
                            }
                            node4 = node4.next;
                            treeNode2 = treeNode3;
                            j5 = j6;
                        }
                        setTabAt(nodeArr, i3, new TreeBin(treeNode));
                        j2 = j5;
                    }
                } else if (((TreeBin) nodeTabAt).putTreeVal(i2, obj2, node.val) == null) {
                    j2 += j;
                }
                z2 = false;
            }
            if (z2) {
                j2++;
                node.next = nodeTabAt;
                setTabAt(nodeArr, i3, node);
            }
            j = 1;
            node = node2;
        }
        this.table = nodeArr;
        this.sizeCtl = iTableSizeFor - (iTableSizeFor >>> 2);
        this.baseCount = j2;
    }

    @Override
    public V putIfAbsent(K k, V v) {
        return (V) putVal(k, v, true);
    }

    @Override
    public boolean remove(Object obj, Object obj2) {
        obj.getClass();
        return (obj2 == null || replaceNode(obj, null, obj2) == null) ? false : true;
    }

    @Override
    public boolean replace(K k, V v, V v2) {
        if (k == null || v == null || v2 == null) {
            throw null;
        }
        return replaceNode(k, v2, v) != null;
    }

    @Override
    public Object replace(Object obj, Object obj2) {
        if (obj == null || obj2 == null) {
            throw null;
        }
        return replaceNode(obj, obj2, null);
    }

    @Override
    public Object getOrDefault(Object obj, Object obj2) {
        V v = get(obj);
        return v == null ? obj2 : v;
    }

    @Override
    public void forEach(BiConsumer biConsumer) {
        biConsumer.getClass();
        Node[] nodeArr = this.table;
        if (nodeArr == null) {
            return;
        }
        Traverser traverser = new Traverser(nodeArr, nodeArr.length, 0, nodeArr.length);
        while (true) {
            Node nodeAdvance = traverser.advance();
            if (nodeAdvance == null) {
                return;
            } else {
                biConsumer.accept(nodeAdvance.key, nodeAdvance.val);
            }
        }
    }

    @Override
    public void replaceAll(BiFunction biFunction) {
        biFunction.getClass();
        Node[] nodeArr = this.table;
        if (nodeArr == null) {
            return;
        }
        Traverser traverser = new Traverser(nodeArr, nodeArr.length, 0, nodeArr.length);
        while (true) {
            Node nodeAdvance = traverser.advance();
            if (nodeAdvance == null) {
                return;
            }
            Object obj = nodeAdvance.val;
            Object obj2 = nodeAdvance.key;
            do {
                Object objApply = biFunction.apply(obj2, obj);
                objApply.getClass();
                if (replaceNode(obj2, objApply, obj) != null) {
                    break;
                } else {
                    obj = get(obj2);
                }
            } while (obj != null);
        }
    }

    boolean removeEntryIf(Predicate predicate) {
        predicate.getClass();
        Node[] nodeArr = this.table;
        boolean z = false;
        if (nodeArr != null) {
            Traverser traverser = new Traverser(nodeArr, nodeArr.length, 0, nodeArr.length);
            while (true) {
                Node nodeAdvance = traverser.advance();
                if (nodeAdvance == null) {
                    break;
                }
                Object obj = nodeAdvance.key;
                Object obj2 = nodeAdvance.val;
                if (predicate.test(new AbstractMap.SimpleImmutableEntry(obj, obj2)) && replaceNode(obj, null, obj2) != null) {
                    z = true;
                }
            }
        }
        return z;
    }

    boolean removeValueIf(Predicate predicate) {
        predicate.getClass();
        Node[] nodeArr = this.table;
        boolean z = false;
        if (nodeArr != null) {
            Traverser traverser = new Traverser(nodeArr, nodeArr.length, 0, nodeArr.length);
            while (true) {
                Node nodeAdvance = traverser.advance();
                if (nodeAdvance == null) {
                    break;
                }
                Object obj = nodeAdvance.key;
                Object obj2 = nodeAdvance.val;
                if (predicate.test(obj2) && replaceNode(obj, null, obj2) != null) {
                    z = true;
                }
            }
        }
        return z;
    }

    @Override
    public java.lang.Object computeIfAbsent(java.lang.Object r12, java.util.function.Function r13) {
        throw new UnsupportedOperationException("Method not decompiled: p000j$.util.concurrent.ConcurrentHashMap.computeIfAbsent(java.lang.Object, java.util.function.Function):java.lang.Object");
    }

    @Override
    public Object computeIfPresent(Object obj, BiFunction biFunction) {
        TreeNode treeNodeFindTreeNode;
        Object obj2;
        if (obj == null || biFunction == null) {
            throw null;
        }
        int iSpread = spread(obj.hashCode());
        Node[] nodeArrInitTable = this.table;
        int i = 0;
        Object objApply = null;
        int i2 = 0;
        while (true) {
            if (nodeArrInitTable != null) {
                int length = nodeArrInitTable.length;
                if (length != 0) {
                    int i3 = (length - 1) & iSpread;
                    Node nodeTabAt = tabAt(nodeArrInitTable, i3);
                    if (nodeTabAt == null) {
                        break;
                    }
                    int i4 = nodeTabAt.hash;
                    if (i4 == -1) {
                        nodeArrInitTable = helpTransfer(nodeArrInitTable, nodeTabAt);
                    } else {
                        synchronized (nodeTabAt) {
                            try {
                                if (tabAt(nodeArrInitTable, i3) == nodeTabAt) {
                                    if (i4 >= 0) {
                                        i2 = 1;
                                        Node node = null;
                                        Node node2 = nodeTabAt;
                                        while (true) {
                                            if (node2.hash == iSpread && ((obj2 = node2.key) == obj || (obj2 != null && obj.equals(obj2)))) {
                                                objApply = biFunction.apply(obj, node2.val);
                                                if (objApply != null) {
                                                    node2.val = objApply;
                                                    break;
                                                }
                                                Node node3 = node2.next;
                                                if (node != null) {
                                                    node.next = node3;
                                                } else {
                                                    setTabAt(nodeArrInitTable, i3, node3);
                                                }
                                                i = -1;
                                                break;
                                            }
                                            Node node4 = node2.next;
                                            if (node4 == null) {
                                                break;
                                            }
                                            i2++;
                                            node = node2;
                                            node2 = node4;
                                        }
                                    } else if (nodeTabAt instanceof TreeBin) {
                                        TreeBin treeBin = (TreeBin) nodeTabAt;
                                        TreeNode treeNode = treeBin.root;
                                        if (treeNode != null && (treeNodeFindTreeNode = treeNode.findTreeNode(iSpread, obj, null)) != null) {
                                            objApply = biFunction.apply(obj, treeNodeFindTreeNode.val);
                                            if (objApply != null) {
                                                treeNodeFindTreeNode.val = objApply;
                                            } else {
                                                if (treeBin.removeTreeNode(treeNodeFindTreeNode)) {
                                                    setTabAt(nodeArrInitTable, i3, untreeify(treeBin.first));
                                                }
                                                i = -1;
                                            }
                                        }
                                        i2 = 2;
                                    } else if (nodeTabAt instanceof ReservationNode) {
                                        throw new IllegalStateException("Recursive update");
                                    }
                                }
                            } catch (Throwable th) {
                                throw th;
                            }
                        }
                        if (i2 != 0) {
                            break;
                        }
                    }
                }
            }
            nodeArrInitTable = initTable();
        }
        if (i != 0) {
            addCount(i, i2);
        }
        return objApply;
    }

    @Override
    public java.lang.Object compute(java.lang.Object r14, java.util.function.BiFunction r15) {
        throw new UnsupportedOperationException("Method not decompiled: p000j$.util.concurrent.ConcurrentHashMap.compute(java.lang.Object, java.util.function.BiFunction):java.lang.Object");
    }

    @Override
    public Object merge(Object obj, Object obj2, BiFunction biFunction) {
        int i;
        Object obj3;
        Object obj4 = obj2;
        if (obj == null || obj4 == null || biFunction == null) {
            throw null;
        }
        int iSpread = spread(obj.hashCode());
        Node[] nodeArrInitTable = this.table;
        int i2 = 0;
        Object obj5 = null;
        int i3 = 0;
        while (true) {
            if (nodeArrInitTable != null) {
                int length = nodeArrInitTable.length;
                if (length != 0) {
                    int i4 = (length - 1) & iSpread;
                    Node nodeTabAt = tabAt(nodeArrInitTable, i4);
                    i = 1;
                    if (nodeTabAt == null) {
                        if (casTabAt(nodeArrInitTable, i4, null, new Node(iSpread, obj, obj4))) {
                            break;
                        }
                    } else {
                        int i5 = nodeTabAt.hash;
                        if (i5 == -1) {
                            nodeArrInitTable = helpTransfer(nodeArrInitTable, nodeTabAt);
                        } else {
                            synchronized (nodeTabAt) {
                                try {
                                    if (tabAt(nodeArrInitTable, i4) == nodeTabAt) {
                                        if (i5 >= 0) {
                                            Node node = null;
                                            Node node2 = nodeTabAt;
                                            i2 = 1;
                                            while (true) {
                                                if (node2.hash == iSpread && ((obj3 = node2.key) == obj || (obj3 != null && obj.equals(obj3)))) {
                                                    Object objApply = biFunction.apply(node2.val, obj4);
                                                    if (objApply != null) {
                                                        node2.val = objApply;
                                                        obj5 = objApply;
                                                        break;
                                                    }
                                                    Node node3 = node2.next;
                                                    if (node != null) {
                                                        node.next = node3;
                                                    } else {
                                                        setTabAt(nodeArrInitTable, i4, node3);
                                                    }
                                                    obj5 = objApply;
                                                    i3 = -1;
                                                    break;
                                                }
                                                Node node4 = node2.next;
                                                if (node4 == null) {
                                                    node2.next = new Node(iSpread, obj, obj4);
                                                    obj5 = obj4;
                                                    i3 = 1;
                                                    break;
                                                }
                                                i2++;
                                                node = node2;
                                                node2 = node4;
                                            }
                                        } else if (nodeTabAt instanceof TreeBin) {
                                            TreeBin treeBin = (TreeBin) nodeTabAt;
                                            TreeNode treeNode = treeBin.root;
                                            TreeNode treeNodeFindTreeNode = treeNode == null ? null : treeNode.findTreeNode(iSpread, obj, null);
                                            Object objApply2 = treeNodeFindTreeNode == null ? obj4 : biFunction.apply(treeNodeFindTreeNode.val, obj4);
                                            if (objApply2 != null) {
                                                if (treeNodeFindTreeNode != null) {
                                                    treeNodeFindTreeNode.val = objApply2;
                                                } else {
                                                    treeBin.putTreeVal(iSpread, obj, objApply2);
                                                    i3 = 1;
                                                }
                                            } else if (treeNodeFindTreeNode != null) {
                                                if (treeBin.removeTreeNode(treeNodeFindTreeNode)) {
                                                    setTabAt(nodeArrInitTable, i4, untreeify(treeBin.first));
                                                }
                                                i3 = -1;
                                            }
                                            i2 = 2;
                                            obj5 = objApply2;
                                        } else if (nodeTabAt instanceof ReservationNode) {
                                            throw new IllegalStateException("Recursive update");
                                        }
                                    }
                                } catch (Throwable th) {
                                    throw th;
                                }
                            }
                            if (i2 != 0) {
                                if (i2 >= 8) {
                                    treeifyBin(nodeArrInitTable, i4);
                                }
                                i = i3;
                                obj4 = obj5;
                                break;
                            }
                        }
                    }
                }
            }
            nodeArrInitTable = initTable();
        }
        if (i != 0) {
            addCount(i, i2);
        }
        return obj4;
    }

    public long mappingCount() {
        long jSumCount = sumCount();
        if (jSumCount < 0) {
            return 0L;
        }
        return jSumCount;
    }

    static final class ForwardingNode extends Node {
        final Node[] nextTable;

        ForwardingNode(Node[] nodeArr) {
            super(-1, null, null);
            this.nextTable = nodeArr;
        }

        @Override
        Node find(int i, Object obj) {
            int length;
            Node nodeTabAt;
            Object obj2;
            Node[] nodeArr = this.nextTable;
            loop0: while (obj != null && nodeArr != null && (length = nodeArr.length) != 0 && (nodeTabAt = ConcurrentHashMap.tabAt(nodeArr, (length - 1) & i)) != null) {
                do {
                    int i2 = nodeTabAt.hash;
                    if (i2 == i && ((obj2 = nodeTabAt.key) == obj || (obj2 != null && obj.equals(obj2)))) {
                        return nodeTabAt;
                    }
                    if (i2 < 0) {
                        if (nodeTabAt instanceof ForwardingNode) {
                            nodeArr = ((ForwardingNode) nodeTabAt).nextTable;
                        } else {
                            return nodeTabAt.find(i, obj);
                        }
                    } else {
                        nodeTabAt = nodeTabAt.next;
                    }
                } while (nodeTabAt != null);
            }
            return null;
        }
    }

    static final class ReservationNode extends Node {
        @Override
        Node find(int i, Object obj) {
            return null;
        }

        ReservationNode() {
            super(-3, null, null);
        }
    }

    static final int resizeStamp(int i) {
        return Integer.numberOfLeadingZeros(i) | 32768;
    }

    private final Node[] initTable() {
        while (true) {
            Node[] nodeArr = this.table;
            if (nodeArr != null && nodeArr.length != 0) {
                return nodeArr;
            }
            int i = this.sizeCtl;
            if (i < 0) {
                Thread.yield();
            } else if (f1381U.compareAndSetInt(this, SIZECTL, i, -1)) {
                try {
                    Node[] nodeArr2 = this.table;
                    if (nodeArr2 == null || nodeArr2.length == 0) {
                        int i2 = i > 0 ? i : 16;
                        Node[] nodeArr3 = new Node[i2];
                        this.table = nodeArr3;
                        i = i2 - (i2 >>> 2);
                        nodeArr2 = nodeArr3;
                    }
                    return nodeArr2;
                } finally {
                    this.sizeCtl = i;
                }
            }
        }
    }

    private final void addCount(long j, int i) {
        boolean z;
        int length;
        CounterCell counterCell;
        boolean zCompareAndSetLong;
        long jSumCount;
        Node[] nodeArr;
        int length2;
        Node[] nodeArr2;
        CounterCell[] counterCellArr = this.counterCells;
        if (counterCellArr == null) {
            DesugarUnsafe desugarUnsafe = f1381U;
            long j2 = BASECOUNT;
            long j3 = this.baseCount;
            jSumCount = j3 + j;
            if (!desugarUnsafe.compareAndSetLong(this, j2, j3, jSumCount)) {
                z = true;
                if (counterCellArr != null && (length = counterCellArr.length - 1) >= 0 && (counterCell = counterCellArr[length & ThreadLocalRandom.getProbe()]) != null) {
                    DesugarUnsafe desugarUnsafe2 = f1381U;
                    long j4 = CELLVALUE;
                    long j5 = counterCell.value;
                    zCompareAndSetLong = desugarUnsafe2.compareAndSetLong(counterCell, j4, j5, j5 + j);
                    if (!zCompareAndSetLong) {
                        z = zCompareAndSetLong;
                    } else if (i <= 1) {
                        return;
                    } else {
                        jSumCount = sumCount();
                    }
                }
                fullAddCount(j, z);
                return;
            }
        } else {
            z = true;
            if (counterCellArr != null) {
                DesugarUnsafe desugarUnsafe3 = f1381U;
                long j6 = CELLVALUE;
                long j7 = counterCell.value;
                zCompareAndSetLong = desugarUnsafe3.compareAndSetLong(counterCell, j6, j7, j7 + j);
                if (!zCompareAndSetLong) {
                    z = zCompareAndSetLong;
                } else if (i <= 1) {
                    return;
                } else {
                    jSumCount = sumCount();
                }
            }
            fullAddCount(j, z);
            return;
        }
        if (i < 0) {
            return;
        }
        while (true) {
            int i2 = this.sizeCtl;
            if (jSumCount < i2 || (nodeArr = this.table) == null || (length2 = nodeArr.length) >= 1073741824) {
                return;
            }
            int iResizeStamp = resizeStamp(length2);
            if (i2 < 0) {
                if ((i2 >>> 16) != iResizeStamp || i2 == iResizeStamp + 1 || i2 == iResizeStamp + 65535 || (nodeArr2 = this.nextTable) == null || this.transferIndex <= 0) {
                    return;
                }
                if (f1381U.compareAndSetInt(this, SIZECTL, i2, i2 + 1)) {
                    transfer(nodeArr, nodeArr2);
                }
            } else if (f1381U.compareAndSetInt(this, SIZECTL, i2, (iResizeStamp << 16) + 2)) {
                transfer(nodeArr, null);
            }
            jSumCount = sumCount();
        }
    }

    final Node[] helpTransfer(Node[] nodeArr, Node node) {
        Node[] nodeArr2;
        int i;
        if (nodeArr != null && (node instanceof ForwardingNode) && (nodeArr2 = ((ForwardingNode) node).nextTable) != null) {
            int iResizeStamp = resizeStamp(nodeArr.length);
            while (nodeArr2 == this.nextTable && this.table == nodeArr && (i = this.sizeCtl) < 0 && (i >>> 16) == iResizeStamp && i != iResizeStamp + 1 && i != 65535 + iResizeStamp && this.transferIndex > 0) {
                if (f1381U.compareAndSetInt(this, SIZECTL, i, i + 1)) {
                    transfer(nodeArr, nodeArr2);
                    break;
                }
            }
            return nodeArr2;
        }
        return this.table;
    }

    private final void tryPresize(int i) {
        int length;
        int iTableSizeFor = i >= 536870912 ? 1073741824 : tableSizeFor(i + (i >>> 1) + 1);
        while (true) {
            int i2 = this.sizeCtl;
            if (i2 < 0) {
                return;
            }
            Node[] nodeArr = this.table;
            if (nodeArr == null || (length = nodeArr.length) == 0) {
                int i3 = i2 > iTableSizeFor ? i2 : iTableSizeFor;
                if (f1381U.compareAndSetInt(this, SIZECTL, i2, -1)) {
                    try {
                        if (this.table == nodeArr) {
                            this.table = new Node[i3];
                            i2 = i3 - (i3 >>> 2);
                        }
                        this.sizeCtl = i2;
                    } catch (Throwable th) {
                        this.sizeCtl = i2;
                        throw th;
                    }
                } else {
                    continue;
                }
            } else {
                if (iTableSizeFor <= i2 || length >= 1073741824) {
                    return;
                }
                if (nodeArr == this.table) {
                    if (f1381U.compareAndSetInt(this, SIZECTL, i2, (resizeStamp(length) << 16) + 2)) {
                        transfer(nodeArr, null);
                    }
                }
            }
        }
    }

    private final void transfer(Node[] nodeArr, Node[] nodeArr2) {
        Node[] nodeArr3;
        ForwardingNode forwardingNode;
        boolean z;
        int i;
        Node treeBin;
        Node treeBin2;
        Node node;
        ConcurrentHashMap<K, V> concurrentHashMap = this;
        Node[] nodeArr4 = nodeArr;
        int length = nodeArr4.length;
        int i2 = NCPU;
        boolean z2 = true;
        int i3 = i2 > 1 ? (length >>> 3) / i2 : length;
        char c = 16;
        int i4 = i3 < 16 ? 16 : i3;
        if (nodeArr2 == null) {
            try {
                Node[] nodeArr5 = new Node[length << 1];
                concurrentHashMap.nextTable = nodeArr5;
                concurrentHashMap.transferIndex = length;
                nodeArr3 = nodeArr5;
            } catch (Throwable unused) {
                concurrentHashMap.sizeCtl = Integer.MAX_VALUE;
                return;
            }
        } else {
            nodeArr3 = nodeArr2;
        }
        int length2 = nodeArr3.length;
        ForwardingNode forwardingNode2 = new ForwardingNode(nodeArr3);
        boolean zCasTabAt = true;
        int i5 = 0;
        int i6 = 0;
        boolean z3 = false;
        while (true) {
            if (zCasTabAt) {
                int i7 = i6 - 1;
                if (i7 >= i5 || z3) {
                    i5 = i5;
                    i6 = i7;
                    zCasTabAt = false;
                } else {
                    int i8 = concurrentHashMap.transferIndex;
                    if (i8 <= 0) {
                        i6 = -1;
                    } else {
                        DesugarUnsafe desugarUnsafe = f1381U;
                        long j = TRANSFERINDEX;
                        int i9 = i8 > i4 ? i8 - i4 : 0;
                        int i10 = i5;
                        if (desugarUnsafe.compareAndSetInt(this, j, i8, i9)) {
                            i6 = i8 - 1;
                            i5 = i9;
                        } else {
                            i5 = i10;
                            i6 = i7;
                        }
                    }
                    zCasTabAt = false;
                }
            } else {
                int i11 = i5;
                TreeNode treeNode = null;
                Node node2 = null;
                if (i6 < 0 || i6 >= length || (i = i6 + length) >= length2) {
                    i4 = i4;
                    length2 = length2;
                    forwardingNode = forwardingNode2;
                    if (z3) {
                        this.nextTable = null;
                        this.table = nodeArr3;
                        this.sizeCtl = (length << 1) - (length >>> 1);
                        return;
                    }
                    concurrentHashMap = this;
                    z = true;
                    DesugarUnsafe desugarUnsafe2 = f1381U;
                    long j2 = SIZECTL;
                    int i12 = concurrentHashMap.sizeCtl;
                    int i13 = i6;
                    if (desugarUnsafe2.compareAndSetInt(this, j2, i12, i12 - 1)) {
                        c = 16;
                        if (i12 - 2 != (resizeStamp(length) << 16)) {
                            return;
                        }
                        i6 = length;
                        zCasTabAt = true;
                        z3 = true;
                    } else {
                        c = 16;
                        i6 = i13;
                    }
                } else {
                    Node nodeTabAt = tabAt(nodeArr4, i6);
                    if (nodeTabAt == null) {
                        zCasTabAt = casTabAt(nodeArr4, i6, null, forwardingNode2);
                        z = z2;
                    } else {
                        int i14 = nodeTabAt.hash;
                        if (i14 == -1) {
                            zCasTabAt = z2;
                            z = zCasTabAt;
                        } else {
                            synchronized (nodeTabAt) {
                                try {
                                    if (tabAt(nodeArr4, i6) == nodeTabAt) {
                                        if (i14 >= 0) {
                                            int i15 = i14 & length;
                                            Node node3 = nodeTabAt;
                                            for (Node node4 = nodeTabAt.next; node4 != null; node4 = node4.next) {
                                                int i16 = node4.hash & length;
                                                if (i16 != i15) {
                                                    node3 = node4;
                                                    i15 = i16;
                                                }
                                            }
                                            if (i15 == 0) {
                                                node = null;
                                                node2 = node3;
                                            } else {
                                                node = node3;
                                            }
                                            Node node5 = nodeTabAt;
                                            while (node5 != node3) {
                                                int i17 = node5.hash;
                                                Object obj = node5.key;
                                                int i18 = i4;
                                                Object obj2 = node5.val;
                                                if ((i17 & length) == 0) {
                                                    node2 = new Node(i17, obj, obj2, node2);
                                                } else {
                                                    node = new Node(i17, obj, obj2, node);
                                                }
                                                node5 = node5.next;
                                                i4 = i18;
                                                length2 = length2;
                                            }
                                            i4 = i4;
                                            length2 = length2;
                                            setTabAt(nodeArr3, i6, node2);
                                            setTabAt(nodeArr3, i, node);
                                            setTabAt(nodeArr4, i6, forwardingNode2);
                                            forwardingNode = forwardingNode2;
                                        } else {
                                            i4 = i4;
                                            length2 = length2;
                                            if (nodeTabAt instanceof TreeBin) {
                                                TreeBin treeBin3 = (TreeBin) nodeTabAt;
                                                TreeNode treeNode2 = null;
                                                TreeNode treeNode3 = null;
                                                Node node6 = treeBin3.first;
                                                int i19 = 0;
                                                int i20 = 0;
                                                TreeNode treeNode4 = null;
                                                while (node6 != null) {
                                                    TreeBin treeBin4 = treeBin3;
                                                    int i21 = node6.hash;
                                                    ForwardingNode forwardingNode3 = forwardingNode2;
                                                    TreeNode treeNode5 = new TreeNode(i21, node6.key, node6.val, null, null);
                                                    if ((i21 & length) == 0) {
                                                        treeNode5.prev = treeNode3;
                                                        if (treeNode3 == null) {
                                                            treeNode = treeNode5;
                                                        } else {
                                                            treeNode3.next = treeNode5;
                                                        }
                                                        i19++;
                                                        treeNode3 = treeNode5;
                                                    } else {
                                                        treeNode5.prev = treeNode2;
                                                        if (treeNode2 == null) {
                                                            treeNode4 = treeNode5;
                                                        } else {
                                                            treeNode2.next = treeNode5;
                                                        }
                                                        i20++;
                                                        treeNode2 = treeNode5;
                                                    }
                                                    node6 = node6.next;
                                                    treeBin3 = treeBin4;
                                                    forwardingNode2 = forwardingNode3;
                                                }
                                                TreeBin treeBin5 = treeBin3;
                                                ForwardingNode forwardingNode4 = forwardingNode2;
                                                if (i19 <= 6) {
                                                    treeBin = untreeify(treeNode);
                                                } else {
                                                    treeBin = i20 != 0 ? new TreeBin(treeNode) : treeBin5;
                                                }
                                                if (i20 <= 6) {
                                                    treeBin2 = untreeify(treeNode4);
                                                } else {
                                                    treeBin2 = i19 != 0 ? new TreeBin(treeNode4) : treeBin5;
                                                }
                                                setTabAt(nodeArr3, i6, treeBin);
                                                setTabAt(nodeArr3, i, treeBin2);
                                                nodeArr4 = nodeArr;
                                                forwardingNode = forwardingNode4;
                                                setTabAt(nodeArr4, i6, forwardingNode);
                                            }
                                        }
                                        zCasTabAt = true;
                                    } else {
                                        i4 = i4;
                                        length2 = length2;
                                    }
                                    forwardingNode = forwardingNode2;
                                } catch (Throwable th) {
                                    throw th;
                                }
                            }
                            concurrentHashMap = this;
                            c = 16;
                            z = true;
                        }
                    }
                    forwardingNode = forwardingNode2;
                }
                forwardingNode2 = forwardingNode;
                concurrentHashMap = concurrentHashMap;
                z2 = z;
                i5 = i11;
                i4 = i4;
                length2 = length2;
                c = c;
            }
        }
    }

    static final class CounterCell {
        volatile long value;

        CounterCell(long j) {
            this.value = j;
        }
    }

    final long sumCount() {
        CounterCell[] counterCellArr = this.counterCells;
        long j = this.baseCount;
        if (counterCellArr != null) {
            for (CounterCell counterCell : counterCellArr) {
                if (counterCell != null) {
                    j += counterCell.value;
                }
            }
        }
        return j;
    }

    private final void fullAddCount(long j, boolean z) {
        int probe;
        boolean z2;
        CounterCell[] counterCellArr;
        boolean z3;
        int length;
        boolean z4;
        int length2;
        int probe2 = ThreadLocalRandom.getProbe();
        if (probe2 == 0) {
            ThreadLocalRandom.localInit();
            probe = ThreadLocalRandom.getProbe();
            z2 = true;
        } else {
            probe = probe2;
            z2 = z;
        }
        int iAdvanceProbe = probe;
        while (true) {
            boolean z5 = false;
            while (true) {
                counterCellArr = this.counterCells;
                if (counterCellArr != null && (length = counterCellArr.length) > 0) {
                    CounterCell counterCell = counterCellArr[(length - 1) & iAdvanceProbe];
                    if (counterCell == null) {
                        if (this.cellsBusy == 0) {
                            CounterCell counterCell2 = new CounterCell(j);
                            if (this.cellsBusy == 0 && f1381U.compareAndSetInt(this, CELLSBUSY, 0, 1)) {
                                try {
                                    CounterCell[] counterCellArr2 = this.counterCells;
                                    if (counterCellArr2 == null || (length2 = counterCellArr2.length) <= 0) {
                                        z4 = false;
                                    } else {
                                        int i = (length2 - 1) & iAdvanceProbe;
                                        if (counterCellArr2[i] == null) {
                                            counterCellArr2[i] = counterCell2;
                                            z4 = true;
                                        } else {
                                            z4 = false;
                                        }
                                    }
                                    this.cellsBusy = 0;
                                    if (z4) {
                                        return;
                                    }
                                } catch (Throwable th) {
                                    this.cellsBusy = 0;
                                    throw th;
                                }
                            }
                        }
                    } else {
                        if (z2) {
                            DesugarUnsafe desugarUnsafe = f1381U;
                            long j2 = CELLVALUE;
                            long j3 = counterCell.value;
                            if (!desugarUnsafe.compareAndSetLong(counterCell, j2, j3, j3 + j)) {
                                if (this.counterCells == counterCellArr && length < NCPU) {
                                    if (!z5) {
                                        z5 = true;
                                    } else if (this.cellsBusy == 0 && desugarUnsafe.compareAndSetInt(this, CELLSBUSY, 0, 1)) {
                                        break;
                                    }
                                }
                            } else {
                                return;
                            }
                        } else {
                            z2 = true;
                        }
                        iAdvanceProbe = ThreadLocalRandom.advanceProbe(iAdvanceProbe);
                    }
                    z5 = false;
                    iAdvanceProbe = ThreadLocalRandom.advanceProbe(iAdvanceProbe);
                } else if (this.cellsBusy == 0 && this.counterCells == counterCellArr && f1381U.compareAndSetInt(this, CELLSBUSY, 0, 1)) {
                    try {
                        if (this.counterCells == counterCellArr) {
                            CounterCell[] counterCellArr3 = new CounterCell[2];
                            counterCellArr3[iAdvanceProbe & 1] = new CounterCell(j);
                            this.counterCells = counterCellArr3;
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        this.cellsBusy = 0;
                        if (z3) {
                            return;
                        }
                    } catch (Throwable th2) {
                        this.cellsBusy = 0;
                        throw th2;
                    }
                } else {
                    DesugarUnsafe desugarUnsafe2 = f1381U;
                    long j4 = BASECOUNT;
                    long j5 = this.baseCount;
                    if (desugarUnsafe2.compareAndSetLong(this, j4, j5, j5 + j)) {
                        return;
                    }
                }
            }
            try {
                if (this.counterCells == counterCellArr) {
                    this.counterCells = (CounterCell[]) Arrays.copyOf(counterCellArr, length << 1);
                }
                this.cellsBusy = 0;
            } catch (Throwable th3) {
                this.cellsBusy = 0;
                throw th3;
            }
        }
    }

    private final void treeifyBin(Node[] nodeArr, int i) {
        if (nodeArr != null) {
            int length = nodeArr.length;
            if (length < 64) {
                tryPresize(length << 1);
                return;
            }
            Node nodeTabAt = tabAt(nodeArr, i);
            if (nodeTabAt == null || nodeTabAt.hash < 0) {
                return;
            }
            synchronized (nodeTabAt) {
                try {
                    if (tabAt(nodeArr, i) == nodeTabAt) {
                        TreeNode treeNode = null;
                        Node node = nodeTabAt;
                        TreeNode treeNode2 = null;
                        while (node != null) {
                            TreeNode treeNode3 = new TreeNode(node.hash, node.key, node.val, null, null);
                            treeNode3.prev = treeNode2;
                            if (treeNode2 == null) {
                                treeNode = treeNode3;
                            } else {
                                treeNode2.next = treeNode3;
                            }
                            node = node.next;
                            treeNode2 = treeNode3;
                        }
                        setTabAt(nodeArr, i, new TreeBin(treeNode));
                    }
                } catch (Throwable th) {
                    throw th;
                }
            }
        }
    }

    static Node untreeify(Node node) {
        Node node2 = null;
        Node node3 = null;
        while (node != null) {
            Node node4 = new Node(node.hash, node.key, node.val);
            if (node3 == null) {
                node2 = node4;
            } else {
                node3.next = node4;
            }
            node = node.next;
            node3 = node4;
        }
        return node2;
    }

    static final class TreeNode extends Node {
        TreeNode left;
        TreeNode parent;
        TreeNode prev;
        boolean red;
        TreeNode right;

        TreeNode(int i, Object obj, Object obj2, Node node, TreeNode treeNode) {
            super(i, obj, obj2, node);
            this.parent = treeNode;
        }

        @Override
        Node find(int i, Object obj) {
            return findTreeNode(i, obj, null);
        }

        final TreeNode findTreeNode(int i, Object obj, Class cls) {
            int iCompareComparables;
            if (obj == null) {
                return null;
            }
            TreeNode treeNode = this;
            do {
                TreeNode treeNode2 = treeNode.left;
                TreeNode treeNode3 = treeNode.right;
                int i2 = treeNode.hash;
                if (i2 <= i) {
                    if (i2 >= i) {
                        Object obj2 = treeNode.key;
                        if (obj2 == obj || (obj2 != null && obj.equals(obj2))) {
                            return treeNode;
                        }
                        if (treeNode2 != null) {
                            if (treeNode3 != null) {
                                if ((cls == null && (cls = ConcurrentHashMap.comparableClassFor(obj)) == null) || (iCompareComparables = ConcurrentHashMap.compareComparables(cls, obj, obj2)) == 0) {
                                    TreeNode treeNodeFindTreeNode = treeNode3.findTreeNode(i, obj, cls);
                                    if (treeNodeFindTreeNode != null) {
                                        return treeNodeFindTreeNode;
                                    }
                                } else if (iCompareComparables >= 0) {
                                    treeNode2 = treeNode3;
                                }
                            }
                            treeNode = treeNode2;
                        }
                    }
                    treeNode = treeNode3;
                } else {
                    treeNode = treeNode2;
                }
            } while (treeNode != null);
            return null;
        }
    }

    static final class TreeBin extends Node {
        private static final long LOCKSTATE;

        private static final DesugarUnsafe f1382U;
        volatile TreeNode first;
        volatile int lockState;
        TreeNode root;
        volatile Thread waiter;

        static int tieBreakOrder(Object obj, Object obj2) {
            int iCompareTo;
            if (obj == null || obj2 == null || (iCompareTo = obj.getClass().getName().compareTo(obj2.getClass().getName())) == 0) {
                return System.identityHashCode(obj) <= System.identityHashCode(obj2) ? -1 : 1;
            }
            return iCompareTo;
        }

        TreeBin(TreeNode treeNode) {
            int iCompareComparables;
            int iTieBreakOrder;
            super(-2, null, null);
            this.first = treeNode;
            TreeNode treeNode2 = null;
            while (treeNode != null) {
                TreeNode treeNode3 = (TreeNode) treeNode.next;
                treeNode.right = null;
                treeNode.left = null;
                if (treeNode2 == null) {
                    treeNode.parent = null;
                    treeNode.red = false;
                } else {
                    Object obj = treeNode.key;
                    int i = treeNode.hash;
                    TreeNode treeNode4 = treeNode2;
                    Class clsComparableClassFor = null;
                    while (true) {
                        Object obj2 = treeNode4.key;
                        int i2 = treeNode4.hash;
                        if (i2 > i) {
                            iTieBreakOrder = -1;
                        } else if (i2 < i) {
                            iTieBreakOrder = 1;
                        } else {
                            iTieBreakOrder = ((clsComparableClassFor == null && (clsComparableClassFor = ConcurrentHashMap.comparableClassFor(obj)) == null) || (iCompareComparables = ConcurrentHashMap.compareComparables(clsComparableClassFor, obj, obj2)) == 0) ? tieBreakOrder(obj, obj2) : iCompareComparables;
                        }
                        TreeNode treeNode5 = iTieBreakOrder <= 0 ? treeNode4.left : treeNode4.right;
                        if (treeNode5 == null) {
                            break;
                        } else {
                            treeNode4 = treeNode5;
                        }
                    }
                    treeNode.parent = treeNode4;
                    if (iTieBreakOrder <= 0) {
                        treeNode4.left = treeNode;
                    } else {
                        treeNode4.right = treeNode;
                    }
                    treeNode = balanceInsertion(treeNode2, treeNode);
                }
                treeNode2 = treeNode;
                treeNode = treeNode3;
            }
            this.root = treeNode2;
        }

        private final void lockRoot() {
            if (f1382U.compareAndSetInt(this, LOCKSTATE, 0, 1)) {
                return;
            }
            contendedLock();
        }

        private final void unlockRoot() {
            this.lockState = 0;
        }

        private final void contendedLock() {
            boolean z = false;
            while (true) {
                int i = this.lockState;
                if ((i & (-3)) == 0) {
                    if (f1382U.compareAndSetInt(this, LOCKSTATE, i, 1)) {
                        break;
                    }
                } else if ((i & 2) == 0) {
                    if (f1382U.compareAndSetInt(this, LOCKSTATE, i, i | 2)) {
                        this.waiter = Thread.currentThread();
                        z = true;
                    }
                } else if (z) {
                    LockSupport.park(this);
                }
            }
            if (z) {
                this.waiter = null;
            }
        }

        @Override
        final Node find(int i, Object obj) {
            Object obj2;
            Thread thread;
            TreeNode treeNodeFindTreeNode = null;
            if (obj != null) {
                Node node = this.first;
                while (node != null) {
                    int i2 = this.lockState;
                    if ((i2 & 3) != 0) {
                        if (node.hash == i && ((obj2 = node.key) == obj || (obj2 != null && obj.equals(obj2)))) {
                            return node;
                        }
                        node = node.next;
                    } else if (f1382U.compareAndSetInt(this, LOCKSTATE, i2, i2 + 4)) {
                        try {
                            TreeNode treeNode = this.root;
                            if (treeNode != null) {
                                treeNodeFindTreeNode = treeNode.findTreeNode(i, obj, null);
                            }
                            return treeNodeFindTreeNode;
                        } finally {
                            if (f1382U.getAndAddInt(this, LOCKSTATE, -4) == 6 && (thread = this.waiter) != null) {
                                LockSupport.unpark(thread);
                            }
                        }
                    }
                }
            }
            return null;
        }

        final TreeNode putTreeVal(int i, Object obj, Object obj2) {
            int iCompareComparables;
            int i2;
            int iTieBreakOrder;
            TreeNode treeNode;
            TreeNode treeNodeFindTreeNode;
            TreeNode treeNode2;
            TreeNode treeNode3;
            TreeNode treeNode4;
            TreeNode treeNode5 = this.root;
            boolean z = false;
            Class clsComparableClassFor = null;
            while (treeNode5 != null) {
                int i3 = treeNode5.hash;
                if (i3 > i) {
                    iTieBreakOrder = -1;
                } else {
                    if (i3 < i) {
                        i2 = 1;
                    } else {
                        Object obj3 = treeNode5.key;
                        if (obj3 == obj || (obj3 != null && obj.equals(obj3))) {
                            return treeNode5;
                        }
                        if ((clsComparableClassFor == null && (clsComparableClassFor = ConcurrentHashMap.comparableClassFor(obj)) == null) || (iCompareComparables = ConcurrentHashMap.compareComparables(clsComparableClassFor, obj, obj3)) == 0) {
                            if (!z) {
                                TreeNode treeNode6 = treeNode5.left;
                                if ((treeNode6 != null && (treeNodeFindTreeNode = treeNode6.findTreeNode(i, obj, clsComparableClassFor)) != null) || ((treeNode = treeNode5.right) != null && (treeNodeFindTreeNode = treeNode.findTreeNode(i, obj, clsComparableClassFor)) != null)) {
                                    return treeNodeFindTreeNode;
                                }
                                z = true;
                            }
                            iTieBreakOrder = tieBreakOrder(obj, obj3);
                        } else {
                            i2 = iCompareComparables;
                        }
                    }
                    if (i2 <= 0) {
                        treeNode2 = treeNode5.left;
                    } else {
                        treeNode2 = treeNode5.right;
                    }
                    if (treeNode2 == null) {
                        treeNode3 = this.first;
                        treeNode4 = new TreeNode(i, obj, obj2, treeNode3, treeNode5);
                        this.first = treeNode4;
                        if (treeNode3 != null) {
                            treeNode3.prev = treeNode4;
                        }
                        if (i2 <= 0) {
                            treeNode5.left = treeNode4;
                        } else {
                            treeNode5.right = treeNode4;
                        }
                        if (!treeNode5.red) {
                            treeNode4.red = true;
                        } else {
                            lockRoot();
                            try {
                                this.root = balanceInsertion(this.root, treeNode4);
                            } finally {
                                unlockRoot();
                            }
                        }
                        return null;
                    }
                    treeNode5 = treeNode2;
                }
                i2 = iTieBreakOrder;
                if (i2 <= 0) {
                    treeNode2 = treeNode5.left;
                } else {
                    treeNode2 = treeNode5.right;
                }
                if (treeNode2 == null) {
                    treeNode3 = this.first;
                    treeNode4 = new TreeNode(i, obj, obj2, treeNode3, treeNode5);
                    this.first = treeNode4;
                    if (treeNode3 != null) {
                        treeNode3.prev = treeNode4;
                    }
                    if (i2 <= 0) {
                        treeNode5.left = treeNode4;
                    } else {
                        treeNode5.right = treeNode4;
                    }
                    if (!treeNode5.red) {
                        treeNode4.red = true;
                    } else {
                        lockRoot();
                        this.root = balanceInsertion(this.root, treeNode4);
                    }
                    return null;
                }
                treeNode5 = treeNode2;
            }
            TreeNode treeNode7 = new TreeNode(i, obj, obj2, null, null);
            this.root = treeNode7;
            this.first = treeNode7;
            return null;
        }

        final boolean removeTreeNode(TreeNode treeNode) {
            TreeNode treeNode2;
            TreeNode treeNode3;
            TreeNode treeNode4 = (TreeNode) treeNode.next;
            TreeNode treeNode5 = treeNode.prev;
            if (treeNode5 == null) {
                this.first = treeNode4;
            } else {
                treeNode5.next = treeNode4;
            }
            if (treeNode4 != null) {
                treeNode4.prev = treeNode5;
            }
            if (this.first == null) {
                this.root = null;
                return true;
            }
            TreeNode treeNodeBalanceDeletion = this.root;
            if (treeNodeBalanceDeletion == null || treeNodeBalanceDeletion.right == null || (treeNode2 = treeNodeBalanceDeletion.left) == null || treeNode2.left == null) {
                return true;
            }
            lockRoot();
            try {
                TreeNode treeNode6 = treeNode.left;
                TreeNode treeNode7 = treeNode.right;
                if (treeNode6 != null && treeNode7 != null) {
                    TreeNode treeNode8 = treeNode7;
                    while (true) {
                        TreeNode treeNode9 = treeNode8.left;
                        if (treeNode9 == null) {
                            break;
                        }
                        treeNode8 = treeNode9;
                    }
                    boolean z = treeNode8.red;
                    treeNode8.red = treeNode.red;
                    treeNode.red = z;
                    TreeNode treeNode10 = treeNode8.right;
                    TreeNode treeNode11 = treeNode.parent;
                    if (treeNode8 == treeNode7) {
                        treeNode.parent = treeNode8;
                        treeNode8.right = treeNode;
                    } else {
                        TreeNode treeNode12 = treeNode8.parent;
                        treeNode.parent = treeNode12;
                        if (treeNode12 != null) {
                            if (treeNode8 == treeNode12.left) {
                                treeNode12.left = treeNode;
                            } else {
                                treeNode12.right = treeNode;
                            }
                        }
                        treeNode8.right = treeNode7;
                        treeNode7.parent = treeNode8;
                    }
                    treeNode.left = null;
                    treeNode.right = treeNode10;
                    if (treeNode10 != null) {
                        treeNode10.parent = treeNode;
                    }
                    treeNode8.left = treeNode6;
                    treeNode6.parent = treeNode8;
                    treeNode8.parent = treeNode11;
                    if (treeNode11 == null) {
                        treeNodeBalanceDeletion = treeNode8;
                    } else if (treeNode == treeNode11.left) {
                        treeNode11.left = treeNode8;
                    } else {
                        treeNode11.right = treeNode8;
                    }
                    if (treeNode10 != null) {
                        treeNode6 = treeNode10;
                    } else {
                        treeNode6 = treeNode;
                    }
                } else if (treeNode6 == null) {
                    if (treeNode7 != null) {
                        treeNode6 = treeNode7;
                    } else {
                        treeNode6 = treeNode;
                    }
                }
                if (treeNode6 != treeNode) {
                    TreeNode treeNode13 = treeNode.parent;
                    treeNode6.parent = treeNode13;
                    if (treeNode13 == null) {
                        treeNodeBalanceDeletion = treeNode6;
                    } else if (treeNode == treeNode13.left) {
                        treeNode13.left = treeNode6;
                    } else {
                        treeNode13.right = treeNode6;
                    }
                    treeNode.parent = null;
                    treeNode.right = null;
                    treeNode.left = null;
                }
                if (!treeNode.red) {
                    treeNodeBalanceDeletion = balanceDeletion(treeNodeBalanceDeletion, treeNode6);
                }
                this.root = treeNodeBalanceDeletion;
                if (treeNode == treeNode6 && (treeNode3 = treeNode.parent) != null) {
                    if (treeNode == treeNode3.left) {
                        treeNode3.left = null;
                    } else if (treeNode == treeNode3.right) {
                        treeNode3.right = null;
                    }
                    treeNode.parent = null;
                }
                return false;
            } finally {
                unlockRoot();
            }
        }

        static TreeNode rotateLeft(TreeNode treeNode, TreeNode treeNode2) {
            TreeNode treeNode3;
            if (treeNode2 != null && (treeNode3 = treeNode2.right) != null) {
                TreeNode treeNode4 = treeNode3.left;
                treeNode2.right = treeNode4;
                if (treeNode4 != null) {
                    treeNode4.parent = treeNode2;
                }
                TreeNode treeNode5 = treeNode2.parent;
                treeNode3.parent = treeNode5;
                if (treeNode5 == null) {
                    treeNode3.red = false;
                    treeNode = treeNode3;
                } else if (treeNode5.left == treeNode2) {
                    treeNode5.left = treeNode3;
                } else {
                    treeNode5.right = treeNode3;
                }
                treeNode3.left = treeNode2;
                treeNode2.parent = treeNode3;
            }
            return treeNode;
        }

        static TreeNode rotateRight(TreeNode treeNode, TreeNode treeNode2) {
            TreeNode treeNode3;
            if (treeNode2 != null && (treeNode3 = treeNode2.left) != null) {
                TreeNode treeNode4 = treeNode3.right;
                treeNode2.left = treeNode4;
                if (treeNode4 != null) {
                    treeNode4.parent = treeNode2;
                }
                TreeNode treeNode5 = treeNode2.parent;
                treeNode3.parent = treeNode5;
                if (treeNode5 == null) {
                    treeNode3.red = false;
                    treeNode = treeNode3;
                } else if (treeNode5.right == treeNode2) {
                    treeNode5.right = treeNode3;
                } else {
                    treeNode5.left = treeNode3;
                }
                treeNode3.right = treeNode2;
                treeNode2.parent = treeNode3;
            }
            return treeNode;
        }

        static TreeNode balanceInsertion(TreeNode treeNode, TreeNode treeNode2) {
            TreeNode treeNode3;
            treeNode2.red = true;
            while (true) {
                TreeNode treeNode4 = treeNode2.parent;
                if (treeNode4 == null) {
                    treeNode2.red = false;
                    return treeNode2;
                }
                if (!treeNode4.red || (treeNode3 = treeNode4.parent) == null) {
                    return treeNode;
                }
                TreeNode treeNode5 = treeNode3.left;
                if (treeNode4 == treeNode5) {
                    TreeNode treeNode6 = treeNode3.right;
                    if (treeNode6 != null && treeNode6.red) {
                        treeNode6.red = false;
                        treeNode4.red = false;
                        treeNode3.red = true;
                        treeNode2 = treeNode3;
                    } else {
                        if (treeNode2 == treeNode4.right) {
                            treeNode = rotateLeft(treeNode, treeNode4);
                            TreeNode treeNode7 = treeNode4.parent;
                            treeNode3 = treeNode7 == null ? null : treeNode7.parent;
                            treeNode4 = treeNode7;
                            treeNode2 = treeNode4;
                        }
                        if (treeNode4 != null) {
                            treeNode4.red = false;
                            if (treeNode3 != null) {
                                treeNode3.red = true;
                                treeNode = rotateRight(treeNode, treeNode3);
                            }
                        }
                    }
                } else if (treeNode5 != null && treeNode5.red) {
                    treeNode5.red = false;
                    treeNode4.red = false;
                    treeNode3.red = true;
                    treeNode2 = treeNode3;
                } else {
                    if (treeNode2 == treeNode4.left) {
                        treeNode = rotateRight(treeNode, treeNode4);
                        TreeNode treeNode8 = treeNode4.parent;
                        treeNode3 = treeNode8 == null ? null : treeNode8.parent;
                        treeNode4 = treeNode8;
                        treeNode2 = treeNode4;
                    }
                    if (treeNode4 != null) {
                        treeNode4.red = false;
                        if (treeNode3 != null) {
                            treeNode3.red = true;
                            treeNode = rotateLeft(treeNode, treeNode3);
                        }
                    }
                }
            }
        }

        static TreeNode balanceDeletion(TreeNode treeNode, TreeNode treeNode2) {
            while (treeNode2 != null && treeNode2 != treeNode) {
                TreeNode treeNode3 = treeNode2.parent;
                if (treeNode3 == null) {
                    treeNode2.red = false;
                    return treeNode2;
                }
                if (treeNode2.red) {
                    treeNode2.red = false;
                    return treeNode;
                }
                TreeNode treeNode4 = treeNode3.left;
                if (treeNode4 == treeNode2) {
                    TreeNode treeNode5 = treeNode3.right;
                    if (treeNode5 != null && treeNode5.red) {
                        treeNode5.red = false;
                        treeNode3.red = true;
                        treeNode = rotateLeft(treeNode, treeNode3);
                        treeNode3 = treeNode2.parent;
                        treeNode5 = treeNode3 == null ? null : treeNode3.right;
                    }
                    if (treeNode5 != null) {
                        TreeNode treeNode6 = treeNode5.left;
                        TreeNode treeNode7 = treeNode5.right;
                        if ((treeNode7 == null || !treeNode7.red) && (treeNode6 == null || !treeNode6.red)) {
                            treeNode5.red = true;
                        } else {
                            if (treeNode7 == null || !treeNode7.red) {
                                if (treeNode6 != null) {
                                    treeNode6.red = false;
                                }
                                treeNode5.red = true;
                                treeNode = rotateRight(treeNode, treeNode5);
                                treeNode3 = treeNode2.parent;
                                treeNode5 = treeNode3 != null ? treeNode3.right : null;
                            }
                            if (treeNode5 != null) {
                                treeNode5.red = treeNode3 == null ? false : treeNode3.red;
                                TreeNode treeNode8 = treeNode5.right;
                                if (treeNode8 != null) {
                                    treeNode8.red = false;
                                }
                            }
                            if (treeNode3 != null) {
                                treeNode3.red = false;
                                treeNode = rotateLeft(treeNode, treeNode3);
                            }
                            treeNode2 = treeNode;
                        }
                    }
                    treeNode2 = treeNode3;
                } else {
                    if (treeNode4 != null && treeNode4.red) {
                        treeNode4.red = false;
                        treeNode3.red = true;
                        treeNode = rotateRight(treeNode, treeNode3);
                        treeNode3 = treeNode2.parent;
                        treeNode4 = treeNode3 == null ? null : treeNode3.left;
                    }
                    if (treeNode4 != null) {
                        TreeNode treeNode9 = treeNode4.left;
                        TreeNode treeNode10 = treeNode4.right;
                        if ((treeNode9 == null || !treeNode9.red) && (treeNode10 == null || !treeNode10.red)) {
                            treeNode4.red = true;
                        } else {
                            if (treeNode9 == null || !treeNode9.red) {
                                if (treeNode10 != null) {
                                    treeNode10.red = false;
                                }
                                treeNode4.red = true;
                                treeNode = rotateLeft(treeNode, treeNode4);
                                treeNode3 = treeNode2.parent;
                                treeNode4 = treeNode3 != null ? treeNode3.left : null;
                            }
                            if (treeNode4 != null) {
                                treeNode4.red = treeNode3 == null ? false : treeNode3.red;
                                TreeNode treeNode11 = treeNode4.left;
                                if (treeNode11 != null) {
                                    treeNode11.red = false;
                                }
                            }
                            if (treeNode3 != null) {
                                treeNode3.red = false;
                                treeNode = rotateRight(treeNode, treeNode3);
                            }
                            treeNode2 = treeNode;
                        }
                    }
                    treeNode2 = treeNode3;
                }
            }
            return treeNode;
        }

        static {
            DesugarUnsafe unsafe = DesugarUnsafe.getUnsafe();
            f1382U = unsafe;
            LOCKSTATE = unsafe.objectFieldOffset(TreeBin.class, "lockState");
        }
    }

    static final class TableStack {
        int index;
        int length;
        TableStack next;
        Node[] tab;

        TableStack() {
        }
    }

    static class Traverser {
        int baseIndex;
        int baseLimit;
        final int baseSize;
        int index;
        Node next = null;
        TableStack spare;
        TableStack stack;
        Node[] tab;

        Traverser(Node[] nodeArr, int i, int i2, int i3) {
            this.tab = nodeArr;
            this.baseSize = i;
            this.index = i2;
            this.baseIndex = i2;
            this.baseLimit = i3;
        }

        final Node advance() {
            Node[] nodeArr;
            int length;
            int i;
            int i2;
            Node node = this.next;
            if (node != null) {
                node = node.next;
            }
            while (node == null) {
                if (this.baseIndex >= this.baseLimit || (nodeArr = this.tab) == null || (length = nodeArr.length) <= (i = this.index) || i < 0) {
                    this.next = null;
                    return null;
                }
                Node nodeTabAt = ConcurrentHashMap.tabAt(nodeArr, i);
                if (nodeTabAt != null && nodeTabAt.hash < 0) {
                    if (nodeTabAt instanceof ForwardingNode) {
                        this.tab = ((ForwardingNode) nodeTabAt).nextTable;
                        pushState(nodeArr, i, length);
                        node = null;
                    } else {
                        node = nodeTabAt instanceof TreeBin ? ((TreeBin) nodeTabAt).first : null;
                        if (this.stack != null) {
                            recoverState(length);
                        } else {
                            i2 = i + this.baseSize;
                            this.index = i2;
                            if (i2 >= length) {
                                int i3 = this.baseIndex + 1;
                                this.baseIndex = i3;
                                this.index = i3;
                            }
                        }
                    }
                } else {
                    node = nodeTabAt;
                    if (this.stack != null) {
                        recoverState(length);
                    } else {
                        i2 = i + this.baseSize;
                        this.index = i2;
                        if (i2 >= length) {
                            int i4 = this.baseIndex + 1;
                            this.baseIndex = i4;
                            this.index = i4;
                        }
                    }
                }
            }
            this.next = node;
            return node;
        }

        private void pushState(Node[] nodeArr, int i, int i2) {
            TableStack tableStack = this.spare;
            if (tableStack != null) {
                this.spare = tableStack.next;
            } else {
                tableStack = new TableStack();
            }
            tableStack.tab = nodeArr;
            tableStack.length = i2;
            tableStack.index = i;
            tableStack.next = this.stack;
            this.stack = tableStack;
        }

        private void recoverState(int i) {
            TableStack tableStack;
            while (true) {
                tableStack = this.stack;
                if (tableStack == null) {
                    break;
                }
                int i2 = this.index;
                int i3 = tableStack.length;
                int i4 = i2 + i3;
                this.index = i4;
                if (i4 < i) {
                    break;
                }
                this.index = tableStack.index;
                this.tab = tableStack.tab;
                tableStack.tab = null;
                TableStack tableStack2 = tableStack.next;
                tableStack.next = this.spare;
                this.stack = tableStack2;
                this.spare = tableStack;
                i = i3;
            }
            if (tableStack == null) {
                int i5 = this.index + this.baseSize;
                this.index = i5;
                if (i5 >= i) {
                    int i6 = this.baseIndex + 1;
                    this.baseIndex = i6;
                    this.index = i6;
                }
            }
        }
    }

    static class BaseIterator extends Traverser {
        Node lastReturned;
        final ConcurrentHashMap map;

        BaseIterator(Node[] nodeArr, int i, int i2, int i3, ConcurrentHashMap concurrentHashMap) {
            super(nodeArr, i, i2, i3);
            this.map = concurrentHashMap;
            advance();
        }

        public final boolean hasNext() {
            return this.next != null;
        }

        public final boolean hasMoreElements() {
            return this.next != null;
        }

        public final void remove() {
            Node node = this.lastReturned;
            if (node == null) {
                throw new IllegalStateException();
            }
            this.lastReturned = null;
            this.map.replaceNode(node.key, null, null);
        }
    }

    static final class KeyIterator extends BaseIterator implements Iterator, Enumeration {
        KeyIterator(Node[] nodeArr, int i, int i2, int i3, ConcurrentHashMap concurrentHashMap) {
            super(nodeArr, i, i2, i3, concurrentHashMap);
        }

        @Override
        public final Object next() {
            Node node = this.next;
            if (node == null) {
                throw new NoSuchElementException();
            }
            Object obj = node.key;
            this.lastReturned = node;
            advance();
            return obj;
        }

        @Override
        public final Object nextElement() {
            return next();
        }
    }

    static final class ValueIterator extends BaseIterator implements Iterator, Enumeration {
        ValueIterator(Node[] nodeArr, int i, int i2, int i3, ConcurrentHashMap concurrentHashMap) {
            super(nodeArr, i, i2, i3, concurrentHashMap);
        }

        @Override
        public final Object next() {
            Node node = this.next;
            if (node == null) {
                throw new NoSuchElementException();
            }
            Object obj = node.val;
            this.lastReturned = node;
            advance();
            return obj;
        }

        @Override
        public final Object nextElement() {
            return next();
        }
    }

    static final class EntryIterator extends BaseIterator implements Iterator {
        EntryIterator(Node[] nodeArr, int i, int i2, int i3, ConcurrentHashMap concurrentHashMap) {
            super(nodeArr, i, i2, i3, concurrentHashMap);
        }

        @Override
        public final Map.Entry next() {
            Node node = this.next;
            if (node == null) {
                throw new NoSuchElementException();
            }
            Object obj = node.key;
            Object obj2 = node.val;
            this.lastReturned = node;
            advance();
            return new MapEntry(obj, obj2, this.map);
        }
    }

    static final class MapEntry implements Map.Entry {
        final Object key;
        final ConcurrentHashMap map;
        Object val;

        MapEntry(Object obj, Object obj2, ConcurrentHashMap concurrentHashMap) {
            this.key = obj;
            this.val = obj2;
            this.map = concurrentHashMap;
        }

        @Override
        public Object getKey() {
            return this.key;
        }

        @Override
        public Object getValue() {
            return this.val;
        }

        @Override
        public int hashCode() {
            return this.key.hashCode() ^ this.val.hashCode();
        }

        public String toString() {
            return Helpers.mapEntryToString(this.key, this.val);
        }

        @Override
        public boolean equals(Object obj) {
            Map.Entry entry;
            Object key;
            Object value;
            Object obj2;
            Object obj3;
            return (obj instanceof Map.Entry) && (key = (entry = (Map.Entry) obj).getKey()) != null && (value = entry.getValue()) != null && (key == (obj2 = this.key) || key.equals(obj2)) && (value == (obj3 = this.val) || value.equals(obj3));
        }

        @Override
        public Object setValue(Object obj) {
            obj.getClass();
            Object obj2 = this.val;
            this.val = obj;
            this.map.put(this.key, obj);
            return obj2;
        }
    }

    static final class KeySpliterator extends Traverser implements Spliterator {
        long est;

        @Override
        public int characteristics() {
            return 4353;
        }

        @Override
        public Comparator getComparator() {
            return Spliterator.CC.$default$getComparator(this);
        }

        @Override
        public long getExactSizeIfKnown() {
            return Spliterator.CC.$default$getExactSizeIfKnown(this);
        }

        @Override
        public boolean hasCharacteristics(int i) {
            return Spliterator.CC.$default$hasCharacteristics(this, i);
        }

        KeySpliterator(Node[] nodeArr, int i, int i2, int i3, long j) {
            super(nodeArr, i, i2, i3);
            this.est = j;
        }

        @Override
        public KeySpliterator trySplit() {
            int i = this.baseIndex;
            int i2 = this.baseLimit;
            int i3 = (i + i2) >>> 1;
            if (i3 <= i) {
                return null;
            }
            Node[] nodeArr = this.tab;
            int i4 = this.baseSize;
            this.baseLimit = i3;
            long j = this.est >>> 1;
            this.est = j;
            return new KeySpliterator(nodeArr, i4, i3, i2, j);
        }

        @Override
        public void forEachRemaining(Consumer consumer) {
            consumer.getClass();
            while (true) {
                Node nodeAdvance = advance();
                if (nodeAdvance == null) {
                    return;
                } else {
                    consumer.accept(nodeAdvance.key);
                }
            }
        }

        @Override
        public boolean tryAdvance(Consumer consumer) {
            consumer.getClass();
            Node nodeAdvance = advance();
            if (nodeAdvance == null) {
                return false;
            }
            consumer.accept(nodeAdvance.key);
            return true;
        }

        @Override
        public long estimateSize() {
            return this.est;
        }
    }

    static final class ValueSpliterator extends Traverser implements Spliterator {
        long est;

        @Override
        public int characteristics() {
            return 4352;
        }

        @Override
        public Comparator getComparator() {
            return Spliterator.CC.$default$getComparator(this);
        }

        @Override
        public long getExactSizeIfKnown() {
            return Spliterator.CC.$default$getExactSizeIfKnown(this);
        }

        @Override
        public boolean hasCharacteristics(int i) {
            return Spliterator.CC.$default$hasCharacteristics(this, i);
        }

        ValueSpliterator(Node[] nodeArr, int i, int i2, int i3, long j) {
            super(nodeArr, i, i2, i3);
            this.est = j;
        }

        @Override
        public ValueSpliterator trySplit() {
            int i = this.baseIndex;
            int i2 = this.baseLimit;
            int i3 = (i + i2) >>> 1;
            if (i3 <= i) {
                return null;
            }
            Node[] nodeArr = this.tab;
            int i4 = this.baseSize;
            this.baseLimit = i3;
            long j = this.est >>> 1;
            this.est = j;
            return new ValueSpliterator(nodeArr, i4, i3, i2, j);
        }

        @Override
        public void forEachRemaining(Consumer consumer) {
            consumer.getClass();
            while (true) {
                Node nodeAdvance = advance();
                if (nodeAdvance == null) {
                    return;
                } else {
                    consumer.accept(nodeAdvance.val);
                }
            }
        }

        @Override
        public boolean tryAdvance(Consumer consumer) {
            consumer.getClass();
            Node nodeAdvance = advance();
            if (nodeAdvance == null) {
                return false;
            }
            consumer.accept(nodeAdvance.val);
            return true;
        }

        @Override
        public long estimateSize() {
            return this.est;
        }
    }

    static final class EntrySpliterator extends Traverser implements Spliterator {
        long est;
        final ConcurrentHashMap map;

        @Override
        public int characteristics() {
            return 4353;
        }

        @Override
        public Comparator getComparator() {
            return Spliterator.CC.$default$getComparator(this);
        }

        @Override
        public long getExactSizeIfKnown() {
            return Spliterator.CC.$default$getExactSizeIfKnown(this);
        }

        @Override
        public boolean hasCharacteristics(int i) {
            return Spliterator.CC.$default$hasCharacteristics(this, i);
        }

        EntrySpliterator(Node[] nodeArr, int i, int i2, int i3, long j, ConcurrentHashMap concurrentHashMap) {
            super(nodeArr, i, i2, i3);
            this.map = concurrentHashMap;
            this.est = j;
        }

        @Override
        public EntrySpliterator trySplit() {
            int i = this.baseIndex;
            int i2 = this.baseLimit;
            int i3 = (i + i2) >>> 1;
            if (i3 <= i) {
                return null;
            }
            Node[] nodeArr = this.tab;
            int i4 = this.baseSize;
            this.baseLimit = i3;
            long j = this.est >>> 1;
            this.est = j;
            return new EntrySpliterator(nodeArr, i4, i3, i2, j, this.map);
        }

        @Override
        public void forEachRemaining(Consumer consumer) {
            consumer.getClass();
            while (true) {
                Node nodeAdvance = advance();
                if (nodeAdvance == null) {
                    return;
                } else {
                    consumer.accept(new MapEntry(nodeAdvance.key, nodeAdvance.val, this.map));
                }
            }
        }

        @Override
        public boolean tryAdvance(Consumer consumer) {
            consumer.getClass();
            Node nodeAdvance = advance();
            if (nodeAdvance == null) {
                return false;
            }
            consumer.accept(new MapEntry(nodeAdvance.key, nodeAdvance.val, this.map));
            return true;
        }

        @Override
        public long estimateSize() {
            return this.est;
        }
    }

    static abstract class CollectionView implements Collection, Serializable {
        private static final long serialVersionUID = 7249069246763182397L;
        final ConcurrentHashMap map;

        @Override
        public abstract boolean contains(Object obj);

        @Override
        public abstract Iterator iterator();

        @Override
        public abstract boolean remove(Object obj);

        CollectionView(ConcurrentHashMap concurrentHashMap) {
            this.map = concurrentHashMap;
        }

        @Override
        public final void clear() {
            this.map.clear();
        }

        @Override
        public final int size() {
            return this.map.size();
        }

        @Override
        public final boolean isEmpty() {
            return this.map.isEmpty();
        }

        @Override
        public final Object[] toArray() {
            long jMappingCount = this.map.mappingCount();
            if (jMappingCount > 2147483639) {
                throw new OutOfMemoryError("Required array size too large");
            }
            int i = (int) jMappingCount;
            Object[] objArrCopyOf = new Object[i];
            int i2 = 0;
            for (Object obj : this) {
                if (i2 == i) {
                    if (i >= 2147483639) {
                        throw new OutOfMemoryError("Required array size too large");
                    }
                    int i3 = i < 1073741819 ? (i >>> 1) + 1 + i : 2147483639;
                    objArrCopyOf = Arrays.copyOf(objArrCopyOf, i3);
                    i = i3;
                }
                objArrCopyOf[i2] = obj;
                i2++;
            }
            return i2 == i ? objArrCopyOf : Arrays.copyOf(objArrCopyOf, i2);
        }

        @Override
        public final Object[] toArray(Object[] objArr) {
            long jMappingCount = this.map.mappingCount();
            if (jMappingCount > 2147483639) {
                throw new OutOfMemoryError("Required array size too large");
            }
            int i = (int) jMappingCount;
            Object[] objArrCopyOf = objArr.length >= i ? objArr : (Object[]) Array.newInstance(objArr.getClass().getComponentType(), i);
            int length = objArrCopyOf.length;
            int i2 = 0;
            for (Object obj : this) {
                if (i2 == length) {
                    if (length >= 2147483639) {
                        throw new OutOfMemoryError("Required array size too large");
                    }
                    int i3 = length < 1073741819 ? (length >>> 1) + 1 + length : 2147483639;
                    objArrCopyOf = Arrays.copyOf(objArrCopyOf, i3);
                    length = i3;
                }
                objArrCopyOf[i2] = obj;
                i2++;
            }
            if (objArr != objArrCopyOf || i2 >= length) {
                return i2 == length ? objArrCopyOf : Arrays.copyOf(objArrCopyOf, i2);
            }
            objArrCopyOf[i2] = null;
            return objArrCopyOf;
        }

        public final String toString() {
            StringBuilder sb = new StringBuilder();
            sb.append('[');
            Iterator it = iterator();
            if (it.hasNext()) {
                while (true) {
                    Object next = it.next();
                    if (next == this) {
                        next = "(this Collection)";
                    }
                    sb.append(next);
                    if (!it.hasNext()) {
                        break;
                    }
                    sb.append(',');
                    sb.append(' ');
                }
            }
            sb.append(']');
            return sb.toString();
        }

        @Override
        public final boolean containsAll(Collection collection) {
            if (collection == this) {
                return true;
            }
            for (Object obj : collection) {
                if (obj == null || !contains(obj)) {
                    return false;
                }
            }
            return true;
        }

        @Override
        public boolean removeAll(Collection collection) {
            collection.getClass();
            Node[] nodeArr = this.map.table;
            boolean zRemove = false;
            if (nodeArr == null) {
                return false;
            }
            if ((collection instanceof Set) && collection.size() > nodeArr.length) {
                Iterator it = iterator();
                while (it.hasNext()) {
                    if (collection.contains(it.next())) {
                        it.remove();
                        zRemove = true;
                    }
                }
            } else {
                Iterator it2 = collection.iterator();
                while (it2.hasNext()) {
                    zRemove |= remove(it2.next());
                }
            }
            return zRemove;
        }

        @Override
        public final boolean retainAll(Collection collection) {
            collection.getClass();
            Iterator it = iterator();
            boolean z = false;
            while (it.hasNext()) {
                if (!collection.contains(it.next())) {
                    it.remove();
                    z = true;
                }
            }
            return z;
        }
    }

    public static class KeySetView extends CollectionView implements Set, Serializable, p000j$.util.Set {
        private static final long serialVersionUID = 7249069246763182397L;
        private final Object value;

        @Override
        public Stream parallelStream() {
            return StreamSupport.stream(p000j$.util.Collection.EL.spliterator(this), true);
        }

        @Override
        public java.util.stream.Stream parallelStream() {
            return Stream.Wrapper.convert(parallelStream());
        }

        @Override
        public boolean removeIf(Predicate predicate) {
            return p000j$.util.Collection.CC.$default$removeIf(this, predicate);
        }

        @Override
        public java.util.Spliterator spliterator() {
            return Spliterator.Wrapper.convert(spliterator());
        }

        @Override
        public Stream stream() {
            return p000j$.util.Collection.CC.$default$stream(this);
        }

        @Override
        public java.util.stream.Stream stream() {
            return Stream.Wrapper.convert(stream());
        }

        @Override
        public Object[] toArray(IntFunction intFunction) {
            return toArray((Object[]) intFunction.apply(0));
        }

        @Override
        public boolean removeAll(Collection collection) {
            return super.removeAll(collection);
        }

        KeySetView(ConcurrentHashMap concurrentHashMap, Object obj) {
            super(concurrentHashMap);
            this.value = obj;
        }

        @Override
        public boolean contains(Object obj) {
            return this.map.containsKey(obj);
        }

        @Override
        public boolean remove(Object obj) {
            return this.map.remove(obj) != null;
        }

        @Override
        public Iterator iterator() {
            ConcurrentHashMap concurrentHashMap = this.map;
            Node[] nodeArr = concurrentHashMap.table;
            int length = nodeArr == null ? 0 : nodeArr.length;
            return new KeyIterator(nodeArr, length, 0, length, concurrentHashMap);
        }

        @Override
        public boolean add(Object obj) {
            Object obj2 = this.value;
            if (obj2 != null) {
                return this.map.putVal(obj, obj2, true) == null;
            }
            throw new UnsupportedOperationException();
        }

        @Override
        public boolean addAll(Collection collection) {
            Object obj = this.value;
            if (obj == null) {
                throw new UnsupportedOperationException();
            }
            Iterator it = collection.iterator();
            boolean z = false;
            while (it.hasNext()) {
                if (this.map.putVal(it.next(), obj, true) == null) {
                    z = true;
                }
            }
            return z;
        }

        @Override
        public int hashCode() {
            Iterator it = iterator();
            int iHashCode = 0;
            while (it.hasNext()) {
                iHashCode += it.next().hashCode();
            }
            return iHashCode;
        }

        @Override
        public boolean equals(Object obj) {
            Set set;
            return (obj instanceof Set) && ((set = (Set) obj) == this || (containsAll(set) && set.containsAll(this)));
        }

        @Override
        public Spliterator spliterator() {
            ConcurrentHashMap concurrentHashMap = this.map;
            long jSumCount = concurrentHashMap.sumCount();
            Node[] nodeArr = concurrentHashMap.table;
            int length = nodeArr == null ? 0 : nodeArr.length;
            return new KeySpliterator(nodeArr, length, 0, length, jSumCount < 0 ? 0L : jSumCount);
        }

        @Override
        public void forEach(Consumer consumer) {
            consumer.getClass();
            Node[] nodeArr = this.map.table;
            if (nodeArr == null) {
                return;
            }
            Traverser traverser = new Traverser(nodeArr, nodeArr.length, 0, nodeArr.length);
            while (true) {
                Node nodeAdvance = traverser.advance();
                if (nodeAdvance == null) {
                    return;
                } else {
                    consumer.accept(nodeAdvance.key);
                }
            }
        }
    }

    static final class ValuesView extends CollectionView implements Collection, Serializable, p000j$.util.Collection {
        private static final long serialVersionUID = 2249069246763182397L;

        @Override
        public Stream parallelStream() {
            return StreamSupport.stream(p000j$.util.Collection.EL.spliterator(this), true);
        }

        @Override
        public java.util.stream.Stream parallelStream() {
            return Stream.Wrapper.convert(parallelStream());
        }

        @Override
        public java.util.Spliterator spliterator() {
            return Spliterator.Wrapper.convert(spliterator());
        }

        @Override
        public Stream stream() {
            return p000j$.util.Collection.CC.$default$stream(this);
        }

        @Override
        public java.util.stream.Stream stream() {
            return Stream.Wrapper.convert(stream());
        }

        @Override
        public Object[] toArray(IntFunction intFunction) {
            return toArray((Object[]) intFunction.apply(0));
        }

        ValuesView(ConcurrentHashMap concurrentHashMap) {
            super(concurrentHashMap);
        }

        @Override
        public final boolean contains(Object obj) {
            return this.map.containsValue(obj);
        }

        @Override
        public final boolean remove(Object obj) {
            if (obj == null) {
                return false;
            }
            Iterator it = iterator();
            while (it.hasNext()) {
                if (obj.equals(it.next())) {
                    it.remove();
                    return true;
                }
            }
            return false;
        }

        @Override
        public final Iterator iterator() {
            ConcurrentHashMap concurrentHashMap = this.map;
            Node[] nodeArr = concurrentHashMap.table;
            int length = nodeArr == null ? 0 : nodeArr.length;
            return new ValueIterator(nodeArr, length, 0, length, concurrentHashMap);
        }

        @Override
        public final boolean add(Object obj) {
            throw new UnsupportedOperationException();
        }

        @Override
        public final boolean addAll(Collection collection) {
            throw new UnsupportedOperationException();
        }

        @Override
        public boolean removeAll(Collection collection) {
            collection.getClass();
            Iterator it = iterator();
            boolean z = false;
            while (it.hasNext()) {
                if (collection.contains(it.next())) {
                    it.remove();
                    z = true;
                }
            }
            return z;
        }

        @Override
        public boolean removeIf(Predicate predicate) {
            return this.map.removeValueIf(predicate);
        }

        @Override
        public Spliterator spliterator() {
            ConcurrentHashMap concurrentHashMap = this.map;
            long jSumCount = concurrentHashMap.sumCount();
            Node[] nodeArr = concurrentHashMap.table;
            int length = nodeArr == null ? 0 : nodeArr.length;
            return new ValueSpliterator(nodeArr, length, 0, length, jSumCount < 0 ? 0L : jSumCount);
        }

        @Override
        public void forEach(Consumer consumer) {
            consumer.getClass();
            Node[] nodeArr = this.map.table;
            if (nodeArr == null) {
                return;
            }
            Traverser traverser = new Traverser(nodeArr, nodeArr.length, 0, nodeArr.length);
            while (true) {
                Node nodeAdvance = traverser.advance();
                if (nodeAdvance == null) {
                    return;
                } else {
                    consumer.accept(nodeAdvance.val);
                }
            }
        }
    }

    static final class EntrySetView extends CollectionView implements Set, Serializable, p000j$.util.Set {
        private static final long serialVersionUID = 2249069246763182397L;

        @Override
        public Stream parallelStream() {
            return StreamSupport.stream(p000j$.util.Collection.EL.spliterator(this), true);
        }

        @Override
        public java.util.stream.Stream parallelStream() {
            return Stream.Wrapper.convert(parallelStream());
        }

        @Override
        public java.util.Spliterator spliterator() {
            return Spliterator.Wrapper.convert(spliterator());
        }

        @Override
        public Stream stream() {
            return p000j$.util.Collection.CC.$default$stream(this);
        }

        @Override
        public java.util.stream.Stream stream() {
            return Stream.Wrapper.convert(stream());
        }

        @Override
        public Object[] toArray(IntFunction intFunction) {
            return toArray((Object[]) intFunction.apply(0));
        }

        EntrySetView(ConcurrentHashMap concurrentHashMap) {
            super(concurrentHashMap);
        }

        @Override
        public boolean contains(Object obj) {
            Map.Entry entry;
            Object key;
            Object obj2;
            Object value;
            return (!(obj instanceof Map.Entry) || (key = (entry = (Map.Entry) obj).getKey()) == null || (obj2 = this.map.get(key)) == null || (value = entry.getValue()) == null || (value != obj2 && !value.equals(obj2))) ? false : true;
        }

        @Override
        public boolean remove(Object obj) {
            Map.Entry entry;
            Object key;
            Object value;
            return (obj instanceof Map.Entry) && (key = (entry = (Map.Entry) obj).getKey()) != null && (value = entry.getValue()) != null && this.map.remove(key, value);
        }

        @Override
        public Iterator iterator() {
            ConcurrentHashMap concurrentHashMap = this.map;
            Node[] nodeArr = concurrentHashMap.table;
            int length = nodeArr == null ? 0 : nodeArr.length;
            return new EntryIterator(nodeArr, length, 0, length, concurrentHashMap);
        }

        @Override
        public boolean add(Map.Entry entry) {
            return this.map.putVal(entry.getKey(), entry.getValue(), false) == null;
        }

        @Override
        public boolean addAll(Collection collection) {
            Iterator it = collection.iterator();
            boolean z = false;
            while (it.hasNext()) {
                if (add((Map.Entry) it.next())) {
                    z = true;
                }
            }
            return z;
        }

        @Override
        public boolean removeIf(Predicate predicate) {
            return this.map.removeEntryIf(predicate);
        }

        @Override
        public final int hashCode() {
            Node[] nodeArr = this.map.table;
            int iHashCode = 0;
            if (nodeArr != null) {
                Traverser traverser = new Traverser(nodeArr, nodeArr.length, 0, nodeArr.length);
                while (true) {
                    Node nodeAdvance = traverser.advance();
                    if (nodeAdvance == null) {
                        break;
                    }
                    iHashCode += nodeAdvance.hashCode();
                }
            }
            return iHashCode;
        }

        @Override
        public final boolean equals(Object obj) {
            Set set;
            return (obj instanceof Set) && ((set = (Set) obj) == this || (containsAll(set) && set.containsAll(this)));
        }

        @Override
        public Spliterator spliterator() {
            ConcurrentHashMap concurrentHashMap = this.map;
            long jSumCount = concurrentHashMap.sumCount();
            Node[] nodeArr = concurrentHashMap.table;
            int length = nodeArr == null ? 0 : nodeArr.length;
            return new EntrySpliterator(nodeArr, length, 0, length, jSumCount >= 0 ? jSumCount : 0L, concurrentHashMap);
        }

        @Override
        public void forEach(Consumer consumer) {
            consumer.getClass();
            Node[] nodeArr = this.map.table;
            if (nodeArr == null) {
                return;
            }
            Traverser traverser = new Traverser(nodeArr, nodeArr.length, 0, nodeArr.length);
            while (true) {
                Node nodeAdvance = traverser.advance();
                if (nodeAdvance == null) {
                    return;
                } else {
                    consumer.accept(new MapEntry(nodeAdvance.key, nodeAdvance.val, this.map));
                }
            }
        }
    }
}
