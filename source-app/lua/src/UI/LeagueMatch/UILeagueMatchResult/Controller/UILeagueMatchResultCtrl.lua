local UILeagueMatchResultCtrl = BaseClass("UILeagueMatchResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILeagueMatchResult)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UILeagueMatchResultCtrl.CloseSelf = CloseSelf
UILeagueMatchResultCtrl.Close = Close
return UILeagueMatchResultCtrl
