local SkinPartyListMessage = BaseClass("SkinPartyListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SkinPartyListMessage:OnCreate(activityId)
  base.OnCreate(self)
  if not activityId then
    Logger.LogError("SkinPartyListMessage:OnCreate - activityId is required")
    return
  end
  self.sfsObj:PutInt("activityId", activityId)
end

function SkinPartyListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActConcertDataManager:OnRecSkinPartyList(t)
  end
end

return SkinPartyListMessage
