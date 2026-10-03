local UILastStandMainCtrl = BaseClass("UILastStandMainCtrl", UIBaseCtrl)

function UILastStandMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILastStandMain, {anim = false})
end

function UILastStandMainCtrl:InitData(self)
end

return UILastStandMainCtrl
