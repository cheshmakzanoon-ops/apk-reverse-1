local UITacticalEquipBagView = BaseClass("UITacticalEquipBagView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TacticalEquipItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipItem")
local UICommonTab = require("UI.UICommonTab.UICommonTab")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitTab()
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
  self.compTabRoot = self:AddComponent(UIBaseContainer, "Root/chipListNode/tabRoot")
  self.compNoChipTip = self:AddComponent(UIBaseContainer, "Root/chipListNode/noChipTip")
  self.textNoChipTip = self:AddComponent(UITextMeshProUGUIEx, "Root/chipListNode/noChipTip")
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, "Root/chipListNode/ItemHolder")
  self.compItemContent = self:AddComponent(UIBaseContainer, "Root/chipListNode/ItemHolder/Viewport/ItemContent")
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
end

local function ComponentDestroy(self)
  if self.compItemContent then
    self.compItemContent:RemoveComponents(TacticalEquipItem)
  end
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  if self.compTabRoot then
    self.compTabRoot:RemoveComponents(UICommonTab)
  end
  self.compTabRoot = nil
  self.compNoChipTip = nil
  self.textNoChipTip = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.btnPanel = nil
  self.btnClose = nil
end

local function DataDefine(self)
  self.tabList = {}
  self.equipListMap = {}
end

local function DataDestroy(self)
  self.curTab = nil
  self.tabList = nil
  self.equipListMap = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UITacticalEquipBagView:InitTab()
  local childCount = self.compTabRoot.transform.childCount
  for i = 0, childCount - 1 do
    local child = self.compTabRoot.transform:GetChild(i)
    local tabParam = {}
    tabParam.tabId = i + 1
    tabParam.clickHandler = self.OnTabClick
    tabParam.customHolder = self
    local tabItem = self.compTabRoot:AddComponent(UICommonTab, child.name)
    tabItem:ReInit(tabParam)
    tabItem:SetActive(true)
    tabItem:SetSelect(false)
    table.insert(self.tabList, tabItem)
  end
end

function UITacticalEquipBagView:ReInit()
  self:OnTabClick(self.tabList[1])
end

function UITacticalEquipBagView:RefreshList()
  if self.curTab == nil then
    return
  end
  local slot = self.curTab.tabId
  if not self.equipListMap[slot] then
    self.equipListMap[slot] = DataCenter.CommonEquipDataManager:GetAllFreeEquipBagData(slot)
  end
  local list = self.equipListMap[slot]
  local hasEquip = list and 0 < #list
  if hasEquip then
    self.loopGridViewItemHolder:SetListItemCount(#list)
  end
  self.loopGridViewItemHolder:SetActive(hasEquip)
  self.compNoChipTip:SetActive(not hasEquip)
end

function UITacticalEquipBagView:OnGetItemByRowColumn(loopScroll, index)
  local slot = self.curTab.tabId
  if self.equipListMap[slot] ~= nil then
    local count = #self.equipListMap[slot]
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("TacticalEquipItem")
    local script = self.compItemContent:GetComponent(item.gameObject.name, TacticalEquipItem)
    if script == nil then
      local name = "equip_" .. index
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(TacticalEquipItem, name)
    end
    local data = self.equipListMap[slot][index]
    script:SetClick(function(eventData)
      local param = {}
      param.equipData = data
      param.width = 420
      param.screenPos = eventData.position
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalEquipItemTips, {anim = true}, param)
    end)
    script:SetData(data, slot)
    script:SetActive(true)
    return item
  end
end

function UITacticalEquipBagView:OnTabClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  self:RefreshList()
end

local function OnBtnPanelClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

UITacticalEquipBagView.OnCreate = OnCreate
UITacticalEquipBagView.OnDestroy = OnDestroy
UITacticalEquipBagView.OnEnable = OnEnable
UITacticalEquipBagView.OnDisable = OnDisable
UITacticalEquipBagView.ComponentDefine = ComponentDefine
UITacticalEquipBagView.ComponentDestroy = ComponentDestroy
UITacticalEquipBagView.DataDefine = DataDefine
UITacticalEquipBagView.DataDestroy = DataDestroy
UITacticalEquipBagView.OnAddListener = OnAddListener
UITacticalEquipBagView.OnRemoveListener = OnRemoveListener
UITacticalEquipBagView.OnBtnPanelClick = OnBtnPanelClick
UITacticalEquipBagView.OnBtnCloseClick = OnBtnCloseClick
return UITacticalEquipBagView
