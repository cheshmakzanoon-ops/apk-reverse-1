package kotlin.jvm.internal;

import java.io.Serializable;
import kotlin.reflect.KFunction;

public class FunInterfaceConstructorReference extends FunctionReference implements Serializable {
    private final Class funInterface;

    public FunInterfaceConstructorReference(Class cls) {
        super(1);
        this.funInterface = cls;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof FunInterfaceConstructorReference) {
            return this.funInterface.equals(((FunInterfaceConstructorReference) obj).funInterface);
        }
        return false;
    }

    @Override
    public int hashCode() {
        return this.funInterface.hashCode();
    }

    @Override
    public String toString() {
        return "fun interface " + this.funInterface.getName();
    }

    @Override
    public KFunction getReflected() {
        throw new UnsupportedOperationException("Functional interface constructor does not support reflection");
    }
}
