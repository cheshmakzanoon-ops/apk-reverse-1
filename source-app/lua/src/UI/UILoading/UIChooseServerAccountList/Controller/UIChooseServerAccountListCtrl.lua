local UIChooseServerAccountListCtrl = BaseClass("UIChooseServerAccountListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChooseServerAccountList)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Info)
end

UIChooseServerAccountListCtrl.CloseSelf = CloseSelf
UIChooseServerAccountListCtrl.Close = Close
return UIChooseServerAccountListCtrl
