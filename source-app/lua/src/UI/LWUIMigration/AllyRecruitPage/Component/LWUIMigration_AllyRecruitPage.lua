local base = UIBaseContainer
local LWUIMigration_AllyRecruitPage = BaseClass("LWUIMigration_AllyRecruitPage", base)
local LWUIMigration_AllyRecruitItem = require("UI.LWUIMigration.AllyRecruitPage.Component.LWUIMigration_AllyRecruitItem")
local LWUIMigration_AllyRecruitItemNew = require("UI.LWUIMigration.AllyRecruitPage.Component.LWUIMigration_AllyRecruitItemNew")
local Localization = CS.GameEntry.Localization
local inputField_path = "Input/InputField"
local inputField_placeholder_path = "Input/InputField/Placeholder"
local searchBtn_path = "Input/SearchBtn"
local arrowBtn_path = "Input/Arrow"
local loopListView_path = "LoopListView"
local loopListContent_path = "LoopListView/Viewport/Content"
local chooseContentCloseBtn_path = "ChooseContentCloseBtn"
local setTagBtn_path = "SetTagBtn"
local itemTagNameTipCloseBtn_path = "ItemTagNameTipCloseBtn"
local chooseContentNode_path = "ChooseContentNode"
local tmpEmptyNotice_path = "TmpEmptyNotice"
local curFilterTagBg_path = {
  "Input/curFilterTags/curFilterTagBg1",
  "Input/curFilterTags/curFilterTagBg2",
  "Input/curFilterTags/curFilterTagBg3",
  "Input/curFilterTags/curFilterTagBg4",
  "Input/curFilterTags/curFilterTagBg5"
}
local curFilterTagIcon_path = {
  "Input/curFilterTags/curFilterTagBg1/curFilterTagIcon1",
  "Input/curFilterTags/curFilterTagBg2/curFilterTagIcon2",
  "Input/curFilterTags/curFilterTagBg3/curFilterTagIcon3",
  "Input/curFilterTags/curFilterTagBg4/curFilterTagIcon4",
  "Input/curFilterTags/curFilterTagBg5/curFilterTagIcon5"
}
local favorItemTag_path = "ChooseContent/TopContent/FavorAndLangContent/FavorItemTag"
local languageItemTag_path = "ChooseContent/TopContent/FavorAndLangContent/LanguageItemTag"
local luaLWUIMigration_AllyChooseContent = "UI.LWUIMigration.AllyRecruitPage.Component.LWUIMigration_AllyChooseContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:RefreshCurFilterTags()
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

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

function LWUIMigration_AllyRecruitPage:GetRecruitItemName(data)
  local enable = DataCenter.ActMigrationManager:NewChooseCompEnable()
  if not enable then
    return "LWUIMigration_AllyRecruitItem", LWUIMigration_AllyRecruitItem
  end
  local desertTime = data.desertTime or 0
  if desertTime <= 0 then
    return "LWUIMigration_AllyRecruitItem", LWUIMigration_AllyRecruitItem
  end
  return "LWUIMigration_AllyRecruitItemNew", LWUIMigration_AllyRecruitItemNew
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.itemDataList then
    return nil
  end
  if index > self.filterData.startIndex + self.filterData.num - MIGRATION_ALLY_LIST_FIX_REQ_THRESHOLD then
    self.filterData.startIndex = #self.itemDataList
    DataCenter.ActMigrationManager:ReqAllianceMarketListData(self.filterData)
    self.searchTimes = self.searchTimes + 1
  end
  local itemData = self.itemDataList[index]
  local itemName, luaType = self:GetRecruitItemName(itemData)
  local item = loopScroll:NewListViewItem(itemName)
  local script = self.loopListContent:GetComponent(item.gameObject.name, luaType)
  if script == nil then
    local objectName = GetItemNameSequence(self)
    item.gameObject.name = objectName
    script = self.loopListContent:AddComponent(luaType, objectName)
  end
  script:SetActive(true)
  script:SetData(itemData, self.filterData)
  return item
end

