local UIResourceItemLackCtrl = BaseClass("UIResourceItemLackCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIResourceItemLack)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Info)
end

UIResourceItemLackCtrl.CloseSelf = CloseSelf
UIResourceItemLackCtrl.Close = Close
return UIResourceItemLackCtrl
