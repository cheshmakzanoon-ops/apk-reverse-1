local UILWDominatorArchiveDetailCtrl = BaseClass("UILWDominatorArchiveDetailCtrl", UIBaseCtrl)

function UILWDominatorArchiveDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorArchiveDetail)
end

return UILWDominatorArchiveDetailCtrl
