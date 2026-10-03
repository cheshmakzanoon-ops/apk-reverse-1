local LWUIAllyDuelPersonalRankPanelCtrl = BaseClass("LWUIAllyDuelPersonalRankPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIAllyDuelPersonalRankPanel)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LWUIAllyDuelPersonalRankPanelCtrl.CloseSelf = CloseSelf
LWUIAllyDuelPersonalRankPanelCtrl.Close = Close
return LWUIAllyDuelPersonalRankPanelCtrl
