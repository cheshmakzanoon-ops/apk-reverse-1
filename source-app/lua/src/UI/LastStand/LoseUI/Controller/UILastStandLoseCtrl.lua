local UILastStandLoseCtrl = BaseClass("UILastStandLoseCtrl", UIBaseCtrl)

function UILastStandLoseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILastStandLose, {anim = false})
end

function UILastStandLoseCtrl:InitData(self)
end

return UILastStandLoseCtrl
