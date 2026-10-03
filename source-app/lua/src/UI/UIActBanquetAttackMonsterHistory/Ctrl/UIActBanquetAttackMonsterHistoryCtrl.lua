local UIActBanquetAttackMonsterHistoryCtrl = BaseClass("UIActBanquetAttackMonsterHistoryCtrl", UIBaseCtrl)
local NormalCard = require("UI.UIActBanquetAttackMonsterHistory.Component.BanquetAttackNormalLogCard")
local eConfig = {
  [ActUIBanquetHistoryLogType.KillZombie] = {
    Prefab = "ActBanquetAttackBossLogCard",
    Script = NormalCard
  },
  [ActUIBanquetHistoryLogType.FlowerCar] = {
    Prefab = "ActBanquetAttackBossLogCard",
    Script = NormalCard
  }
}

function UIActBanquetAttackMonsterHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActBanquetAttackMonsterHistory)
end

function UIActBanquetAttackMonsterHistoryCtrl:ReqBatLogData(activityId, partyNewId)
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2GetHistory, activityId, partyNewId)
end

function UIActBanquetAttackMonsterHistoryCtrl:GetHistoryReward()
  return DataCenter.ActBanquetV2Data:GetHistoryRewardList()
end

function UIActBanquetAttackMonsterHistoryCtrl:GetExtraReward()
  return DataCenter.ActBanquetV2Data:GetExtraReward()
end

function UIActBanquetAttackMonsterHistoryCtrl:GetBatLogDataCnt()
  local battleLogList = DataCenter.ActBanquetV2Data:GetBattleLogList()
  return #battleLogList
end

function UIActBanquetAttackMonsterHistoryCtrl:GetBatLogDataByIndex(index)
  local battleLogList = DataCenter.ActBanquetV2Data:GetBattleLogList()
  return battleLogList[index]
end

function UIActBanquetAttackMonsterHistoryCtrl:ReqClaimStashReward(activityId)
  local curStashReward = DataCenter.ActBanquetV2Data:GetExtraReward()
  if not curStashReward or #curStashReward <= 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2ExtraReward, activityId)
end

function UIActBanquetAttackMonsterHistoryCtrl:GetHasUsedIcon()
  local actBanquetTemplate = DataCenter.ActBanquetV2Data:GetTemplate()
  local costItem1PicPath = ""
  if actBanquetTemplate then
    local costData = actBanquetTemplate.cost_item
    if costData[1] == BanquetAttackMonsterCostType.Resource then
      costItem1PicPath = DataCenter.RewardManager:GetPicByType(ResTypeToReward[costData[2]], 0)
    elseif costData[1] == BanquetAttackMonsterCostType.Goods then
      costItem1PicPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(costData[2]))
    end
  end
  return costItem1PicPath
end

function UIActBanquetAttackMonsterHistoryCtrl:GetPrefabAndScriptName(data)
  if not data then
    return
  end
  local prefabName, scriptName
  local type = data.type or ActUIBanquetHistoryLogType.KillZombie
  prefabName = eConfig[type].Prefab
  scriptName = eConfig[type].Script
  return prefabName, scriptName
end

function UIActBanquetAttackMonsterHistoryCtrl:GetItemByIndex(activityId, index)
  local battleLogList = DataCenter.ActBanquetV2Data:GetBattleLogList()
  return battleLogList[index]
end

function UIActBanquetAttackMonsterHistoryCtrl:GetCostItems()
  return DataCenter.ActBanquetV2Data:GetCostItems()
end

return UIActBanquetAttackMonsterHistoryCtrl
