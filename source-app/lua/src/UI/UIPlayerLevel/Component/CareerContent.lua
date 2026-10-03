local CareerContent = BaseClass("CareerContent", UIBaseContainer)
local base = UIBaseContainer
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local UICareerStage = require("UI.UIPlayerLevel.Component.UICareerStage")
local UICareerTag = require("UI.UIPlayerLevel.Component.UICareerTag")
local UICareerContentTip = require("UI.UIPlayerLevel.Component.UICareerContentTip")
local UICareerEffectTip = require("UI.UIPlayerLevel.Component.UICareerEffectTip")
local head_path = "HeadBg/Head"
local name_path = "Name"
local desc_path = "Desc"
local select_btn_path = "Select"
local select_text_path = "Select/SelectText"
local need_path = "Select/Need"
local need_icon_path = "Select/Need/NeedIcon"
local need_count_path = "Select/Need/NeedCount"
local scroll_view_path = "Mask/ScrollView"
local content_path = "Mask/ScrollView/Viewport/Content"
local tag_list_path = "TagList"
local content_tip_path = "UICareerContentTip"
local tag_tip_path = "UICareerEffectTip"
local info_path = "Info"
local change_path = "Change"
local change_red_path = "Change/ChangeRed"
local free_time_path = "FreeTime"
local MISSING_HEAD = "Assets/Main/Sprites/UI/UICareer/UICareer_heroIcon_33001"
local ItemWidth = 157 * GetStandardScale()

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.head_btn = self:AddComponent(UIButton, head_path)
  self.head_btn:SetOnClick(function()
    self:OnHeadClick()
  end)
  self.name_text = self:AddComponent(UIText, name_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.event_trigger = self:AddComponent(UIEventTrigger, content_path)
  self.event_trigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.event_trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.event_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.tag_list_go = self:AddComponent(UIBaseContainer, tag_list_path)
  self.content_tip = self:AddComponent(UICareerContentTip, content_tip_path)
  self.content_tip:SetOnDrag(function(eventData)
    self:OnDrag(eventData)
  end, function(eventData)
    self:OnBeginDrag(eventData)
  end, function(eventData)
    self:OnEndDrag(eventData)
  end, function(eventData)
    self:OnPointerUp(eventData)
  end)
  self.content_tip:SetActive(true)
  self.tag_tip = self:AddComponent(UICareerEffectTip, tag_tip_path)
  self.tag_tip:SetOnDrag(function(eventData)
    self:OnDrag(eventData)
  end, function(eventData)
    self:OnBeginDrag(eventData)
  end, function(eventData)
    self:OnEndDrag(eventData)
  end, function(eventData)
    self:OnPointerUp(eventData)
  end)
  self.tag_tip:SetActive(true)
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.select_btn:SetOnClick(function()
    self:OnSelectClick()
  end)
  self.select_text = self:AddComponent(UIText, select_text_path)
  self.need_go = self:AddComponent(UIBaseContainer, need_path)
  self.need_icon_image = self:AddComponent(UIImage, need_icon_path)
  self.need_count_text = self:AddComponent(UIText, need_count_path)
  self.info_btn = self:AddComponent(UIButton, info_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.change_btn = self:AddComponent(UIButton, change_path)
  self.change_btn:SetOnClick(function()
    self:OnChangeClick()
  end)
  self.change_red_go = self:AddComponent(UIBaseContainer, change_red_path)
  self.free_time_text = self:AddComponent(UIText, free_time_path)
end

local function ComponentDestroy(self)
  self.head_btn = nil
  self.name_text = nil
  self.desc_text = nil
  self.scroll_view = nil
  self.event_trigger = nil
  self.tag_list_go = nil
  self.content_tip = nil
  self.tag_tip = nil
  self.select_btn = nil
  self.select_text = nil
  self.need_go = nil
  self.need_icon_image = nil
  self.need_count_text = nil
  self.info_btn = nil
  self.change_btn = nil
  self.change_red_go = nil
  self.free_time_text = nil
end

local function DataDefine(self)
  self.careerType = nil
  self.careerLv = nil
  self.careerTemplate = nil
  self.itemList = {}
  self.tagItemList = {}
  self.careerTagReqs = {}
  self.isDragging = false
  self.draggingDisableBtns = {}
  self.timer = nil
end

local function DataDestroy(self)
  self.careerType = nil
  self.careerLv = nil
  self.careerTemplate = nil
  self.itemList = nil
  self.tagItemList = nil
  self.careerTagReqs = nil
  self.isDragging = nil
  self.draggingDisableBtns = nil
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerCareerLevelUp, self.OnCareerLevelUp)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerCareerLevelUp, self.OnCareerLevelUp)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:HideTip(true)
end

