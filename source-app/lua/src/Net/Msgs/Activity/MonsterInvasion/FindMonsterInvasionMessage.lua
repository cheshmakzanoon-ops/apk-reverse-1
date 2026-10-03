local FindMonsterInvasionMessage = BaseClass("FindMonsterInvasionMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, special)
  base.OnCreate(self)
  self.sfsObj:PutInt("inSpecial", special)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.MonsterInvasionGetPoint, {
      pointId = t.pointId,
      uuid = t.uuid
    })
  end
end

FindMonsterInvasionMessage.OnCreate = OnCreate
FindMonsterInvasionMessage.HandleMessage = HandleMessage
return FindMonsterInvasionMessage
