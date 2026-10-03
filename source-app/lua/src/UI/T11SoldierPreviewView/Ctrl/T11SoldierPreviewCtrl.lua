local T11SoldierPreviewCtrl = BaseClass("T11SoldierPreviewCtrl", UIBaseCtrl)

function T11SoldierPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.T11SoldierPreviewView)
end

return T11SoldierPreviewCtrl
