local base = UIBaseContainer
local UILWMailDetailMuster = BaseClass("UILWMailDetailMuster", UIBaseContainer)
local MailArmyCell = require("UI.UILWMail.UILWMailMain.Component.MailArmyCell")
local MailRoundCell = require("UI.UILWMail.UILWMailMain.Component.MailRoundCell")
local UILWMailDetailMusterHead = require("UI.UILWMail.UILWMailMain.Component.UILWMailDetailMusterHead")
local MusterDropdown = require("UI.UILWMail.UILWMailMain.Component.MusterDropdown")

function UILWMailDetailMuster:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailMuster:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailMuster:DataDefine()
  self.mailUid = {}
  self.mailData = {}
  self.totalCount = 0
end

function UILWMailDetailMuster:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
  self.totalCount = 0
  self.armyCount = 0
  self.roundCount = 0
end

function UILWMailDetailMuster:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailMuster:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailMuster:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailMuster:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailMuster:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  self.loopListView = self:AddComponent(UILoopListView2, "ScrollView")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.items = {}
end

function UILWMailDetailMuster:ComponentDestroy()
  self.items = {}
  self.content:RemoveComponents(UILWMailDetailMusterHead)
  self.content:RemoveComponents(MailRoundCell)
  self.content:RemoveComponents(MailArmyCell)
  self.content:RemoveComponents(MusterDropdown)
  self.loopListView:ClearAllItems()
end

function UILWMailDetailMuster:RefreshContent()
  self:RefreshData()
  self:RefreshView(true)
end

function UILWMailDetailMuster:RefreshData()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  self.extData = self.mailData:GetMailExt()
  self.armyData = self.extData.army
  self.roundData = self.extData.round
  self.toggleIsOn = false
end

function UILWMailDetailMuster:RefreshView(scrollToTop)
  if scrollToTop then
    self.content:SetAnchoredPosition(Vector2.zero)
  end
  local armyCount = table.count(self.armyData)
  local roundCount = table.count(self.roundData)
  if self.toggleIsOn then
    self.armyCount = armyCount
    self.roundCount = roundCount
    self.showDropDown = true
  else
    self.armyCount = math.min(armyCount, 10)
    self.roundCount = roundCount
    self.showDropDown = 10 < armyCount
  end
  local totalCount = self.showDropDown and 2 + self.armyCount + roundCount or 1 + self.armyCount + roundCount
  self.totalCount = totalCount
  self.loopListView:SetListItemCount(totalCount, false, false)
  self.loopListView:RefreshAllShownItem()
end

function UILWMailDetailMuster:OnClickToggle(bool)
  if self.toggleIsOn == bool then
    return
  end
  self.toggleIsOn = bool
  self:RefreshView(false)
end

function UILWMailDetailMuster:GetScrollItem(listview, index)
  if index < 0 or index >= self.totalCount then
    return nil
  end
  local csItem
  if index == 0 then
    csItem = listview:NewListViewItem("TableHead")
    if self.items[csItem] == nil then
      NameCount = NameCount + 1
      local nameStr = "TableHead" .. NameCount
      csItem.gameObject.name = nameStr
      local mailItem = self.content:AddComponent(UILWMailDetailMusterHead, nameStr)
      self.items[csItem] = mailItem
    end
    self.items[csItem]:RefreshContent()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.items[csItem].transform)
  elseif index <= self.armyCount then
    csItem = listview:NewListViewItem("ArmyCell")
    if self.items[csItem] == nil then
      NameCount = NameCount + 1
      local nameStr = "ArmyCell" .. NameCount
      csItem.gameObject.name = nameStr
      local mailItem = self.content:AddComponent(MailArmyCell, nameStr)
      self.items[csItem] = mailItem
    end
    self.items[csItem]:SetData(self.armyData[index])
  elseif self.showDropDown and index == self.armyCount + 1 then
    csItem = listview:NewListViewItem("Dropdown")
    if self.items[csItem] == nil then
      NameCount = NameCount + 1
      local nameStr = "Dropdown" .. NameCount
      csItem.gameObject.name = nameStr
      local mailItem = self.content:AddComponent(MusterDropdown, nameStr)
      self.items[csItem] = mailItem
    end
    self.items[csItem]:SetData(self, self.toggleIsOn)
  else
    csItem = listview:NewListViewItem("RoundCell")
    if self.items[csItem] == nil then
      NameCount = NameCount + 1
      local nameStr = "RoundCell" .. NameCount
      csItem.gameObject.name = nameStr
      local mailItem = self.content:AddComponent(MailRoundCell, nameStr)
      self.items[csItem] = mailItem
    end
    local dataIndex = self.showDropDown and index - self.armyCount - 1 or index - self.armyCount
    self.items[csItem]:SetData(self.roundData[dataIndex], self.mailUid)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.items[csItem].transform)
  end
  return csItem
end

return UILWMailDetailMuster
