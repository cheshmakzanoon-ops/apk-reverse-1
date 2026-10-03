local TacticalDecorationIcons = BaseClass("TacticalDecorationIcons", UIBaseContainer)
local base = UIBaseContainer
local UIDecorationIconCell = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationIconCell")
local UIDecorationTittleItem = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationTittleItem")
local Localization = CS.GameEntry.Localization
local twoColScroll_view_path = "TowColScrollView"
local oneColScroll_view_path = "OneColScrollView"
local unlock_btn_path = "UnlockBtn"
local unlock_btn_text_path = "UnlockBtn/UnlockBtnText"
local unlock_redDot_path = "UnlockBtn/UnlockBtnRedDot"
local TacticalWeaponSkinItem = require("UI.UILWTacticalWeapon.UITacticalWeaponSkinPage.TacticalWeaponSkinItem")
local remain_time_path = "remainTimeNode"
local remain_time_text_path = "remainTimeNode/RemainTime/RemainTimeText"
local remain_time_add_btn_path = "remainTimeNode/RemainTime/RemainTimeAddBtn"
local remain_time_add_btn_redDot_path = "remainTimeNode/RemainTime/RemainTimeAddBtn/RedDotWithoutNum"
local use_btn_path = "UseBtn"
local use_btn_text_path = "UseBtn/UseBtnText"
local in_use_btn_path = "InUseBtn"
local in_use_btn_text_path = "InUseBtn/InUseBtnText"
local SPACING = -5
local SKIN_ITEM_WIDTH = 260

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
  self.twoColScroll_view = self:AddComponent(UIScrollView, twoColScroll_view_path)
  self.twoColScroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateTowColCell(itemObj, index)
  end)
  self.twoColScroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteTwoColCell(itemObj, index)
  end)
  self.oneColScroll_view = self:AddComponent(UIScrollView, oneColScroll_view_path)
  self.oneColScroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateOneColCell(itemObj, index)
  end)
  self.oneColScroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteOneColCell(itemObj, index)
  end)
  self.unlock_btn = self:AddComponent(UIButton, unlock_btn_path)
  self.unlock_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnUnlockClick()
  end)
  self.unlock_redDot = self:AddComponent(UIBaseContainer, unlock_redDot_path)
  self.unlock_redDot:SetActive(false)
  self.btn_text = self:AddComponent(UIText, unlock_btn_text_path)
  self.btn_text:SetLocalText(2000462)
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
  self.use_btn_text:SetLocalText(2000463)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnUseClick()
  end)
  
  function self.timer_action(temp)
    self:RefreshRemainTime()
  end
  
  self.in_use_btn = self:AddComponent(UIButton, in_use_btn_path)
  self.in_use_btn_text = self:AddComponent(UIText, in_use_btn_text_path)
  self.in_use_btn_Shadow = self:AddComponent(UIShadow, in_use_btn_text_path)
  self.in_use_btn_text:SetLocalText(2000468)
  CS.UIGray.SetGray(self.in_use_btn.transform, true, false)
  self:AddTimer()
  self.btnRightChange = self:AddComponent(UIButton, "Middle/rightChangeBtn")
  self.btnRightChange:SetOnClick(function()
    self:RightBtnClick()
  end)
  self.btnLeftChange = self:AddComponent(UIButton, "Middle/leftChangeBtn")
  self.btnLeftChange:SetOnClick(function()
    self:LeftBtnClick()
  end)
  self.compContent = self:AddComponent(UIBaseContainer, "Middle/WeaponScrollView/Content")
  self.weaponListEventTrigger = self:AddComponent(UIEventTrigger, "Middle/WeaponScrollView")
  self.weaponListEventTrigger:OnBeginDrag(function(eventData)
    self.isInDrag = true
    self.lastDragPosition = eventData.position
  end)
  self.weaponListEventTrigger:OnEndDrag(function(eventData)
    self.isInDrag = false
    if math.abs(eventData.position.x - self.lastDragPosition.x) < 100 then
      self.isInDrag = false
      return
    end
    if eventData.position.x > self.lastDragPosition.x then
      self:LeftBtnClick()
    elseif eventData.position.x < self.lastDragPosition.x then
      self:RightBtnClick()
    end
  end)
  self.compVFXQualitySwitch = self:AddComponent(UIVfx, "Middle/VFX_quality_switch")
  self.unlockTips = self:AddComponent(UIText, "unlockTips")
end

local function ComponentDestroy(self)
  self.compContent:RemoveComponents(TacticalWeaponSkinItem)
  self:ClearTwoScroll()
  self:ClearOneScroll()
  self:DeleteTimer()
  self.twoColScroll_view = nil
  self.oneColScroll_view = nil
end

local function DataDefine(self)
  self.itemList = {}
end

