local UIAllyDuelLeagueHistoryCtrl = BaseClass("UIAllyDuelLeagueHistoryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDuelLeagueHistory)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAllyDuelLeagueHistoryCtrl.CloseSelf = CloseSelf
UIAllyDuelLeagueHistoryCtrl.Close = Close
return UIAllyDuelLeagueHistoryCtrl
