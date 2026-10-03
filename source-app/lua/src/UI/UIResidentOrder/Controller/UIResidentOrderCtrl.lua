local UIResidentOrderCtrl = BaseClass("UIResidentOrderCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIResidentOrder)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIResidentOrderCtrl.CloseSelf = CloseSelf
UIResidentOrderCtrl.Close = Close
return UIResidentOrderCtrl
