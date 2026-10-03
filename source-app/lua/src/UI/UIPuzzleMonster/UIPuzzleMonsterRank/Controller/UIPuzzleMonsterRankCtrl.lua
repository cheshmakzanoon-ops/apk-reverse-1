local UIPuzzleMonsterRankCtrl = BaseClass("UIPuzzleMonsterRankCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIPuzzleMonsterRank)
end

local function GetBossRankData(self, uuid)
  local data = DataCenter.ActivityPuzzleDataManager:GetBossRankDataByUuid(uuid)
  if data ~= nil then
    return data
  end
  return {}
end

local function GetActivityRewardList(self, uuid)
  local list = DataCenter.ActivityPuzzleDataManager:GetBossRankReward()
  if list ~= nil then
    return list
  end
  return {}
end

UIPuzzleMonsterRankCtrl.CloseSelf = CloseSelf
UIPuzzleMonsterRankCtrl.GetActivityRewardList = GetActivityRewardList
UIPuzzleMonsterRankCtrl.GetBossRankData = GetBossRankData
return UIPuzzleMonsterRankCtrl
