local NuclearServerScoreViewMessage = BaseClass("NuclearServerScoreViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", toInt(serverId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode then
    local msg = t.errorMsg or ""
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.zoneScore and t.zoneScore.score then
    DataCenter.WorldAllianceCityDataManager:SetThroneNuclearScore(t.zoneScore.score, t.serverId)
    EventManager:GetInstance():Broadcast(EventId.ActNuclearScoreUpdate)
  end
end

NuclearServerScoreViewMessage.OnCreate = OnCreate
NuclearServerScoreViewMessage.HandleMessage = HandleMessage
return NuclearServerScoreViewMessage
