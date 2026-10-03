local base = UIBaseView
local LWUIZoneMobilizationSuppliesListView = BaseClass("LWUIZoneMobilizationSuppliesListView", base)
local LWUIZoneMobilizationSuppliesItemRender = require("UI.LWUIZoneMobilization.LWUISuppliesListView.Component.LWUIZoneMobilizationSuppliesItemRender")
local LWUIZoneMobilizationResItemRender = require("UI.LWUIZoneMobilization.LWUISuppliesListView.Component.LWUIZoneMobilizationResItemRender")
local Localization = CS.GameEntry.Localization
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local resource_empty_text_path = "PopUpContent/ResourceRoot/ResourceEmptyText"
local closeBtn_path = "PopUpContent/CloseBtn"
local resource_scroll_view_path = "PopUpContent/ResourceRoot/ResourceScrollView"
local resource_scroll_content_path = "PopUpContent/ResourceRoot/ResourceScrollView/Viewport/ResourceScrollContent"
local tips_btn_path = "PopUpContent/TipsBtn"
local resource_tog_path = "PopUpContent/TabGroup/ResourceTog"
local resource_checkmark_path = "PopUpContent/TabGroup/ResourceTog/ResourceCheckmark"
local supplies_tog_path = "PopUpContent/TabGroup/SuppliesTog"
local supplies_checkmark_path = "PopUpContent/TabGroup/SuppliesTog/SuppliesCheckmark"
local resource_root_path = "PopUpContent/ResourceRoot"
local personal_num_text_path = "PopUpContent/ResourceRoot/IconRoot/PersonalIcon/PersonalNumText"
local supplies_root_path = "PopUpContent/SuppliesRoot"
local supplies_scroll_view_path = "PopUpContent/SuppliesRoot/SuppliesScrollView"
local scroll_content_path = "PopUpContent/SuppliesRoot/SuppliesScrollView/Viewport/ScrollContent"
local record_btn_path = "PopUpContent/RecordBtn"
local supplies_empty_text_path = "PopUpContent/SuppliesRoot/SuppliesEmptyText"
local personal_icon_path = "PopUpContent/ResourceRoot/IconRoot/PersonalIcon"
local alliance_icon_path = "PopUpContent/ResourceRoot/IconRoot/AllianceIcon"
local alliance_num_text_path = "PopUpContent/ResourceRoot/IconRoot/AllianceIcon/AllianceNumText"
local ICON_PATH = "Assets/Main/Sprites/UI/LWUIZoneMobilization/%s.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.GetZoneMobilizationTaskInfo, 0)
end

local function OnDestroy(self)
  self.resource_scroll_content:RemoveComponents(LWUIZoneMobilizationSuppliesItemRender)
  self.resource_scroll_view:ClearAllItems()
  self.scroll_content:RemoveComponents(LWUIZoneMobilizationResItemRender)
  self.supplies_scroll_view:ClearAllItems()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  self.resource_root:SetActive(false)
  self.supplies_root:SetActive(false)
end

local function ComponentDefine(self)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.resource_empty_text = self:AddComponent(UITextMeshProUGUIEx, resource_empty_text_path)
  self.resource_empty_text:SetLocalText("zone_mobilization_task_alliance_supplies")
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.resource_scroll_view = self:AddComponent(UILoopListView2, resource_scroll_view_path)
  self.resource_scroll_content = self:AddComponent(UIBaseContainer, resource_scroll_content_path)
  self.tipsBtn = self:AddComponent(UIButton, tips_btn_path)
  self.titleText:SetLocalText("zone_mobilization_alliance_find_title")
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tipsBtn:SetOnClick(BindCallback(self, self.OnTipBtnClick))
  self.resource_scroll_view:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
  self.resource_tog = self:AddComponent(UIButton, resource_tog_path)
  self.resource_tog:SetOnClick(function()
    self:OnTogClick(1)
  end)
  self.resource_checkmark = self:AddComponent(UIBaseContainer, resource_checkmark_path)
  self.supplies_tog = self:AddComponent(UIButton, supplies_tog_path)
  self.supplies_tog:SetOnClick(function()
    self:OnTogClick(2)
  end)
  self.supplies_checkmark = self:AddComponent(UIBaseContainer, supplies_checkmark_path)
  self.resource_root = self:AddComponent(UIBaseContainer, resource_root_path)
  self.personal_num_text = self:AddComponent(UITextMeshProUGUIEx, personal_num_text_path)
  self.supplies_root = self:AddComponent(UIBaseContainer, supplies_root_path)
  self.supplies_scroll_view = self:AddComponent(UILoopListView2, supplies_scroll_view_path)
  self.supplies_scroll_view:InitListView(0, function(listView, index)
    return self:OnGetResItemByIndex(listView, index)
  end)
  self.scroll_content = self:AddComponent(UIBaseContainer, scroll_content_path)
  self.record_btn = self:AddComponent(UIButton, record_btn_path)
  self.record_btn:SetOnClick(BindCallback(self, self.OnRecordBtnClick))
  self.record_btn:SetActive(DataCenter.LWZoneMobilizationManager:GetIsNewFunc())
  self.supplies_empty_text = self:AddComponent(UITextMeshProUGUIEx, supplies_empty_text_path)
  self.supplies_empty_text:SetLocalText("zone_mobilization_donated_no_resource")
  self.personal_icon = self:AddComponent(UIButton, personal_icon_path)
  self.personal_icon:SetOnClick(BindCallback(self, self.OnPersonalBtnClick))
  self.personal_icon:SetActive(DataCenter.LWZoneMobilizationManager:GetIsNewFunc())
  self.alliance_icon = self:AddComponent(UIButton, alliance_icon_path)
  self.alliance_icon:SetOnClick(BindCallback(self, self.OnAllianceBtnClick))
  self.alliance_num_text = self:AddComponent(UITextMeshProUGUIEx, alliance_num_text_path)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.resource_empty_text = nil
  self.closeBtn = nil
  self.resource_scroll_view = nil
  self.resource_scroll_content = nil
  self.tipsBtn = nil
  self.resource_tog = nil
  self.resource_checkmark = nil
  self.supplies_tog = nil
  self.supplies_checkmark = nil
  self.resource_root = nil
  self.personal_num_text = nil
  self.supplies_root = nil
  self.supplies_scroll_view = nil
  self.scroll_content = nil
  self.record_btn = nil
  self.supplies_empty_text = nil
  self.personal_icon = nil
  self.alliance_icon = nil
  self.alliance_num_text = nil
