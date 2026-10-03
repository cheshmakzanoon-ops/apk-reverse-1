local UILWDominatorArchiveCockatriceCtrl = BaseClass("UILWDominatorArchiveCockatriceCtrl", UIBaseCtrl)

function UILWDominatorArchiveCockatriceCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorArchiveCockatrice)
end

return UILWDominatorArchiveCockatriceCtrl
