local UISkirmishResultCtrl = BaseClass("UISkirmishResultCtrl", UIBaseCtrl)

function UISkirmishResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWArena3V3SkirmishResult, {anim = false})
end

function UISkirmishResultCtrl:InitData(self)
end

return UISkirmishResultCtrl
