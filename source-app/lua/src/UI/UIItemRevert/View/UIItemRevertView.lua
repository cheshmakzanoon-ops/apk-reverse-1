local UIItemRevertView = BaseClass("UIItemRevertView", UIBaseView)
local base = UIBaseView
local UIItemRevertAuto = require("UI.UIItemRevert.Auto.UIItemRevertAuto")
local UIItemRevertItemComView = require("UI.UIItemRevert.Component.UIItemRevertItemComView")

function UIItemRevertView:OnCreate()
  base.OnCreate(self)
  self.binder = UIItemRevertAuto.New()
  self.binder:bind(self)
  self.itemPrefab:GameObjectCreatePool()
  self.itemScrollRect:AddValueChangeListener(function(vec)
    self:OnScrollValueChanged(vec)
  end)
  self.btn_btnswitch:SetOnClick(function()
    self:OnBtnSwitchClick()
  end)
  self.btn_lw_btn_info:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemRevertRule, {anim = true})
  end)
  self.btn_panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_lw_btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_uinewbutton:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemRevertHistory)
  end)
  self.button_filter:SetOnClick(function()
    self:OpenFilterPanel()
  end)
  self.filter_full_close_btn:SetOnClick(function()
    self:CloseFilterPanel()
  end)
  self:InitFilterPanel()
  self.totalCount = 0
  self.remainingCount = 0
  self.chipRemainingCount = 0
  self.cardRemainingCount = 0
  self.text_none:SetActive(true)
  self:UpdateTimeTypeText()
  self:LoadInitialHistory()
  self.resetTimer = TimerManager:GetInstance():GetTimer(1.0, self.UpdateResetTime, self, false, false, false)
  self.resetTimer:Start()
  self:UpdateResetTime()
end

function UIItemRevertView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  self.compCContent:RemoveComponents(UIItemRevertItemComView)
  self.compCContent = nil
  self.itemPrefab:GameObjectRecycleAll()
  self.itemPrefab = nil
  self.itemList = nil
  self.historyRecords = nil
  self.itemScrollRect = nil
  if self.resetTimer then
    self.resetTimer:Stop()
    self.resetTimer = nil
  end
  base.OnDestroy(self)
end

function UIItemRevertView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ItemRevertTimeTypeSwitch, self.UpdateTimeTypeText)
end

function UIItemRevertView:OnRemoveListener()
  self:RemoveUIListener(EventId.ItemRevertTimeTypeSwitch, self.UpdateTimeTypeText)
  base.OnRemoveListener(self)
end

function UIItemRevertView:LoadInitialHistory()
  self.historyRecords = {}
  self.recordIdSet = {}
  self.currentPage = 0
  self.hasMoreRecords = true
  self.itemList = {}
  self:FetchHistoryRecords(0)
end

function UIItemRevertView:FetchHistoryRecords(page)
  if self.isLoading then
    return
  end
  self.isLoading = true
  local filters = {}
  local mapping = {
    [2] = 1,
    [3] = 2,
    [4] = 4,
    [5] = 3,
    [6] = 5
  }
  if not self.selectedFilterOptions[1] then
    for i = 2, 6 do
      if self.selectedFilterOptions[i] then
        table.insert(filters, mapping[i])
      end
    end
  end
  local intSort = 0
  if self.selectedSwitchOptions[2] then
    intSort = 1
  end
  SFSNetwork.SendMessage(MsgDefines.ItemRevertMainView, page, nil, filters, intSort)
end

function UIItemRevertView:LoadMoreHistory()
  if not self.hasMoreRecords or self.isLoading then
    return
  end
  self:FetchHistoryRecords(self.currentPage + 1)
end

function UIItemRevertView:HistoryRecordsCallback(message)
  self.isLoading = false
  self.currentPage = message.page or self.currentPage
  local newRecords = message.revertInfos or {}
  self.totalCount = message.totalCount or 0
  self.remainingCount = message.remainingCount or 0
  self.chipRemainingCount = message.chipRemainingCount or 0
  self.cardRemainingCount = message.cardRemainingCount or 0
  local remainingDescStr = CS.GameEntry.Localization:GetString("undo_system_rest_desc02")
  local colorStr = "<color=#F97077>%d</color>"
  self.txt_textcount:SetText(remainingDescStr .. " " .. string.format(colorStr, self.remainingCount))
  local addedCount = 0
  for _, record in ipairs(newRecords) do
    local recordId = record.id
    if not self.recordIdSet[recordId] then
      self.recordIdSet[recordId] = true
      table.insert(self.historyRecords, record)
      addedCount = addedCount + 1
    end
  end
  self.hasMoreRecords = #newRecords == 20 and 0 < addedCount
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  if self.selectedSwitchOptions[1] then
    local filteredRecords = {}
    for _, record in ipairs(self.historyRecords) do
      local canRevert = true
      if record.rightItem then
        for _, v in ipairs(record.rightItem) do
          if not (v.own and v.num) or v.own < v.num then
            canRevert = false
            break
          end
        end
        if record.type == 2 and nowTime >= record.activityCloseTime then
          canRevert = false
        end
        if canRevert then
          table.insert(filteredRecords, record)
        end
      end
    end
    self.historyRecords = filteredRecords
  end
  self:ClearContent()
  for i = 1, #self.historyRecords do
    local item = self.itemPrefab:GameObjectSpawn(self.compCContent.transform)
    item.name = "revert_item_" .. i
    local cell = self.compCContent:AddComponent(UIItemRevertItemComView, item.name)
    cell:UpdateData(self.historyRecords[i])
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compCContent.rectTransform)
  local itemCount = #self.historyRecords
  if 0 < itemCount then
    self.text_none:SetActive(false)
  else
    self.text_none:SetActive(true)
  end
