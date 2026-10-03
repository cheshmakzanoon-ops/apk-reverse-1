local UIPlayerDownloadCenterDeleteListCtrl = BaseClass("UIPlayerDownloadCenterDeleteListCtrl", UIBaseCtrl)

function UIPlayerDownloadCenterDeleteListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerDownloadCenterDeleteList)
end

return UIPlayerDownloadCenterDeleteListCtrl
