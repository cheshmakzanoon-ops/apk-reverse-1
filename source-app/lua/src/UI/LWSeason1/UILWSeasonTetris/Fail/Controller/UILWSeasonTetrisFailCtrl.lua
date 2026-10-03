local UILWSeasonTetrisFailCtrl = BaseClass("UILWSeasonTetrisFailCtrl", UIBaseCtrl)

function UILWSeasonTetrisFailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonTetrisFail)
end

function UILWSeasonTetrisFailCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
  DataCenter.SeasonTetrisManager:SendReset(false)
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisCloseGame)
end

return UILWSeasonTetrisFailCtrl
