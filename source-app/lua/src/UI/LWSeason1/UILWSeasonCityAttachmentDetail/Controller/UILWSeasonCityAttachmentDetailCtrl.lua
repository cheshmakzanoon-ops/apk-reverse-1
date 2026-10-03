local UILWSeasonCityAttachmentDetailCtrl = BaseClass("UILWSeasonCityAttachmentDetailCtrl", UIBaseCtrl)

function UILWSeasonCityAttachmentDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCityAttachmentDetail)
end

return UILWSeasonCityAttachmentDetailCtrl
