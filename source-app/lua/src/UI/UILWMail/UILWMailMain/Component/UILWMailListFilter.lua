local UILWMailListFilter = BaseClass("UILWMailListFilter", UIBaseContainer)
local base = UIBaseContainer
local UILWMailListFilterItem = require("UI.UILWMail.UILWMailMain.Component.UILWMailListFilterItem")
local UILWMailListSearchRecordItem = require("UI.UILWMail.UILWMailMain.Component.UILWMailListSearchRecordItem")
local Localization = CS.GameEntry.Localization
local name_filter_path = "NameFilterContainer/NameFilter"
local name_filter_focus_path = "NameFilterContainer/NameFilter/FocusBtn"
local search_btn_path = "NameFilterContainer/SearchBtn"
local delete_btn_path = "NameFilterContainer/DeleteBtn"
local limit_txt_path = "NameFilterContainer/DeleteBtn/LimitText"
local show_types_btn_path = "TypeFilterContainer/ShowTypesBtn"
local type_filter_panel_path = "TypeFilterContainer/TypeFilterPanel"
local close_mask_btn_path = "TypeFilterContainer/TypeFilterPanel/CloseMaskBtn"
local scroll_view_path = "TypeFilterContainer/TypeFilterPanel/ScrollView"
local filter_btn_path = "TypeFilterContainer/TypeFilterPanel/FilterBtn"
local arrow_down_path = "TypeFilterContainer/ShowTypesBtn/ArrowDown"
local show_types_btn_txt_path = "TypeFilterContainer/ShowTypesBtn/ShowTypesBtnText"
local img_loading_path = "NameFilterContainer/ImgLoading"
local progress_text_path = "NameFilterContainer/ProgressText"
local search_history_panel_path = "NameFilterContainer/SearchHistoryPanel"
local search_scroll_view_path = "NameFilterContainer/SearchHistoryPanel/SearchScrollView"
local search_close_mask_btn_path = "NameFilterContainer/SearchCloseMaskBtn"
local Click_Interval = 5000
local Character_Limit = 20

function UILWMailListFilter:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UILWMailListFilter:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailListFilter:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
end

function UILWMailListFilter:OnRemoveListener()
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  base.OnRemoveListener(self)
end

local IgnoreWindowNames = {
  [UIWindowNames.UINoticeTips] = true,
  [UIWindowNames.UICommonMessageSpecialBar] = true,
  [UIWindowNames.UICommonSingleMsgBar] = true,
  [UIWindowNames.UICommonMessageBar] = true,
  [UIWindowNames.UICommonMessageBarOld] = true,
  [UIWindowNames.UIBattleMessageBar] = true
}

function UILWMailListFilter:OnWindowOpened(windowName)
  local isIgnore = UIUtil.CheckIsIgnoreWindowAtMobileInputFunc(windowName)
  if isIgnore then
    return
  end
  local isNotCovered = UIUtil.CheckNormalLayerWindowIsNotCovered(self.view.__name)
  if not isNotCovered then
    self.mobileInputField:SetVisible(false)
  end
end

function UILWMailListFilter:OnWindowClosed(windowName)
  local isIgnore = UIUtil.CheckIsIgnoreWindowAtMobileInputFunc(windowName)
  if isIgnore then
    return
  end
  local isNotCovered = UIUtil.CheckNormalLayerWindowIsNotCovered(self.view.__name)
  if isNotCovered then
    self.mobileInputField:SetVisible(true)
  end
end

