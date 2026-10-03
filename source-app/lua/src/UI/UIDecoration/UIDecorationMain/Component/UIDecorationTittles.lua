local UIDecorationTittles = BaseClass("UIDecorationTittles", UIBaseContainer)
local base = UIBaseContainer
local UIDecorationTittleItem = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationTittleItem")
local Localization = CS.GameEntry.Localization
local scroll_view_path = "OneColScrollView"
local unlock_btn_path = "UnlockBtn"
local unlock_btn_text_path = "UnlockBtn/UnlockBtnText"
local unlock_redDot_path = "UnlockBtn/UnlockBtnRedDot"
local remain_time_path = "RemainTime"
local remain_time_text_path = "RemainTime/RemainTimeText"
local remain_time_add_btn_path = "RemainTime/RemainTimeAddBtn"
local remain_time_add_btn_redDot_path = "RemainTime/RemainTimeAddBtn/RedDotWithoutNum"
local use_btn_path = "UseBtn"
local use_btn_text_path = "UseBtn/UseBtnText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.unlock_btn = self:AddComponent(UIButton, unlock_btn_path)
  self.unlock_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnUnlockClick()
  end)
  self.unlock_redDot = self:AddComponent(UIBaseContainer, unlock_redDot_path)
  self.unlock_redDot:SetActive(false)
  self.btn_text = self:AddComponent(UIText, unlock_btn_text_path)
  self.btn_text:SetLocalText(130056)
  self.remain_time = self:AddComponent(UIBaseContainer, remain_time_path)
  self.remain_time_text = self:AddComponent(UIText, remain_time_text_path)
  self.remain_time_add_btn = self:AddComponent(UIButton, remain_time_add_btn_path)
  self.remain_time_add_btn_redDot = self:AddComponent(UIImage, remain_time_add_btn_redDot_path)
  self.remain_time_add_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnUnlockClick()
  end)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn_text = self:AddComponent(UIText, use_btn_text_path)
  self.use_btn_text:SetLocalText(110046)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnUseClick()
  end)
  
  function self.timer_action(temp)
    self:RefreshRemainTime()
  end
  
  self:AddTimer()
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self:DeleteTimer()
  self.scroll_view = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function SetData(self, dataList, currentSelect)
  self.dataList = dataList
  self.currentSelect = currentSelect
  self:RefreshScrollView()
  self:RefreshBtn()
  self:RefreshRemainTime()
end

local function RefreshScrollView(self)
  self:ClearScroll()
  local count = table.count(self.dataList)
  self.scroll_view:SetTotalCount(count)
  self.scroll_view:RefillCells()
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIDecorationTittleItem, itemObj)
  local data = self.dataList[index]
  cellItem:ReInit(data, self.currentSelect)
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIDecorationTittleItem)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIDecorationTittleItem)
end

local function OnUnlockClick(self)
  DecorationUtil:DoWhenClickUnlock(self.currentSelect)
end

local function RefreshBtn(self)
  local data = DataCenter.DecorationDataManager:GetSkinDataById(self.currentSelect)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.currentSelect)
  local showTime = false
  local showAdd = false
  local showUnlock = true
  local showAddRedDot = false
  if data == nil then
    if template:IsDefault() then
      showTime = true
      showUnlock = false
    end
  else
    if data:IsInExpireTime() then
      showUnlock = false
      showTime = true
    end
    showAdd = data.expireTime > 0
  end
  showAdd = showAdd and template.typeGain ~= DecorationGainType.DecorationGainType_Female
  self.unlock_btn:SetActive(showUnlock)
  local showUnlockRedDot = false
  for k, v in ipairs(self.dataList) do
    if v.id == self.currentSelect then
      showUnlockRedDot = v.showRedPoint
      showAddRedDot = v.showAddRedPoint
      break
    end
  end
  self.unlock_redDot:SetActive(showUnlockRedDot)
  self.remain_time:SetActive(showTime)
  self.remain_time_add_btn:SetActive(showAdd)
  self.remain_time_add_btn_redDot:SetActive(showAddRedDot)
  local showUse = false
  if template:IsDefault() then
    local currentUse = DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type)
    if currentUse ~= nil and currentUse ~= self.currentSelect and (data == nil or not data:IsWear()) then
      showUse = true
    end
  else
    showUse = data and not data:IsWear() and data:IsInExpireTime()
  end
  self.use_btn:SetActive(showUse)
end

local function RefreshRemainTime(self)
  if self.remain_time and self.remain_time:GetActive() then
    local now = UITimeManager:GetInstance():GetServerTime()
    local template = DataCenter.DecorationTemplateManager:GetTemplate(self.currentSelect)
    local restTimeStr = ""
    local data = DataCenter.DecorationDataManager:GetSkinDataById(self.currentSelect)
    if data ~= nil then
      local restTime = data.expireTime - now
      restTime = math.max(0, restTime)
      restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
      if data.expireTime <= 0 then
        restTimeStr = Localization:GetString("280098")
      end
    elseif template:IsDefault() then
      restTimeStr = Localization:GetString("280098")
    end
    self.remain_time_text:SetText(restTimeStr)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.remain_time.transform)
end

local function OnUseClick(self)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.currentSelect)
  if template == nil then
    return
  end
  local lastSex = LuaEntry.Player:GetGender()
  if lastSex ~= SexType.Woman and template.typeGain == DecorationGainType.DecorationGainType_Female then
    UIUtil.ShowTipsId(2000469)
    return
  end
  if template:IsDefault() then
    local currentUse = DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type)
    if currentUse ~= self.currentSelect then
      DataCenter.DecorationDataManager:TakeOffSkin(currentUse)
    end
  else
    DataCenter.DecorationDataManager:WearSkin(self.currentSelect)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
end

local function OnUserSkinUpdate(self)
  self:RefreshScrollView()
  self:RefreshBtn()
  self:RefreshRemainTime()
end

local function OnSelectEvent(self, decorationId)
  self.currentSelect = decorationId
  self:RefreshBtn()
  self:RefreshRemainTime()
end

UIDecorationTittles.OnSelectEvent = OnSelectEvent
UIDecorationTittles.OnUserSkinUpdate = OnUserSkinUpdate
UIDecorationTittles.OnAddListener = OnAddListener
UIDecorationTittles.OnRemoveListener = OnRemoveListener
UIDecorationTittles.RefreshRemainTime = RefreshRemainTime
UIDecorationTittles.RefreshBtn = RefreshBtn
UIDecorationTittles.OnUnlockClick = OnUnlockClick
UIDecorationTittles.RefreshScrollView = RefreshScrollView
UIDecorationTittles.OnDeleteCell = OnDeleteCell
UIDecorationTittles.OnCreateCell = OnCreateCell
UIDecorationTittles.ClearScroll = ClearScroll
UIDecorationTittles.OnCreate = OnCreate
UIDecorationTittles.OnDestroy = OnDestroy
UIDecorationTittles.OnEnable = OnEnable
UIDecorationTittles.OnDisable = OnDisable
UIDecorationTittles.ComponentDefine = ComponentDefine
UIDecorationTittles.ComponentDestroy = ComponentDestroy
UIDecorationTittles.DataDefine = DataDefine
UIDecorationTittles.DataDestroy = DataDestroy
UIDecorationTittles.SetData = SetData
UIDecorationTittles.DeleteTimer = DeleteTimer
UIDecorationTittles.AddTimer = AddTimer
UIDecorationTittles.OnUseClick = OnUseClick
return UIDecorationTittles
