local PersonalTargetCtrl = BaseClass("PersonalTargetCtrl", UIBaseCtrl)

function PersonalTargetCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentPersonalTarget)
end

return PersonalTargetCtrl
