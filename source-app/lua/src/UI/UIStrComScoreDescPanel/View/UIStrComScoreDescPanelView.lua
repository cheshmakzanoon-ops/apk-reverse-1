local base = UIBaseView
local UIStrComScoreDescPanelView = BaseClass("UIStrComScoreDescPanelView", base)
local Localization = CS.GameEntry.Localization
local UIStrComScoreMethodItem = require("UI.UIStrComScoreDescPanel.Component.UIStrComScoreMethodItem")
local UIGray = CS.UIGray
local bgPanelPath = "Panel"
local closeBtnPath = "UICommonPopUpTitle/CloseBtn"
local methodScrollPath = "Root/MethodScroll"
local methodScrollContentPath = "Root/MethodScroll/Viewport/Content"
local desc_text_path = "Root/DescText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.methodList, self.selectedStage, self.curStage = self:GetUserData()
  if not self.methodList then
    self.ctrl:CloseSelf()
    return
  end
  self:RefreshView()
end

local function ClearScroll(self)
  self.methodScrollContent:RemoveComponents(UIStrComScoreMethodItem)
  self.methodScroll:ClearAllItems()
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.dataList then
    return nil
  end
  local data = self.dataList[index]
  if data == "line" then
    local item = loopScroll:NewListViewItem("LineItem")
    return item
  else
    local item = loopScroll:NewListViewItem("MethodItem")
    local script = self.methodScrollContent:GetComponent(item.gameObject.name, UIStrComScoreMethodItem)
    if script == nil then
      local objectName = tostring(self.itemIndex)
      self.itemIndex = self.itemIndex + 1
      item.gameObject.name = objectName
      script = self.methodScrollContent:AddComponent(UIStrComScoreMethodItem, objectName)
    end
    script:SetActive(true)
    script:SetData(data, self.selectedStage <= self.curStage)
    return item
  end
end

local function ComponentDefine(self)
  self.bgPanel = self:AddComponent(UIButton, bgPanelPath)
  self.bgPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, closeBtnPath)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.methodScroll = self:AddComponent(UILoopListView2, methodScrollPath)
  self.methodScroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.methodScrollContent = self:AddComponent(UIBaseContainer, methodScrollContentPath)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
end

local function ComponentDestroy(self)
  self.bgPanel = nil
  self.closeBtn = nil
  self.methodScroll = nil
  self.methodScrollContent = nil
  self.desc_text = nil
end

local function DataDefine(self)
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.itemIndex = nil
end

local function GenerateViewDataList(self)
  local viewDataList = {}
  for i = 1, #self.methodList do
    local line = "line"
    table.insert(viewDataList, line)
    local scoreId = self.methodList[i]
    local scoreDescData = {}
    local name = GetTableData(TableName.Score, scoreId, "tips")
    local gotoType = tonumber(GetTableData(TableName.Score, scoreId, "gotype2")) or 0
    local gotoPara = GetTableData(TableName.Score, scoreId, "gopara") or ""
    scoreDescData.name = name
    scoreDescData.gotype = gotoType
    scoreDescData.gotype2 = gotoType
    if not string.IsNullOrEmpty(gotoPara) then
      scoreDescData.gopara = string.split(gotoPara, ";")
    else
      scoreDescData.gopara = {}
    end
    scoreDescData.gopara2 = scoreDescData.gopara
    table.insert(viewDataList, scoreDescData)
  end
  if 0 < table.count(viewDataList) then
    local line = "line"
    table.insert(viewDataList, line)
  end
  return viewDataList
end

local function RefreshView(self)
  self.dataList = GenerateViewDataList(self)
  ClearScroll(self)
  if self.dataList == nil or #self.dataList == 0 then
    self.methodScroll:SetActive(false)
    return
  end
  self.methodScroll:SetActive(true)
  self.methodScroll:SetListItemCount(#self.dataList, false, false)
  if self.selectedStage == self.curStage then
    self.desc_text:SetLocalText(2000230)
  else
    self.desc_text:SetLocalText("activity_commander_tips3")
  end
end

UIStrComScoreDescPanelView.OnCreate = OnCreate
UIStrComScoreDescPanelView.OnDestroy = OnDestroy
UIStrComScoreDescPanelView.ComponentDefine = ComponentDefine
UIStrComScoreDescPanelView.ComponentDestroy = ComponentDestroy
UIStrComScoreDescPanelView.DataDefine = DataDefine
UIStrComScoreDescPanelView.DataDestroy = DataDestroy
UIStrComScoreDescPanelView.RefreshView = RefreshView
return UIStrComScoreDescPanelView
