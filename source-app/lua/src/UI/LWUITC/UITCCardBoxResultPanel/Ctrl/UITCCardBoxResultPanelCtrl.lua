local UITCCardBoxResultPanelCtrl = BaseClass("UITCCardBoxResultPanelCtrl", UIBaseCtrl)
local PANEL_PHASE = require("UI.LWUITC.UITCCardBoxResultPanel.CardBoxResultPhase")

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCCardBoxResultPanel)
end

function UITCCardBoxResultPanelCtrl:GetPhase()
  return self.phase or PANEL_PHASE.Drawing
end

function UITCCardBoxResultPanelCtrl:SetPhase(phase)
  self.phase = phase
end

function UITCCardBoxResultPanelCtrl:IsInDrawingPhase()
  return self:GetPhase() == PANEL_PHASE.Drawing
end

function UITCCardBoxResultPanelCtrl:OnCustomKeyCodeEscape()
  if self:IsInDrawingPhase() then
    EventManager:GetInstance():Broadcast(EventId.TacticalCardBoxResultSkipPhase)
  else
    self:CloseSelf()
  end
end

UITCCardBoxResultPanelCtrl.CloseSelf = CloseSelf
return UITCCardBoxResultPanelCtrl
