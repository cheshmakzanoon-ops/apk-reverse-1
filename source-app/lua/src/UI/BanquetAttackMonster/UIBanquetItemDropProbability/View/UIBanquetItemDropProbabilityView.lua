local UIBanquetItemDropProbabilityView = BaseClass("UIBanquetItemDropProbabilityView", UIBaseView)
local M = UIBanquetItemDropProbabilityView
local base = UIBaseView
local UIBanquetItemDropProbabilityItem = require("UI.BanquetAttackMonster.UIBanquetItemDropProbability.Component.UIBanquetItemDropProbabilityItem")
local UIBanquetItemDropProbabilityItem_Box = require("UI.BanquetAttackMonster.UIBanquetItemDropProbability.Component.UIBanquetItemDropProbabilityItem_Box")
local Logger = require("Framework.Logger.Logger")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")

function M:OnCreate()
  base.OnCreate(self)
  self.activityId = self:GetUserData()
  self.itemIndex = 0
  self.curTabIndex = 1
  self.itemDropProbCfgDic = nil
  self.scrollItemCfgList = nil
  self.expandDic = {}
  self:ComponentDefine()
  self:RefreshView()
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId)
  self:ModifyByConfig()
end

function M:OnDestroy()
  self.curTabIndex = 1
  self.itemDropProbCfgDic = nil
  self.scrollItemCfgList = nil
  self.expandDic = nil
  self.ScrollContent:RemoveComponents(UIBanquetItemDropProbabilityItem)
  self.ScrollContent:RemoveComponents(UIBanquetItemDropProbabilityItem_Box)
  DataCenter.ActBanquetV2Data:ClearData()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/safearea/TopBar/TextTitle")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/safearea/BtnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnTab1 = self:AddComponent(UIButton, "Tabs/Viewport/Content/Tab0")
  self.btnTab1:SetOnClick(function()
    self:OnBtnTabClick(1)
  end)
  self.btnTab2 = self:AddComponent(UIButton, "Tabs/Viewport/Content/Tab1")
  self.btnTab2:SetOnClick(function()
    self:OnBtnTabClick(2)
  end)
  self.btnBlankSpaceClose = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnBlankSpaceClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTabUnselect1 = self:AddComponent(UITextMeshProUGUIEx, "Tabs/Viewport/Content/Tab0/unSelect0/unselectText0")
  self.textTabSelect1 = self:AddComponent(UITextMeshProUGUIEx, "Tabs/Viewport/Content/Tab0/select0/selectText0")
  self.textTabUnselect2 = self:AddComponent(UITextMeshProUGUIEx, "Tabs/Viewport/Content/Tab1/unSelect1/unselectText1")
  self.textTabSelect2 = self:AddComponent(UITextMeshProUGUIEx, "Tabs/Viewport/Content/Tab1/select1/selectText1")
  self.ScrollLoopListView = self:AddComponent(UILoopListView2, "Scroll View")
  self.ScrollContent = self:AddComponent(UIBaseContainer, "Scroll View/Viewport/Content")
  self.compUnSelect1 = self:AddComponent(UIBaseContainer, "Tabs/Viewport/Content/Tab0/unSelect0")
  self.compSelect1 = self:AddComponent(UIBaseContainer, "Tabs/Viewport/Content/Tab0/select0")
  self.compUnSelect2 = self:AddComponent(UIBaseContainer, "Tabs/Viewport/Content/Tab1/unSelect1")
  self.compSelect2 = self:AddComponent(UIBaseContainer, "Tabs/Viewport/Content/Tab1/select1")
  self.ScrollLoopListView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "UICommonPopUpTitle/safearea/CommonActivityPopUpBgPart")
  self.select0 = self:AddComponent(UIImage, "Tabs/Viewport/Content/Tab0/select0")
  self.unSelect0 = self:AddComponent(UIImage, "Tabs/Viewport/Content/Tab0/unSelect0")
  self.select1 = self:AddComponent(UIImage, "Tabs/Viewport/Content/Tab1/select1")
  self.unSelect1 = self:AddComponent(UIImage, "Tabs/Viewport/Content/Tab1/unSelect1")
end

function M:ComponentDestroy()
  self.textTitle = nil
  self.btnClose = nil
  self.btnTab1 = nil
  self.btnTab2 = nil
  self.textTabUnselect1 = nil
  self.textTabSelect1 = nil
  self.textTabUnselect2 = nil
  self.textTabSelect2 = nil
  self.ScrollLoopListView:ClearAllItems()
  self.ScrollLoopListView = nil
  self.rootNextMonster = nil
  self.imgNextMonsterIcon = nil
  self.textNextMonsterName = nil
  self.compUnSelect1 = nil
  self.compSelect1 = nil
  self.compUnSelect2 = nil
  self.compSelect2 = nil
  self.commonActivityPopUpBgPart = nil
end

function M:OnEnable()
end

function M:OnDisable()
end

function M:RefreshView()
  local actBanquetTemplate = DataCenter.ActBanquetV2Data.actBanquetTemplate
  self.itemDropProbCfgDic = DataCenter.ActBanquetV2Data:GetItemDropProbCfgByDropShowId(actBanquetTemplate.drop_show)
  if self.itemDropProbCfgDic == nil then
    return
  end
  for k, v in pairs(self.itemDropProbCfgDic) do
    if v.page == 1 then
      self.textTabUnselect1:SetLocalText(v.page_name)
      self.textTabSelect1:SetLocalText(v.page_name)
    elseif v.page == 2 then
      self.textTabUnselect2:SetLocalText(v.page_name)
      self.textTabSelect2:SetLocalText(v.page_name)
    end
  end
  self:SelectTabShow()