function UILWMailListFilter:ComponentDefine()
  self.type_filter_panel = self:AddComponent(UIBaseContainer, type_filter_panel_path)
  self.filter_btn = self:AddComponent(UIButton, filter_btn_path)
  self.filter_btn:SetOnClick(function()
    self:OnFilterTypeBtnClick()
  end)
  self.show_types_btn = self:AddComponent(UIButton, show_types_btn_path)
  self.show_types_btn:SetOnClick(function()
    self:OnShowTypesBtnClick()
  end)
  self.close_mask_btn = self:AddComponent(UIButton, close_mask_btn_path)
  self.close_mask_btn:SetOnClick(function()
    self:OnMaskBtnClick()
  end)
  self.arrow_down_img = self:AddComponent(UIImage, arrow_down_path)
  self.show_types_btn_txt = self:AddComponent(UIText, show_types_btn_txt_path)
  self.scrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scrollView:AddComponent(UILWMailListFilterItem, itemObj)
    self.objList[itemObj.name] = cellItem
    if cellItem ~= nil then
      cellItem:RefreshView(index, self.list[index], self.selectedList, self.onItemSelectFunc)
    end
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self.objList[itemObj.name] = nil
    self.scrollView:RemoveComponent(itemObj.name, UILWMailListFilterItem)
  end)
  self.search_history_panel = self:AddComponent(UIBaseContainer, search_history_panel_path)
  self.searchScrollView = self:AddComponent(UIScrollView, search_scroll_view_path)
  self.searchScrollView:SetOnItemMoveIn(function(itemObj, index)
    local records = DataCenter.MailDataManager.Filter:GetSearchRecords()
    itemObj.name = tostring(index)
    local cellItem = self.scrollView:AddComponent(UILWMailListSearchRecordItem, itemObj)
    if cellItem ~= nil then
      cellItem:RefreshView(index, records[index], self.onSearchItemSelect)
    end
  end)
  self.searchScrollView:SetOnItemMoveOut(function(itemObj, index)
    self.scrollView:RemoveComponent(itemObj.name, UILWMailListSearchRecordItem)
  end)
  self.search_btn = self:AddComponent(UIButton, search_btn_path)
  self.search_btn:SetOnClick(function()
    self:OnSearchBtnClick()
  end)
  self.delete_btn = self:AddComponent(UIButton, delete_btn_path)
  self.delete_btn:SetOnClick(function()
    self:OnDeleteBtnClick()
  end)
  self.limitText = self:AddComponent(UIText, limit_txt_path)
  self.search_close_mask_btn = self:AddComponent(UIButton, search_close_mask_btn_path)
  self.search_close_mask_btn:SetOnClick(function()
    self:OnSearchMaskBtnClick()
  end)
  self.name_filter_focus_btn = self:AddComponent(UIButton, name_filter_focus_path)
  self.name_filter_focus_btn:SetOnClick(function()
    self:SetFocus(true)
  end)
  self.loading_anim = self:AddComponent(UISimpleAnimation, img_loading_path)
  self.progressText = self:AddComponent(UIText, progress_text_path)
  self.name_filter = self:AddComponent(UIInput, name_filter_path)
  self.mobileInputField = self.name_filter.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
  if not self:IsOnAndroidOrIOS() then
    self.name_filter:SetOnValueChange(function(val)
      self:OnTextChange(val)
    end)
    
    function self.inputOnSelectFunc()
      self:ShowSearchRecords()
    end
    
    self.name_filter.unity_tmpinput.onSelect:AddListener(self.inputOnSelectFunc)
  else
    function self.OnShowKeyboard(mobilId, isShow, height)
      if isShow then
        self:ShowSearchRecords()
      else
      end
    end
    
    function self.OnTextChangeFromPlatform(str)
      self:OnTextChange(str)
    end
    
    if ChatInterface.GetMobilSupportMultiple() then
      self.mobileInputField.OnShowKeyboard = self.OnShowKeyboard
      self.mobileInputField.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform
    else
      CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = self.OnShowKeyboard
      CS.Mopsicus.Plugins.MobileInput.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform
    end
  end
end

function UILWMailListFilter:ComponentDestroy()
  if not self:IsOnAndroidOrIOS() then
    self.name_filter.unity_tmpinput.onSelect:RemoveListener(self.inputOnSelectFunc)
    self.inputOnSelectFunc = nil
  else
    if ChatInterface.GetMobilSupportMultiple() then
      self.mobileInputField.OnShowKeyboard = nil
      self.mobileInputField.OnTextChangeFromPlatform = nil
    else
      CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = nil
      CS.Mopsicus.Plugins.MobileInput.OnTextChangeFromPlatform = nil
    end
    self.OnShowKeyboard = nil
    self.OnTextChangeFromPlatform = nil
  end
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UILWMailListFilterItem)
  self.searchScrollView:ClearCells()
  self.searchScrollView:RemoveComponents(UILWMailListSearchRecordItem)
  self.name_filter = nil
  self.search_btn = nil
  self.progressText = nil
  self.delete_btn = nil
  self.show_types_btn = nil
  self.type_filter_panel = nil
  self.close_mask_btn = nil
  self.scroll_view = nil
  self.filter_btn = nil
  self.show_types_btn_txt = nil
  self.limitText = nil
end

function UILWMailListFilter:InitData()
  self.objList = {}
  self.list = {}
  self.isShowTypeList = false
  self.selectedList = {}
  self.keywords = ""
  self.cacheInputText = ""
  self.filterTypes = {}
  self.filterMailIds = {}
  self.filterExcludeMailIds = {}
  self.lastClickSearchTime = -1
  self.lastClickFilterTime = -1
  self.querying = false
end

function UILWMailListFilter:DataDefine()
  self:InitData()
  self.filterFunc = nil
  
  function self.onItemSelectFunc(item, index)
    self:OnItemSelect(index)
  end
  
  function self.onSearchItemSelect(index, data)
    self:OnSearchItemSelect(index, data)
  end
  
  Click_Interval = self:GetFilterInterval()
end

