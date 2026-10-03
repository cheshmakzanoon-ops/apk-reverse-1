local UIDecorationIcons = BaseClass("UIDecorationIcons", UIBaseContainer)
local base = UIBaseContainer
local UIDecorationIconCell = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationIconCell")
local UIDecorationTittleItem = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationTittleItem")
local Localization = CS.GameEntry.Localization
local twoColScroll_view_path = "TowColScrollView"
local oneColScroll_view_path = "OneColScrollView"
local unlock_btn_path = "UnlockBtn"
local unlock_btn_text_path = "UnlockBtn/UnlockBtnText"
local unlock_redDot_path = "UnlockBtn/UnlockBtnRedDot"
local remain_time_path = "RemainTime"
local remain_time_text_path = "RemainTime/RemainTimeText"
local remain_time_add_btn_path = "RemainTime/RemainTimeAddBtn"
local remain_time_info_btn_path = "RemainTime/RemainTimeInfoBtn"
local remain_time_add_btn_redDot_path = "RemainTime/RemainTimeAddBtn/RedDotWithoutNum"
local use_btn_path = "UseBtn"
local use_btn_text_path = "UseBtn/UseBtnText"
local in_use_btn_path = "InUseBtn"
local in_use_btn_text_path = "InUseBtn/InUseBtnText"

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
  self.mapStickerScrollView = self:AddComponent(UIScrollView, "mapStickerScrollView")
  self.mapStickerScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateTowColCell(itemObj, index, self.mapStickerScrollView)
  end)
  self.mapStickerScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteTwoColCell(itemObj, index, self.mapStickerScrollView)
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
    self:OnUnlockClick()
  end)
  self.remain_time_info_btn = self:AddComponent(UIButton, remain_time_info_btn_path)
  self.remain_time_info_btn:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("season_mastery_s2_UI_25"), self.remain_time_info_btn.transform.position, 0, -20, -20)
  end)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn_text = self:AddComponent(UIText, use_btn_text_path)
  self.use_btn_text:SetLocalText(2000463)
  self.use_btn:SetOnClick(function()
    self:OnUseClick()
  end)
  self.in_use_btn = self:AddComponent(UIButton, in_use_btn_path)
  self.in_use_btn_text = self:AddComponent(UIText, in_use_btn_text_path)
  self.in_use_btn_Shadow = self:AddComponent(UIShadow, in_use_btn_text_path)
  self.in_use_btn_text:SetLocalText(2000468)
  CS.UIGray.SetGray(self.in_use_btn.transform, true, false)
end

local function ComponentDestroy(self)
  self:ClearTwoScroll()
  self:ClearOneScroll()
  self.twoColScroll_view = nil
  self.oneColScroll_view = nil
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

local function SetData(self, dataList, currentSelect, curSelectType)
  self.dataList = dataList
  self.currentSelect = currentSelect
  self.curSelectType = curSelectType
  self:RefreshScrollView()
  self:RefreshBtn()
  self:RefreshRemainTime()
end

local function RefreshScrollView(self)
  if self.curSelectType == DecorationType.DecorationType_Emoji then
    self.oneColScroll_view:SetActive(false)
    self.twoColScroll_view:SetActive(false)
    self.mapStickerScrollView:SetActive(true)
    self:ClearTwoScroll(self.mapStickerScrollView)
    self:ClearTwoScroll()
    local count = table.count(self.dataList)
    self.mapStickerScrollView:SetTotalCount(count)
    self.mapStickerScrollView:RefillCells()
  else
    self.oneColScroll_view:SetActive(false)
    self.mapStickerScrollView:SetActive(false)
    self.twoColScroll_view:SetActive(true)
    self:ClearTwoScroll()
    self:ClearTwoScroll(self.mapStickerScrollView)
    local count = table.count(self.dataList)
    self.twoColScroll_view:SetTotalCount(count)
    self.twoColScroll_view:RefillCells()
  end
end

local function OnCreateTowColCell(self, itemObj, index, scrollViewCom)
  itemObj.name = tostring(index)
  local scrollView = scrollViewCom or self.twoColScroll_view
  local cellItem = scrollView:AddComponent(UIDecorationIconCell, itemObj)
  local data = self.dataList[index]
  cellItem:ReInit(data, self.currentSelect, UIDecorationIconCellParentType.UIDecorationIconCell)
end

local function OnDeleteTwoColCell(self, itemObj, index, scrollViewCom)
  local scrollView = scrollViewCom or self.twoColScroll_view
  scrollView:RemoveComponent(itemObj.name, UIDecorationIconCell)
end

