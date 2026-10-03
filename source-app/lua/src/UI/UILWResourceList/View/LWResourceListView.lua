local LWResourceListView = BaseClass("LWResourceListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonToggleListComponent = require("UI/UILWCommon/UICommonToggleList/UICommonToggleListComponent")
local LWResourceListItemComponent = require("UI/UILWResourceList/Component/LWResourceListItemComponent")

function LWResourceListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
  PostEventLog.Track(PostEventLog.Defines.open_window, {
    windowName = UIWindowNames.UILWResourceList
  })
end

function LWResourceListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWResourceListView:ComponentDefine()
  self.btnUICommonBlackMask = self:AddComponent(UIButton, "UICommonBlackMask")
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "PanelRoot/TitleText")
  self.btnClose = self:AddComponent(UIButton, "PanelRoot/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compUICommonToggleList = self:AddComponent(UICommonToggleListComponent, "PanelRoot/Content/UICommonToggleList")
  self.compContent = self:AddComponent(UIBaseContainer, "PanelRoot/Content/ScrollView/Viewport/Content")
  self.compLWResourceListItem = self:AddComponent(LWResourceListItemComponent, "PanelRoot/Content/ScrollView/Viewport/LWResourceListItem")
  self.textTitleText01 = self:AddComponent(UITextMeshProUGUIEx, "PanelRoot/Content/Title/TitleText01")
  self.textTitleText02 = self:AddComponent(UITextMeshProUGUIEx, "PanelRoot/Content/Title/TitleText02")
  self.textTitleText03 = self:AddComponent(UITextMeshProUGUIEx, "PanelRoot/Content/Title/TitleText03")
  self.textTitle:SetLocalText("resource_list_title")
  self.compLWResourceListItem:SetActive(false)
  self.compLWResourceListItem.gameObject:GameObjectCreatePool()
end

function LWResourceListView:ComponentDestroy()
  self:ClearContent()
  self.btnUICommonBlackMask = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compUICommonToggleList = nil
  self.compContent = nil
  self.compLWResourceListItem = nil
  self.textTitleText01 = nil
  self.textTitleText02 = nil
  self.textTitleText03 = nil
end

function LWResourceListView:DataDefine()
end

function LWResourceListView:DataDestroy()
end

function LWResourceListView:OnAddListener()
  base.OnAddListener(self)
end

function LWResourceListView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWResourceListView:OnOpen()
  self:InitToggle()
end

function LWResourceListView:InitToggle()
  local data = {}
  local resourceData = {}
  resourceData.name = self.ctrl:GetShowTypeTitle(DataCenter.ResourceListManager.ShowType.Resource)
  local materialData = {}
  materialData.name = self.ctrl:GetShowTypeTitle(DataCenter.ResourceListManager.ShowType.Material)
  data.itemsDataList = {resourceData, materialData}
  
  function data.onItemSelect(index, itemData)
    self:OnSelectToggle(index, itemData)
  end
  
  data.defaultSelectIndex = 1
  self.compUICommonToggleList:ReInit(data)
end

function LWResourceListView:OnSelectToggle(index, itemData)
  if index == DataCenter.ResourceListManager.ShowType.Resource then
    self:UpdateResource()
  elseif index == DataCenter.ResourceListManager.ShowType.Material then
    self:UpdateMaterial()
  end
end

function LWResourceListView:UpdateResource()
  self:ClearContent()
  self.items = {}
  local templates = DataCenter.ResourceListManager:GetAllSpeedShowTemplatesByShowType(DataCenter.ResourceListManager.ShowType.Resource)
  local index = 1
  for i, v in ipairs(templates) do
    if self.ctrl:IsShowSpeedShowTemplate(v) then
      local item = self.compLWResourceListItem.gameObject:GameObjectSpawn(self.compContent.transform)
      item.name = "LWResourceList" .. index
      local obj = self.compContent:AddComponent(LWResourceListItemComponent, item.name)
      obj:SetActive(true)
      obj:ReInit(v, index)
      table.insert(self.items, obj)
      index = index + 1
    end
  end
  self.textTitleText01:SetLocalText("resource_list_resource")
  self.textTitleText02:SetLocalText("resource_list_production")
  self.textTitleText03:SetLocalText("resource_list_handle")
end

function LWResourceListView:UpdateMaterial()
  self:ClearContent()
  self.items = {}
  local templates = DataCenter.ResourceListManager:GetAllSpeedShowTemplatesByShowType(DataCenter.ResourceListManager.ShowType.Material)
  for i, v in ipairs(templates) do
    if self.ctrl:IsShowSpeedShowTemplate(v) then
      local item = self.compLWResourceListItem.gameObject:GameObjectSpawn(self.compContent.transform)
      item.name = "LWResourceList" .. i
      local obj = self.compContent:AddComponent(LWResourceListItemComponent, item.name)
      obj:SetActive(true)
      obj:ReInit(v, i)
      table.insert(self.items, obj)
    end
  end
  self.textTitleText01:SetLocalText("resource_list_tag2")
  self.textTitleText02:SetLocalText("resource_list_production")
  self.textTitleText03:SetLocalText("resource_list_handle")
end

function LWResourceListView:ClearContent()
  self.compContent:RemoveComponents(LWResourceListItemComponent)
  self.compLWResourceListItem.gameObject:GameObjectRecycleAll()
  self.items = nil
end

function LWResourceListView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function LWResourceListView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return LWResourceListView
