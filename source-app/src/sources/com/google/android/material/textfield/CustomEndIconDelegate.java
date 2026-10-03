package com.google.android.material.textfield;

class CustomEndIconDelegate extends EndIconDelegate {
    CustomEndIconDelegate(EndCompoundLayout endCompoundLayout) {
        super(endCompoundLayout);
    }

    @Override
    void setUp() {
        this.endLayout.setEndIconOnLongClickListener(null);
    }
}
