local PushAlPlagueBossUpdateMessage = BaseClass("PushAlPlagueBossUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAlPlagueBossUpdateMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAlPlagueBossUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.damage and t.lv and t.maxDamage and t.bossType == AllyDrillBoss.RoadHog then
    DataCenter.AllyDrillBaseManager:RefreshRoadHogDamage(t)
  end
end

return PushAlPlagueBossUpdateMessage
