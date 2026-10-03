local CommonTabGroupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local SeasonMoneyRankLogCtrl = BaseClass("SeasonMoneyRankLogCtrl", UIBaseCtrl)

function SeasonMoneyRankLogCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonMoneyRankLog)
end

function SeasonMoneyRankLogCtrl:GetTabListData()
  local tabList = {}
  for i = 1, 4 do
    local tabData = CommonTabGroupItemTemplate.New()
    tabData.title = CS.GameEntry.Localization:GetString(DataCenter.SeasonMoneyRankManager.LogTabTitle[i])
    table.insert(tabList, tabData)
  end
  return tabList
end

return SeasonMoneyRankLogCtrl
