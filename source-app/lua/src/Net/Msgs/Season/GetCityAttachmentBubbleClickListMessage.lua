local GetCityAttachmentBubbleClickListMessage = BaseClass("GetCityAttachmentBubbleClickListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCityAttachmentBubbleClickListMessage:OnCreate()
  base.OnCreate(self)
end

function GetCityAttachmentBubbleClickListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil and t.record then
    local Player = CS.GameEntry.Data.Player
    for _, uuid in ipairs(t.record) do
      Player:SetData(uuid .. "_record_cab", tostring(uuid))
    end
  end
end

return GetCityAttachmentBubbleClickListMessage
