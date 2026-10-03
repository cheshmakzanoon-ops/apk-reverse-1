local LWUIMonsterInvasionRankCtrl = BaseClass("LWUIMonsterInvasionRankCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIMonsterInvasionRankCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIMonsterInvasionRank)
end

function LWUIMonsterInvasionRankCtrl:GetRankData(actId)
  local data = DataCenter.ActivityMonsterInvasionDataManager:GetRankDataByActId(actId)
  if data ~= nil then
    return data
  end
  return {}
end

return LWUIMonsterInvasionRankCtrl
