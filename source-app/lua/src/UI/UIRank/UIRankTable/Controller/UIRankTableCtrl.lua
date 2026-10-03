local UIRankTableCtrl = BaseClass("UIRankTableCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIRankTableCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRankTable)
end

function UIRankTableCtrl:CloseAll()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerDetail)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIRankTable)
end

function UIRankTableCtrl:GetRankTypeList()
  local showList = {}
  table.insert(showList, {
    type = RankingTypeServer.POWER_ALLIANCE,
    title = Localization:GetString("129094")
  })
  table.insert(showList, {
    type = RankingTypeServer.KILL_ALLIANCE,
    title = Localization:GetString("129093")
  })
  table.insert(showList, {
    type = RankingTypeServer.POWER,
    title = Localization:GetString("129096")
  })
  table.insert(showList, {
    type = RankingTypeServer.BUILDING,
    title = Localization:GetString("129097")
  })
  table.insert(showList, {
    type = RankingTypeServer.KILL,
    title = Localization:GetString("129095")
  })
  table.insert(showList, {
    type = RankingTypeServer.PVE_STAGE,
    title = Localization:GetString("451034")
  })
  table.insert(showList, {
    type = RankingTypeServer.HERO_TOTAL_POWER,
    title = Localization:GetString("451035")
  })
  table.insert(showList, {
    type = RankingTypeServer.ONE_HERO_POWER,
    title = Localization:GetString("451036")
  })
  table.insert(showList, {
    type = RankingTypeServer.TRIAL_TOWER_TANK,
    title = Localization:GetString("trialtower_024")
  })
  table.insert(showList, {
    type = RankingTypeServer.TRIAL_TOWER_AIRPLANE,
    title = Localization:GetString("trialtower_025")
  })
  table.insert(showList, {
    type = RankingTypeServer.TRIAL_TOWER_MISSILE,
    title = Localization:GetString("trialtower_026")
  })
  if DataCenter.DomintorStageManager:IsShow() then
    table.insert(showList, {
      type = RankingTypeServer.DOMINATOR_UP_PVE,
      title = Localization:GetString("armed_truck_dominator_rank_title")
    })
  end
  return showList
end

function UIRankTableCtrl:OnRankItemClick(global, theType, serverId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankDetailList, {anim = true, hideTop = false}, global, theType, serverId)
end

return UIRankTableCtrl