end

function M:SelectTabShow()
  self.compUnSelect1:SetActive(self.curTabIndex ~= 1)
  self.compSelect1:SetActive(self.curTabIndex == 1)
  self.compUnSelect2:SetActive(self.curTabIndex ~= 2)
  self.compSelect2:SetActive(self.curTabIndex == 2)
  self.scrollItemCfgList = self:GetItemDropProbCfgByPageIndex(self.itemDropProbCfgDic, self.curTabIndex)
  self.ScrollLoopListView:SetListItemCount(#self.scrollItemCfgList, false, false)
  self.ScrollLoopListView:RefreshAllShownItem()
  self.ScrollLoopListView:MovePanelToItemIndex_Mod(0, 0)
end

function M:OnBtnTabClick(index)
  if self.curTabIndex == index then
    return
  end
  self.curTabIndex = index
  self:SelectTabShow()
end

function M:GetItemDropProbCfgByPageIndex(itemDropProbCfg, curTabIndex)
  local scrollItemCfgList = {}
  local tmpCfgDic = {}
  for k, v in pairs(itemDropProbCfg) do
    local dropProbCfgRow = v
    if dropProbCfgRow.page == curTabIndex then
      local tmpScrollItemData = tmpCfgDic[dropProbCfgRow.type]
      if tmpScrollItemData == nil then
        tmpCfgDic[dropProbCfgRow.type] = {dropProbCfgRow}
      else
        table.insert(tmpScrollItemData, dropProbCfgRow)
      end
    end
  end
  for k, v in pairs(tmpCfgDic) do
    table.insert(scrollItemCfgList, v)
  end
  table.sort(scrollItemCfgList, function(a, b)
    return a[1].order > b[1].order
  end)
  for i = 1, #scrollItemCfgList do
    local scrollItemCfg = scrollItemCfgList[i]
    table.sort(scrollItemCfg, function(a, b)
      return a.order > b.order
    end)
  end
  return scrollItemCfgList
end

function M:OnGetItemByIndex(listview, index)
  if self.scrollItemCfgList == nil or index < 0 or index >= #self.scrollItemCfgList then
    return nil
  end
  index = index + 1
  local prefabName = self:GetPrefabName(index)
  local item = listview:NewListViewItem(prefabName)
  if item == nil then
    Logger.LogError("\232\161\168\230\131\133\230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150Item\228\184\186\231\169\186 UIBanquetItemDropProbabilityView")
    return
  end
  local itemScript = self:GetScriptName(index)
  local script = self.ScrollContent:GetComponent(item.gameObject.name, itemScript)
  if script == nil then
    local objectName = item.gameObject.name .. tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.ScrollContent:AddComponent(itemScript, objectName)
  end
  script:SetActive(true)
  local tmpType = self.scrollItemCfgList[index][1].type
  if self.expandDic[tmpType] == nil then
    self.expandDic[tmpType] = true
  end
  script:SetItemShow(self.scrollItemCfgList[index], self.expandDic[tmpType], index)
  return item
end

function M:GetScriptName(index)
  local data = self.scrollItemCfgList[index]
  if data and data[1] and data[1].type == 8 then
    return UIBanquetItemDropProbabilityItem_Box
  end
  return UIBanquetItemDropProbabilityItem
end

function M:GetPrefabName(index)
  local data = self.scrollItemCfgList[index]
  if data and data[1] and data[1].type == 8 then
    return "UIBanquetItemDropProbabilityItem_Box"
  end
  return "UIBanquetItemDropProbabilityItem"
end

function M:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function M:SetExpandStateByType(type, state)
  self.expandDic[type] = state
end

function M:ModifyByConfig()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not activityInfo then
    Logger.LogError("ActivityListDataManager GetActivityDataById is nil id:" .. tostring(self.activityId))
    return
  end
  local configId = activityInfo:GetFestivalInterfaceCfgId() or 0
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, configId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. configId)
    return
  end
  if not string.IsNullOrEmpty(lineData.board_page) then
    local pageList = string.split(lineData.board_page, "|")
    self.select0:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, pageList[1]))
    self.select1:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, pageList[1]))
    self.unSelect0:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, pageList[2]))
    self.unSelect1:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, pageList[2]))
    local selectWorldColorArr = string.split(pageList[3], ",")
    local unSelectWorldColorArr = string.split(pageList[4], ",")
    local selectColor = Color.New(tonumber(selectWorldColorArr[1]) / 255, tonumber(selectWorldColorArr[2]) / 255, tonumber(selectWorldColorArr[3]) / 255, tonumber(selectWorldColorArr[4] / 255))
    local unSelectColor = Color.New(tonumber(unSelectWorldColorArr[1]) / 255, tonumber(unSelectWorldColorArr[2]) / 255, tonumber(unSelectWorldColorArr[3]) / 255, tonumber(unSelectWorldColorArr[4] / 255))
    self.textTabUnselect1:SetColor(unSelectColor)
    self.textTabUnselect2:SetColor(unSelectColor)
    self.textTabSelect1:SetColor(selectColor)
    self.textTabSelect2:SetColor(selectColor)
  end
end

return UIBanquetItemDropProbabilityView
