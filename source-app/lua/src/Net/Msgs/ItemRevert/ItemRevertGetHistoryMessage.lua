local ItemRevertGetHistoryMessage = BaseClass("ItemRevertGetHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ItemRevertGetHistoryMessage:OnCreate(param)
  base.OnCreate(self)
end

function ItemRevertGetHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return ItemRevertGetHistoryMessage
