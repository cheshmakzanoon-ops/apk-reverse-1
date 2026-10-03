package androidx.fragment.app;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.lifecycle.HasDefaultViewModelProviderFactory;
import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelLazy;
import androidx.lifecycle.ViewModelProvider;
import androidx.lifecycle.ViewModelStore;
import androidx.lifecycle.ViewModelStoreOwner;
import androidx.lifecycle.viewmodel.CreationExtras;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.LazyThreadSafetyMode;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Lambda;
import kotlin.jvm.internal.Reflection;
import kotlin.reflect.KClass;

@Metadata(d1 = {"\u0000:\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a1\u0010\u0000\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003*\u00020\u00042\u0010\b\n\u0010\u0005\u001a\n\u0012\u0004\u0012\u00020\u0007\u0018\u00010\u0006H\u0087\b\u001aC\u0010\u0000\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003*\u00020\u00042\u0010\b\n\u0010\b\u001a\n\u0012\u0004\u0012\u00020\t\u0018\u00010\u00062\u0010\b\n\u0010\u0005\u001a\n\u0012\u0004\u0012\u00020\u0007\u0018\u00010\u0006H\u0087\b\u001aJ\u0010\n\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\b\b\u0000\u0010\u0002*\u00020\u0003*\u00020\u00042\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u0002H\u00020\f2\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u000e0\u00062\u0010\b\u0002\u0010\u0005\u001a\n\u0012\u0004\u0012\u00020\u0007\u0018\u00010\u0006H\u0007\u001aZ\u0010\n\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\b\b\u0000\u0010\u0002*\u00020\u0003*\u00020\u00042\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u0002H\u00020\f2\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u000e0\u00062\u000e\b\u0002\u0010\b\u001a\b\u0012\u0004\u0012\u00020\t0\u00062\u0010\b\u0002\u0010\u0005\u001a\n\u0012\u0004\u0012\u00020\u0007\u0018\u00010\u0006H\u0007\u001aA\u0010\u000f\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003*\u00020\u00042\u000e\b\n\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00110\u00062\u0010\b\n\u0010\u0005\u001a\n\u0012\u0004\u0012\u00020\u0007\u0018\u00010\u0006H\u0087\b\u001aS\u0010\u000f\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003*\u00020\u00042\u000e\b\n\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00110\u00062\u0010\b\n\u0010\b\u001a\n\u0012\u0004\u0012\u00020\t\u0018\u00010\u00062\u0010\b\n\u0010\u0005\u001a\n\u0012\u0004\u0012\u00020\u0007\u0018\u00010\u0006H\u0087\b¨\u0006\u0012²\u0006\u0016\u0010\u0013\u001a\u00020\u0011\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003X\u008a\u0084\u0002²\u0006\u0016\u0010\u0013\u001a\u00020\u0011\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003X\u008a\u0084\u0002"}, d2 = {"activityViewModels", "Lkotlin/Lazy;", "VM", "Landroidx/lifecycle/ViewModel;", "Landroidx/fragment/app/Fragment;", "factoryProducer", "Lkotlin/Function0;", "Landroidx/lifecycle/ViewModelProvider$Factory;", "extrasProducer", "Landroidx/lifecycle/viewmodel/CreationExtras;", "createViewModelLazy", "viewModelClass", "Lkotlin/reflect/KClass;", "storeProducer", "Landroidx/lifecycle/ViewModelStore;", "viewModels", "ownerProducer", "Landroidx/lifecycle/ViewModelStoreOwner;", "fragment-ktx_release", "owner"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class FragmentViewModelLazyKt {
    public static Lazy viewModels$default(final Fragment fragment, Function0 function0, Function0 function1, int i, Object obj) {
        if ((i & 1) != 0) {
            function0 = new Function0<Fragment>() {
                {
                    super(0);
                }

                public final Fragment m2208invoke() {
                    return fragment;
                }
            };
        }
        if ((i & 2) != 0) {
            function1 = null;
        }
        Lazy lazy = LazyKt.lazy(LazyThreadSafetyMode.NONE, new FragmentViewModelLazyKt$viewModels$owner$2(function0));
        Intrinsics.reifiedOperationMarker(4, "VM");
        KClass orCreateKotlinClass = Reflection.getOrCreateKotlinClass(ViewModel.class);
        C04132 c04132 = new C04132(lazy);
        C04143 c04143 = new C04143(lazy);
        if (function1 == null) {
            function1 = new C04154(fragment, lazy);
        }
        return createViewModelLazy(fragment, orCreateKotlinClass, c04132, c04143, function1);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Superseded by viewModels that takes a CreationExtras producer")
    public static final <VM extends ViewModel> Lazy<VM> viewModels(Fragment fragment, Function0<? extends ViewModelStoreOwner> function0, Function0<? extends ViewModelProvider.Factory> function1) {
        Lazy lazy = LazyKt.lazy(LazyThreadSafetyMode.NONE, new FragmentViewModelLazyKt$viewModels$owner$2(function0));
        Intrinsics.reifiedOperationMarker(4, "VM");
        KClass orCreateKotlinClass = Reflection.getOrCreateKotlinClass(ViewModel.class);
        C04132 c04132 = new C04132(lazy);
        C04143 c04143 = new C04143(lazy);
        if (function1 == null) {
            function1 = new C04154(fragment, lazy);
        }
        return createViewModelLazy(fragment, orCreateKotlinClass, c04132, c04143, function1);
    }

    public static final ViewModelStoreOwner m2197viewModels$lambda0(Lazy<? extends ViewModelStoreOwner> lazy) {
        return (ViewModelStoreOwner) lazy.getValue();
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/ViewModelStore;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04132 extends Lambda implements Function0<ViewModelStore> {
        final Lazy<ViewModelStoreOwner> $owner$delegate;

        public C04132(Lazy<? extends ViewModelStoreOwner> lazy) {
            super(0);
            this.$owner$delegate = lazy;
        }

        public final ViewModelStore m2209invoke() {
            return FragmentViewModelLazyKt.m2197viewModels$lambda0(this.$owner$delegate).getViewModelStore();
        }
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/viewmodel/CreationExtras;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04143 extends Lambda implements Function0<CreationExtras> {
        final Lazy<ViewModelStoreOwner> $owner$delegate;

        public C04143(Lazy<? extends ViewModelStoreOwner> lazy) {
            super(0);
            this.$owner$delegate = lazy;
        }

        public final CreationExtras m2210invoke() {
            CreationExtras defaultViewModelCreationExtras;
            ViewModelStoreOwner viewModelStoreOwnerM2197viewModels$lambda0 = FragmentViewModelLazyKt.m2197viewModels$lambda0(this.$owner$delegate);
            HasDefaultViewModelProviderFactory hasDefaultViewModelProviderFactory = viewModelStoreOwnerM2197viewModels$lambda0 instanceof HasDefaultViewModelProviderFactory ? (HasDefaultViewModelProviderFactory) viewModelStoreOwnerM2197viewModels$lambda0 : null;
            return (hasDefaultViewModelProviderFactory == null || (defaultViewModelCreationExtras = hasDefaultViewModelProviderFactory.getDefaultViewModelCreationExtras()) == null) ? CreationExtras.Empty.INSTANCE : defaultViewModelCreationExtras;
        }
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/ViewModelProvider$Factory;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04154 extends Lambda implements Function0<ViewModelProvider.Factory> {
        final Lazy<ViewModelStoreOwner> $owner$delegate;
        final Fragment $this_viewModels;

        public C04154(Fragment fragment, Lazy<? extends ViewModelStoreOwner> lazy) {
            super(0);
            this.$this_viewModels = fragment;
            this.$owner$delegate = lazy;
        }

        public final ViewModelProvider.Factory m2211invoke() {
            ViewModelProvider.Factory defaultViewModelProviderFactory;
            ViewModelStoreOwner viewModelStoreOwnerM2197viewModels$lambda0 = FragmentViewModelLazyKt.m2197viewModels$lambda0(this.$owner$delegate);
            HasDefaultViewModelProviderFactory hasDefaultViewModelProviderFactory = viewModelStoreOwnerM2197viewModels$lambda0 instanceof HasDefaultViewModelProviderFactory ? (HasDefaultViewModelProviderFactory) viewModelStoreOwnerM2197viewModels$lambda0 : null;
            return (hasDefaultViewModelProviderFactory == null || (defaultViewModelProviderFactory = hasDefaultViewModelProviderFactory.getDefaultViewModelProviderFactory()) == null) ? this.$this_viewModels.getDefaultViewModelProviderFactory() : defaultViewModelProviderFactory;
        }
    }

    public static Lazy viewModels$default(final Fragment fragment, Function0 function0, Function0 function1, Function0 function2, int i, Object obj) {
        if ((i & 1) != 0) {
            function0 = new Function0<Fragment>() {
                {
                    super(0);
                }

                public final Fragment m2212invoke() {
                    return fragment;
                }
            };
        }
        if ((i & 2) != 0) {
            function1 = null;
        }
        if ((i & 4) != 0) {
            function2 = null;
        }
        Lazy lazy = LazyKt.lazy(LazyThreadSafetyMode.NONE, new FragmentViewModelLazyKt$viewModels$owner$4(function0));
        Intrinsics.reifiedOperationMarker(4, "VM");
        KClass orCreateKotlinClass = Reflection.getOrCreateKotlinClass(ViewModel.class);
        C04176 c04176 = new C04176(lazy);
        C04187 c04187 = new C04187(function1, lazy);
        if (function2 == null) {
            function2 = new C04198(fragment, lazy);
        }
        return createViewModelLazy(fragment, orCreateKotlinClass, c04176, c04187, function2);
    }

    public static final <VM extends ViewModel> Lazy<VM> viewModels(Fragment fragment, Function0<? extends ViewModelStoreOwner> function0, Function0<? extends CreationExtras> function1, Function0<? extends ViewModelProvider.Factory> function2) {
        Lazy lazy = LazyKt.lazy(LazyThreadSafetyMode.NONE, new FragmentViewModelLazyKt$viewModels$owner$4(function0));
        Intrinsics.reifiedOperationMarker(4, "VM");
        KClass orCreateKotlinClass = Reflection.getOrCreateKotlinClass(ViewModel.class);
        C04176 c04176 = new C04176(lazy);
        C04187 c04187 = new C04187(function1, lazy);
        if (function2 == null) {
            function2 = new C04198(fragment, lazy);
        }
        return createViewModelLazy(fragment, orCreateKotlinClass, c04176, c04187, function2);
    }

    public static final ViewModelStoreOwner m2198viewModels$lambda1(Lazy<? extends ViewModelStoreOwner> lazy) {
        return (ViewModelStoreOwner) lazy.getValue();
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/ViewModelStore;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04176 extends Lambda implements Function0<ViewModelStore> {
        final Lazy<ViewModelStoreOwner> $owner$delegate;

        public C04176(Lazy<? extends ViewModelStoreOwner> lazy) {
            super(0);
            this.$owner$delegate = lazy;
        }

        public final ViewModelStore m2213invoke() {
            return FragmentViewModelLazyKt.m2198viewModels$lambda1(this.$owner$delegate).getViewModelStore();
        }
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/viewmodel/CreationExtras;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04187 extends Lambda implements Function0<CreationExtras> {
        final Function0<CreationExtras> $extrasProducer;
        final Lazy<ViewModelStoreOwner> $owner$delegate;

        public C04187(Function0<? extends CreationExtras> function0, Lazy<? extends ViewModelStoreOwner> lazy) {
            super(0);
            this.$extrasProducer = function0;
            this.$owner$delegate = lazy;
        }

        public final CreationExtras m2214invoke() {
            CreationExtras creationExtras;
            Function0<CreationExtras> function0 = this.$extrasProducer;
            if (function0 != null && (creationExtras = (CreationExtras) function0.invoke()) != null) {
                return creationExtras;
            }
            ViewModelStoreOwner viewModelStoreOwnerM2198viewModels$lambda1 = FragmentViewModelLazyKt.m2198viewModels$lambda1(this.$owner$delegate);
            HasDefaultViewModelProviderFactory hasDefaultViewModelProviderFactory = viewModelStoreOwnerM2198viewModels$lambda1 instanceof HasDefaultViewModelProviderFactory ? (HasDefaultViewModelProviderFactory) viewModelStoreOwnerM2198viewModels$lambda1 : null;
            return hasDefaultViewModelProviderFactory != null ? hasDefaultViewModelProviderFactory.getDefaultViewModelCreationExtras() : CreationExtras.Empty.INSTANCE;
        }
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/ViewModelProvider$Factory;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04198 extends Lambda implements Function0<ViewModelProvider.Factory> {
        final Lazy<ViewModelStoreOwner> $owner$delegate;
        final Fragment $this_viewModels;

        public C04198(Fragment fragment, Lazy<? extends ViewModelStoreOwner> lazy) {
            super(0);
            this.$this_viewModels = fragment;
            this.$owner$delegate = lazy;
        }

        public final ViewModelProvider.Factory m2215invoke() {
            ViewModelProvider.Factory defaultViewModelProviderFactory;
            ViewModelStoreOwner viewModelStoreOwnerM2198viewModels$lambda1 = FragmentViewModelLazyKt.m2198viewModels$lambda1(this.$owner$delegate);
            HasDefaultViewModelProviderFactory hasDefaultViewModelProviderFactory = viewModelStoreOwnerM2198viewModels$lambda1 instanceof HasDefaultViewModelProviderFactory ? (HasDefaultViewModelProviderFactory) viewModelStoreOwnerM2198viewModels$lambda1 : null;
            return (hasDefaultViewModelProviderFactory == null || (defaultViewModelProviderFactory = hasDefaultViewModelProviderFactory.getDefaultViewModelProviderFactory()) == null) ? this.$this_viewModels.getDefaultViewModelProviderFactory() : defaultViewModelProviderFactory;
        }
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/ViewModelStore;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04041 extends Lambda implements Function0<ViewModelStore> {
        final Fragment $this_activityViewModels;

        public C04041(Fragment fragment) {
            super(0);
            this.$this_activityViewModels = fragment;
        }

        public final ViewModelStore m2199invoke() {
            return this.$this_activityViewModels.requireActivity().getViewModelStore();
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Superseded by activityViewModels that takes a CreationExtras producer")
    public static final <VM extends ViewModel> Lazy<VM> activityViewModels(Fragment fragment, Function0<? extends ViewModelProvider.Factory> function0) {
        Intrinsics.reifiedOperationMarker(4, "VM");
        KClass orCreateKotlinClass = Reflection.getOrCreateKotlinClass(ViewModel.class);
        C04041 c04041 = new C04041(fragment);
        C04052 c04052 = new C04052(fragment);
        if (function0 == null) {
            function0 = new C04063(fragment);
        }
        return createViewModelLazy(fragment, orCreateKotlinClass, c04041, c04052, function0);
    }

    public static Lazy activityViewModels$default(Fragment fragment, Function0 function0, int i, Object obj) {
        if ((i & 1) != 0) {
            function0 = null;
        }
        Intrinsics.reifiedOperationMarker(4, "VM");
        KClass orCreateKotlinClass = Reflection.getOrCreateKotlinClass(ViewModel.class);
        C04041 c04041 = new C04041(fragment);
        C04052 c04052 = new C04052(fragment);
        if (function0 == null) {
            function0 = new C04063(fragment);
        }
        return createViewModelLazy(fragment, orCreateKotlinClass, c04041, c04052, function0);
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/viewmodel/CreationExtras;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04052 extends Lambda implements Function0<CreationExtras> {
        final Fragment $this_activityViewModels;

        public C04052(Fragment fragment) {
            super(0);
            this.$this_activityViewModels = fragment;
        }

        public final CreationExtras m2200invoke() {
            return this.$this_activityViewModels.requireActivity().getDefaultViewModelCreationExtras();
        }
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/ViewModelProvider$Factory;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04063 extends Lambda implements Function0<ViewModelProvider.Factory> {
        final Fragment $this_activityViewModels;

        public C04063(Fragment fragment) {
            super(0);
            this.$this_activityViewModels = fragment;
        }

        public final ViewModelProvider.Factory m2201invoke() {
            return this.$this_activityViewModels.requireActivity().getDefaultViewModelProviderFactory();
        }
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/ViewModelStore;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04074 extends Lambda implements Function0<ViewModelStore> {
        final Fragment $this_activityViewModels;

        public C04074(Fragment fragment) {
            super(0);
            this.$this_activityViewModels = fragment;
        }

        public final ViewModelStore m2202invoke() {
            return this.$this_activityViewModels.requireActivity().getViewModelStore();
        }
    }

    public static final <VM extends ViewModel> Lazy<VM> activityViewModels(Fragment fragment, Function0<? extends CreationExtras> function0, Function0<? extends ViewModelProvider.Factory> function1) {
        Intrinsics.reifiedOperationMarker(4, "VM");
        KClass orCreateKotlinClass = Reflection.getOrCreateKotlinClass(ViewModel.class);
        C04074 c04074 = new C04074(fragment);
        C04085 c04085 = new C04085(function0, fragment);
        if (function1 == null) {
            function1 = new C04096(fragment);
        }
        return createViewModelLazy(fragment, orCreateKotlinClass, c04074, c04085, function1);
    }

    public static Lazy activityViewModels$default(Fragment fragment, Function0 function0, Function0 function1, int i, Object obj) {
        if ((i & 1) != 0) {
            function0 = null;
        }
        if ((i & 2) != 0) {
            function1 = null;
        }
        Intrinsics.reifiedOperationMarker(4, "VM");
        KClass orCreateKotlinClass = Reflection.getOrCreateKotlinClass(ViewModel.class);
        C04074 c04074 = new C04074(fragment);
        C04085 c04085 = new C04085(function0, fragment);
        if (function1 == null) {
            function1 = new C04096(fragment);
        }
        return createViewModelLazy(fragment, orCreateKotlinClass, c04074, c04085, function1);
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/viewmodel/CreationExtras;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04085 extends Lambda implements Function0<CreationExtras> {
        final Function0<CreationExtras> $extrasProducer;
        final Fragment $this_activityViewModels;

        public C04085(Function0<? extends CreationExtras> function0, Fragment fragment) {
            super(0);
            this.$extrasProducer = function0;
            this.$this_activityViewModels = fragment;
        }

        public final CreationExtras m2203invoke() {
            CreationExtras creationExtras;
            Function0<CreationExtras> function0 = this.$extrasProducer;
            return (function0 == null || (creationExtras = (CreationExtras) function0.invoke()) == null) ? this.$this_activityViewModels.requireActivity().getDefaultViewModelCreationExtras() : creationExtras;
        }
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\n\b\u0000\u0010\u0002\u0018\u0001*\u00020\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "Landroidx/lifecycle/ViewModelProvider$Factory;", "VM", "Landroidx/lifecycle/ViewModel;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C04096 extends Lambda implements Function0<ViewModelProvider.Factory> {
        final Fragment $this_activityViewModels;

        public C04096(Fragment fragment) {
            super(0);
            this.$this_activityViewModels = fragment;
        }

        public final ViewModelProvider.Factory m2204invoke() {
            return this.$this_activityViewModels.requireActivity().getDefaultViewModelProviderFactory();
        }
    }

    public static Lazy createViewModelLazy$default(Fragment fragment, KClass kClass, Function0 function0, Function0 function1, int i, Object obj) {
        if ((i & 4) != 0) {
            function1 = null;
        }
        return createViewModelLazy(fragment, kClass, function0, function1);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Superseded by createViewModelLazy that takes a CreationExtras producer")
    public static final Lazy createViewModelLazy(final Fragment fragment, KClass kClass, Function0 function0, Function0 function1) {
        return createViewModelLazy(fragment, kClass, function0, new Function0<CreationExtras>() {
            {
                super(0);
            }

            public final CreationExtras m2205invoke() {
                return fragment.getDefaultViewModelCreationExtras();
            }
        }, function1);
    }

    public static Lazy createViewModelLazy$default(final Fragment fragment, KClass kClass, Function0 function0, Function0 function1, Function0 function2, int i, Object obj) {
        if ((i & 4) != 0) {
            function1 = new Function0<CreationExtras>() {
                {
                    super(0);
                }

                public final CreationExtras m2206invoke() {
                    return fragment.getDefaultViewModelCreationExtras();
                }
            };
        }
        if ((i & 8) != 0) {
            function2 = null;
        }
        return createViewModelLazy(fragment, kClass, function0, function1, function2);
    }

    public static final <VM extends ViewModel> Lazy<VM> createViewModelLazy(final Fragment fragment, KClass<VM> kClass, Function0<? extends ViewModelStore> function0, Function0<? extends CreationExtras> function1, Function0<? extends ViewModelProvider.Factory> function2) {
        if (function2 == null) {
            function2 = new Function0<ViewModelProvider.Factory>() {
                {
                    super(0);
                }

                public final ViewModelProvider.Factory m2207invoke() {
                    return fragment.getDefaultViewModelProviderFactory();
                }
            };
        }
        return new ViewModelLazy(kClass, function0, function2, function1);
    }
}
