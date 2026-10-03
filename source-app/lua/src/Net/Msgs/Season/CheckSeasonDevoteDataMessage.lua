local CheckSeasonDevoteDataMessage = BaseClass("CheckSeasonDevoteDataMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CheckSeasonDevoteDataMessage:OnCreate(allianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("allianceId", allianceId)
end

function CheckSeasonDevoteDataMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t and t.has then
    Logger.Log("CheckSeasonDevoteData: true")
    DataCenter.SeasonDataManager.ExistDevoteData = true
    EventManager:GetInstance():Broadcast(EventId.CheckSeasonDevoteData)
  else
    Logger.Log("CheckSeasonDevoteData: false")
  end
end

return CheckSeasonDevoteDataMessage
