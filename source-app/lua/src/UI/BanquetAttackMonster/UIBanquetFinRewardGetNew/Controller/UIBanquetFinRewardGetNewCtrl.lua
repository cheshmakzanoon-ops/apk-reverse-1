local UIBanquetFinRewardGetNewCtrl = BaseClass("UIBanquetFinRewardGetNewCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local NormalCard = require("UI.BanquetAttackMonster.UIBanquetFinRewardGetNew.Component.BountyHunterNormalLogCardComponent")
local TabType = {CurStoreReward = 1, AlreadyClaimReward = 2}
local CardType = {NormalMonsterCard = 1, BossCard = 2}
local eConfig = {
  [CardType.NormalMonsterCard] = {
    Prefab = "BountyHunterNormalLogCard",
    Script = NormalCard
  },
  [CardType.BossCard] = {
    Prefab = "BountyHunterBossLogCard",
    Script = NormalCard
  }
}

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBanquetFinRewardGetNew)
end

function UIBanquetFinRewardGetNewCtrl:GetRewardDataByTabType(tabType)
  if tabType == TabType.CurStoreReward then
    return DataCenter.ActBanquetV2Data:GetExtraReward()
  else
    return DataCenter.ActBanquetV2Data:GetHistoryRewardList()
  end
end

function UIBanquetFinRewardGetNewCtrl:GetRewardNoneTipsKey(tabType)
  if tabType == TabType.CurStoreReward then
    return "activity_partynew_record_desc2"
  else
    return "activity_partynew_record_desc3"
  end
end

function UIBanquetFinRewardGetNewCtrl:ReqClaimStashReward(activityId)
  local curStashReward = DataCenter.ActBanquetV2Data:GetExtraReward()
  if not curStashReward or #curStashReward <= 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2ExtraReward, activityId)
end

function UIBanquetFinRewardGetNewCtrl:ReqBatLogData(activityId, partyNewId)
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2GetHistory, activityId, partyNewId)
end

function UIBanquetFinRewardGetNewCtrl:GetBatLogDataCnt(activityId)
  local battleLogList = DataCenter.ActBanquetV2Data:GetBattleLogList()
  return #battleLogList
end

function UIBanquetFinRewardGetNewCtrl:GetItemByIndex(activityId, index)
  local battleLogList = DataCenter.ActBanquetV2Data:GetBattleLogList()
  return battleLogList[index]
end

function UIBanquetFinRewardGetNewCtrl:GetPrefabAndScriptName(data)
  if not data then
    return
  end
  local prefabName, scriptName, cardType
  local configId = data.cfgId
  local curMonsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(configId)
  local type = curMonsterTemp.type
  if type == 1 then
    cardType = CardType.NormalMonsterCard
  else
    cardType = CardType.BossCard
  end
  prefabName = eConfig[cardType].Prefab
  scriptName = eConfig[cardType].Script
  return prefabName, scriptName
end

UIBanquetFinRewardGetNewCtrl.CloseSelf = CloseSelf
return UIBanquetFinRewardGetNewCtrl
