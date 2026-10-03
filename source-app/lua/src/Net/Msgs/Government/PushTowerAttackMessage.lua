local PushTowerAttackMessage = BaseClass("PushTowerAttackMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushTowerAttackMessage:OnCreate(allianceId)
  base.OnCreate(self)
  self.sfsObj:PutInt("openHide", 1)
  self.sfsObj:PutUtfString("allianceId", allianceId)
end

function PushTowerAttackMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.damage == 0 then
    return
  end
  if t.serverId and t.pointId and CS.SceneManager:IsInWorld() then
    if t.uuid then
      local info = CS.SceneManager.World:GetPointInfoByUuid(t.uuid)
      if info ~= nil and info.CityId ~= nil and info.serverId then
        local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(info.CityId, info.serverId)
        if cityMeta and cityMeta:IsThroneCityBattery() then
          DataCenter.ZoneWarManager:BatteryFire(cityMeta.id, t, 0)
        end
        EventManager:GetInstance():Broadcast(EventId.KingdomBadgesFire, t.pointId)
        return
      end
    end
    if t.cityId then
      DataCenter.ZoneWarManager:BatteryFire(t.cityId, t, 0)
    else
      local cityData = DataCenter.AllianceCityTemplateManager:GetCityDataByPointIndex(t.pointId, t.serverId or LuaEntry.Player:GetCurServerId())
      if cityData and cityData:IsThroneCityBattery() then
        DataCenter.ZoneWarManager:BatteryFire(cityData.id, t, 0)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.KingdomBadgesFire, t.pointId)
  end
end

return PushTowerAttackMessage
