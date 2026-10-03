local UIBuffBarCtrl = BaseClass("UIBuffBarCtrl", UIBaseCtrl)

function UIBuffBarCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuffBar, {anim = false})
end

function UIBuffBarCtrl:InitData(self)
end

return UIBuffBarCtrl