local function OnDisable(self)
  self:ClearScroll()
  self:ClearTagItems()
  base.OnDisable(self)
end

local function OnCellMoveIn(self, itemObj, index)
  local level = index
  itemObj.name = tostring(level)
  local item = self.scroll_view:AddComponent(UICareerStage, itemObj)
  self:RefreshCell(item, level)
end

local function OnCellMoveOut(self, itemObj, index)
  local level = index
  self.scroll_view:RemoveComponent(itemObj.name, UICareerStage)
  self.itemList[level] = nil
end

local function ShowCells(self)
  self:ClearScroll()
  local count = DataCenter.PlayerCareerManager:GetCareerMaxLv(self.careerType)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICareerStage)
end

local function RefreshCell(self, item, level)
  local careerTemplate = DataCenter.PlayerCareerManager:GetCareerTemplate(self.careerType, level)
  local id = careerTemplate.levelEffect
  local idList = careerTemplate.initEffectList
  local state, fillSlider
  if self.careerLv == nil or level <= self.careerLv then
    state = UICareerStage.State.Engaged
  elseif DataCenter.PlayerLevelManager:GetLevel() >= careerTemplate.requirePlayerLv then
    state = UICareerStage.State.Available
  else
    state = UICareerStage.State.Locked
  end
  if level == DataCenter.PlayerCareerManager:GetCareerMaxLv(self.careerType) then
    fillSlider = nil
  elseif self.careerLv == nil or level < self.careerLv then
    fillSlider = true
  else
    fillSlider = false
  end
  local data = {
    id = id,
    idList = idList,
    level = level,
    state = state,
    fillSlider = fillSlider
  }
  item:SetData(data)
  item:SetOnClick(function()
    if item.state == UICareerStage.State.Available then
      DataCenter.PlayerCareerManager:LevelUpCareer(self.careerType, self.careerLv, level)
    else
      self:ShowContentTip(level)
    end
  end, function()
    self:ShowContentTip(level)
  end)
  item:SetOnDrag(function(eventData)
    self:OnDrag(eventData)
  end, function(eventData)
    self:OnBeginDrag(eventData)
  end, function(eventData)
    self:OnEndDrag(eventData)
  end, function(eventData)
    self:OnPointerUp(eventData)
  end)
  self.itemList[level] = item
end

local function OnDrag(self, eventData)
  self.scroll_view:OnDrag(eventData)
end

local function OnBeginDrag(self, eventData)
  self.scroll_view:OnBeginDrag(eventData)
  self.isDragging = true
  for _, btn in ipairs(self.draggingDisableBtns) do
    btn.unity_uibutton.enabled = false
  end
  self:HideTip()
end

local function OnEndDrag(self, eventData)
  self.scroll_view:OnEndDrag(eventData)
  for _, btn in ipairs(self.draggingDisableBtns) do
    btn.unity_uibutton.enabled = true
  end
  self.isDragging = false
end

local function OnPointerUp(self, eventData)
  self:HideTip()
end

local function ShowTagItems(self)
  self.careerTagReqs = {}
  for i, tagInfo in ipairs(self.careerTemplate.tagInfoList) do
    local req = Resource:InstantiateAsync(UIAssets.UICareerTag)
    req:completed("+", function()
      if req.isError then
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(req)
      if self.tag_list_go == nil then
        req:Destroy()
        return
      end
      local go = req.gameObject
      go:SetActive(true)
      go.name = tostring(i)
      local tf = go.transform
      tf:SetParent(self.tag_list_go.transform)
      tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local item = self.tag_list_go:AddComponent(UICareerTag, go)
      item:SetData(tagInfo)
      item:SetOnClick(function()
        self:ShowTagTip(i)
      end)
      self.tagItemList[i] = item
      table.insert(self.careerTagReqs, req)
    end)
  end
end

