local CommonTabGroupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local UILWSeasonMilitaryEliteLogCtrl = BaseClass("UILWSeasonMilitaryEliteLogCtrl", UIBaseCtrl)

function UILWSeasonMilitaryEliteLogCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonMilitaryEliteLog)
end

function UILWSeasonMilitaryEliteLogCtrl:GetTabListData()
  local tabList = {}
  for i = 1, 4 do
    local tabData = CommonTabGroupItemTemplate.New()
    tabData.title = CS.GameEntry.Localization:GetString(DataCenter.SeasonMilitaryEliteManager.LogTabTitle[i])
    table.insert(tabList, tabData)
  end
  return tabList
end

return UILWSeasonMilitaryEliteLogCtrl