function UILWMailListFilter:DataDestroy()
  self:InitData()
  self.filterFunc = nil
  self.onItemSelectFunc = nil
  self.onSearchItemSelect = nil
end

function UILWMailListFilter:OnItemSelect(index)
  local needRefresh = false
  if index == 1 then
    if 1 < #self.list then
      for i = 2, #self.list do
        if self.selectedList[i] == true then
          self.selectedList[i] = false
          needRefresh = true
        end
      end
    end
  elseif self.selectedList[1] == true then
    self.selectedList[1] = false
    needRefresh = true
  end
  if needRefresh then
    for _, obj in pairs(self.objList) do
      if not IsNull(obj) then
        obj:UpdateToggle()
      end
    end
  end
  local state = true
  for k, v in pairs(self.selectedList) do
    if v then
      state = false
      break
    end
  end
  CS.UIGray.SetGray(self.filter_btn.transform, state, not state)
end

function UILWMailListFilter:SetDefaultSelect()
  if not DataCenter.MailDataManager.Filter:IsFilterOpen() then
    return
  end
  local isDefaultSelectAll = true
  local selectedList = {}
  if self.view and self.view.ctrl then
    local list = self.view.ctrl:GetMailGroupFilters()
    for i, v in ipairs(list) do
      if v.default_open_type == 1 then
        local isOpen = BattleFieldUtil.InBattleField(tonumber(v.default_open_param[1]))
        if isOpen then
          selectedList[i] = isOpen
          isDefaultSelectAll = false
        end
      end
    end
  end
  if isDefaultSelectAll then
    self.selectedList[1] = true
    self.show_types_btn_txt:SetText(Localization:GetString("mail_filter_tips_16"))
  else
    self.selectedList = selectedList
    self:OnFilterTypeBtnClick()
  end
end

function UILWMailListFilter:SetFilterListener(filterFunc)
  self.filterFunc = filterFunc
end

function UILWMailListFilter:ResetView()
  self:InitData()
  self:SetDefaultSelect()
  self:RefreshView()
  self:OnFinishQuery()
end

