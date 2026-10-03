local BuildingCampCollectMessage = BaseClass("BuildingCampCollectMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  else
    DataCenter.BuildManager:HandleProduceBuildingUpgrade(message)
    if message.buildInfo.uuid ~= nil then
      local uuid = message.buildInfo.uuid
      local buildItemId = message.buildInfo.bId
      local icon = ""
      if buildItemId == BuildingTypes.LW_BUILD_MILITARY_CAMP then
        local collectCount = message.sNum
        local itemId = DataCenter.SoldierDataManager:GetSoldierIdByLevel(message.sLevel)
        local soldierDataTemplate = DataCenter.SoldierDataManager:GetTemplate(itemId)
        if soldierDataTemplate then
          icon = DataCenter.SoldierDataManager:GetPlayerSelfSoldierIconByTmp(soldierDataTemplate)
          DataCenter.LWCityPerformNpcManager:GetUtil():MilitaryCampCollectSolder(uuid, itemId, collectCount)
          DataCenter.ProductLineManager:ShowCollectEffectForBuilding(uuid, icon, collectCount)
        else
          Logger.LogError("Cant find SoldierTempalte: level" .. message.sLevel .. " id:" .. itemId)
        end
        EventManager:GetInstance():Broadcast(EventId.GF_building_training_collect, message.buildInfo)
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.CollectSoldier, false)
      elseif buildItemId == BuildingTypes.LW_BUILD_SMITH_SHOP then
        local itemId = message.equipId
        icon = string.format(LoadPath.ItemPath, DataCenter.EquipTemplateManager:GetEquipIconById(itemId))
        DataCenter.ProductLineManager:ShowCollectEffectForBuilding(uuid, icon, 1)
        local rewardMessage = {}
        rewardMessage.reward = {}
        local rewardData = {}
        rewardData.type = RewardType.EQUIP
        rewardData.value = {}
        rewardData.value.id = message.equipId
        rewardData.value.add = 1
        table.insert(rewardMessage.reward, rewardData)
        DataCenter.RewardManager:ShowCommonReward(rewardMessage)
      elseif buildItemId == BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY then
        local itemId = message.chipId
        icon = string.format(LoadPath.ItemPath, BuildBubbleIconName.TacticalChipFactoryBubble)
        DataCenter.ProductLineManager:ShowCollectEffectForBuilding(uuid, icon, 1)
        local rewardMessage = {}
        rewardMessage.reward = {}
        local rewardData = {}
        rewardData.type = RewardType.TWSkillChip
        rewardData.value = {}
        rewardData.value.updates = {}
        local chipData = {}
        chipData.cfgId = itemId
        chipData.num = 1
        chipData.uuid = message.uuid
        table.insert(rewardData.value.updates, chipData)
        table.insert(rewardMessage.reward, rewardData)
        DataCenter.RewardManager:ShowCommonReward(rewardMessage)
      end
    end
  end
end

BuildingCampCollectMessage.OnCreate = OnCreate
BuildingCampCollectMessage.HandleMessage = HandleMessage
return BuildingCampCollectMessage
