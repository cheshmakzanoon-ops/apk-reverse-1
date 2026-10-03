local UIChatViewBigPhotoCtrl = BaseClass("UIChatViewBigPhotoCtrl", UIBaseCtrl)

function UIChatViewBigPhotoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatViewBigPhotoView)
end

return UIChatViewBigPhotoCtrl
