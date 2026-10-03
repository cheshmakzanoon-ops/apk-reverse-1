local PushDragonCityMoveCoolDownMessage = BaseClass("PushDragonCityMoveCoolDownMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushDragonCityMoveCoolDownMessage:OnCreate()
  base.OnCreate(self)
end

function PushDragonCityMoveCoolDownMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  BattleFieldUtil.cool = t
  EventManager:GetInstance():Broadcast(EventId.DragonCityMoveCoolDown, t)
end

return PushDragonCityMoveCoolDownMessage