local function DataDestroy(self)
  self.isItemLoadComplete = nil
  self.itemList = nil
  self.dataList = nil
  self.currentSelect = nil
  self.curSelectType = nil
  self.btnRightChange = nil
  self.btnLeftChange = nil
  self.compContent = nil
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

local function SetData(self, dataList, currentSelect, curSelectType)
  self.dataList = dataList
  self.currentSelect = currentSelect
  self.curSelectType = curSelectType
  if self.dataList then
    for i, v in ipairs(self.dataList) do
      if v and v.id == self.currentSelect then
        self.curSelectIndex = i
      end
    end
  end
  self.contentPos = 260 - (self.curSelectIndex - 1) * 255
  self.compContent:SetLocalPositionXYZ(self.contentPos, 0, 0)
  self:RefreshList()
  self:RefreshBtn()
  self:RefreshRemainTime()
end

local function RefreshScrollView(self)
end

function TacticalDecorationIcons:RefreshList()
  if self.itemList and #self.itemList > 0 then
    for i, v in ipairs(self.dataList) do
      if v then
        self.itemList[i]:ReInit(v, self.currentSelect, function()
          self:MoveToIndex(i)
        end)
      end
    end
  else
    for i, v in ipairs(self.dataList) do
      if v then
        self:CreateItem(i, v)
      end
    end
  end
end

function TacticalDecorationIcons:CreateItem(index, data)
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUITacticalWeapon/MainV2/TacticalWeaponSkinItem.prefab", function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go:SetActive(true)
    go.transform:SetParent(self.compContent.transform)
    go.transform:Set_localScale(1, 1, 1)
    local pos = 10 + (index - 1) * (SKIN_ITEM_WIDTH + SPACING)
    go.transform:Set_localPosition(pos, -131, 0)
    go.transform:SetSiblingIndex(index)
    go.name = "skin_" .. data.id
    local cell = self.compContent:AddComponent(TacticalWeaponSkinItem, go.name)
    table.insert(self.itemList, cell)
    local realIndex = #self.itemList
    cell:ReInit(data, self.currentSelect, function()
      self:MoveToIndex(realIndex)
    end)
    if self.itemList and self.dataList and #self.itemList == #self.dataList then
      self.isItemLoadComplete = true
      self:MoveToCurItem(false)
    end
  end)
end

local function OnCreateTowColCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.twoColScroll_view:AddComponent(UIDecorationIconCell, itemObj)
  local data = self.dataList[index]
  cellItem:ReInit(data, self.currentSelect)
end

local function OnDeleteTwoColCell(self, itemObj, index)
  self.twoColScroll_view:RemoveComponent(itemObj.name, UIDecorationIconCell)
end

local function ClearTwoScroll(self)
  self.twoColScroll_view:ClearCells()
  self.twoColScroll_view:RemoveComponents(UIDecorationIconCell)
end

local function OnCreateOneColCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.oneColScroll_view:AddComponent(UIDecorationTittleItem, itemObj)
  local data = self.dataList[index]
  cellItem:ReInit(data, self.currentSelect)
end

local function OnDeleteOneColCell(self, itemObj, index)
  self.oneColScroll_view:RemoveComponent(itemObj.name, UIDecorationTittleItem)
end

local function ClearOneScroll(self)
  self.oneColScroll_view:ClearCells()
  self.oneColScroll_view:RemoveComponents(UIDecorationTittleItem)
end

local function OnUnlockClick(self)
  DecorationUtil:DoWhenClickUnlock(self.currentSelect)
end

local function RefreshBtn(self)
  local data = DataCenter.DecorationDataManager:GetSkinDataById(self.currentSelect)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.currentSelect)
  local notVipPreviewSkinId = self.currentSelect ~= LuaEntry.DataConfig:TryGetNum("vip_base_skin_model_config", "k1")
  local showTime = false
  local showAdd = false
  local showUnlock = true
  local showUnlockTips = false
  local showAddRedDot = false
  if data == nil then
    if template:IsDefault() or template.typeGain == DecorationGainType.DecorationGainType_LevelUp then
      showUnlock = false
    end
    if template.typeGain == DecorationGainType.DecorationGainType_LevelUp then
      showUnlockTips = true
    end
  else
    if data.expireTime <= 0 then
      showUnlock = false
    elseif data:IsInExpireTime() then
      showUnlock = false
      showTime = true
    end
    showAdd = data.expireTime > 0
  end
  showAdd = showAdd and template.typeGain ~= DecorationGainType.DecorationGainType_Female
  self.unlock_btn:SetActive(notVipPreviewSkinId and showUnlock)
  self.unlockTips:SetActive(showUnlockTips)
  if showUnlockTips then
    self.unlockTips:SetLocalText("new_uav_level_skin_desc2", DataCenter.TacticalWeaponManager:GetDecorationUnlockLv(self.currentSelect))
  end
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
  local showUse = false
  if template:IsDefault() then
    local currentUse = DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type)
    if currentUse ~= nil and currentUse ~= self.currentSelect and (data == nil or not data:IsWear()) then
      showUse = true
    end
  else
    showUse = data and not data:IsWear() and data:IsInExpireTime()
  end
  self.use_btn:SetActive(notVipPreviewSkinId and showUse)
  self.in_use_btn:SetActive(notVipPreviewSkinId and template.id == DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type))
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
        restTimeStr = Localization:GetString("2000464")
      end
    elseif template:IsDefault() then
      restTimeStr = Localization:GetString("2000464")
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
  DataCenter.DecorationDataManager:WearSkin(self.currentSelect)
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