local function ClearTagItems(self)
  if table.count(self.careerTagReqs) > 0 then
    self.tag_list_go:RemoveComponents(UICareerTag)
    for _, req in pairs(self.careerTagReqs) do
      req:Destroy()
    end
    self.careerTagReqs = {}
  end
end

local function ReInit(self, careerType, careerLv)
  local curCareerType = DataCenter.PlayerCareerManager:GetCareerType()
  self.careerType = careerType
  self.careerLv = careerLv
  self.careerTemplate = DataCenter.PlayerCareerManager:GetCareerTemplate(careerType, careerLv or 1)
  if self.careerTemplate == nil then
    Logger.LogError("CareerContent, ReInit, careerType = " .. careerType .. ", careerTemplate = null")
    return
  end
  self.head_btn:LoadSprite(string.format(LoadPath.UIPlayerCareer, self.careerTemplate.image), MISSING_HEAD)
  self.desc_text:SetLocalText(self.careerTemplate.description)
  self.change_red_go:SetActive(DataCenter.PlayerCareerManager:ShowFreeChangeRed())
  local showNeed = false
  if DataCenter.PlayerCareerManager:Enabled() then
    if careerLv == nil then
      self.head_btn:SetInteractable(false)
      self.change_btn:SetActive(false)
      if curCareerType ~= careerType then
        self.select_btn:SetActive(true)
        if curCareerType == CareerType.None then
          self.select_text:SetLocalText(110108)
          showNeed = true
        elseif DataCenter.PlayerCareerManager:HaveFreeChangeForCareer(careerType) then
          self.select_text:SetLocalText(130126)
          showNeed = false
        else
          self.select_text:SetLocalText(110126)
          showNeed = true
        end
      else
        self.select_btn:SetActive(false)
        showNeed = false
      end
      TimerManager:GetInstance():DelayInvoke(function()
        self:ShowTagTip(1)
      end, 0.25)
    else
      self.head_btn:SetInteractable(true)
      self.change_btn:SetActive(true)
      self.select_btn:SetActive(false)
      showNeed = false
    end
  else
    self.head_btn:SetInteractable(false)
    self.change_btn:SetActive(false)
    self.select_btn:SetActive(true)
    self.select_text:SetLocalText(110108)
    showNeed = true
  end
  local requireItemDict = DataCenter.PlayerCareerManager:GetCareerRequireItemDict(careerType)
  if showNeed and not table.IsNullOrEmpty(requireItemDict) then
    self.need_go:SetActive(true)
    for itemId, count in pairs(requireItemDict) do
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      self.need_icon_image:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.icon))
      self.need_count_text:SetText("x" .. count)
      break
    end
  else
    self.need_go:SetActive(false)
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if DataCenter.PlayerCareerManager:HaveFreeChangeForCareer(careerType) then
    self.free_time_text:SetActive(true)
    local restTime = DataCenter.PlayerCareerManager:GetFreeChangeRestTime()
    local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
    self.free_time_text:SetLocalText(395402, restTimeStr)
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
    self.timer:Start()
  else
    self.free_time_text:SetActive(false)
  end
  self:RefreshName()
  self:ShowCells()
  self:ShowTagItems()
  self:HideTip(true)
  self:ScrollToLevel(careerLv or 1)
end

local function TimerAction(self)
  local restTime = DataCenter.PlayerCareerManager:GetFreeChangeRestTime()
  if 0 < restTime then
    local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
    self.free_time_text:SetLocalText(395402, restTimeStr)
  end
end

local function SetDraggingDisableBtn(self, btnList)
  self.draggingDisableBtns = btnList
end

local function RefreshName(self)
  local nameStr = Localization:GetString(self.careerTemplate.name)
  local levelStr = self.careerLv and NumToRoman(self.careerLv) or ""
  self.name_text:SetText(nameStr .. " " .. levelStr)
end

local function ShowContentTip(self, level)
  local item = self.itemList[level]
  if item == nil then
    return
  end
  if self.isDragging then
    return
  end
  self.content_tip:SetData(self.careerType, level, item.content_btn.gameObject)
  self.content_tip:Show()
  self.scroll_view:StopMovement()
end

