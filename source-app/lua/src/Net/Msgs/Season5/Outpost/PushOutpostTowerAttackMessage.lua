local PushOutpostTowerAttackMessage = BaseClass("PushOutpostTowerAttackMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushOutpostTowerAttackMessage:OnCreate()
  base.OnCreate(self)
end

function PushOutpostTowerAttackMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  local serverId = toInt(t.serverId)
  local cityId = toInt(t.cityId)
  if 0 < cityId and 0 < serverId then
    local template = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
    if template == nil then
      return
    end
    local curServerId = template:GetCurServerId()
    local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
    DataCenter.ZoneWarManager:UpdateBatteryFireTime(cityId, toInt(t.attackTime))
    local uuid = toInt(t.uuid)
    if 0 < uuid then
      if seasonInfo ~= nil and seasonInfo:GetServerSubdivisionType(false) == SeasonMapType.NineNation then
        curServerId = seasonInfo:GetNinePalacesServer(5)
      end
      CS.WorldPointManager.DoMissileFire(curServerId, cityId, t.uuid)
    end
    local totalDamage = toInt(t.damage)
    if totalDamage ~= nil and 0 < totalDamage then
      do
        local pointId = template:GetPointId()
        if template:IsCrossZoneOutpostCanon() then
          local parent_city_id = template.parent_output
          local cityData = DataCenter.AllianceCityTemplateManager:GetTemplate(parent_city_id, serverId)
          if cityData then
            pointId = cityData:GetPointId()
          end
        end
        TimerManager:GetInstance():DelayInvoke(function()
          local data = {
            pointId = pointId,
            solider = totalDamage,
            serverId = curServerId
          }
          DataCenter.WorldBattleManager:OnHandlePvpBattleDamage(data)
        end, 1.2)
      end
    end
  end
end

return PushOutpostTowerAttackMessage
