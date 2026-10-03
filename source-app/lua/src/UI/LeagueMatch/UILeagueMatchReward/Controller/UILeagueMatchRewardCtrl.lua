local UILeagueMatchRewardCtrl = BaseClass("UILeagueMatchRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILeagueMatchReward)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UILeagueMatchRewardCtrl.CloseSelf = CloseSelf
UILeagueMatchRewardCtrl.Close = Close
return UILeagueMatchRewardCtrl
