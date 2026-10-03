local UIDeclareConditionCtrl = BaseClass("UIDeclareConditionCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDeclareCondition)
end

UIDeclareConditionCtrl.CloseSelf = CloseSelf
return UIDeclareConditionCtrl
