package androidx.lifecycle;

import androidx.arch.core.util.Function;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;

@Metadata(d1 = {"\u0000\u001c\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\u001e\u0010\u0000\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0001H\u0007\u001aB\u0010\u0003\u001a\b\u0012\u0004\u0012\u0002H\u00040\u0001\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0004*\b\u0012\u0004\u0012\u0002H\u00020\u00012\u001c\u0010\u0005\u001a\u0018\u0012\t\u0012\u0007H\u0002¢\u0006\u0002\b\u0007\u0012\t\u0012\u0007H\u0004¢\u0006\u0002\b\u00070\u0006H\u0007\u001a8\u0010\u0003\u001a\b\u0012\u0004\u0012\u0002H\u00040\u0001\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0004*\b\u0012\u0004\u0012\u0002H\u00020\u00012\u0012\u0010\b\u001a\u000e\u0012\u0004\u0012\u0002H\u0002\u0012\u0004\u0012\u0002H\u00040\tH\u0007\u001aJ\u0010\n\u001a\b\u0012\u0004\u0012\u0002H\u00040\u0001\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0004*\b\u0012\u0004\u0012\u0002H\u00020\u00012$\u0010\u0005\u001a \u0012\t\u0012\u0007H\u0002¢\u0006\u0002\b\u0007\u0012\u0011\u0012\u000f\u0012\u0004\u0012\u0002H\u0004\u0018\u00010\u0001¢\u0006\u0002\b\u00070\u0006H\u0007\u001a>\u0010\n\u001a\b\u0012\u0004\u0012\u0002H\u00040\u0001\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0004*\b\u0012\u0004\u0012\u0002H\u00020\u00012\u0018\u0010\u000b\u001a\u0014\u0012\u0004\u0012\u0002H\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00040\u00010\tH\u0007¨\u0006\f"}, d2 = {"distinctUntilChanged", "Landroidx/lifecycle/LiveData;", "X", "map", "Y", "transform", "Lkotlin/Function1;", "Lkotlin/jvm/JvmSuppressWildcards;", "mapFunction", "Landroidx/arch/core/util/Function;", "switchMap", "switchMapFunction", "lifecycle-livedata_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class Transformations {
    public static final <X, Y> LiveData<Y> map(LiveData<X> liveData, final Function1<X, Y> function1) {
        final MediatorLiveData mediatorLiveData;
        Intrinsics.checkNotNullParameter(liveData, "<this>");
        Intrinsics.checkNotNullParameter(function1, "transform");
        if (liveData.isInitialized()) {
            mediatorLiveData = new MediatorLiveData(function1.invoke(liveData.getValue()));
        } else {
            mediatorLiveData = new MediatorLiveData();
        }
        mediatorLiveData.addSource(liveData, new Transformations$sam$androidx_lifecycle_Observer$0(new Function1<X, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                m2229invoke(obj);
                return Unit.INSTANCE;
            }

            public final void m2229invoke(X x) {
                mediatorLiveData.setValue((Y) function1.invoke(x));
            }
        }));
        return mediatorLiveData;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Use kotlin functions, instead of outdated arch core Functions")
    public static final LiveData map(LiveData liveData, final Function function) {
        Intrinsics.checkNotNullParameter(liveData, "<this>");
        Intrinsics.checkNotNullParameter(function, "mapFunction");
        final MediatorLiveData mediatorLiveData = new MediatorLiveData();
        mediatorLiveData.addSource(liveData, new Transformations$sam$androidx_lifecycle_Observer$0(new Function1<X, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                m2230invoke(obj);
                return Unit.INSTANCE;
            }

            public final void m2230invoke(X x) {
                mediatorLiveData.setValue((Y) function.apply(x));
            }
        }));
        return mediatorLiveData;
    }

    public static final <X, Y> LiveData<Y> switchMap(LiveData<X> liveData, final Function1<X, LiveData<Y>> function1) {
        final MediatorLiveData mediatorLiveData;
        LiveData liveData2;
        Intrinsics.checkNotNullParameter(liveData, "<this>");
        Intrinsics.checkNotNullParameter(function1, "transform");
        final Ref.ObjectRef objectRef = new Ref.ObjectRef();
        if (liveData.isInitialized() && (liveData2 = (LiveData) function1.invoke(liveData.getValue())) != null && liveData2.isInitialized()) {
            mediatorLiveData = new MediatorLiveData(liveData2.getValue());
        } else {
            mediatorLiveData = new MediatorLiveData();
        }
        mediatorLiveData.addSource(liveData, new Transformations$sam$androidx_lifecycle_Observer$0(new Function1<X, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                m2231invoke(obj);
                return Unit.INSTANCE;
            }

            public final void m2231invoke(X x) {
                LiveData liveData3 = (LiveData) function1.invoke(x);
                if (objectRef.element != liveData3) {
                    if (objectRef.element != null) {
                        MediatorLiveData<Y> mediatorLiveData2 = mediatorLiveData;
                        Object obj = objectRef.element;
                        Intrinsics.checkNotNull(obj);
                        mediatorLiveData2.removeSource((LiveData<S>) ((LiveData) obj));
                    }
                    objectRef.element = liveData3;
                    if (objectRef.element != null) {
                        MediatorLiveData<Y> mediatorLiveData3 = mediatorLiveData;
                        Object obj2 = objectRef.element;
                        Intrinsics.checkNotNull(obj2);
                        final MediatorLiveData<Y> mediatorLiveData4 = mediatorLiveData;
                        mediatorLiveData3.addSource((LiveData<S>) ((LiveData) obj2), new Transformations$sam$androidx_lifecycle_Observer$0(new Function1<Y, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj3) {
                                m2232invoke(obj3);
                                return Unit.INSTANCE;
                            }

                            public final void m2232invoke(Y y) {
                                mediatorLiveData4.setValue(y);
                            }
                        }));
                    }
                }
            }
        }));
        return mediatorLiveData;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Use kotlin functions, instead of outdated arch core Functions")
    public static final LiveData switchMap(LiveData liveData, final Function function) {
        Intrinsics.checkNotNullParameter(liveData, "<this>");
        Intrinsics.checkNotNullParameter(function, "switchMapFunction");
        final MediatorLiveData mediatorLiveData = new MediatorLiveData();
        mediatorLiveData.addSource(liveData, new Observer<X>() {
            private LiveData<Y> liveData;

            public final LiveData<Y> getLiveData() {
                return this.liveData;
            }

            public final void setLiveData(LiveData<Y> liveData2) {
                this.liveData = liveData2;
            }

            @Override
            public void onChanged(X value) {
                LiveData<Y> liveData2 = (LiveData) function.apply(value);
                Object obj = this.liveData;
                if (obj == liveData2) {
                    return;
                }
                if (obj != null) {
                    MediatorLiveData<Y> mediatorLiveData2 = mediatorLiveData;
                    Intrinsics.checkNotNull(obj);
                    mediatorLiveData2.removeSource(obj);
                }
                this.liveData = liveData2;
                if (liveData2 != 0) {
                    MediatorLiveData<Y> mediatorLiveData3 = mediatorLiveData;
                    Intrinsics.checkNotNull(liveData2);
                    final MediatorLiveData<Y> mediatorLiveData4 = mediatorLiveData;
                    mediatorLiveData3.addSource(liveData2, new Transformations$sam$androidx_lifecycle_Observer$0(new Function1<Y, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj2) {
                            m2233invoke(obj2);
                            return Unit.INSTANCE;
                        }

                        public final void m2233invoke(Y y) {
                            mediatorLiveData4.setValue(y);
                        }
                    }));
                }
            }
        });
        return mediatorLiveData;
    }

    public static final <X> LiveData<X> distinctUntilChanged(LiveData<X> liveData) {
        final MediatorLiveData mediatorLiveData;
        Intrinsics.checkNotNullParameter(liveData, "<this>");
        final Ref.BooleanRef booleanRef = new Ref.BooleanRef();
        booleanRef.element = true;
        if (liveData.isInitialized()) {
            booleanRef.element = false;
            mediatorLiveData = new MediatorLiveData(liveData.getValue());
        } else {
            mediatorLiveData = new MediatorLiveData();
        }
        mediatorLiveData.addSource(liveData, new Transformations$sam$androidx_lifecycle_Observer$0(new Function1<X, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                m2228invoke(obj);
                return Unit.INSTANCE;
            }

            public final void m2228invoke(X x) {
                X value = mediatorLiveData.getValue();
                if (booleanRef.element || ((value == null && x != null) || !(value == null || Intrinsics.areEqual(value, x)))) {
                    booleanRef.element = false;
                    mediatorLiveData.setValue(x);
                }
            }
        }));
        return mediatorLiveData;
    }
}
