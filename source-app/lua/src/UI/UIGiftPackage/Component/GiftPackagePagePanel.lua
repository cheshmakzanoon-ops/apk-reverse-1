local GoldExchangeNormalLuaView = require("UI.UIGiftPackage.Component.GoldExchangeNormalLuaView")
local GiftPackagePagePanel = BaseClass("GiftPackagePagePanel", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  showMainType,
  showSubType,
  goldExchangeId,
  welfareTagType,
  targetShowType,
  targetPackageId
}
local warn_text_path = "WarnGo/WarnText"
local warn_go_path = "WarnGo"
local scroll_path = "Scroll"
local content_path = "Scroll/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshView)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshView)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.warn_text = self:AddComponent(UIText, warn_text_path)
  self.warn_go = self:AddComponent(UIBaseContainer, warn_go_path)
  self.scroll = self:AddComponent(UIScrollRect, scroll_path)
  self.content_sv = self:AddComponent(GridInfinityScrollView, content_path)
  local OnInitCell = BindCallback(self, self.OnInitCell)
  local OnUpdateCell = BindCallback(self, self.OnUpdateCell)
  local OnDestroyCell = BindCallback(self, self.OnDestroyCell)
  self.content_sv:Init(OnInitCell, OnUpdateCell, OnDestroyCell)
end

local function ComponentDestroy(self)
  self.warn_text = nil
  self.warn_go = nil
  self.scroll = nil
  self.content_sv = nil
end

local function DataDefine(self)
  self.dataList = {}
  self.itemList = {}
  self.param = {}
  self.targetPackageIndex = nil
  self.targetPackageId = nil
  self.active = false
end

local function DataDestroy(self)
  self.dataList = nil
  self.itemList = nil
  self.param = nil
  self.targetPackageIndex = nil
  self.targetPackageId = nil
end

local function RefreshView(self)
  if not self.active then
    return
  end
  if not self.param then
    return
  end
  self:SetDataList()
  self:ShowGift()
end

local function ReInit(self, param)
  self.param = param
  self:SetDataList()
  self:ShowGift()
end

local function SetDataList(self)
  local panelType = self.param.welfareTagType
  if panelType == WelfareTagType.PackStore then
    self.dataList = GiftPackageData.GenerateDataByType(self.param.showMainType, self.param.showSubType)
    if self.param.targetPackageId then
      self.targetPackageIndex = self:GetPackageIndexById(self.dataList, self.param.targetPackageId)
      self.targetPackageId = self.param.targetPackageId
    elseif self.param.targetShowType then
      self.targetPackageIndex = self:GetTargetPackageIndex(self.dataList, self.param.targetShowType)
      self.targetPackageId = self.dataList[self.targetPackageIndex]:getID()
    end
  elseif panelType == WelfareTagType.PremiumPack then
    self.dataList = GiftPackageData.getPremiumPacks()
  else
    self.dataList = {}
  end
  local goldExchangeId = self.param.goldExchangeId or ""
  if not string.IsNullOrEmpty(goldExchangeId) then
    local index = 1
    local exchangeItem
    for key, eItem in pairs(self.dataList) do
      local exchangeId = eItem:getID()
      if goldExchangeId == exchangeId then
        index = key
        exchangeItem = eItem
        break
      end
    end
    if index ~= 1 then
      local firstItem = self.dataList[1]
      self.dataList[1] = exchangeItem
      self.dataList[index] = firstItem
    end
  end
end

local function ShowGift(self)
  if #self.dataList > 0 then
    self.warn_go:SetActive(false)
    self:AddGiftCells()
  else
    self.warn_go:SetActive(true)
    self.warn_text:SetLocalText(320006)
    if self.param.callBack ~= nil then
      self.param.callBack()
      self.param.callBack = nil
    end
  end
end

local function GetTargetPackageIndex(self, tempList, tempType)
  if string.IsNullOrEmpty(tempType) or #tempList == 0 then
    return
  end
  local kvArr = string.split(tempType, ";")
  mainType, subType = kvArr[1], kvArr[2]
  for i, v in ipairs(tempList) do
    if v:isContainShowType(mainType, subType) then
      return i
    end
  end
  return 1
end

local function GetPackageIndexById(self, tempList, packId)
  if string.IsNullOrEmpty(packId) or #tempList == 0 then
    return
  end
  for i, v in ipairs(tempList) do
    if v:getID() == packId then
      return i
    end
  end
end

local function AddGiftCells(self)
  self.content_sv:SetItemCount(#self.dataList)
  if self.targetPackageIndex and self.targetPackageId then
    self.content_sv:MoveItemByIndex(self.targetPackageIndex - 1, 0)
    self.targetPackageIndex = nil
    TimerManager:GetInstance():DelayInvoke(function()
      for go, itemComp in pairs(self.itemList) do
        if itemComp and itemComp.param and itemComp.param.info and itemComp.param.info:getID() == self.targetPackageId then
          itemComp:ShowArrow()
          break
        end
      end
      self.targetPackageId = nil
    end, 0.5)
  end
end

local function OnInitCell(self, go, index)
  local item = self.scroll:AddComponent(GoldExchangeNormalLuaView, go)
  self.itemList[go] = item
end

local function OnUpdateCell(self, go, index)
  local item = self.itemList[go]
  local data = self.dataList[index + 1]
  local tempId = data:getID()
  go.name = tempId
  go:SetActive(true)
  local needArrow = self.targetPackageId == tempId
  item:ReInit({
    info = data,
    index = index + 1,
    scrollView = self.scroll,
    showArrow = needArrow
  })
end

local function OnDestroyCell(self, go, index)
end

local function ClearScroll(self)
  self.scroll:RemoveComponents(GoldExchangeNormalLuaView)
  self.content_sv:DestroyChildNode()
end

GiftPackagePagePanel.OnCreate = OnCreate
GiftPackagePagePanel.OnDestroy = OnDestroy
GiftPackagePagePanel.OnInitCell = OnInitCell
GiftPackagePagePanel.OnUpdateCell = OnUpdateCell
GiftPackagePagePanel.OnDestroyCell = OnDestroyCell
GiftPackagePagePanel.OnDisable = OnDisable
GiftPackagePagePanel.ReInit = ReInit
GiftPackagePagePanel.ComponentDefine = ComponentDefine
GiftPackagePagePanel.DataDefine = DataDefine
GiftPackagePagePanel.ComponentDestroy = ComponentDestroy
GiftPackagePagePanel.DataDestroy = DataDestroy
GiftPackagePagePanel.OnEnable = OnEnable
GiftPackagePagePanel.OnAddListener = OnAddListener
GiftPackagePagePanel.OnRemoveListener = OnRemoveListener
GiftPackagePagePanel.Param = Param
GiftPackagePagePanel.AddGiftCells = AddGiftCells
GiftPackagePagePanel.ShowGift = ShowGift
GiftPackagePagePanel.SetDataList = SetDataList
GiftPackagePagePanel.GetTargetPackageIndex = GetTargetPackageIndex
GiftPackagePagePanel.GetPackageIndexById = GetPackageIndexById
GiftPackagePagePanel.ClearScroll = ClearScroll
GiftPackagePagePanel.RefreshView = RefreshView
return GiftPackagePagePanel
