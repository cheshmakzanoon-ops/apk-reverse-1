local UIDispathTreasureExchangeLogView = BaseClass("UIDispathTreasureExchangeLogView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDispathTreasureExchangeLogToggle = require("UI.UIDispatchTask.Treasure.ExchangeLog.Component.UIDispathTreasureExchangeLogToggle")
local UIDispathTreasureExchangeLogCell = require("UI.UIDispatchTask.Treasure.ExchangeLog.Component.UIDispathTreasureExchangeLogCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.ownToggle = self:AddComponent(UIDispathTreasureExchangeLogToggle, "Root/Content/ContentHolder/TabGroup/OwnToggle")
  self.allianceToggle = self:AddComponent(UIDispathTreasureExchangeLogToggle, "Root/Content/ContentHolder/TabGroup/AllianceToggle")
  self.levelTabGroup = self:AddComponent(UIBaseContainer, "Root/Content/ContentHolder/LevelTabGroupBg/LevelTabGroup")
  self.scrollView = self:AddComponent(UIScrollView, "Root/Content/ContentHolder/ScrollView")
  self.content = self:AddComponent(UIBaseContainer, "Root/Content/ContentHolder/ScrollView/Viewport/Content")
  self.textEmpty = self:AddComponent(UIText, "Root/Content/ContentHolder/TxtEmpty")
  self.panelclose = self:AddComponent(UIButton, "Panel")
  self.btnClose = self:AddComponent(UIButton, "Root/Content/UICommonPopBg/bg_3/CloseBtn")
  self.titleText = self:AddComponent(UIText, "Root/Content/UICommonPopBg/bg_3/TitleTxt")
  self.titleText:SetLocalText("Treasure_map_22")
  self.btnClose:SetOnClick(Bind(self.ctrl, self.ctrl.CloseSelf))
  self.panelclose:SetOnClick(Bind(self.ctrl, self.ctrl.CloseSelf))
  self.ownToggle:SetTitleText(Localization:GetString("Treasure_map_57"))
  self.ownToggle:SetOnValueChanged(function(tf)
    if tf then
      self:SelectTab(1, 1)
    end
  end)
  self.allianceToggle:SetTitleText(Localization:GetString("Treasure_map_58"))
  self.allianceToggle:SetOnValueChanged(function(tf)
    if tf then
      self:SelectTab(2, 1)
    end
  end)
  self.lvToggles = {}
  for i = 0, self.levelTabGroup.transform.childCount - 1 do
    local itemObj = self.levelTabGroup.transform:GetChild(i).gameObject
    local item = self.levelTabGroup:AddComponent(UIDispathTreasureExchangeLogToggle, itemObj.name)
    item:SetOnValueChanged(function(tf)
      if tf then
        self:SelectLvTab(i + 1)
      end
    end)
    if i == 0 then
      item:SetTitleText(Localization:GetString("Treasure_map_59"))
    else
      item:SetTitleText(DataCenter.SplinterExchangeManager:GetIndexStrByIndex(SplinterExchangeType.DispatchTreasure.Id, i))
    end
    table.insert(self.lvToggles, item)
  end
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.ownToggle = nil
  self.allianceToggle = nil
  self.levelTabGroup = nil
  self.scrollView = nil
  self.content = nil
  self.textEmpty = nil
  self.panelclose = nil
  self.btnClose = nil
end

local function DataDefine(self)
  self.scrollCellPool = {}
  self.itemIndex = 1
  local selectTab, lvSelectTab = self:GetUserData()
  if selectTab == nil then
    selectTab = 1
  end
  if lvSelectTab == nil then
    lvSelectTab = 1
  end
  self:SelectTab(selectTab, lvSelectTab)
end

local function DataDestroy(self)
  self.selectTab = nil
  self.lvSelectTab = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.DispatchTreasureRefreshLog, self.OnRefreshRecordData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.DispatchTreasureRefreshLog, self.OnRefreshRecordData)
  base.OnRemoveListener(self)
end

local function SelectTab(self, index, lvIndex)
  if self.selectTab == index then
    return
  end
  self.selectTab = index
  if index == 1 then
    self.ownToggle:SetSelect()
    self.allianceToggle:SetUnSelect()
  else
    self.ownToggle:SetUnSelect()
    self.allianceToggle:SetSelect()
  end
  self.lvSelectTab = nil
  self:SelectLvTab(lvIndex or 1)
end

local function SelectLvTab(self, index)
  if self.lvSelectTab == index then
    return
  end
  self.lvSelectTab = index
  for i, v in ipairs(self.lvToggles) do
    if i == self.lvSelectTab then
      v:SetSelect()
    else
      v:SetUnSelect()
    end
  end
  self:Refresh()
end

local function Refresh(self)
  local data = DataCenter.ActDispatchTreasureManager:GetLogByTypeAndLv(self.selectTab, self.lvSelectTab)
  if data and 0 < #data then
    self.textEmpty:SetActive(false)
    self.scrollView:SetActive(true)
    self.showDatalist = data
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.textEmpty:SetActive(true)
    self.scrollView:SetActive(false)
  end
end

local function OnRefreshRecordData(self, logType)
  if self.selectTab == logType then
    self:Refresh()
  end
end

local function OnItemMoveIn(self, itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UIDispathTreasureExchangeLogCell, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(self.showDatalist[index], self.selectTab)
end

local function OnItemMoveOut(self, itemObj, index)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIDispathTreasureExchangeLogCell)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

UIDispathTreasureExchangeLogView.OnCreate = OnCreate
UIDispathTreasureExchangeLogView.OnDestroy = OnDestroy
UIDispathTreasureExchangeLogView.OnEnable = OnEnable
UIDispathTreasureExchangeLogView.OnDisable = OnDisable
UIDispathTreasureExchangeLogView.ComponentDefine = ComponentDefine
UIDispathTreasureExchangeLogView.ComponentDestroy = ComponentDestroy
UIDispathTreasureExchangeLogView.DataDefine = DataDefine
UIDispathTreasureExchangeLogView.DataDestroy = DataDestroy
UIDispathTreasureExchangeLogView.OnAddListener = OnAddListener
UIDispathTreasureExchangeLogView.OnRemoveListener = OnRemoveListener
UIDispathTreasureExchangeLogView.SelectTab = SelectTab
UIDispathTreasureExchangeLogView.SelectLvTab = SelectLvTab
UIDispathTreasureExchangeLogView.Refresh = Refresh
UIDispathTreasureExchangeLogView.OnRefreshRecordData = OnRefreshRecordData
UIDispathTreasureExchangeLogView.OnItemMoveIn = OnItemMoveIn
UIDispathTreasureExchangeLogView.OnItemMoveOut = OnItemMoveOut
UIDispathTreasureExchangeLogView.ClearScroll = ClearScroll
return UIDispathTreasureExchangeLogView