local function ShowTagTip(self, i)
  local item = self.tagItemList[i]
  if item == nil then
    return
  end
  local tagInfo = self.careerTemplate.tagInfoList[1]
  local desc = Localization:GetString(tagInfo.detail)
  local offsetX = self.tag_list_go.rectTransform.sizeDelta.x * GetStandardScale() / 2
  self.tag_tip:SetData(nil, desc, self.tag_list_go.gameObject)
  self.tag_tip:Show(UICareerEffectTip.Direction.Down, Vector2.New(offsetX, 0))
end

local function HideTip(self, immediate)
  self.content_tip:Hide(immediate)
  self.tag_tip:Hide(immediate)
end

local function ScrollToLevel(self, level)
  local maxLevel = DataCenter.PlayerCareerManager:GetCareerMaxLv(self.careerType)
  local pos
  if level <= 3 then
    pos = 0
  elseif level >= maxLevel - 2 then
    pos = 1
  else
    local x = (level - 3) * ItemWidth
    local maxX = 5 < maxLevel and (maxLevel - 5) * ItemWidth or 1
    pos = x / maxX
  end
  self.scroll_view:SetHorizontalNormalizedPosition(pos)
end

local function OnCareerLevelUp(self, level)
  self.careerLv = level
  self:RefreshName()
  for k, v in pairs(self.itemList) do
    self:RefreshCell(v, k)
  end
end

local function OnSelectClick(self)
  DataCenter.PlayerCareerManager:SelectCareer(self.careerType)
end

local function OnHeadClick(self)
  GoToUtil.GoToCareerSelect(function()
    self:SelectViewCloseCallback()
  end)
end

local function OnInfoClick(self)
  local intro = Localization:GetString("395120") .. "\n" .. Localization:GetString("395121") .. "\n" .. Localization:GetString("395122")
  UIUtil.ShowIntro(Localization:GetString("395000"), Localization:GetString("302027"), intro)
end

local function OnChangeClick(self)
  if DataCenter.PlayerCareerManager:ShowFreeChangeRed() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    Setting:SetString(SettingKeys.CAREER_CHANGE_CHECK_TIME .. LuaEntry.Player.uid, tostring(curTime))
    EventManager:GetInstance():Broadcast(EventId.PlayerCareerFreeChangeUpdate)
  end
  GoToUtil.GoToCareerSelect(function()
    GoToUtil.GoToPlayerCareer()
  end)
end

local function SelectViewCloseCallback(self)
  GoToUtil.GoToPlayerCareer()
end

CareerContent.OnCreate = OnCreate
CareerContent.OnDestroy = OnDestroy
CareerContent.ComponentDefine = ComponentDefine
CareerContent.ComponentDestroy = ComponentDestroy
CareerContent.DataDefine = DataDefine
CareerContent.DataDestroy = DataDestroy
CareerContent.OnAddListener = OnAddListener
CareerContent.OnRemoveListener = OnRemoveListener
CareerContent.OnEnable = OnEnable
CareerContent.OnDisable = OnDisable
CareerContent.OnCellMoveIn = OnCellMoveIn
CareerContent.OnCellMoveOut = OnCellMoveOut
CareerContent.ShowCells = ShowCells
CareerContent.ClearScroll = ClearScroll
CareerContent.RefreshCell = RefreshCell
CareerContent.OnDrag = OnDrag
CareerContent.OnBeginDrag = OnBeginDrag
CareerContent.OnEndDrag = OnEndDrag
CareerContent.OnPointerUp = OnPointerUp
CareerContent.ShowTagItems = ShowTagItems
CareerContent.ClearTagItems = ClearTagItems
CareerContent.ReInit = ReInit
CareerContent.TimerAction = TimerAction
CareerContent.SetDraggingDisableBtn = SetDraggingDisableBtn
CareerContent.RefreshName = RefreshName
CareerContent.ShowContentTip = ShowContentTip
CareerContent.ShowTagTip = ShowTagTip
CareerContent.HideTip = HideTip
CareerContent.ScrollToLevel = ScrollToLevel
CareerContent.OnCareerLevelUp = OnCareerLevelUp
CareerContent.OnSelectClick = OnSelectClick
CareerContent.OnHeadClick = OnHeadClick
CareerContent.OnInfoClick = OnInfoClick
CareerContent.OnChangeClick = OnChangeClick
CareerContent.SelectViewCloseCallback = SelectViewCloseCallback
return CareerContent
