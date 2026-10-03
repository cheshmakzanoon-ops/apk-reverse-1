local UILWSeasonTetrisSuccessCtrl = BaseClass("UILWSeasonTetrisSuccessCtrl", UIBaseCtrl)

function UILWSeasonTetrisSuccessCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonTetrisSuccess)
end

function UILWSeasonTetrisSuccessCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
  DataCenter.SeasonTetrisManager:SendReset(false)
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisCloseGame)
end

return UILWSeasonTetrisSuccessCtrl
