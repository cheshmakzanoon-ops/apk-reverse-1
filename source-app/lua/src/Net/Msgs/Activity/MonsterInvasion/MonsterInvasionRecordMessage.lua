local MonsterInvasionRecordMessage = BaseClass("MonsterInvasionRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityMonsterInvasionDataManager:UpdateRecordData(t)
    EventManager:GetInstance():Broadcast(EventId.MonsterInvasionGetRecord)
  end
end

MonsterInvasionRecordMessage.OnCreate = OnCreate
MonsterInvasionRecordMessage.HandleMessage = HandleMessage
return MonsterInvasionRecordMessage
