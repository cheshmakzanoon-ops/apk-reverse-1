local GoldTreePrayShowCtrl = BaseClass("GoldTreePrayShowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.GoldTreePrayShow)
end

GoldTreePrayShowCtrl.CloseSelf = CloseSelf
return GoldTreePrayShowCtrl
