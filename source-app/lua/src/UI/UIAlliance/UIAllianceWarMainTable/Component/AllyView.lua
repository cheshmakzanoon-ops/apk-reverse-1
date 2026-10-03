local AllyView = BaseClass("AllyView", UIBaseContainer)
local base = UIBaseContainer
local UILWAllianceWarningItem = require("UI.UIAlliance.UIAllianceWarMainTable.Component.UILWAllianceWarningItem")
local UILWAllianceWarningEffect = require("UI.UIAlliance.UIAllianceWarMainTable.Component.UILWAllianceWarningEffect")
local Localization = CS.GameEntry.Localization

function AllyView:OnCreate()
  base.OnCreate(self)
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "Viewport/Content")
  self.ScrollView = self:AddComponent(UILoopListView2, "")
  self.ScrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

function AllyView:OnDestroy()
  self:Clear()
  base.OnDestroy(self)
end

function AllyView:Clear()
  self.items = {}
  self.content:RemoveComponents(UILWAllianceWarningItem)
  self.content:RemoveComponents(UILWAllianceWarningEffect)
  self.ScrollView:ClearAllItems()
end

function AllyView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AlOfficialSkillAlertEffect, self.CheckAOSAlertEffect)
end

function AllyView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AlOfficialSkillAlertEffect, self.CheckAOSAlertEffect)
end

function AllyView:ReInit()
  self:CreateList()
end

function AllyView:CheckAOSAlertEffect()
  self:CreateList()
end

function AllyView:CreateList(index, isRefreshAlert)
  local data = self.view.ctrl:GetAllianceWarIdList(3, self.arrowUuid)
  local dataCount = #data
  self.dataList = data
  self.ScrollView:SetListItemCount(dataCount, false, false)
  self.ScrollView:RefreshAllShownItem()
  DataCenter.AllianceAlertDataManager:UpdateLastReadTimeS()
  if self.view and self.view.ShowEmptyLang then
    self.view:ShowEmptyLang(dataCount == 0)
  end
end

function AllyView:RefreshAlertItem(index)
  self:CreateList()
end

function AllyView:TryGetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem
  local data = dataList[index]
  local theScript
  if data.effectType == AlAlertType.AresMissile or data.effectType == AlAlertType.MissileFactory or data.effectType == AlAlertType.GoddessMummy then
    csItem = listview:NewListViewItem("UILWAllianceWarningEffect")
    theScript = UILWAllianceWarningEffect
  else
    csItem = listview:NewListViewItem("UILWAllianceWarningItem")
    theScript = UILWAllianceWarningItem
  end
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "Cell" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(theScript, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:SetData(data)
    self.items[csItem]:RefreshData(true)
  end
  return csItem
end

return AllyView
