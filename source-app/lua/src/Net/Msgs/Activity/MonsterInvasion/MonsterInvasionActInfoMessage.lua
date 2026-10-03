local MonsterInvasionActInfoMessage = BaseClass("MonsterInvasionActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, needTotal)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  if needTotal ~= nil then
    self.sfsObj:PutBool("needTotal", needTotal)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityMonsterInvasionDataManager:UpdateActData(t)
    EventManager:GetInstance():Broadcast(EventId.MonsterInvasionGetData)
  end
end

MonsterInvasionActInfoMessage.OnCreate = OnCreate
MonsterInvasionActInfoMessage.HandleMessage = HandleMessage
return MonsterInvasionActInfoMessage
