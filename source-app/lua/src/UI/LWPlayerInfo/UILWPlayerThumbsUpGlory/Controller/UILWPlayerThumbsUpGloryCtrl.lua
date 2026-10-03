local UILWPlayerThumbsUpGloryCtrl = BaseClass("UILWPlayerThumbsUpGloryCtrl", UIBaseCtrl)

function UILWPlayerThumbsUpGloryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerThumbsUpGlory)
end

return UILWPlayerThumbsUpGloryCtrl
