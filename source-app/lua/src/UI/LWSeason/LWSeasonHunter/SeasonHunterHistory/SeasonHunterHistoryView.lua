local base = UIBaseView
local SeasonHunterHistory = BaseClass("SeasonHunterHistory", base)
local SeasonHunterHistoryItem = require("UI.LWSeason.LWSeasonHunter.Component.SeasonHunterHistoryItem")
local Localization = CS.GameEntry.Localization
local btnBack_path = "safearea/BtnClose"
local panel_path = "Panel"
local txtTitle_path = "safearea/TopBar/TextTitle"
local emptyDes_path = "safearea/MiddleContentContainer/noLogTxt"
local scrollView_path = "safearea/MiddleContentContainer/ScrollView"
local content_path = "safearea/MiddleContentContainer/ScrollView/Viewport/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView(true)
end

local function OnDestroy(self)
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
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.emptyDes = self:AddComponent(UIText, emptyDes_path)
  self.scrollView = self:AddComponent(UILoopListView2, scrollView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.txtTitle:SetLocalText("season_s4_activity_1200011_name11")
  self.scrollView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnBack = nil
  self.panel = nil
  self.txtTitle = nil
  self.emptyDes = nil
  self.scrollView = nil
  self.content = nil
end

local function DataDefine(self)
  self.itemIndex = 0
  self.dataList = {}
end

local function DataDestroy(self)
end

function SeasonHunterHistory:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonHunterGetMatchHistory, self.SeasonHunterGetMatchHistory)
end

function SeasonHunterHistory:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonHunterGetMatchHistory, self.SeasonHunterGetMatchHistory)
  base.OnRemoveListener(self)
end

function SeasonHunterHistory:ClearScroll()
  self.content:RemoveComponents(SeasonHunterHistoryItem)
  self.scrollView:ClearAllItems()
end

function SeasonHunterHistory:SeasonHunterGetMatchHistory()
  self:RefreshView()
end

function SeasonHunterHistory:RefreshView(sendMsg)
  self.dataList = DataCenter.SeasonHunterManager:GetMatchHistory(sendMsg)
  local count = self.dataList and #self.dataList or 0
  if 0 < count then
    for i, v in ipairs(self.dataList) do
      v.isOpened = false
    end
    self.scrollView:SetListItemCount(count, false, false)
    self.scrollView:RefreshAllShownItem()
    self.scrollView:SetActive(true)
    self.emptyDes:SetActive(false)
  else
    self.scrollView:SetActive(false)
    self.emptyDes:SetActive(true)
  end
end

function SeasonHunterHistory:GetScrollItem(listView, index)
  local count = table.count(self.dataList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local data = self.dataList[index]
  local scriptItem = SeasonHunterHistoryItem
  local item = listView:NewListViewItem(scriptItem.__cname)
  local script = self.content:GetComponent(item.gameObject.name, scriptItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(scriptItem, objectName)
  end
  script:ReInit(index, data, self.OnItemSizeChanged, self)
  script:SetActive(true)
  return item
end

function SeasonHunterHistory:OnItemSizeChanged(index)
  self.scrollView:OnItemSizeChanged(index - 1)
end

SeasonHunterHistory.OnCreate = OnCreate
SeasonHunterHistory.OnDestroy = OnDestroy
SeasonHunterHistory.OnEnable = OnEnable
SeasonHunterHistory.OnDisable = OnDisable
SeasonHunterHistory.ComponentDefine = ComponentDefine
SeasonHunterHistory.ComponentDestroy = ComponentDestroy
SeasonHunterHistory.DataDefine = DataDefine
SeasonHunterHistory.DataDestroy = DataDestroy
return SeasonHunterHistory
