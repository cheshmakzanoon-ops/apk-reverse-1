local UIChatViewBigPhotoListCtrl = BaseClass("UIChatViewBigPhotoListCtrl", UIBaseCtrl)

function UIChatViewBigPhotoListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatViewBigPhotoListView)
end

return UIChatViewBigPhotoListCtrl
