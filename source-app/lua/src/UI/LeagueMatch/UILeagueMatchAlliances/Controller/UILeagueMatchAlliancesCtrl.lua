local UILeagueMatchAlliancesCtrl = BaseClass("UILeagueMatchAlliancesCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILeagueMatchAlliances)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UILeagueMatchAlliancesCtrl.CloseSelf = CloseSelf
UILeagueMatchAlliancesCtrl.Close = Close
return UILeagueMatchAlliancesCtrl
