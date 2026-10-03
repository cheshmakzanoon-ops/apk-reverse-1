local LWClaimStageSoldierMessage = BaseClass("LWClaimStageSoldierMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, stageId, restSoilders)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  local soldierId = tonumber(message.soldierItemId)
  local soldierNum = tonumber(message.soldierNum)
  local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_COUNT_BATTLE)[1]
  local soldierDataTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
  if soldierDataTemplate then
    local icon = DataCenter.SoldierDataManager:GetPlayerSelfSoldierIconByTmp(soldierDataTemplate)
    DataCenter.LWCityPerformNpcManager:GetUtil():MilitaryCampCollectSolder(buildingData.uuid, soldierId, soldierNum)
    DataCenter.ProductLineManager:ShowCollectEffectForBuilding(buildingData.uuid, icon, soldierNum)
  else
    Logger.LogError("Cant find SoldierTempalte: soldierId" .. message.soldierItemId)
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.CollectSoldier, false)
  EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, buildingData.uuid)
end

LWClaimStageSoldierMessage.OnCreate = OnCreate
LWClaimStageSoldierMessage.HandleMessage = HandleMessage
return LWClaimStageSoldierMessage
