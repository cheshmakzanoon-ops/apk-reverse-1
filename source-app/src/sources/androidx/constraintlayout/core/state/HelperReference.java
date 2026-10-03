package androidx.constraintlayout.core.state;

import androidx.constraintlayout.core.state.helpers.Facade;
import androidx.constraintlayout.core.widgets.ConstraintWidget;
import androidx.constraintlayout.core.widgets.HelperWidget;
import java.util.ArrayList;
import java.util.Collections;

public class HelperReference extends ConstraintReference implements Facade {
    protected final State mHelperState;
    private HelperWidget mHelperWidget;
    protected ArrayList<Object> mReferences;
    final State.Helper mType;

    @Override
    public void apply() {
    }

    public HelperReference(State state, State.Helper helper) {
        super(state);
        this.mReferences = new ArrayList<>();
        this.mHelperState = state;
        this.mType = helper;
    }

    public State.Helper getType() {
        return this.mType;
    }

    public HelperReference add(Object... objArr) {
        Collections.addAll(this.mReferences, objArr);
        return this;
    }

    public void setHelperWidget(HelperWidget helperWidget) {
        this.mHelperWidget = helperWidget;
    }

    public HelperWidget getHelperWidget() {
        return this.mHelperWidget;
    }

    @Override
    public ConstraintWidget getConstraintWidget() {
        return getHelperWidget();
    }

    public void applyBase() {
        super.apply();
    }
}
