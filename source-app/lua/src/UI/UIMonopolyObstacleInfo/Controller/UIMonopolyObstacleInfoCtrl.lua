local UIMonopolyObstacleInfoCtrl = BaseClass("UIMonopolyObstacleInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMonopolyObstacleInfo)
end

local function Close(self)
end

UIMonopolyObstacleInfoCtrl.CloseSelf = CloseSelf
UIMonopolyObstacleInfoCtrl.Close = Close
return UIMonopolyObstacleInfoCtrl
