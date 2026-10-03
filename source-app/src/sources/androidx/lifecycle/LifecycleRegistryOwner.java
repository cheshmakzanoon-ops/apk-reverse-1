package androidx.lifecycle;

@Deprecated
public interface LifecycleRegistryOwner extends LifecycleOwner {
    @Override
    LifecycleRegistry getLifecycle();

    public final class CC {
    }
}
