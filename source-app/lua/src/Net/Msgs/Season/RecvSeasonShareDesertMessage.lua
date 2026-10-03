local RecvSeasonShareDesertMessage = BaseClass("RecvSeasonShareDesertMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RecvSeasonShareDesertMessage:OnCreate(desertUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", desertUuid)
end

function RecvSeasonShareDesertMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.uuid then
    if t.recUser then
      UIUtil.ShowTipsId("season_tips194")
    end
    DataCenter.SeasonDataManager:SetShareDesertStatus(t.uuid, t.invalidFlag, t.recUser)
    EventManager:GetInstance():Broadcast(EventId.LWShareDesertStatusUpdate)
  end
end

return RecvSeasonShareDesertMessage
