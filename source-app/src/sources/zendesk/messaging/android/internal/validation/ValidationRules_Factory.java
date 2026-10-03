package zendesk.messaging.android.internal.validation;

import dagger.internal.Factory;

public final class ValidationRules_Factory implements Factory<ValidationRules> {
    @Override
    public ValidationRules get() {
        return newInstance();
    }

    public static ValidationRules_Factory create() {
        return InstanceHolder.INSTANCE;
    }

    public static ValidationRules newInstance() {
        return new ValidationRules();
    }

    private static final class InstanceHolder {
        private static final ValidationRules_Factory INSTANCE = new ValidationRules_Factory();

        private InstanceHolder() {
        }
    }
}
