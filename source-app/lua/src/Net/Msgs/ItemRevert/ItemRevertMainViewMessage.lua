local ItemRevertMainViewMessage = BaseClass("ItemRevertMainViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ItemRevertMainViewMessage:OnCreate(param, state, filters, intSort)
  base.OnCreate(self)
  self.sfsObj:PutInt("page", param)
  if state ~= nil then
    self.sfsObj:PutInt("state", state)
  end
  if filters ~= nil and type(filters) == "table" and 0 < #filters then
    self.sfsObj:PutIntArray("filters", filters)
  end
  if intSort ~= nil then
    self.sfsObj:PutInt("isSort", intSort)
  end
end

function ItemRevertMainViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.state == 1 then
    local v18HistoryView = UIManager:GetInstance():GetWindow(UIWindowNames.UIItemRevertHistory)
    if v18HistoryView and v18HistoryView.View then
      v18HistoryView.View:HistoryRecordsCallback(t)
    end
  else
    local v18HistoryView = UIManager:GetInstance():GetWindow(UIWindowNames.UIItemRevert)
    if v18HistoryView and v18HistoryView.View then
      v18HistoryView.View:HistoryRecordsCallback(t)
    end
  end
end

return ItemRevertMainViewMessage
