package p000j$.util.stream;

import java.util.Collection;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.function.BiConsumer;
import java.util.function.Consumer;
import java.util.function.IntFunction;
import java.util.function.Supplier;
import p000j$.util.Objects;
import p000j$.util.Spliterator;
import p000j$.util.concurrent.ConcurrentHashMap;
import p000j$.util.function.BiConsumer$CC;
import p000j$.util.function.Consumer$CC;

abstract class DistinctOps {

    class C05161 extends ReferencePipeline.StatefulOp {
        C05161(AbstractPipeline abstractPipeline, StreamShape streamShape, int i) {
            super(abstractPipeline, streamShape, i);
        }

        Node reduce(PipelineHelper pipelineHelper, Spliterator spliterator) {
            return Nodes.node((Collection) ReduceOps.makeRef(new Supplier() {
                @Override
                public final Object get() {
                    return new LinkedHashSet();
                }
            }, new BiConsumer() {
                @Override
                public final void accept(Object obj, Object obj2) {
                    ((LinkedHashSet) obj).add(obj2);
                }

                public BiConsumer andThen(BiConsumer biConsumer) {
                    return BiConsumer$CC.$default$andThen(this, biConsumer);
                }
            }, new BiConsumer() {
                @Override
                public final void accept(Object obj, Object obj2) {
                    ((LinkedHashSet) obj).addAll((LinkedHashSet) obj2);
                }

                public BiConsumer andThen(BiConsumer biConsumer) {
                    return BiConsumer$CC.$default$andThen(this, biConsumer);
                }
            }).evaluateParallel(pipelineHelper, spliterator));
        }

        @Override
        Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            if (StreamOpFlag.DISTINCT.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return pipelineHelper.evaluate(spliterator, false, intFunction);
            }
            if (StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return reduce(pipelineHelper, spliterator);
            }
            final AtomicBoolean atomicBoolean = new AtomicBoolean(false);
            final ConcurrentHashMap concurrentHashMap = new ConcurrentHashMap();
            ForEachOps.makeRef(new Consumer() {
                @Override
                public final void accept(Object obj) {
                    DistinctOps.C05161.lambda$opEvaluateParallel$0(atomicBoolean, concurrentHashMap, obj);
                }

                public Consumer andThen(Consumer consumer) {
                    return Consumer$CC.$default$andThen(this, consumer);
                }
            }, false).evaluateParallel(pipelineHelper, spliterator);
            Collection collectionKeySet = concurrentHashMap.keySet();
            if (atomicBoolean.get()) {
                HashSet hashSet = new HashSet(collectionKeySet);
                hashSet.add(null);
                collectionKeySet = hashSet;
            }
            return Nodes.node(collectionKeySet);
        }

        static void lambda$opEvaluateParallel$0(AtomicBoolean atomicBoolean, ConcurrentHashMap concurrentHashMap, Object obj) {
            if (obj == null) {
                atomicBoolean.set(true);
            } else {
                concurrentHashMap.putIfAbsent(obj, Boolean.TRUE);
            }
        }

        @Override
        Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
            if (StreamOpFlag.DISTINCT.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return pipelineHelper.wrapSpliterator(spliterator);
            }
            if (StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return reduce(pipelineHelper, spliterator).spliterator();
            }
            return new StreamSpliterators$DistinctSpliterator(pipelineHelper.wrapSpliterator(spliterator));
        }

        @Override
        Sink opWrapSink(int i, Sink sink) {
            Objects.requireNonNull(sink);
            if (StreamOpFlag.DISTINCT.isKnown(i)) {
                return sink;
            }
            if (StreamOpFlag.SORTED.isKnown(i)) {
                return new Sink.ChainedReference(sink) {
                    Object lastSeen;
                    boolean seenNull;

                    @Override
                    public void begin(long j) {
                        this.seenNull = false;
                        this.lastSeen = null;
                        this.downstream.begin(-1L);
                    }

                    @Override
                    public void end() {
                        this.seenNull = false;
                        this.lastSeen = null;
                        this.downstream.end();
                    }

                    @Override
                    public void accept(Object obj) {
                        if (obj == null) {
                            if (this.seenNull) {
                                return;
                            }
                            this.seenNull = true;
                            Sink sink2 = this.downstream;
                            this.lastSeen = null;
                            sink2.accept((Object) null);
                            return;
                        }
                        Object obj2 = this.lastSeen;
                        if (obj2 == null || !obj.equals(obj2)) {
                            Sink sink3 = this.downstream;
                            this.lastSeen = obj;
                            sink3.accept(obj);
                        }
                    }
                };
            }
            return new Sink.ChainedReference(sink) {
                Set seen;

                @Override
                public void begin(long j) {
                    this.seen = new HashSet();
                    this.downstream.begin(-1L);
                }

                @Override
                public void end() {
                    this.seen = null;
                    this.downstream.end();
                }

                @Override
                public void accept(Object obj) {
                    if (this.seen.contains(obj)) {
                        return;
                    }
                    this.seen.add(obj);
                    this.downstream.accept(obj);
                }
            };
        }
    }

    static ReferencePipeline makeRef(AbstractPipeline abstractPipeline) {
        return new C05161(abstractPipeline, StreamShape.REFERENCE, StreamOpFlag.IS_DISTINCT | StreamOpFlag.NOT_SIZED);
    }
}
