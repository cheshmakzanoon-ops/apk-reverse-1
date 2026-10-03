local PushLandlordTowerAttackMessage = BaseClass("PushLandlordTowerAttackMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function PushLandlordTowerAttackMessage:OnCreate()
  base.OnCreate(self)
end

function PushLandlordTowerAttackMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.uuid then
    if not SceneUtils.GetIsInWorld() or CS.SceneManager.World == nil then
      return
    end
    local canonPointInfo = CS.SceneManager.World:GetPointInfoByUuid(t.uuid)
    if canonPointInfo == nil then
      return
    end
    local serverId = toInt(canonPointInfo.serverId)
    local cityId = toInt(canonPointInfo.cityId)
    if 0 < cityId and 0 < serverId then
      DataCenter.ZoneWarManager:UpdateBatteryFireTime(cityId, toInt(t.attackTime))
      local uuid = toInt(t.uuid)
      if 0 < uuid then
        local curServerId = DataCenter.LandlordMgr:GetCenterServerId()
        CS.WorldPointManager.DoMissileFire(curServerId, cityId, t.uuid)
        TimerManager:GetInstance():DelayInvoke(function()
          local data = {
            pointId = t.targetPointId,
            solider = t.damage,
            serverId = curServerId
          }
          DataCenter.WorldBattleManager:OnHandlePvpBattleDamage(data)
        end, 1.2)
        EventManager:GetInstance():Broadcast(EventId.LandlordCanonTowerFire, cityId)
      end
    end
  end
end

return PushLandlordTowerAttackMessage