local function ComponentDefine(self)
  self.inputField = self:AddComponent(UIInput, inputField_path)
  self.inputField_placeholder = self:AddComponent(UIText, inputField_placeholder_path)
  self.searchBtn = self:AddComponent(UIButton, searchBtn_path)
  self.arrowBtn = self:AddComponent(UIButton, arrowBtn_path)
  self.loopListView = self:AddComponent(UILoopListView2, loopListView_path)
  self.loopListContent = self:AddComponent(UIBaseContainer, loopListContent_path)
  self.chooseContentCloseBtn = self:AddComponent(UIButton, chooseContentCloseBtn_path)
  self.setTagBtn = self:AddComponent(UIButton, setTagBtn_path)
  self.itemTagNameTipCloseBtn = self:AddComponent(UIButton, itemTagNameTipCloseBtn_path)
  self.chooseContentNode = self:AddComponent(UIBaseContainer, chooseContentNode_path)
  self.tmpEmptyNotice = self:AddComponent(UIText, tmpEmptyNotice_path)
  self.curFilterTagBg = {
    self:AddComponent(UIImage, curFilterTagBg_path[1]),
    self:AddComponent(UIImage, curFilterTagBg_path[2]),
    self:AddComponent(UIImage, curFilterTagBg_path[3]),
    self:AddComponent(UIImage, curFilterTagBg_path[4]),
    self:AddComponent(UIImage, curFilterTagBg_path[5])
  }
  self.curFilterTagIcon = {
    self:AddComponent(UIImage, curFilterTagIcon_path[1]),
    self:AddComponent(UIImage, curFilterTagIcon_path[2]),
    self:AddComponent(UIImage, curFilterTagIcon_path[3]),
    self:AddComponent(UIImage, curFilterTagIcon_path[4]),
    self:AddComponent(UIImage, curFilterTagIcon_path[5])
  }
  self.loopListView:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.inputField:SetOnValueChange(function(value)
    self:OnInputFieldValueChange(value)
  end)
  self.inputField:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.searchBtn:SetOnClick(BindCallback(self, self.OnSearchClick))
  self.chooseContentCloseBtn:SetActive(false)
  self.itemTagNameTipCloseBtn:SetActive(false)
  self.arrowBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if not self.dCompChoose then
      UIManager.Instance:OpenWindow(UIWindowNames.LWUIMigrationSearchAlly, {anim = true}, self.filterData)
      return
    end
    if self.dCompChoose.isAsync or not self.dCompChoose:GetActive() then
      self.dCompChoose:ShowTags(self.filterData)
      self.dCompChoose:SetActive(true)
      self.chooseContentCloseBtn:SetActive(true)
    else
      self.dCompChoose:SetActive(false)
    end
  end)
  self.chooseContentCloseBtn:SetOnClick(function()
    self.chooseContentCloseBtn:SetActive(false)
    if not self.dCompChoose then
      return
    end
    self.dCompChoose:SetActive(false)
    self:OnSearchClick()
  end)
  self.itemTagNameTipCloseBtn:SetOnClick(function()
    EventManager:GetInstance():Broadcast(EventId.ActMigrationUISetTagNameTipShow, false)
  end)
  self.setTagBtn:SetOnClick(function()
    local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
    if not isR4orR5 then
      UIUtil.ShowTipsId("migration_activity_tips_20050")
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationSetAllyRecruit, {anim = true}, {
      showServerTime = self.filterData.showServerTime
    })
  end)
  local showNewChoose = DataCenter.ActMigrationManager:NewChooseCompEnable()
  if not showNewChoose then
    self.dCompChoose = UIAsyncLoaderBridge.New(self, "dCompChoose", self.chooseContentNode.transform, UIAssets.LWUIMigrationAllyChooseContent, luaLWUIMigration_AllyChooseContent, true)
  else
    self.dCompChoose = nil
  end
  self.tmpEmptyNotice:SetLocalText("migration_activity_recommend_tips_1006")
  self.tmpEmptyNotice:SetActive(false)
  self.inputField:SetText()
end

local function ComponentDestroy(self)
  self:ClearRecruitItem()
  self.inputField = nil
  self.inputField_placeholder = nil
  self.searchBtn = nil
  self.arrowBtn = nil
  self.loopListView = nil
  self.loopListContent = nil
  self.chooseContentCloseBtn = nil
  self.setTagBtn = nil
  self.itemTagNameTipCloseBtn = nil
  self.chooseContentNode = nil
  self.tmpEmptyNotice = nil
  self.curFilterTagBg = nil
  self.curFilterTagIcon = nil
  if self.dCompChoose then
    self.dCompChoose:Delete()
    self.dCompChoose = nil
  end
end

local function DataDefine(self)
  self.filterData = {}
  self.filterData.startIndex = 0
  self.filterData.num = MIGRATION_ALLY_LIST_FIX_REQ_NUM
  self.filterData.searchTag = {}
  self.filterData.stars = 0
  self.filterData.desertTime = 7
  self.filterData.saveTag = false
  self.filterData.saveLang = false
  self.filterData.searchLanguageId = Localization:GetLanguage()
  self.searchTimes = 0
  self.filterData.showServerTime = false
end

local function DataDestroy(self)
  self.filterData = nil
  self.tagsInit = nil
end

