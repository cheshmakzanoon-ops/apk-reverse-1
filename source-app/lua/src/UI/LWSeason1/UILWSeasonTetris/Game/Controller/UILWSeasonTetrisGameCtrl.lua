local UILWSeasonTetrisGameCtrl = BaseClass("UILWSeasonTetrisGameCtrl", UIBaseCtrl)

function UILWSeasonTetrisGameCtrl:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.SeasonSelectLocationGameClose)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonTetrisGame)
end

function UILWSeasonTetrisGameCtrl:OnCustomKeyCodeEscape()
  EventManager:GetInstance():Broadcast(EventId.SeasonSelectLocationGameEsc)
end

return UILWSeasonTetrisGameCtrl
