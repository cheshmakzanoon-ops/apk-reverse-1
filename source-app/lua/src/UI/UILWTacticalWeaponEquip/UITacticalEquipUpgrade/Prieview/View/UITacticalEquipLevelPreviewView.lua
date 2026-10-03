local UITacticalEquipLevelPreviewView = BaseClass("UITacticalEquipLevelPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TacticalEquipPreviewItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipPreviewItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
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
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.loopListView2ItemHolder = self:AddComponent(UILoopListView2, "Root/itemHolder")
  self.compItemContent = self:AddComponent(UIBaseContainer, "Root/itemHolder/Viewport/ItemContent")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_img_title/titleText")
  self.btnClose = self:AddComponent(UIButton, "Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.loopListView2ItemHolder:InitListView(0, function(loopScroll, index, item)
    return self:OnGetItemByIndex(loopScroll, index)
  end)
end

local function ComponentDestroy(self)
  self.compItemContent:RemoveComponents(TacticalEquipPreviewItem)
  if self.loopListView2ItemHolder then
    self.loopListView2ItemHolder:ClearAllItems()
  end
  self.btnPanel = nil
  self.loopListView2ItemHolder = nil
  self.compItemContent = nil
  self.textTitle = nil
  self.btnClose = nil
end

function UITacticalEquipLevelPreviewView:ReInit()
  self.curEquipData, self.slot = self:GetUserData()
  if self.curEquipData == nil then
    self.curConfigId = nil
  else
    self.curConfigId = self.curEquipData.cfgId
  end
  self:RefreshConfigList()
end

local function DataDefine(self)
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.itemIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UITacticalEquipLevelPreviewView:RefreshConfigList()
  self.configList = DataCenter.CommonEquipTemplateManager:GetTemplateListBySlot(self.slot)
  if self.configList == nil then
    return
  end
  table.sort(self.configList, function(a, b)
    return a.id < b.id
  end)
  local count = #self.configList
  self.loopListView2ItemHolder:SetListItemCount(count, false, false)
  local jumpToIndex = 0
  for i, v in ipairs(self.configList) do
    if v and v.id == self.curConfigId then
      jumpToIndex = i - 1
      break
    end
  end
  self.loopListView2ItemHolder:MovePanelToItemIndex(jumpToIndex)
end

function UITacticalEquipLevelPreviewView:OnGetItemByIndex(loopScroll, index)
  if self.configList ~= nil then
    local count = #self.configList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    self.itemIndex = self.itemIndex + 1
    local item = loopScroll:NewListViewItem("TacticalEquipPreviewItem")
    local script = self.compItemContent:GetComponent(item.gameObject.name, TacticalEquipPreviewItem)
    if script == nil then
      local name = "config_" .. self.itemIndex
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(TacticalEquipPreviewItem, name)
    end
    local data = self.configList[index]
    script:SetLocalScaleXYZ(1, 1, 1)
    script:SetData(self.curConfigId, data)
    script:SetActive(true)
    return item
  end
end

local function OnBtnPanelClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

UITacticalEquipLevelPreviewView.OnCreate = OnCreate
UITacticalEquipLevelPreviewView.OnDestroy = OnDestroy
UITacticalEquipLevelPreviewView.OnEnable = OnEnable
UITacticalEquipLevelPreviewView.OnDisable = OnDisable
UITacticalEquipLevelPreviewView.ComponentDefine = ComponentDefine
UITacticalEquipLevelPreviewView.ComponentDestroy = ComponentDestroy
UITacticalEquipLevelPreviewView.DataDefine = DataDefine
UITacticalEquipLevelPreviewView.DataDestroy = DataDestroy
UITacticalEquipLevelPreviewView.OnAddListener = OnAddListener
UITacticalEquipLevelPreviewView.OnRemoveListener = OnRemoveListener
UITacticalEquipLevelPreviewView.OnBtnPanelClick = OnBtnPanelClick
UITacticalEquipLevelPreviewView.OnBtnCloseClick = OnBtnCloseClick
return UITacticalEquipLevelPreviewView
