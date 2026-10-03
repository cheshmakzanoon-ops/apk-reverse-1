local UILWDominatorArchiveCtrl = BaseClass("UILWDominatorArchiveCtrl", UIBaseCtrl)

function UILWDominatorArchiveCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorArchive)
end

return UILWDominatorArchiveCtrl
