local UILWHowToPlayCtrl = BaseClass("UILWHowToPlayCtrl", UIBaseCtrl)

function UILWHowToPlayCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWHowToPlay)
end

return UILWHowToPlayCtrl
