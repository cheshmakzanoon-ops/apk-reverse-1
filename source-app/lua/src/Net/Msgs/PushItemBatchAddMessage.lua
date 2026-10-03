local PushItemBatchAddMessage = BaseClass("PushItemBatchAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushItemBatchAddMessage:OnCreate(self, param)
  base.OnCreate(self)
end

function PushItemBatchAddMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t and t.changeArray then
    for i = 1, #t.changeArray do
      local item = t.changeArray[i]
      DataCenter.ItemData:UpdateOneItem(item, true, false)
    end
  end
end

return PushItemBatchAddMessage
