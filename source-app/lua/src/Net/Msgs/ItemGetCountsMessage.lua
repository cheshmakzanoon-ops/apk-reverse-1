local ItemGetCountsMessage = BaseClass("ItemGetCountsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ItemGetCountsMessage:OnCreate(itemIds)
  base.OnCreate(self)
  local array = SFSArray.New()
  for _, id in pairs(itemIds) do
    array:AddUtfString(tostring(id))
  end
  self.sfsObj:PutSFSArray("itemIds", array)
end

function ItemGetCountsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ItemData:HandleItemGetCounts(t)
  end
end

return ItemGetCountsMessage
