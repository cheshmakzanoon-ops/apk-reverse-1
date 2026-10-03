local UIRobotPackCtrl = BaseClass("UIRobotPackCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRobotPack)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function BuyGift(self, info, selectedCombineIndex)
  local vec = string.split(info:getItem2Str(), "@", 0, true)
  local combinationData = ""
  if vec ~= nil and selectedCombineIndex ~= nil and selectedCombineIndex < #vec then
    combinationData = vec[self.model.selectedCombineIndex]
  end
  DataCenter.PayManager:CallPayment(info, "UIRobotPackView", combinationData)
end

UIRobotPackCtrl.CloseSelf = CloseSelf
UIRobotPackCtrl.Close = Close
UIRobotPackCtrl.BuyGift = BuyGift
return UIRobotPackCtrl
