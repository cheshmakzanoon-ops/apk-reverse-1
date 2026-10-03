local UISkirmishResultCtrl = BaseClass("UISkirmishResultCtrl", UIBaseCtrl)

function UISkirmishResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkirmishResult, {anim = false})
end

function UISkirmishResultCtrl:InitData(self)
end

return UISkirmishResultCtrl
