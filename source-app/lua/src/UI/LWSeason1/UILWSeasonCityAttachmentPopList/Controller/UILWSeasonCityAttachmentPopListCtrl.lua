local UILWSeasonCityAttachmentPopListCtrl = BaseClass("UILWSeasonCityAttachmentPopListCtrl", UIBaseCtrl)

function UILWSeasonCityAttachmentPopListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCityAttachmentPopList)
end

return UILWSeasonCityAttachmentPopListCtrl
