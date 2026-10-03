local LWUIWorldBossRankCtrl = BaseClass("LWUIWorldBossRankCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIWorldBossRankCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIWorldBossRank)
end

function LWUIWorldBossRankCtrl:GetBossRankData(actId)
  local data = DataCenter.ActBossDataManager:GetBossRankDataByActId(actId)
  if data ~= nil then
    return data
  end
  return {}
end

return LWUIWorldBossRankCtrl
