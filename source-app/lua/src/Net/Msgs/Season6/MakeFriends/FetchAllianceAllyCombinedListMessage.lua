local FetchAllianceAllyCombinedListMessage = BaseClass("FetchAllianceAllyCombinedListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchAllianceAllyCombinedListMessage:OnCreate()
  base.OnCreate(self)
end

function FetchAllianceAllyCombinedListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonAllyFriendManager:SetAllyCombinedList(t)
end

return FetchAllianceAllyCombinedListMessage
