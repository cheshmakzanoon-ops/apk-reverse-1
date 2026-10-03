local UILastStandCtrl = BaseClass("UILastStandCtrl", UIBaseCtrl)

function UILastStandCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILastStandWin, {anim = false})
end

function UILastStandCtrl:InitData(self)
end

return UILastStandCtrl