function LWUIMigration_AllyRecruitPage:ResetSearchFilter()
  self.filterData.startIndex = 0
  self.filterData.num = MIGRATION_ALLY_LIST_FIX_REQ_NUM
  table.clear(self.filterData.searchTag)
  self.filterData.stars = 0
  self.filterData.desertTime = 7
  self.filterData.saveTag = false
  self.filterData.saveLang = false
  self.filterData.searchLanguageId = Localization:GetLanguage()
end

local function SetData(self, searchName)
  if self.searchTimes <= 0 or not string.IsNullOrEmpty(searchName) then
    if searchName then
      self:ResetSearchFilter()
      self.filterData.searchName = searchName
      if self.inputField then
        self.inputField:SetText(searchName)
      end
      self:RefreshCurFilterTags()
    end
    DataCenter.ActMigrationManager:ReqAllianceMarketListData(self.filterData)
    self.searchTimes = self.searchTimes + 1
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationSetAllyTagToggle, self.OnAllyTagToggleSet)
  self:AddUIListener(EventId.ActMigrationSetFavorTagToggle, self.OnFavorTagToggleSet)
  self:AddUIListener(EventId.ActMigrationOnHandleAllianceMarketList, self.OnHandleAllianceMarketList)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClose)
  self:AddUIListener(EventId.ActMigrationOnHandleSaveAllianceMarket, self.OneSaveAllianceMarket)
  self:AddUIListener(EventId.ActMigrationUISetTagNameTipShow, self.OnSetTagNameTipShow)
  self:AddUIListener(EventId.ActMigrationSetLanguage, self.OnActMigrationSetLanguage)
  self:AddUIListener(EventId.ActMigrationStartSearch, self.OnSearchClick)
  self:AddUIListener(EventId.ActMigrationSetSearchFilter, self.OnResetSearchParams)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActMigrationSetAllyTagToggle, self.OnAllyTagToggleSet)
  self:RemoveUIListener(EventId.ActMigrationSetFavorTagToggle, self.OnFavorTagToggleSet)
  self:RemoveUIListener(EventId.ActMigrationOnHandleAllianceMarketList, self.OnHandleAllianceMarketList)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClose)
  self:RemoveUIListener(EventId.ActMigrationOnHandleSaveAllianceMarket, self.OneSaveAllianceMarket)
  self:RemoveUIListener(EventId.ActMigrationUISetTagNameTipShow, self.OnSetTagNameTipShow)
  self:RemoveUIListener(EventId.ActMigrationSetLanguage, self.OnActMigrationSetLanguage)
  self:RemoveUIListener(EventId.ActMigrationStartSearch, self.OnSearchClick)
  self:RemoveUIListener(EventId.ActMigrationSetSearchFilter, self.OnResetSearchParams)
  base.OnRemoveListener(self)
end

function LWUIMigration_AllyRecruitPage:IsChooseActive()
  if not self.dCompChoose then
    return UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIMigrationSearchAlly)
  end
  if self.dCompChoose.isAsync then
    return false
  end
  return self.dCompChoose:GetActive()
end

function LWUIMigration_AllyRecruitPage:OnAllyTagToggleSet(data)
  if self:IsChooseActive() and self.filterData and data.id then
    if not data.isChoose then
      table.removebyvalue(self.filterData.searchTag, data.id)
    else
      table.insert(self.filterData.searchTag, data.id)
    end
    self:RefreshCurFilterTags()
  end
end

function LWUIMigration_AllyRecruitPage:OnFavorTagToggleSet(data)
  if self.filterData then
    self.filterData.saveTag = data
    self:RefreshCurFilterTags()
  end
end

function LWUIMigration_AllyRecruitPage:OnHandleAllianceMarketList()
  self:RefreshList()
end

function LWUIMigration_AllyRecruitPage:OnWindowClose(windowName)
  if windowName == UIWindowNames.LWUIMigrationSetAllyRecruit then
    DataCenter.ActMigrationManager:ReqAllianceMarketListData(self.filterData)
  end
end

function LWUIMigration_AllyRecruitPage:OneSaveAllianceMarket()
  DataCenter.ActMigrationManager:ReqAllianceMarketListData(self.filterData)
end

function LWUIMigration_AllyRecruitPage:OnSetTagNameTipShow(data)
  if data then
    self.itemTagNameTipCloseBtn:SetActive(true)
  else
    self.itemTagNameTipCloseBtn:SetActive(false)
  end
end

function LWUIMigration_AllyRecruitPage:OnActMigrationSetLanguage(data)
  local bIsChoose = data.isChoose
  local idLang = data.idLang
  self.filterData.searchLanguageId = idLang
  self.filterData.saveLang = bIsChoose
  self:RefreshCurFilterTags()
end

