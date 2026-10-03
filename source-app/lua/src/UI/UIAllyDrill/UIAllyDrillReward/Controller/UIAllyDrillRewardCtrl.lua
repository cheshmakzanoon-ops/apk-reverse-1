local UIAllyDrillRewardCtrl = BaseClass("UIAllyDrillRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDrillReward)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAllyDrillRewardCtrl.CloseSelf = CloseSelf
UIAllyDrillRewardCtrl.Close = Close
return UIAllyDrillRewardCtrl
