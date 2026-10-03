local UILWSeasonCityAttachmentCtrl = BaseClass("UILWSeasonCityAttachmentCtrl", UIBaseCtrl)

function UILWSeasonCityAttachmentCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCityAttachment)
end

return UILWSeasonCityAttachmentCtrl