local function ClearTwoScroll(self, scrollViewCom)
  local scrollView = scrollViewCom or self.twoColScroll_view
  scrollView:ClearCells()
  scrollView:RemoveComponents(UIDecorationIconCell)
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
  if not template then
    self.use_btn:SetActive(false)
    self.in_use_btn:SetActive(false)
    self.remain_time:SetActive(false)
    if self.curSelectType == DecorationType.DecorationType_Emoji then
      self.unlock_btn:SetActive(false)
    end
    return
  else
    self.use_btn:SetActive(true)
    self.remain_time:SetActive(true)
  end
  local notVipPreviewSkinId = self.currentSelect ~= LuaEntry.DataConfig:TryGetNum("vip_base_skin_model_config", "k1")
  local isSeasonSkinId = DataCenter.DecorationTemplateManager:IsSeasonSkin(self.currentSelect)
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
  if self.curSelectType == DecorationType.DecorationType_Emoji and showUnlock == true then
    local isUnlock = DataCenter.StickerWithDecorationLinkManager:CheckIsUnlockByDecoId(self.currentSelect)
    if isUnlock then
      showTime = true
      showUnlock = false
      local stickerExpiredTime = DataCenter.StickerWithDecorationLinkManager:GetExpireTimeByDecoId(self.currentSelect)
      showAdd = stickerExpiredTime and 0 < stickerExpiredTime
    end
  end
  showAdd = showAdd and template.typeGain ~= DecorationGainType.DecorationGainType_Female
  self.unlock_btn:SetActive(notVipPreviewSkinId and showUnlock and not isSeasonSkinId)
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
  self.remain_time_info_btn:SetActive(isSeasonSkinId)
  local showUse = false
  if template:IsDefault() then
    local currentUse = DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type)
    if (currentUse ~= nil and currentUse ~= self.currentSelect or template.type == DecorationType.DecorationType_Emoji) and (data == nil or not data:IsWear()) then
      showUse = true
    end
  elseif template.type == DecorationType.DecorationType_Emoji then
    showUse = showTime
  else
    showUse = data and not data:IsWear() and data:IsInExpireTime()
  end
  local isSelect
  if template.type == DecorationType.DecorationType_Emoji then
    isSelect = template.id == self.view.mapStickersNew:GetSelectStickerDecorationId()
  else
    isSelect = template.id == DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type)
  end
  self.use_btn:SetActive(notVipPreviewSkinId and showUse)
  self.in_use_btn:SetActive(notVipPreviewSkinId and isSelect)
end

local function RefreshRemainTime(self)
  if self.remain_time and self.remain_time:GetActive() then
    local now = UITimeManager:GetInstance():GetServerTime()
    local template = DataCenter.DecorationTemplateManager:GetTemplate(self.currentSelect)
    local restTimeStr = ""
    local data = DataCenter.DecorationDataManager:GetSkinDataById(self.currentSelect)
    if not template then
      return
    end
    if template.type == DecorationType.DecorationType_Emoji then
      local expireTime = DataCenter.StickerWithDecorationLinkManager:GetExpireTimeByDecoId(self.currentSelect)
      if expireTime and 0 < expireTime then
        local restTime = expireTime - now
        restTime = math.max(0, restTime)
        restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
        if restTime <= 0 then
          self:OnUserSkinUpdate()
        end
      else
        restTimeStr = Localization:GetString("2000464")
      end
    elseif data ~= nil then
      local expireTime = data.expireTime
      local restTime = expireTime - now
      restTime = math.max(0, restTime)
      restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
      if expireTime <= 0 then
        restTimeStr = Localization:GetString("2000464")
      end
      if restTime <= 0 then
        self:OnUserSkinUpdate()
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
  if template.type == DecorationType.DecorationType_Emoji then
    self.view.mapStickersNew:SaveSticker()
    self:RefreshBtn()
    return
  end
  if template:IsDefault() then
    local currentUse = DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type, true)
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
  self:RefreshBtn()
end

local function OnSelectEvent(self, decorationId)
  self.currentSelect = decorationId
  self:RefreshBtn()
  self:RefreshRemainTime()
end

function UIDecorationIcons:Update1000MS()
  self:RefreshRemainTime()
end

UIDecorationIcons.OnSelectEvent = OnSelectEvent
UIDecorationIcons.OnUserSkinUpdate = OnUserSkinUpdate
UIDecorationIcons.OnAddListener = OnAddListener
UIDecorationIcons.OnRemoveListener = OnRemoveListener
UIDecorationIcons.RefreshRemainTime = RefreshRemainTime
UIDecorationIcons.RefreshBtn = RefreshBtn
UIDecorationIcons.OnUnlockClick = OnUnlockClick
UIDecorationIcons.RefreshScrollView = RefreshScrollView
UIDecorationIcons.OnDeleteTwoColCell = OnDeleteTwoColCell
UIDecorationIcons.OnCreateTowColCell = OnCreateTowColCell
UIDecorationIcons.ClearTwoScroll = ClearTwoScroll
UIDecorationIcons.OnDeleteOneColCell = OnDeleteOneColCell
UIDecorationIcons.OnCreateOneColCell = OnCreateOneColCell
UIDecorationIcons.ClearOneScroll = ClearOneScroll
UIDecorationIcons.OnCreate = OnCreate
UIDecorationIcons.OnDestroy = OnDestroy
UIDecorationIcons.OnEnable = OnEnable
UIDecorationIcons.OnDisable = OnDisable
UIDecorationIcons.ComponentDefine = ComponentDefine
UIDecorationIcons.ComponentDestroy = ComponentDestroy
UIDecorationIcons.DataDefine = DataDefine
UIDecorationIcons.DataDestroy = DataDestroy
UIDecorationIcons.SetData = SetData
UIDecorationIcons.OnUseClick = OnUseClick
return UIDecorationIcons
