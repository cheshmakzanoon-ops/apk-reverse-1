local TacticalChipCollectMessage = BaseClass("TacticalChipCollectMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildManager:HandleProduceBuildingUpgrade(message)
    if message.buildInfo.uuid ~= nil then
      local uuid = message.buildInfo.uuid
      local buildItemId = message.buildInfo.bId
      local icon = ""
      if buildItemId == BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY then
        local itemId = message.chipId
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

TacticalChipCollectMessage.OnCreate = OnCreate
TacticalChipCollectMessage.HandleMessage = HandleMessage
return TacticalChipCollectMessage
