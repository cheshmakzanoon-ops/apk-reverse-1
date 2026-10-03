local LWUIBerserkBossRankCtrl = BaseClass("LWUIBerserkBossRankCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIBerserkBossRankCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIBerserkBossRank)
end

function LWUIBerserkBossRankCtrl:GetTabViewData()
  self.tabViewData = {}
  table.insert(self.tabViewData, {
    tabType = LWUIBerserkBossRankTabType.TotalPersonalDamage,
    tabName = Localization:GetString("activity_berserkboss_title_07"),
    bossUuid = 0
  })
  local berserkBossList = DataCenter.LWBerserkBossManager:GetAllBerserkBossInfoList()
  for i = 1, table.count(berserkBossList) do
    local berserkBossInfo = berserkBossList[i]
    local monsterName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), berserkBossInfo.monsterId, "name")
    table.insert(self.tabViewData, {
      tabType = LWUIBerserkBossRankTabType.Boss,
      tabName = Localization:GetString(monsterName),
      bossUuid = berserkBossInfo.uuid
    })
  end
  table.insert(self.tabViewData, {
    tabType = LWUIBerserkBossRankTabType.TotalAllianceDamage,
    tabName = Localization:GetString("activity_berserkboss_title_08"),
    bossUuid = 0
  })
  return self.tabViewData
end

return LWUIBerserkBossRankCtrl
