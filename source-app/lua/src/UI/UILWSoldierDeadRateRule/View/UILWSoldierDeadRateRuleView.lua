local base = UIBaseView
local UILWSoldierDeadRateRuleView = BaseClass("UILWSoldierDeadRateRuleView", base)
local Localization = CS.GameEntry.Localization
local SoldierDeadRuleGrid = require("UI.UILWSoldierDeadRateRule.Component.SoldierDeadRuleGrid")
local contentList_path = "PopUpTitle/Common_bg_orange2/contentScroll"
local contentContainer_path = "PopUpTitle/Common_bg_orange2/contentScroll/viewport/content"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_txt_path = "PopUpTitle/Common_img_title/titleText"
local closePanel_btn_path = "panel"
local tabs_path = {
  "PopUpTitle/tabs/tab1",
  "PopUpTitle/tabs/tab2",
  "PopUpTitle/tabs/tab3"
}
local tabSelecteds_path = {
  "PopUpTitle/tabs/tab1/selected1",
  "PopUpTitle/tabs/tab2/selected2",
  "PopUpTitle/tabs/tab3/selected3"
}
local tabBtns_path = {
  "PopUpTitle/tabs/tab1/btn1",
  "PopUpTitle/tabs/tab2/btn2",
  "PopUpTitle/tabs/tab3/btn3"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.showDatas = {}
  self.showDatas[1] = {}
  self.showDatas[1][1] = "soldier_death_rule_detail_1"
  self.showDatas[1][2] = {}
  local types = string.split(LuaEntry.DataConfig:TryGetStr("death_type_config", "k1", ""), ",")
  for i, key in ipairs(types) do
    local lineInfo = {
      name = string.format("soldier_death_type_%s", key)
    }
    local val1_num = LuaEntry.DataConfig:TryGetNum("Serious_injury_battle_config", string.format("k%s", key), 0)
    local val1_str = string.format("%d%%", val1_num)
    local val2_num = LuaEntry.DataConfig:TryGetNum("Dead_battle_config", string.format("k%s", key), 0)
    local val2_str = string.format("%d%%", val2_num)
    lineInfo.val1 = val1_str
    lineInfo.val2 = val2_str
    self.showDatas[1][2][i] = lineInfo
  end
  self.showDatas[2] = {
    "soldier_death_rule_detail_2"
  }
  self.showDatas[3] = {
    "soldier_death_rule_detail_3"
  }
  self:GotoTab(1)
end

local function OnDestroy(self)
  self.contentContainer:RemoveAllComponentes()
  self.contentList:ClearAllItems()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showData then
    return nil
  end
  local showInfo = self.showData[index]
  local item
  if type(showInfo) == "string" then
    item = loopScroll:NewListViewItem("desc_txt")
    local script = self.contentContainer:GetComponent(item.gameObject.name, UIText)
    if script == nil then
      local objectName = GetItemNameSequence(self)
      item.gameObject.name = objectName
      script = self.contentContainer:AddComponent(UIText, objectName)
    end
    script:SetLocalText(showInfo)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(script.rectTransform)
  else
    item = loopScroll:NewListViewItem("grid")
    local script = self.contentContainer:GetComponent(item.gameObject.name, SoldierDeadRuleGrid)
    if script == nil then
      local objectName = GetItemNameSequence(self)
      item.gameObject.name = objectName
      script = self.contentContainer:AddComponent(SoldierDeadRuleGrid, objectName)
    end
    script:SetActive(true)
    script:SetData(showInfo)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(script.rectTransform)
  end
  return item
end

local function ComponentDefine(self)
  self.contentList = self:AddComponent(UILoopListView2, contentList_path)
  self.contentContainer = self:AddComponent(UIBaseContainer, contentContainer_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.closePanel_btn = self:AddComponent(UIButton, closePanel_btn_path)
  self.tabs = {
    self:AddComponent(UIBaseContainer, tabs_path[1]),
    self:AddComponent(UIBaseContainer, tabs_path[2]),
    self:AddComponent(UIBaseContainer, tabs_path[3])
  }
  self.tabSelecteds = {
    self:AddComponent(UIBaseContainer, tabSelecteds_path[1]),
    self:AddComponent(UIBaseContainer, tabSelecteds_path[2]),
    self:AddComponent(UIBaseContainer, tabSelecteds_path[3])
  }
  self.tabBtns = {
    self:AddComponent(UIButton, tabBtns_path[1]),
    self:AddComponent(UIButton, tabBtns_path[2]),
    self:AddComponent(UIButton, tabBtns_path[3])
  }
  self.contentList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  for i = 1, #self.tabBtns do
    self.tabBtns[i]:SetOnClick(function()
      self:GotoTab(i)
    end)
  end
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closePanel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.contentList = nil
  self.contentContainer = nil
  self.close_btn = nil
  self.title_txt = nil
  self.closePanel_btn = nil
  self.tabs = nil
  self.tabSelecteds = nil
  self.tabBtns = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshList(self)
  self.showData = self.showDatas[self.curTab]
  self.contentList:SetListItemCount(#self.showData, false, false)
  self.contentList:RefreshAllShownItem()
end

local function GotoTab(self, tabIndex)
  if self.curTab ~= nil and self.curTab == tabIndex then
    return
  end
  self.curTab = tabIndex
  RefreshList(self)
  for i = 1, #self.tabSelecteds do
    self.tabSelecteds[i]:SetActive(i == tabIndex)
  end
end

UILWSoldierDeadRateRuleView.OnCreate = OnCreate
UILWSoldierDeadRateRuleView.OnDestroy = OnDestroy
UILWSoldierDeadRateRuleView.OnEnable = OnEnable
UILWSoldierDeadRateRuleView.OnDisable = OnDisable
UILWSoldierDeadRateRuleView.ComponentDefine = ComponentDefine
UILWSoldierDeadRateRuleView.ComponentDestroy = ComponentDestroy
UILWSoldierDeadRateRuleView.DataDefine = DataDefine
UILWSoldierDeadRateRuleView.DataDestroy = DataDestroy
UILWSoldierDeadRateRuleView.GotoTab = GotoTab
return UILWSoldierDeadRateRuleView