function UILWMailListFilter:RefreshView()
  if not self.view or not self.view.ctrl then
    return
  end
  local current_view = self.view.ctrl:GetCurrentView()
  if current_view ~= MailContentType.MailList then
    return
  end
  self.list = self.view.ctrl:GetMailGroupFilters()
  self:SetVisible(true)
  self:SetText(self.cacheInputText)
  self.limitText:SetActive(not self.querying)
  self.limitText:SetText(utf8.len(self.cacheInputText) .. "/" .. Character_Limit)
  self.delete_btn:SetActive(not string.IsNullOrEmpty(self.cacheInputText) and not self.querying)
  self.arrow_down_img:SetActive(self.isShowTypeList)
  self.type_filter_panel:SetActive(self.isShowTypeList)
  self.search_history_panel:SetActive(false)
  self.show_types_btn:SetActive(#self.list > 1)
  if self.isShowTypeList then
    self.dataCount = #self.list
    if self.dataCount > 0 then
      self.scrollView:SetActive(true)
      self.scrollView:SetTotalCount(self.dataCount)
      self.scrollView:RefillCells()
    else
      self.scrollView:SetActive(false)
    end
  else
    self.scrollView:SetActive(false)
  end
end

function UILWMailListFilter:OnShowTypesBtnClick()
  self.isShowTypeList = not self.isShowTypeList
  self:RefreshView()
end

function UILWMailListFilter:OnMaskBtnClick()
  self.isShowTypeList = false
  self:RefreshView()
end

function UILWMailListFilter:OnFilterTypeBtnClick()
  if self.querying then
    return
  end
  local str = ""
  if self.selectedList then
    local tab = {}
    for k, v in pairs(self.selectedList) do
      if v then
        table.insert(tab, k)
      end
    end
    str = table.concat(tab, ",")
  end
  PostEventLog.Track(PostEventLog.Defines.MAIL_FILTER, {chat_channel = str})
  self.isShowTypeList = false
  self:RefreshView()
  if type(self.filterFunc) == "function" then
    local types = {}
    local mailIds = {}
    local nameTab = {}
    local excludeMailIds = {}
    for k, v in pairs(self.selectedList) do
      if v then
        local data = self.list[k]
        if data then
          table.insert(types, data.type)
          table.insert(mailIds, data.mail_id)
          table.insert(excludeMailIds, data.not_show_mail_id)
          table.insert(nameTab, Localization:GetString(data.name))
        end
      end
    end
    self.filterTypes = types
    self.filterMailIds = mailIds
    self.filterExcludeMailIds = excludeMailIds
    self.filterFunc(MailFilterType.MailType, {
      keywords = self.keywords,
      mailTypes = self.filterTypes,
      mailIds = self.filterMailIds,
      excludeMailIds = self.filterExcludeMailIds
    })
    self.show_types_btn_txt:SetText(table.concat(nameTab, ", "))
  end
end

function UILWMailListFilter:OnHideFilter()
  self:SetVisible(false)
end

function UILWMailListFilter:OnSearchBtnClick()
  if self.querying then
    return
  end
  local text = self.name_filter:GetText()
  if self.keywords == text then
    UIUtil.ShowTipsId("mail_search_tips_2")
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.lastClickSearchTime + Click_Interval then
    UIUtil.ShowTipsId("mail_tips_10005")
    return
  end
  local tab = -1
  if self.view and self.view.ctrl then
    tab = self.view.ctrl:GetCurrentTab()
  end
  PostEventLog.Track(PostEventLog.Defines.MAIL_SEARCH, {count = tab})
  self.lastClickSearchTime = now
  self:HideSearchRecords()
  self:SetFocus(false)
  self.keywords = text
  if type(self.filterFunc) == "function" then
    self.filterFunc(MailFilterType.MailName, {
      keywords = string.trim(self.keywords),
      mailTypes = self.filterTypes,
      mailIds = self.filterMailIds,
      excludeMailIds = self.filterExcludeMailIds
    })
    DataCenter.MailDataManager.Filter:AddSearchRecords(string.trim(self.keywords))
  end
end

function UILWMailListFilter:OnDeleteBtnClick()
  self:SetText("")
end

function UILWMailListFilter:OnStartQuery()
  self.querying = true
  self.loading_anim:SetActive(true)
  self.progressText:SetActive(true)
  self.delete_btn:SetActive(false)
  self:UpdateProgress()
  self:SetBtnsGray(true)
end

function UILWMailListFilter:SetText(text)
  self.name_filter:SetText(text)
  self.mobileInputField.Text = text
end

function UILWMailListFilter:SetTextWithoutCallback(val)
  self.suppressCallback = true
  self:SetText(val)
  self.suppressCallback = false
end

function UILWMailListFilter:OnTextChange(val)
  if self.suppressCallback then
    return
  end
  if val == self.cacheInputText then
    return
  end
  if self.querying then
    self:SetTextWithoutCallback(self.cacheInputText)
    return
  end
  self.cacheInputText = val
  self.delete_btn:SetActive(not string.IsNullOrEmpty(val))
  self.limitText:SetText(utf8.len(val) .. "/" .. Character_Limit)
end

function UILWMailListFilter:SetVisible(state)
  self.mobileInputField:SetVisible(state)
end

function UILWMailListFilter:SetFocus(state)
  if not self:IsOnAndroidOrIOS() then
    if state then
      self.name_filter:Select()
    end
  else
    self.mobileInputField:SetFocus(state)
  end
end

function UILWMailListFilter:OnFinishQuery()
  self.loading_anim:SetActive(false)
  self.progressText:SetActive(false)
  local searchTxt = self.name_filter:GetText()
  self.delete_btn:SetActive(not string.IsNullOrEmpty(searchTxt))
  self:UpdateProgress()
  self:SetBtnsGray(false)
  self.querying = false
end

function UILWMailListFilter:UpdateProgress(index, total)
  if not self.view then
    return
  end
  local text = "0%"
  if total ~= nil and index ~= nil then
    text = string.format("%.1f%%", math.min(index / total * 100, 100))
  end
  self.progressText:SetText(text)
end

function UILWMailListFilter:SetBtnsGray(state)
  CS.UIGray.SetGray(self.search_btn.transform, state, not state)
  CS.UIGray.SetGray(self.filter_btn.transform, state, not state)
end

function UILWMailListFilter:ShowSearchRecords()
  if self.querying then
    return
  end
  self.search_close_mask_btn:SetActive(true)
  local records = DataCenter.MailDataManager.Filter:GetSearchRecords()
  if #records <= 0 then
    self.search_history_panel:SetActive(false)
    return
  end
  self.search_history_panel:SetActive(true)
  self.searchScrollView:SetTotalCount(#records)
  self.searchScrollView:RefillCells(1, true)
end

function UILWMailListFilter:HideSearchRecords()
  self.search_history_panel:SetActive(false)
  self.search_close_mask_btn:SetActive(false)
end

function UILWMailListFilter:OnSearchItemSelect(index, data)
  self:SetText(data)
  self:HideSearchRecords()
  self:SetFocus(false)
end

function UILWMailListFilter:OnSearchMaskBtnClick()
  self:HideSearchRecords()
  self:SetFocus(false)
end

function UILWMailListFilter:IsOnEditorOrPC()
  return CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC()
end

function UILWMailListFilter:IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

function UILWMailListFilter:GetFilterInterval()
  local interval = LuaEntry.DataConfig:TryGetNum("mail_optimize_102", "k2", 5)
  return interval * 1000
end

return UILWMailListFilter
