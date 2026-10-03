local LWUIPlayerPackageRewardChangeCtrl = BaseClass("LWUIPlayerPackageRewardChangeCtrl", UIBaseCtrl)

function LWUIPlayerPackageRewardChangeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIPlayerPackageRewardChange)
end

return LWUIPlayerPackageRewardChangeCtrl