function LWUIMigration_AllyRecruitPage:OnInputFieldValueChange(_)
  local value = self.inputField:GetText()
  self.inputField_placeholder:SetActive(value == "")
  if #value > MAX_AL_NAME_CHAR then
    CS.UIGray.SetGray(self.searchBtn.transform, true, true)
  else
    CS.UIGray.SetGray(self.searchBtn.transform, false, true)
  end
  if #value == 0 then
    self.filterData.searchName = value
    DataCenter.ActMigrationManager:ReqAllianceMarketListData(self.filterData)
  end
end

function LWUIMigration_AllyRecruitPage:IptOnValueChange(_)
  local value = self.inputField:GetText()
end

function LWUIMigration_AllyRecruitPage:OnSearchClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local value = self.inputField:GetText()
  if #value > MAX_AL_NAME_CHAR then
    UIUtil.ShowTipsId(120193)
    return
  end
  self.filterData.searchName = value
  DataCenter.ActMigrationManager:ReqAllianceMarketListData(self.filterData)
  self.searchTimes = self.searchTimes + 1
end

function LWUIMigration_AllyRecruitPage:OnResetSearchParams(params)
  if not params then
    return
  end
  if self.filterData then
    if self.filterData.searchTag then
      table.clear(self.filterData.searchTag)
    end
    if params.searchTag then
      for k, v in ipairs(params.searchTag) do
        table.insert(self.filterData.searchTag, v)
      end
    end
    self.filterData.saveTag = params.saveTag
    self.filterData.saveLang = params.saveLang
    self.filterData.searchLanguageId = params.searchLanguageId
    self.filterData.stars = params.stars or 0
    self.filterData.desertTime = params.desertTime or 7
    self.filterData.showServerTime = params.showServerTime
  end
  self:RefreshCurFilterTags()
end

function LWUIMigration_AllyRecruitPage:ClearRecruitItem()
  self.loopListContent:RemoveComponents(LWUIMigration_AllyRecruitItem)
  self.loopListContent:RemoveComponents(LWUIMigration_AllyRecruitItemNew)
  self.loopListView:ClearAllItems()
end

function LWUIMigration_AllyRecruitPage:RefreshList()
  self:ClearRecruitItem()
  self.itemDataList = DataCenter.ActMigrationManager.alMarketListData
  if self.itemDataList then
    if #self.itemDataList == 0 then
      self.loopListView:SetActive(false)
      self.tmpEmptyNotice:SetActive(true)
    else
      self.loopListView:SetActive(true)
      self.loopListView:SetListItemCount(#self.itemDataList, false, false)
      self.loopListView:RefreshAllShownItem()
      self.tmpEmptyNotice:SetActive(false)
    end
  end
end

function LWUIMigration_AllyRecruitPage:RefreshCurFilterTags()
  if self.filterData then
    local curFilterTags = self.filterData.searchTag
    for i = 1, math.min(#self.curFilterTagBg - 2, #curFilterTags) do
      self.curFilterTagBg[i]:SetActive(true)
      local icon = GetTableData(TableName.LW_Migration_Alliance_Tag, curFilterTags[i], "icon") or ""
      local icon_bg = GetTableData(TableName.LW_Migration_Alliance_Tag, curFilterTags[i], "icon_bg") or ""
      self.curFilterTagBg[i]:LoadSpriteAuto(string.format(LoadPath.LWUIMigrationIconPath, icon_bg))
      self.curFilterTagIcon[i]:LoadSpriteAuto(string.format(LoadPath.LWUIMigrationIconPath, icon))
    end
    for i = #curFilterTags + 1, #self.curFilterTagBg - 2 do
      self.curFilterTagBg[i]:SetActive(false)
    end
    self.curFilterTagBg[#self.curFilterTagBg - 1]:SetActive(self.filterData.saveTag)
    self.curFilterTagBg[#self.curFilterTagBg]:SetActive(self.filterData.saveLang)
    EventManager:GetInstance():Broadcast(EventId.ActMigrationSetAllyTagToggleChanged)
  end
end

LWUIMigration_AllyRecruitPage.OnCreate = OnCreate
LWUIMigration_AllyRecruitPage.OnDestroy = OnDestroy
LWUIMigration_AllyRecruitPage.OnEnable = OnEnable
LWUIMigration_AllyRecruitPage.OnDisable = OnDisable
LWUIMigration_AllyRecruitPage.ComponentDefine = ComponentDefine
LWUIMigration_AllyRecruitPage.ComponentDestroy = ComponentDestroy
LWUIMigration_AllyRecruitPage.DataDefine = DataDefine
LWUIMigration_AllyRecruitPage.DataDestroy = DataDestroy
LWUIMigration_AllyRecruitPage.SetData = SetData
LWUIMigration_AllyRecruitPage.OnAddListener = OnAddListener
LWUIMigration_AllyRecruitPage.OnRemoveListener = OnRemoveListener
return LWUIMigration_AllyRecruitPage