end

function UIItemRevertView:ClearContent()
  self.compCContent:RemoveComponents(UIItemRevertItemComView)
  self.itemPrefab:GameObjectRecycleAll()
end

function UIItemRevertView:OnScrollValueChanged(value)
  if value.y < 0.1 then
    self:LoadMoreHistory()
  end
end

function UIItemRevertView:OnBtnSwitchClick()
  local isLocalTime = CS.GameEntry.Setting:GetPrivateBool("ItemRevertTimeType_LocalTime", false)
  if isLocalTime then
    CS.GameEntry.Setting:SetPrivateBool("ItemRevertTimeType_LocalTime", false)
  else
    CS.GameEntry.Setting:SetPrivateBool("ItemRevertTimeType_LocalTime", true)
  end
  EventManager:GetInstance():Broadcast(EventId.ItemRevertTimeTypeSwitch)
end

function UIItemRevertView:UpdateTimeTypeText()
  local isLocalTime = CS.GameEntry.Setting:GetPrivateBool("ItemRevertTimeType_LocalTime", false)
  if isLocalTime then
    self.txt_texttimetype:SetLocalText("undo_system_time_switch_btn1")
  else
    self.txt_texttimetype:SetLocalText("undo_system_time_switch_btn2")
  end
end

function UIItemRevertView:UpdateResetTime()
  local nextMonthTime = UITimeManager:GetInstance():GetNextMonth()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if nextMonthTime ~= nil then
    local remainTime = nextMonthTime - curTime
    if 0 < remainTime then
      local txt = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      self.txt_next_month:SetText(txt)
    else
      self.txt_next_month:SetActive(false)
    end
  else
    self.txt_next_month:SetActive(false)
  end
end

function UIItemRevertView:GetTotalCount()
  return self.totalCount
end

function UIItemRevertView:GetRemainingCount()
  return self.remainingCount
end

function UIItemRevertView:GetChipRemainingCount()
  return self.chipRemainingCount
end

function UIItemRevertView:GetCardRemainingCount()
  return self.cardRemainingCount
end

function UIItemRevertView:InitFilterPanel()
  self.selectedFilterOptions = {}
  self.cachedFilterOptions = {}
  for i = 1, 6 do
    self.selectedFilterOptions[i] = false
    self.cachedFilterOptions[i] = false
    self.filterOptions[i]:SetCallData(i, self.OnFilterOptionClick, self)
  end
  self.selectedSwitchOptions = {}
  self.cachedSwitchOptions = {}
  for i = 1, 2 do
    self.selectedSwitchOptions[i] = false
    self.cachedSwitchOptions[i] = false
    self.switchOptions[i]:SetCallData(i, self.OnSwitchOptionClick, self)
  end
  self:OnFilterOptionClick(1)
  self:RefreshSwitchOptions()
  self:RefreshFilterBtnState()
end

function UIItemRevertView:RefreshFilterBtnState()
  local filterOnlySelectedAll = self.selectedFilterOptions[1]
  local SwitchNoneSelected = true
  for i = 1, 2 do
    if self.selectedSwitchOptions[i] then
      SwitchNoneSelected = false
      break
    end
  end
  if filterOnlySelectedAll and SwitchNoneSelected then
    self.text_filter:SetLocalText("undo_system2_filter_btn1")
    self.image_filter_close:SetActive(true)
    self.image_filter_open:SetActive(false)
  else
    self.text_filter:SetLocalText("undo_system2_filter_btn2")
    self.image_filter_close:SetActive(false)
    self.image_filter_open:SetActive(true)
  end
end

function UIItemRevertView:OpenFilterPanel()
  self.filter_root:SetActive(true)
  for i = 1, 6 do
    self.cachedFilterOptions[i] = self.selectedFilterOptions[i]
  end
  for i = 1, 2 do
    self.cachedSwitchOptions[i] = self.selectedSwitchOptions[i]
  end
end

function UIItemRevertView:CloseFilterPanel()
  self.filter_root:SetActive(false)
  local filterChanged = false
  for i = 1, 6 do
    if self.cachedFilterOptions[i] ~= self.selectedFilterOptions[i] then
      filterChanged = true
      break
    end
  end
  if not filterChanged then
    for i = 1, 2 do
      if self.cachedSwitchOptions[i] ~= self.selectedSwitchOptions[i] then
        filterChanged = true
        break
      end
    end
  end
  if filterChanged then
    self:RefreshFilterBtnState()
    self:LoadInitialHistory()
  end
end

function UIItemRevertView:IsFilterSelected(index)
  return self.selectedFilterOptions[index] or false
end

function UIItemRevertView:OnFilterOptionClick(index)
  for i = 1, 6 do
    if i == index then
      self.selectedFilterOptions[i] = true
    else
      self.selectedFilterOptions[i] = false
    end
  end
  if index == 1 then
    self.selectedSwitchOptions[2] = false
    self:RefreshSwitchOptions()
  end
  self:RefreshFilterOptions()
end

function UIItemRevertView:OnSwitchOptionClick(index)
  local selected = not self.selectedSwitchOptions[index]
  if selected and index == 2 and self.selectedFilterOptions[1] then
    UIUtil.ShowTipsId("undo_system2_toast")
    return
  end
  self.selectedSwitchOptions[index] = selected
  self:RefreshSwitchOptions()
end

function UIItemRevertView:RefreshFilterOptions()
  for i = 1, 6 do
    self.filterOptions[i]:SetSelected(self.selectedFilterOptions[i])
  end
end

function UIItemRevertView:RefreshSwitchOptions()
  for i = 1, 2 do
    self.switchOptions[i]:SetSelected(self.selectedSwitchOptions[i])
  end
end

return UIItemRevertView
