local CampSelectListCtrl = BaseClass("CampSelectListCtrl", UIBaseCtrl)

function CampSelectListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.CampSelectList)
end

return CampSelectListCtrl
