local UILWSeasonResourceDownloadCtrl = BaseClass("UILWSeasonResourceDownloadCtrl", UIBaseCtrl)

function UILWSeasonResourceDownloadCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonResourceDownload)
end

return UILWSeasonResourceDownloadCtrl
