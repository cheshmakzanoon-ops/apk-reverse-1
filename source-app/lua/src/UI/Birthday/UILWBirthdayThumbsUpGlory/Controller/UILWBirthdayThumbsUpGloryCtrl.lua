local UILWBirthdayThumbsUpGloryCtrl = BaseClass("UILWBirthdayThumbsUpGloryCtrl", UIBaseCtrl)

function UILWBirthdayThumbsUpGloryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBirthdayThumbsUpGlory)
end

return UILWBirthdayThumbsUpGloryCtrl
