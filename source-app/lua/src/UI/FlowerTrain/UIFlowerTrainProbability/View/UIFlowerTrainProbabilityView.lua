local base = UIBaseView
local UIFlowerTrainProbabilityView = BaseClass("UIFlowerTrainProbabilityView", base)
local UIFlowerTrainProbabilityItemView = require("UI.FlowerTrain.UIFlowerTrainProbability.View.UIFlowerTrainProbabilityItemView")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local closeBtn_path = "Content/CloseBtn"
local commonActivityPopUpBgPart_path = "Content/CommonActivityPopUpBgPart"
local closePanelBtn_path = "panel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
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
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.commonActivityPopUpBgPart = self:AddComponent(UIBaseContainer, commonActivityPopUpBgPart_path)
  self.closePanelBtn = self:AddComponent(UIButton, closePanelBtn_path)
  self.commonActivityPopUpBgPartComponent = self:AddComponent(CommonActivityPopUpBgPart, commonActivityPopUpBgPart_path)
  self.commonActivityPopUpBgPartComponent:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ScrollLoopListView = self:AddComponent(UILoopListView2, "Content/Scroll View")
  self.ScrollContent = self:AddComponent(UIBaseContainer, "Content/Scroll View/Viewport/Content")
  self.ScrollLoopListView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closePanelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.closeBtn = nil
  self.commonActivityPopUpBgPart = nil
  self.closePanelBtn = nil
  self.ScrollContent:RemoveComponents(UIFlowerTrainProbabilityItemView)
  self.ScrollLoopListView:ClearAllItems()
  self.ScrollLoopListView = nil
  self.commonActivityPopUpBgPartComponent = nil
end

local function DataDefine(self)
  self.itemIndex = 0
  local data = self:GetUserData()
  self.itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(data.itemId)
  local dic = FlowerTrainUtils.GetItemDropProbCfgDic(data.itemId)
  local list = {}
  table.walksort(dic, function(a, b)
    return a < b
  end, function(k, v)
    table.insert(list, v)
  end)
  self.scrollItemCfgList = list
end

local function DataDestroy(self)
  self.itemIndex = 0
  self.scrollItemCfgList = {}
end

function UIFlowerTrainProbabilityView:OnGetItemByIndex(listview, index)
  if self.scrollItemCfgList == nil or index < 0 or index >= #self.scrollItemCfgList then
    return nil
  end
  index = index + 1
  local prefabName = self:GetPrefabName(self.scrollItemCfgList[index])
  local item = listview:NewListViewItem(prefabName)
  if item == nil then
    return
  end
  local script = self.ScrollContent:GetComponent(item.gameObject.name, UIFlowerTrainProbabilityItemView)
  if script == nil then
    local objectName = item.gameObject.name .. tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.ScrollContent:AddComponent(UIFlowerTrainProbabilityItemView, objectName)
  end
  script:SetActive(true)
  script:RefreshView(self.scrollItemCfgList[index], index, function(index)
    listview:OnItemSizeChanged(index - 1)
  end)
  script:RefreshSkin(self.itemMeta)
  return item
end

function UIFlowerTrainProbabilityView:GetPrefabName(data)
  if data and data[1] and data[1].type == 7 then
    return "UIFlowerTrainProbabilityItem_NoTitle"
  end
  return "UIFlowerTrainProbabilityItem"
end

function UIFlowerTrainProbabilityView:RefreshView()
  self.ScrollLoopListView:SetListItemCount(#self.scrollItemCfgList, false, false)
  self.ScrollLoopListView:RefreshAllShownItem()
  local configId = self.itemMeta.serverPara3
  if string.IsNullOrEmpty(configId) then
    configId = 3
  end
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, configId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. configId)
    return
  end
  self.commonActivityPopUpBgPartComponent:ModifyPanelPacking(lineData)
  self.commonActivityPopUpBgPartComponent:SetTitle("2025halloween_treasure_dropinfo_title")
end

UIFlowerTrainProbabilityView.OnCreate = OnCreate
UIFlowerTrainProbabilityView.OnDestroy = OnDestroy
UIFlowerTrainProbabilityView.OnEnable = OnEnable
UIFlowerTrainProbabilityView.OnDisable = OnDisable
UIFlowerTrainProbabilityView.ComponentDefine = ComponentDefine
UIFlowerTrainProbabilityView.ComponentDestroy = ComponentDestroy
UIFlowerTrainProbabilityView.DataDefine = DataDefine
UIFlowerTrainProbabilityView.DataDestroy = DataDestroy
return UIFlowerTrainProbabilityView
