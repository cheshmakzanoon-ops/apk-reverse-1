local UILWPureDisplaySkirmishResultCtrl = BaseClass("UILWPureDisplaySkirmishResultCtrl", UIBaseCtrl)

function UILWPureDisplaySkirmishResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPureDisplaySkirmishResult, {anim = false})
end

function UILWPureDisplaySkirmishResultCtrl:InitData(self)
end

return UILWPureDisplaySkirmishResultCtrl
