local UIPVEPowerLackScrollView = BaseClass("UIPVEPowerLackScrollView", UIBaseContainer)
local base = UIBaseContainer
local UIPVEPowerLackItem = require("UI.UIPVE.UIPVEPowerLack.Component.UIPVEPowerLackItem")
local scroll_view_path = ""
local content_path = "Viewport/Content"
local ITEM_WIDTH = 196.5
local HEIGHT = 355

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateItem(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteItem(itemObj, index)
  end)
  self.content_go = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
  self.scroll_view = nil
  self.content_go = nil
end

local function DataDefine(self)
  self.lackType = PvePowerLackType.None
  self.tips = {}
  self.heroUuidList = {}
  self.dataList = {}
  self.itemDict = {}
end

local function DataDestroy(self)
  self.lackType = nil
  self.tips = nil
  self.heroUuidList = nil
  self.dataList = nil
  self.itemDict = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnCreateItem(self, itemObj, index)
  local data = self.dataList[index]
  itemObj.name = tostring(data.tip)
  local item = self.scroll_view:AddComponent(UIPVEPowerLackItem, itemObj)
  item:SetData(data)
  self.itemDict[index] = item
end

local function OnDeleteItem(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIPVEPowerLackItem)
  self.itemDict[index] = nil
end

local function ShowScroll(self)
  self.scroll_view:SetTotalCount(#self.dataList)
  if #self.dataList > 0 then
    self.scroll_view:RefillCells()
    self.scroll_view.unity_scroll_view.m_ContentConstraintCount = 4
    self.scroll_view.gameObject:SetActive(true)
    self.scroll_view:ScrollToCell(1, 1000)
  end
  local width
  if #self.dataList >= self.itemCount then
    width = ITEM_WIDTH * self.itemCount
  else
    width = ITEM_WIDTH * #self.dataList
  end
  self.rectTransform.sizeDelta = Vector2.New(width, HEIGHT)
end

local function ClearScroll(self)
  self.scroll_view:ClearItems()
  self.scroll_view:RemoveComponents(UIPVEPowerLackItem)
end

local function SetData(self, lackType, tips, itemCount, showBg, closeFunc)
  self.lackType = lackType
  self.tips = tips
  self.itemCount = itemCount
  self.showBg = showBg
  self.closeFunc = closeFunc
  self.heroUuidList = {}
  for heroUuid, _ in pairs(PveActorMgr:GetInstance():GetHeroDataBackup()) do
    table.insert(self.heroUuidList, heroUuid)
  end
  self.dataList = self:GetDataList()
  self:ShowScroll()
end

local function GetItemClickFunc(self, data)
  local param = {}
  param.lackType = data.lackType
  param.tip = data.tip
  param.heroUuidList = self.heroUuidList
  param.closeFunc = self.closeFunc
  return PveUtil.GetPowerLackTipClickFunc(param)
end

local function GetDataList(self)
  local dataList = {}
  
  local function TryAddTip(tip)
    local templates = DataCenter.ResLackManager:GetTemplatesByTip(math.abs(tip))
    if not table.IsNullOrEmpty(templates) then
      local data = {}
      data.lackType = self.lackType
      data.tip = tip
      data.template = templates[1]
      data.showBg = self.showBg
      data.onClick = self:GetItemClickFunc(data)
      if data.onClick then
        table.insert(dataList, data)
      end
    end
  end
  
  for _, tip in ipairs(self.tips) do
    TryAddTip(tip)
  end
  if #dataList == 0 then
    TryAddTip(PvePowerLackTipType.MainQuest)
  end
  if 0 < #dataList then
    table.sort(dataList, function(a, b)
      return a.template.order < b.template.order
    end)
    local list = {}
    local groups = {}
    for _, data in ipairs(dataList) do
      if data.template.group == 0 or groups[data.template.group] == nil then
        groups[data.template.group] = true
        table.insert(list, data)
      end
    end
    dataList = list
    dataList[1].recommended = true
  end
  return dataList
end

local function HasTip(self, tips)
  for k, v in ipairs(self.dataList) do
    if v.tip == tips then
      return true
    end
  end
  return false
end

UIPVEPowerLackScrollView.OnCreate = OnCreate
UIPVEPowerLackScrollView.OnDestroy = OnDestroy
UIPVEPowerLackScrollView.ComponentDefine = ComponentDefine
UIPVEPowerLackScrollView.ComponentDestroy = ComponentDestroy
UIPVEPowerLackScrollView.DataDefine = DataDefine
UIPVEPowerLackScrollView.DataDestroy = DataDestroy
UIPVEPowerLackScrollView.OnEnable = OnEnable
UIPVEPowerLackScrollView.OnDisable = OnDisable
UIPVEPowerLackScrollView.OnAddListener = OnAddListener
UIPVEPowerLackScrollView.OnRemoveListener = OnRemoveListener
UIPVEPowerLackScrollView.OnCreateItem = OnCreateItem
UIPVEPowerLackScrollView.OnDeleteItem = OnDeleteItem
UIPVEPowerLackScrollView.ShowScroll = ShowScroll
UIPVEPowerLackScrollView.ClearScroll = ClearScroll
UIPVEPowerLackScrollView.SetData = SetData
UIPVEPowerLackScrollView.GetItemClickFunc = GetItemClickFunc
UIPVEPowerLackScrollView.GetDataList = GetDataList
UIPVEPowerLackScrollView.HasTip = HasTip
return UIPVEPowerLackScrollView
