local UIActBountyHunterRewardCtrl = BaseClass("UIActBountyHunterRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local NormalCard = require("UI.LWUIActBountyHunter.LWUIActBountyHunterReward.Component.BountyHunterNormalLogCardComponent")
local TabType = {CurStoreReward = 1, AlreadyClaimReward = 2}
local CardType = {NormalCard = 1, BossCard = 2}
local eConfig = {
  [CardType.NormalCard] = {
    Prefab = "BountyHunterNormalLogCard",
    Script = NormalCard
  },
  [CardType.BossCard] = {
    Prefab = "BountyHunterBossLogCard",
    Script = NormalCard
  }
}

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BountyHunterReward)
end

function UIActBountyHunterRewardCtrl:GetRewardDataByTabType(params, tabType)
  local activityId = toInt(params)
  if not activityId then
    return nil
  end
  local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
  if not actData then
    return nil
  end
  if tabType == TabType.CurStoreReward then
    return actData:GetCurStashRewardData()
  else
    return actData:GetHistoryClaimRewardData()
  end
end

function UIActBountyHunterRewardCtrl:ReqClaimStashReward(activityId)
  local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
  if not actData then
    return
  end
  local curStashReward = actData:GetCurStashRewardData()
  if not curStashReward or #curStashReward <= 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BountyHunterReceiveDropReward, activityId)
end

function UIActBountyHunterRewardCtrl:ReqBatLogData(activityId)
  local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
  if not actData then
    return
  end
  local batLogDataList = actData:GetBatLogData()
  if not batLogDataList or #batLogDataList <= 0 then
    SFSNetwork.SendMessage(MsgDefines.BountyHunterGetLogInfo, activityId)
    return
  end
  return batLogDataList
end

function UIActBountyHunterRewardCtrl:GetBatLogDataCnt(activityId)
  local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
  if not actData then
    return 0
  end
  local realCount = #actData.batLogArr or 0
  local maxLimit = actData:GetBatLogShowCountLimit()
  if 0 <= maxLimit and realCount > maxLimit then
    return maxLimit
  end
  return realCount
end

function UIActBountyHunterRewardCtrl:GetItemByIndex(activityId, index)
  local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
  if not actData then
    return
  end
  return actData.batLogArr[index]
end

function UIActBountyHunterRewardCtrl:GetPrefabAndScriptName(data)
  if not data then
    return
  end
  local prefabName, scriptName, cardType
  local configId = data.confId
  local isBoss = false
  local lineData = LocalController:instance():tryGetLine(TableName.Bounty_Monster, configId)
  if lineData and lineData.type == BountyMonsterQualityType.Boss then
    isBoss = true
  end
  if isBoss then
    cardType = CardType.BossCard
  else
    cardType = CardType.NormalCard
  end
  prefabName = eConfig[cardType].Prefab
  scriptName = eConfig[cardType].Script
  return prefabName, scriptName
end

UIActBountyHunterRewardCtrl.CloseSelf = CloseSelf
return UIActBountyHunterRewardCtrl
