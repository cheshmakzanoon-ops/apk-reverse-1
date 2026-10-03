local LWUIChangeEnterAllianceConditionCtrl = BaseClass("LWUIChangeEnterAllianceConditionCtrl", UIBaseCtrl)

function LWUIChangeEnterAllianceConditionCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWChangeEnterAllianceCondition)
end

return LWUIChangeEnterAllianceConditionCtrl
