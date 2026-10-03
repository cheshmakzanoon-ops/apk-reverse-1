local LWUIAllyDuelRewardPanelCtrl = BaseClass("LWUIAllyDuelRewardPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIAllyDuelRewardPanel)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LWUIAllyDuelRewardPanelCtrl.CloseSelf = CloseSelf
LWUIAllyDuelRewardPanelCtrl.Close = Close
return LWUIAllyDuelRewardPanelCtrl
