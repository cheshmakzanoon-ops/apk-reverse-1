local LWClaimSparkSoldierMessage = BaseClass("LWClaimSparkSoldierMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LWClaimSparkSoldierMessage:OnCreate(param)
  base.OnCreate(self)
end

function LWClaimSparkSoldierMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local soldierId = tonumber(t.soldierItemId)
    local soldierNum = tonumber(t.soldierNum)
    local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_CIVILIZATION_SPARK)[1]
    local soldierDataTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
    if soldierDataTemplate then
      local icon = DataCenter.SoldierDataManager:GetPlayerSelfSoldierIconByTmp(soldierDataTemplate)
      DataCenter.LWCityPerformNpcManager:GetUtil():MilitaryCampCollectSolder(buildingData.uuid, soldierId, soldierNum)
      DataCenter.ProductLineManager:ShowCollectEffectForBuilding(buildingData.uuid, icon, soldierNum)
    else
      Logger.LogError("Cant find SoldierTempalte: soldierId" .. t.soldierItemId)
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.CollectSoldier, false)
    EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, buildingData.uuid)
  end
end

return LWClaimSparkSoldierMessage