function TacticalDecorationIcons:PlayMoveContent()
  local nexPos = Vector3.New(260 - (self.curSelectIndex - 1) * 255, 0, 0)
  self.compContent.transform:DOLocalMove(nexPos, 0.3)
end

function TacticalDecorationIcons:MoveToIndex(index)
  if not self.isItemLoadComplete or not self.itemList then
    return
  end
  if self.curSelectIndex == index then
    return
  end
  local preItem = self.itemList[self.curSelectIndex]
  if preItem then
    preItem:Move({alpha = 0, scale = 1})
  end
  self.curSelectIndex = index
  self:MoveToCurItem(true)
end

function TacticalDecorationIcons:LeftBtnClick()
  if not self.isItemLoadComplete or not self.itemList then
    return
  end
  local nextIndex = self.curSelectIndex - 1
  if nextIndex <= 0 then
    return
  end
  self.curSelectIndex = nextIndex
  self:MoveToCurItem(true)
  local preItem = self.itemList[self.curSelectIndex + 1]
  if preItem then
    preItem:Move({alpha = 0, scale = 1})
  end
end

function TacticalDecorationIcons:RightBtnClick()
  if not self.isItemLoadComplete or not self.itemList then
    return
  end
  local nextIndex = self.curSelectIndex + 1
  if nextIndex > #self.itemList then
    return
  end
  self.curSelectIndex = nextIndex
  self:MoveToCurItem(true)
  local preItem = self.itemList[self.curSelectIndex - 1]
  if preItem then
    preItem:Move({alpha = 0, scale = 1})
  end
end

function TacticalDecorationIcons:MoveToCurItem(playAni)
  if self.itemList[self.curSelectIndex] then
    if self.itemList[self.curSelectIndex]:GetQuality() == 4 then
      self.compVFXQualitySwitch:PlayByStay(VfxAssets.TacticalWeaponSkinNamePurple)
    elseif self.itemList[self.curSelectIndex]:GetQuality() == 5 then
      self.compVFXQualitySwitch:PlayByStay(VfxAssets.TacticalWeaponSkinNameGold)
    else
      self.compVFXQualitySwitch:Remove()
    end
    self:PlayMoveContent()
    self.itemList[self.curSelectIndex].transform:SetAsLastSibling()
    self.itemList[self.curSelectIndex]:Move({alpha = 1, scale = 1.25}, playAni)
    self.itemList[self.curSelectIndex]:OnSelect()
  end
end

TacticalDecorationIcons.OnSelectEvent = OnSelectEvent
TacticalDecorationIcons.OnUserSkinUpdate = OnUserSkinUpdate
TacticalDecorationIcons.OnAddListener = OnAddListener
TacticalDecorationIcons.OnRemoveListener = OnRemoveListener
TacticalDecorationIcons.RefreshRemainTime = RefreshRemainTime
TacticalDecorationIcons.RefreshBtn = RefreshBtn
TacticalDecorationIcons.OnUnlockClick = OnUnlockClick
TacticalDecorationIcons.RefreshScrollView = RefreshScrollView
TacticalDecorationIcons.OnDeleteTwoColCell = OnDeleteTwoColCell
TacticalDecorationIcons.OnCreateTowColCell = OnCreateTowColCell
TacticalDecorationIcons.ClearTwoScroll = ClearTwoScroll
TacticalDecorationIcons.OnDeleteOneColCell = OnDeleteOneColCell
TacticalDecorationIcons.OnCreateOneColCell = OnCreateOneColCell
TacticalDecorationIcons.ClearOneScroll = ClearOneScroll
TacticalDecorationIcons.OnCreate = OnCreate
TacticalDecorationIcons.OnDestroy = OnDestroy
TacticalDecorationIcons.OnEnable = OnEnable
TacticalDecorationIcons.OnDisable = OnDisable
TacticalDecorationIcons.ComponentDefine = ComponentDefine
TacticalDecorationIcons.ComponentDestroy = ComponentDestroy
TacticalDecorationIcons.DataDefine = DataDefine
TacticalDecorationIcons.DataDestroy = DataDestroy
TacticalDecorationIcons.SetData = SetData
TacticalDecorationIcons.DeleteTimer = DeleteTimer
TacticalDecorationIcons.AddTimer = AddTimer
TacticalDecorationIcons.OnUseClick = OnUseClick
return TacticalDecorationIcons
