local GoldTreeResultCtrl = BaseClass("GoldTreeResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.GoldTreeResult)
end

GoldTreeResultCtrl.CloseSelf = CloseSelf
return GoldTreeResultCtrl
