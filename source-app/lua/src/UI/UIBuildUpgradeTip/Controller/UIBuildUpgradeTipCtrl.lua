local UIBuildUpgradeTipCtrl = BaseClass("UIBuildUpgradeTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildUpgradeTip, {anim = true})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIBuildUpgradeTipCtrl.CloseSelf = CloseSelf
UIBuildUpgradeTipCtrl.Close = Close
return UIBuildUpgradeTipCtrl
