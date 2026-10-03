local UILWAlModifyGroupCtrl = BaseClass("UILWAlModifyGroupCtrl", UIBaseCtrl)

function UILWAlModifyGroupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlModifyGroup)
end

return UILWAlModifyGroupCtrl
