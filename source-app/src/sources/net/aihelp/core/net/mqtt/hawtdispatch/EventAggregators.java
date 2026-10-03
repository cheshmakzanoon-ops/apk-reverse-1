package net.aihelp.core.net.mqtt.hawtdispatch;

import java.util.HashSet;
import java.util.LinkedList;

public class EventAggregators {
    public static final EventAggregator<Integer, Integer> INTEGER_ADD = new EventAggregator<Integer, Integer>() {
        @Override
        public Integer mergeEvent(Integer num, Integer num2) {
            return num == null ? num2 : Integer.valueOf(num.intValue() + num2.intValue());
        }

        @Override
        public Integer mergeEvents(Integer num, Integer num2) {
            return Integer.valueOf(num.intValue() + num2.intValue());
        }
    };
    public static final EventAggregator<Long, Long> LONG_ADD = new EventAggregator<Long, Long>() {
        @Override
        public Long mergeEvent(Long l, Long l2) {
            return l == null ? l2 : Long.valueOf(l.longValue() + l2.longValue());
        }

        @Override
        public Long mergeEvents(Long l, Long l2) {
            return Long.valueOf(l.longValue() + l2.longValue());
        }
    };
    public static final EventAggregator<Integer, Integer> INTEGER_OR = new EventAggregator<Integer, Integer>() {
        @Override
        public Integer mergeEvent(Integer num, Integer num2) {
            return num == null ? num2 : Integer.valueOf(num.intValue() | num2.intValue());
        }

        @Override
        public Integer mergeEvents(Integer num, Integer num2) {
            return Integer.valueOf(num.intValue() | num2.intValue());
        }
    };
    public static final EventAggregator<Long, Long> LONG_OR = new EventAggregator<Long, Long>() {
        @Override
        public Long mergeEvent(Long l, Long l2) {
            if (l == null) {
                return l2;
            }
            return Long.valueOf(l2.longValue() | l.longValue());
        }

        @Override
        public Long mergeEvents(Long l, Long l2) {
            return Long.valueOf(l2.longValue() | l.longValue());
        }
    };

    public static <T> EventAggregator<T, LinkedList<T>> linkedList() {
        return new OrderedEventAggregator<T, LinkedList<T>>() {
            @Override
            public LinkedList<T> mergeEvent(LinkedList<T> linkedList, T t) {
                if (linkedList == null) {
                    linkedList = new LinkedList<>();
                }
                linkedList.add(t);
                return linkedList;
            }

            @Override
            public LinkedList<T> mergeEvents(LinkedList<T> linkedList, LinkedList<T> linkedList2) {
                linkedList.addAll(linkedList2);
                return linkedList;
            }
        };
    }

    public static <T> EventAggregator<T, HashSet<T>> hashSet() {
        return new EventAggregator<T, HashSet<T>>() {
            public boolean ordered() {
                return false;
            }

            @Override
            public HashSet<T> mergeEvent(HashSet<T> hashSet, T t) {
                if (hashSet == null) {
                    hashSet = new HashSet<>();
                }
                hashSet.add(t);
                return hashSet;
            }

            @Override
            public HashSet<T> mergeEvents(HashSet<T> hashSet, HashSet<T> hashSet2) {
                hashSet.addAll(hashSet2);
                return hashSet;
            }
        };
    }
}
