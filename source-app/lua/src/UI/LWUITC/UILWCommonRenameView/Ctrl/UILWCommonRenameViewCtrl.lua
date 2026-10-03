local UILWCommonRenameViewCtrl = BaseClass("UILWCommonRenameViewCtrl", UIBaseCtrl)

function UILWCommonRenameViewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCommonRenameView)
end

return UILWCommonRenameViewCtrl