end

local function DataDefine(self)
  self.tab = nil
end

local function DataDestroy(self)
  self.tab = nil
end

local function InitData(self)
  self:InitResourceData()
  self:InitSuppliesData()
  local tab = 1
  if table.IsNullOrEmpty(self.suppliesData) and not table.IsNullOrEmpty(self.resourceData) then
    tab = 2
  end
  self:OnTogClick(tab)
end

local function InitResourceData(self)
  self.resourceData = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationResourcePointsData()
  if self.resourceData then
    table.sort(self.resourceData, function(data1, data2)
      if data1.rewarded ~= data2.rewarded then
        return not data1.rewarded
      end
      if data1.rewardNum == ZoneMobilizationSuppliesMaxCount and data2.rewardNum < ZoneMobilizationSuppliesMaxCount or data1.rewardNum < ZoneMobilizationSuppliesMaxCount and data2.rewardNum == ZoneMobilizationSuppliesMaxCount then
        return data2.rewardNum == ZoneMobilizationSuppliesMaxCount and true or false
      end
      if data1.rewardNum ~= data2.rewardNum then
        return data1.rewardNum > data2.rewardNum
      end
      return data1.expireTime < data2.expireTime
    end)
    local listCount = table.count(self.resourceData)
    self.resource_empty_text:SetActive(listCount == 0)
    self.resource_scroll_view:SetListItemCount(listCount, false, false)
    self.resource_scroll_view:RefreshAllShownItem()
  end
  self.personal_icon:LoadSprite(string.format(ICON_PATH, DataCenter.LWZoneMobilizationManager:GetResourceIcon(0)))
  self.alliance_icon:LoadSprite(string.format(ICON_PATH, DataCenter.LWZoneMobilizationManager:GetResourceIcon(1)))
  local personalMax = DataCenter.LWZoneMobilizationManager.personalMax
  local personalNumStr = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationSmallSuppliesSelfGetCount() .. "/" .. personalMax
  self.personal_num_text:SetText(personalNumStr)
  local allianceMax = DataCenter.LWZoneMobilizationManager.allianceMax
  local allianceNumStr = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationSuppliesSelfGetCount() .. "/" .. allianceMax
  self.alliance_num_text:SetText(allianceNumStr)
end

local function InitSuppliesData(self)
  self.suppliesData = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationSuppliesPointsData()
  if self.suppliesData then
    local listCount = table.count(self.suppliesData)
    self.supplies_empty_text:SetActive(listCount == 0)
    self.supplies_scroll_view:SetListItemCount(listCount, false, false)
    self.supplies_scroll_view:RefreshAllShownItem()
  end
end

local function OnGetItemByIndex(self, listView, index)
  local count = table.count(self.resourceData)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = listView:NewListViewItem("LWUIZoneMobilizationSuppliesItemRender")
  local script = self.resource_scroll_content:GetComponent(item.gameObject.name, LWUIZoneMobilizationSuppliesItemRender)
  if script == nil then
    NameCount = NameCount + 1
    local objectName = tostring(NameCount)
    item.gameObject.name = objectName
    script = self.resource_scroll_content:AddComponent(LWUIZoneMobilizationSuppliesItemRender, objectName)
  end
  script:SetActive(true)
  local data = self.resourceData[index]
  script:InitData(data)
  return item
