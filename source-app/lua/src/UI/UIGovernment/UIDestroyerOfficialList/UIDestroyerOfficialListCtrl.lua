local UIDestroyerOfficialListCtrl = BaseClass("UIDestroyerOfficialListCtrl", UIBaseCtrl)

function UIDestroyerOfficialListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDestroyerOfficialList)
end

return UIDestroyerOfficialListCtrl
