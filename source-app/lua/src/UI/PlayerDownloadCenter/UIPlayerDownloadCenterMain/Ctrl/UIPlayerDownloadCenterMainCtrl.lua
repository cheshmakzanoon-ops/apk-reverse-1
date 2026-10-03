local UIPlayerDownloadCenterMainCtrl = BaseClass("UIPlayerDownloadCenterMainCtrl", UIBaseCtrl)

function UIPlayerDownloadCenterMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerDownloadCenterMain)
end

return UIPlayerDownloadCenterMainCtrl