end

local function OnGetResItemByIndex(self, listView, index)
  local count = table.count(self.suppliesData)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = listView:NewListViewItem("LWUIZoneMobilizationResItemRender")
  local script = self.scroll_content:GetComponent(item.gameObject.name, LWUIZoneMobilizationResItemRender)
  if script == nil then
    NameCount = NameCount + 1
    local objectName = tostring(NameCount)
    item.gameObject.name = objectName
    script = self.scroll_content:AddComponent(LWUIZoneMobilizationResItemRender, objectName)
  end
  script:SetActive(true)
  local data = self.suppliesData[index]
  script:InitData(data)
  return item
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetZoneMobilizationResourcePointsData, self.InitData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetZoneMobilizationResourcePointsData, self.InitData)
  base.OnRemoveListener(self)
end

local function OnTogClick(self, type)
  self.tab = type
  if type == 1 then
    self.resource_checkmark:SetActive(true)
    self.supplies_checkmark:SetActive(false)
    self.resource_root:SetActive(false)
    self.supplies_root:SetActive(true)
  elseif type == 2 then
    self.resource_checkmark:SetActive(false)
    self.supplies_checkmark:SetActive(true)
    self.resource_root:SetActive(true)
    self.supplies_root:SetActive(false)
  end
end

local function OnRecordBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZoneMobilizationSuppliesRecord, {anim = true})
end

local function OnPersonalBtnClick(self)
  local personalMax = DataCenter.LWZoneMobilizationManager.personalMax
  local content = Localization:GetString("zone_mobilization_donated_supplies_rule_3", DataCenter.LWZoneMobilizationManager:GetZoneMobilizationSmallSuppliesSelfGetCount(), personalMax)
  self:ShowTipsPanel(content, self.personal_icon)
end

local function OnAllianceBtnClick(self)
  local allianceMax = DataCenter.LWZoneMobilizationManager.allianceMax
  local content = Localization:GetString("zone_mobilization_donated_supplies_rule_2", DataCenter.LWZoneMobilizationManager:GetZoneMobilizationSuppliesSelfGetCount(), allianceMax)
  self:ShowTipsPanel(content, self.alliance_icon)
end

local function ShowTipsPanel(self, content, node)
  UIUtil.ShowBubbleTips(content, node.transform.position, 0, -40, 0)
end

local function OnTipBtnClick(self)
  local content = ""
  if self.tab == 1 then
    local prob1 = DataCenter.LWZoneMobilizationManager:GetProbWhenOpenBoxItemData()
    content = Localization:GetString("zone_mobilization_task_complement", prob1)
  else
    local _, prob2 = DataCenter.LWZoneMobilizationManager:GetProbWhenOpenBoxItemData()
    content = Localization:GetString("zone_mobilization_donated_supplies_rule_1", prob2)
  end
  UIUtil.ShowBubbleTips(content, self.tipsBtn.transform.position, CommonUtil.IsArabicAutoMirrorOpen() and -25 or 25, -40, 0)
end

LWUIZoneMobilizationSuppliesListView.OnCreate = OnCreate
LWUIZoneMobilizationSuppliesListView.OnDestroy = OnDestroy
LWUIZoneMobilizationSuppliesListView.OnEnable = OnEnable
LWUIZoneMobilizationSuppliesListView.OnDisable = OnDisable
LWUIZoneMobilizationSuppliesListView.ComponentDefine = ComponentDefine
LWUIZoneMobilizationSuppliesListView.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationSuppliesListView.DataDefine = DataDefine
LWUIZoneMobilizationSuppliesListView.DataDestroy = DataDestroy
LWUIZoneMobilizationSuppliesListView.OnGetItemByIndex = OnGetItemByIndex
LWUIZoneMobilizationSuppliesListView.InitData = InitData
LWUIZoneMobilizationSuppliesListView.InitResourceData = InitResourceData
LWUIZoneMobilizationSuppliesListView.InitSuppliesData = InitSuppliesData
LWUIZoneMobilizationSuppliesListView.OnAddListener = OnAddListener
LWUIZoneMobilizationSuppliesListView.OnRemoveListener = OnRemoveListener
LWUIZoneMobilizationSuppliesListView.OnTogClick = OnTogClick
LWUIZoneMobilizationSuppliesListView.OnGetResItemByIndex = OnGetResItemByIndex
LWUIZoneMobilizationSuppliesListView.OnRecordBtnClick = OnRecordBtnClick
LWUIZoneMobilizationSuppliesListView.OnPersonalBtnClick = OnPersonalBtnClick
LWUIZoneMobilizationSuppliesListView.OnAllianceBtnClick = OnAllianceBtnClick
LWUIZoneMobilizationSuppliesListView.ShowTipsPanel = ShowTipsPanel
LWUIZoneMobilizationSuppliesListView.OnTipBtnClick = OnTipBtnClick
return LWUIZoneMobilizationSuppliesListView
