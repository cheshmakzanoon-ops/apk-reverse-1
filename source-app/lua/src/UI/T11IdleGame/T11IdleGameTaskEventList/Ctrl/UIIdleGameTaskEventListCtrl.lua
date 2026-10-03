local UIIdleGameTaskEventListCtrl = BaseClass("UIIdleGameTaskEventListCtrl", UIBaseCtrl)

function UIIdleGameTaskEventListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIIdleGameTaskEventList)
end

function UIIdleGameTaskEventListCtrl:SetCurSelectItemData(gameEventData, eventCfgData)
  self.curGameEventData = gameEventData
  self.curEventCfgData = eventCfgData
end

function UIIdleGameTaskEventListCtrl:GetCurSelectItemData()
  return self.curGameEventData, self.curEventCfgData
end

return UIIdleGameTaskEventListCtrl
