local UILWTWSkillChipUpgradeView = BaseClass("UILWTWSkillChipUpgradeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local SkillChipSimpleAttrLineItem = require("UI.UILWTWSkillChip.UILWTWSkillChipUpgrade.Component.SkillChipSimpleAttrLineItem")
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local SkillChipSmallItem = require("UI.UILWTWSkillChip.UILWTWSkillChipUpgrade.Component.SkillChipSelectSmallItem")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/Common_bg_orange2/Content"
local basic_info_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo"
local chip_item_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/ChipItem"
local name_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/NameText"
local type_icon_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/ChipType/TypeIcon"
local type_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/ChipType/TypeText"
local power_number_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/PowerInfo/PowerNumberText"
local attribute_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/Attributes/Attribute%d"
local level_area_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/LevelArea"
local level_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/LevelArea/LevelText"
local level_progress_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/LevelArea/LevelProgress"
local progress_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/LevelArea/LevelProgress/ProgressText"
local max_level_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/LevelArea/LevelProgress/MaxLevelText"
local chips_area_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea"
local empty_tip_text_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/EmptyTipText"
local chips_scroll_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/ChipsScroll"
local chips_scroll_content_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/ChipsScroll/Viewport/ChipContent"
local funcitons_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons"
local auto_select_btn_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/AutoSelectBtn"
local confirm_btn_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/ConfirmBtn"
local get_more_btn_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/GetMoreBtn"
local fill_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/LevelArea/LevelProgress/Fill"
local max_level_tip_text_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/MaxLevelTipText"
local ItemType = {Goods = 1, Chip = 2}

local function DefineCallbacks(self)
  self.clickCallback = BindCallback(self, self.OnSkillChipItemClick)
  self.longPressCallback = BindCallback(self, self.OnSkillChipItemLongPress)
  self.pointerUpCallback = BindCallback(self, self.OnSkillChipItemPointerUp)
  self.unsetClickCallback = BindCallback(self, self.OnUnsetClick)
  self.unsetLongPressCallback = BindCallback(self, self.OnUnsetLongPressStart)
  self.unsetPointerUpCallback = BindCallback(self, self.OnUnsetPointerUp)
  self.beginDragCallback = BindCallback(self, self.OnBeginDrag)
  self.endDragCallback = BindCallback(self, self.OnEndDrag)
  self.dragCallback = BindCallback(self, self.OnDrag)
end

local function RemoveCallbacks(self)
  self.clickCallback = nil
  self.longPressCallback = nil
  self.pointerUpCallback = nil
  self.beginDragCallback = nil
  self.endDragCallback = nil
  self.dragCallback = nil
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  DefineCallbacks(self)
  self:DataDefine()
  self.chipInfo = self:GetUserData()
  self:OnOpen()
end

local function ClearScroll(self)
  if self.chips_scroll then
    self.chips_scroll_content:RemoveComponents(SkillChipSmallItem)
    self.chips_scroll:ClearAllItems()
  end
end

local function OnDestroy(self)
  ClearScroll(self)
  RemoveCallbacks(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function GetSelectedNum(self, type, uuid)
  if type == ItemType.Goods then
    return self.selectedGoods[uuid] or 0
  elseif type == ItemType.Chip then
    return self.selectedChips[uuid] or 0
  end
end

local function OnGetItemByRowColumn(self, loopScroll, index, rowIndex, columnIndex)
  if self.chipsDataList ~= nil then
    local count = #self.chipsDataList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("UILWTWSkillChipSelectSmallItem")
    local script = self.chips_scroll_content:GetComponent(item.gameObject.name, SkillChipSmallItem)
    if script == nil then
      local objectName = GetItemNameSequence(self)
      item.gameObject.name = objectName
      script = self.chips_scroll_content:AddComponent(SkillChipSmallItem, objectName)
      script:SetOnClick(self.clickCallback)
      script:SetOnLongPress(self.longPressCallback)
      script:SetOnPointerUp(self.pointerUpCallback)
      script:SetOnUnsetClick(self.unsetClickCallback)
      script:SetOnUnsetLongPress(self.unsetLongPressCallback)
      script:SetOnUnsetPointerUp(self.unsetPointerUpCallback)
      script:SetOnBeginDrag(self.beginDragCallback)
      script:SetOnEndDrag(self.endDragCallback)
      script:SetOnDrag(self.dragCallback)
    end
    script:SetActive(true)
    local itemInfo = self.chipsDataList[index]
    script:SetData(itemInfo)
    script:SetSelectNumber(GetSelectedNum(self, itemInfo.type, itemInfo.data.uuid))
    return item
  end
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.get_more_btn = self:AddComponent(UIButton, get_more_btn_path)
  self.get_more_btn:SetOnClick(function()
    TacticalWeaponUtils.ShowSkillChipExpLackWindow()
  end)
  self.basic_info = self:AddComponent(UIBaseContainer, basic_info_path)
  self.chip_item = self:AddComponent(SkillChipItem, chip_item_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.type_icon = self:AddComponent(UIImage, type_icon_path)
  self.type_text = self:AddComponent(UIText, type_text_path)
  self.power_number_text = self:AddComponent(UIText, power_number_text_path)
  self.attributes = {}
  for i = 1, 3 do
    self.attributes[i] = self:AddComponent(SkillChipSimpleAttrLineItem, string.format(attribute_path, i))
  end
  self.level_area = self:AddComponent(UIBaseContainer, level_area_path)
  self.level_text = self:AddComponent(UIText, level_text_path)
  self.level_progress = self:AddComponent(UISlider, level_progress_path)
  self.progress_text = self:AddComponent(UIText, progress_text_path)
  self.max_level_text = self:AddComponent(UIText, max_level_text_path)
  self.chips_area = self:AddComponent(UIBaseContainer, chips_area_path)
  self.empty_tip_text = self:AddComponent(UIText, empty_tip_text_path)
  self.chips_scroll = self:AddComponent(UILoopGridView, chips_scroll_path)
  self.chips_scroll:InitGridView(0, function(loopScroll, index, item)
    return OnGetItemByRowColumn(self, loopScroll, index)
  end)
  self.chips_scrollRect = self:AddComponent(UIScrollRect, chips_scroll_path)
  self.chips_scroll_content = self:AddComponent(UIBaseContainer, chips_scroll_content_path)
  self.funcitons = self:AddComponent(UIBaseContainer, funcitons_path)
  self.auto_select_btn = self:AddComponent(UIButton, auto_select_btn_path)
  self.auto_select_btn:SetOnClick(function()
    self:OnAutoSelectBtnClick()
  end)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn:SetOnClick(function()
    if self.totalExp > 0 and self.chipInfo.uuid then
      local useChips = {}
      for k, v in pairs(self.selectedChips) do
        if 0 < v then
          useChips[k] = v
        end
      end
      local useGoods = {}
      for k, v in pairs(self.selectedGoods) do
        if 0 < v then
          useGoods[k] = v
        end
      end
      local targetLevel = self.targetLevel ~= nil and self.targetLevel or self.chipInfo.level
      if targetLevel == self.chipInfo.maxLevel then
        local returnItemNeedPerExp = LuaEntry.DataConfig:TryGetNum("TacticalWeapon_config", "k3", 1)
        local curTotalExp = self.chipInfo:GetSelfTotalExp(false)
        local targetLevelNeedExp = DataCenter.TWSkillChipTemplateManager:GetTotalNeedExpByTypeAndLevel(self.chipInfo:GetExpId(), targetLevel - 1)
        if returnItemNeedPerExp <= curTotalExp + self.totalExp - targetLevelNeedExp then
          local returnItemId = LuaEntry.DataConfig:TryGetNum("TacticalWeapon_config", "k4", 0)
          local returnItemName = ""
          if 0 < returnItemId then
            local returnItemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(returnItemId)
            if returnItemTemplate then
              returnItemName = Localization:GetString(returnItemTemplate.name)
            end
          end
          UIUtil.ShowMessage(Localization:GetString("drone_skillChip_tips_7", returnItemName), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            SFSNetwork.SendMessage(MsgDefines.TWSkillChipLvUp, self.chipInfo.uuid, useChips, useGoods)
          end, nil)
          return
        end
      end
      SFSNetwork.SendMessage(MsgDefines.TWSkillChipLvUp, self.chipInfo.uuid, useChips, useGoods)
    end
  end)
  self.fill = self:AddComponent(UIImage, fill_path)
  self.max_level_tip_text = self:AddComponent(UIText, max_level_tip_text_path)
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.panel = nil
  self.close_btn = nil
  self.content = nil
  self.get_more_btn = nil
  self.basic_info = nil
  self.chip_item = nil
  self.name_text = nil
  self.type_icon = nil
  self.type_text = nil
  self.power_number_text = nil
  self.attributes = nil
  self.level_area = nil
  self.level_text = nil
  self.level_progress = nil
  self.progress_text = nil
  self.max_level_text = nil
  self.chips_area = nil
  self.empty_tip_text = nil
  self.chips_scroll = nil
  self.chips_scrollRect = nil
  self.chips_scroll_content = nil
  self.funcitons = nil
  self.auto_select_btn = nil
  self.confirm_btn = nil
  self.fill = nil
  self.max_level_tip_text = nil
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self:RemoveLongPressTimer()
  self.active = false
end

local function OnChipUpgrade(self, eventData)
  if eventData and eventData.changedChipUuid and eventData.changedChipUuid == self.chipInfo.uuid and eventData.srcLv and self.chipInfo:GetLevel() > eventData.srcLv then
    local closeCallback
    if eventData.msg and not table.IsNullOrEmpty(eventData.msg.reward) then
      function closeCallback()
        DataCenter.RewardManager:ShowCommonReward(eventData.msg)
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipChangeSuccess, {anim = true}, eventData.changedChipUuid, eventData.srcLv, nil, closeCallback)
  end
  self:OnOpen()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TWSkillUpdate, self.OnOpen)
  self:AddUIListener(EventId.TWSkillChipUpgrade, self.OnChipUpgrade)
  self:AddUIListener(EventId.RefreshItems, self.OnOpen)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.TWSkillUpdate, self.OnOpen)
  self:RemoveUIListener(EventId.TWSkillChipUpgrade, self.OnChipUpgrade)
  self:RemoveUIListener(EventId.RefreshItems, self.OnOpen)
end

local function ResetData(self)
  self.selectedChips = {}
  self.selectedGoods = {}
  self.totalExp = 0
  self.targetLevel = nil
  self.targetExp = nil
end

local function OnOpen(self)
  self.chipsDataList, self.goodsDict, self.chipsDict = self.ctrl.RefreshChipDataList(self.chipInfo)
  ResetData(self)
  self:UpdateView()
  self:RefreshChipBasicInfo(self.chipInfo)
end

local function RefreshChipBasicInfo(self, chipInfo)
  self.chip_item:SetData(chipInfo)
  self.name_text:SetText(chipInfo:GetName())
  self.type_icon:LoadSprite(TacticalWeaponUtils.GetSkillChipTypeIcon(chipInfo:GetType()))
  self.type_text:SetText(TacticalWeaponUtils.GetSkillChipTypeText(chipInfo:GetType()))
  self:RefreshLevelExpInfo()
  self.power_number_text:SetText(chipInfo:GetPower())
end

local function UpdateView(self)
  self:RemoveLongPressTimer()
  if table.count(self.chipsDataList) <= 0 then
    self.empty_tip_text:SetActive(true)
    self.chips_scroll:SetActive(fasle)
    self.chips_scroll:SetListItemCount(0)
  else
    self.empty_tip_text:SetActive(false)
    self.chips_scroll:SetActive(true)
    self.chips_scroll:SetListItemCount(table.count(self.chipsDataList))
    self.chips_scroll:RefreshAllShownItem()
  end
end

local function CanAddChip(self)
  local curLevel = self.targetLevel ~= nil and self.targetLevel or self.chipInfo.level
  if curLevel == self.chipInfo.maxLevel then
    UIUtil.ShowTipsId("drone_skillChip_tips_2")
    return false
  end
  return true
end

local function RefreshLevelExpInfo(self)
  local curLevel = self.chipInfo.level
  local targetLevel = self.targetLevel ~= nil and self.targetLevel or curLevel
  local curExp = self.chipInfo.exp
  local targetExp = self.targetExp ~= nil and self.targetExp or curExp
  if curLevel == targetLevel then
    self.level_text:SetText(string.format("Lv.%s", curLevel))
  else
    self.level_text:SetText(string.format("Lv.%s->Lv.%s", curLevel, targetLevel))
  end
  if targetLevel == self.chipInfo.maxLevel then
    self.progress_text:SetActive(false)
    self.max_level_text:SetActive(true)
    self.level_progress:SetValue(1)
    self.fill:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_lan.png")
  else
    local targetLevelNeedExp = DataCenter.TWSkillChipTemplateManager:GetNeedExpByTypeAndLevel(self.chipInfo:GetExpId(), targetLevel)
    self.level_progress:SetValue(targetExp / targetLevelNeedExp)
    self.progress_text:SetActive(true)
    self.progress_text:SetText(string.format("%s/%s", targetExp, targetLevelNeedExp))
    self.max_level_text:SetActive(false)
    self.fill:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_lv.png")
  end
  local properties = self.chipInfo:GetSortedProperties()
  local targetLevelProperties
  if curLevel < targetLevel then
    targetLevelProperties = self.chipInfo.template:GetAttributes(targetLevel)
  end
  for i = 1, 3 do
    local attriValue = properties[i]
    if attriValue then
      local id = attriValue.id
      local value = attriValue.value
      if value and 0 < value then
        self.attributes[i]:SetActive(true)
        local targetAttri
        if targetLevelProperties then
          targetAttri = targetLevelProperties[id]
        end
        self.attributes[i]:SetData(id, value, targetAttri)
      else
        self.attributes[i]:SetActive(false)
      end
    end
  end
  if self.chipInfo:IsMaxLevel() then
    self.auto_select_btn:SetActive(false)
    self.confirm_btn:SetActive(false)
    self.get_more_btn:SetActive(false)
    self.max_level_tip_text:SetActive(true)
  else
    if 0 >= table.count(self.chipsDataList) then
      self.auto_select_btn:SetActive(false)
      self.confirm_btn:SetActive(false)
      self.get_more_btn:SetActive(true)
    else
      self.auto_select_btn:SetActive(true)
      self.confirm_btn:SetActive(true)
      self.get_more_btn:SetActive(false)
    end
    self.max_level_tip_text:SetActive(false)
  end
  UIGray.SetGray(self.confirm_btn.transform, 0 >= self.totalExp, 0 < self.totalExp)
end

local function GetItemPerExp(self, type, uuid)
  local dict
  if type == ItemType.Goods then
    dict = self.goodsDict
  elseif type == ItemType.Chip then
    dict = self.chipsDict
  end
  if not dict then
    return 0
  end
  local item = dict[uuid]
  if not item then
    return 0
  end
  if item.type == ItemType.Goods then
    return tonumber(item.data.para1)
  elseif item.type == ItemType.Chip then
    return item.data:GetSelfTotalExp(true)
  end
  return 0
end

local function GetItemMaxNum(self, type, uuid)
  local dict
  if type == ItemType.Goods then
    dict = self.goodsDict
  elseif type == ItemType.Chip then
    dict = self.chipsDict
  end
  if not dict then
    return 0
  end
  local item = dict[uuid]
  if not item then
    return 0
  end
  if item.type == ItemType.Goods then
    return tonumber(item.data.count)
  elseif item.type == ItemType.Chip then
    return item.data.num
  end
  return 0
end

local function OnSelectedItemChanged(self, type, uuid, num)
  local perExp = GetItemPerExp(self, type, uuid)
  self.totalExp = self.totalExp + perExp * num
  self.targetLevel, self.targetExp = self.chipInfo:GetTargetLevelByAddExp(self.totalExp)
  self:RefreshLevelExpInfo()
end

local function ChangeSelectItem(self, type, uuid, num)
  local prevCount = GetSelectedNum(self, type, uuid)
  local dataContainer
  if type == ItemType.Goods then
    dataContainer = self.selectedGoods
  elseif type == ItemType.Chip then
    dataContainer = self.selectedChips
  end
  if num <= 0 then
    dataContainer[uuid] = 0
  else
    local maxNum = GetItemMaxNum(self, type, uuid)
    if num > maxNum then
      num = maxNum
    end
    dataContainer[uuid] = num
  end
  local differ = GetSelectedNum(self, type, uuid) - prevCount
  self:OnSelectedItemChanged(type, uuid, differ)
end

local function OnSkillChipItemClick(self, item, itemInfo)
  if not itemInfo then
    return
  end
  if self.startLongPress then
    self:RemoveLongPressTimer()
    return
  end
  if not CanAddChip(self) then
    return
  end
  local type = itemInfo.type
  local uuid = itemInfo.data.uuid
  local curSelectedNum = GetSelectedNum(self, type, uuid)
  if curSelectedNum + 1 > GetItemMaxNum(self, type, uuid) then
    return
  end
  curSelectedNum = curSelectedNum + 1
  item:SetSelectNumber(curSelectedNum)
  ChangeSelectItem(self, type, uuid, curSelectedNum)
end

local function RemoveLongPressTimer(self)
  if self.longPressTimer ~= nil then
    self.longPressTimer:Stop()
    self.longPressTimer = nil
  end
  self.startLongPress = false
  self.longPressItem = nil
  self.longPressItemInfo = nil
  self.addSpeed = 1
end

local function OnLongPressTimer(self)
  if self.startLongPress and self.longPressItemInfo then
    local type = self.longPressItemInfo.type
    local uuid = self.longPressItemInfo.data.uuid
    local maxNum = GetItemMaxNum(self, type, uuid)
    local curSelectedNum = GetSelectedNum(self, type, uuid)
    local curLevel = self.targetLevel ~= nil and self.targetLevel or self.chipInfo.level
    if self.addSpeed > 0 and (maxNum <= curSelectedNum or curLevel >= self.chipInfo.maxLevel) then
      RemoveLongPressTimer(self)
      return
    elseif self.addSpeed < 0 and curSelectedNum <= 0 then
      RemoveLongPressTimer(self)
      return
    end
    curSelectedNum = curSelectedNum + 1 * self.addSpeed
    if maxNum < curSelectedNum then
      curSelectedNum = maxNum
    elseif curSelectedNum < 0 then
      curSelectedNum = 0
    end
    ChangeSelectItem(self, type, uuid, curSelectedNum)
    if self.addSpeed > 0 then
      curLevel = self.targetLevel ~= nil and self.targetLevel or self.chipInfo.level
      if curLevel >= self.chipInfo.maxLevel then
        local tomaxLevelNeedExp = self.chipInfo:GetTargetLevelNeedExp(self.chipInfo.maxLevel - 1)
        local maxoutExp = self.totalExp - tomaxLevelNeedExp
        if 0 < maxoutExp then
          local perExp = GetItemPerExp(self, type, uuid)
          local maxoutNum = math.floor(maxoutExp / perExp)
          curSelectedNum = curSelectedNum - maxoutNum
          ChangeSelectItem(self, type, uuid, curSelectedNum)
        end
      end
    end
    if self.longPressItem then
      self.longPressItem:SetSelectNumber(curSelectedNum)
    end
    if self.addSpeed > 0 then
      self.addSpeed = self.addSpeed + 1
    else
      self.addSpeed = self.addSpeed - 1
    end
    if maxNum <= curSelectedNum then
      self:RemoveLongPressTimer()
    end
  end
end

local function AddLongPressTimer(self)
  if self.longPressTimer == nil then
    self.longPressTimer = TimerManager:GetInstance():GetTimer(0.1, function()
      self:OnLongPressTimer()
    end, nil, false, false, false)
  end
  self.longPressTimer:Start()
end

local function OnSkillChipItemLongPress(self, item, itemInfo)
  if not itemInfo then
    return
  end
  self:RemoveLongPressTimer()
  if not CanAddChip(self) then
    return
  end
  self.startLongPress = true
  self.longPressItemInfo = itemInfo
  self.longPressItem = item
  local type = itemInfo.type
  local uuid = itemInfo.data.uuid
  local maxNum = GetItemMaxNum(self, type, uuid)
  local curSelectedNum = GetSelectedNum(self, type, uuid)
  if maxNum <= curSelectedNum then
    return
  end
  self:AddLongPressTimer()
  self.addSpeed = 1
end

local function OnSkillChipItemPointerUp(self, item, itemInfo)
  if not itemInfo then
    return
  end
  RemoveLongPressTimer(self)
end

local function OnAutoSelectBtnClick(self)
  if table.count(self.chipsDataList) <= 0 then
    return
  end
  if not CanAddChip(self) then
    return
  end
  local curExp = self.targetExp ~= nil and self.targetExp or self.chipInfo.exp
  local curLevel = self.targetLevel ~= nil and self.targetLevel or self.chipInfo.level
  local toNextLevelNeedExp = DataCenter.TWSkillChipTemplateManager:GetNeedExpByTypeAndLevel(self.chipInfo:GetExpId(), curLevel)
  toNextLevelNeedExp = toNextLevelNeedExp - curExp
  local hasAddItem = false
  for i = 1, #self.chipsDataList do
    local info = self.chipsDataList[i]
    local data = info.data
    local type = info.type
    local uuid = data.uuid
    local maxNum = GetItemMaxNum(self, type, uuid)
    local curSelectedNum = GetSelectedNum(self, type, uuid)
    if not (maxNum <= curSelectedNum) then
      local remainNum = maxNum - curSelectedNum
      local perExp = GetItemPerExp(self, type, uuid)
      local needNum = math.ceil(toNextLevelNeedExp / perExp)
      if remainNum < needNum then
        needNum = remainNum
      end
      curSelectedNum = curSelectedNum + needNum
      ChangeSelectItem(self, type, uuid, curSelectedNum)
      hasAddItem = true
      toNextLevelNeedExp = toNextLevelNeedExp - needNum * perExp
      if toNextLevelNeedExp <= 0 then
        break
      end
    end
  end
  if hasAddItem and self.chips_scroll then
    self.chips_scroll:RefreshAllShownItem()
  end
end

local function OnUnsetClick(self, item, itemInfo)
  if not itemInfo then
    return
  end
  if self.startLongPress then
    self:RemoveLongPressTimer()
    return
  end
  local type = itemInfo.type
  local uuid = itemInfo.data.uuid
  local curSelectedNum = GetSelectedNum(self, type, uuid)
  if curSelectedNum <= 0 then
    return
  end
  curSelectedNum = curSelectedNum - 1
  item:SetSelectNumber(curSelectedNum)
  ChangeSelectItem(self, type, uuid, curSelectedNum)
end

local function OnUnsetLongPressStart(self, item, itemInfo)
  if not itemInfo then
    return
  end
  self:RemoveLongPressTimer()
  self.startLongPress = true
  self.longPressItemInfo = itemInfo
  self.longPressItem = item
  local type = itemInfo.type
  local uuid = itemInfo.data.uuid
  local curSelectedNum = GetSelectedNum(self, type, uuid)
  if curSelectedNum <= 0 then
    return
  end
  self:AddLongPressTimer()
  self.addSpeed = -1
end

local function OnUnsetPointerUp(self, item, itemInfo)
  if not itemInfo then
    return
  end
  RemoveLongPressTimer(self)
end

local function OnBeginDrag(self, eventData)
  if self.chips_scrollRect then
    self.chips_scrollRect:OnBeginDrag(eventData)
  end
  if self.chips_scroll then
    self.chips_scroll:OnBeginDrag(eventData)
  end
end

local function OnEndDrag(self, eventData)
  if self.chips_scrollRect then
    self.chips_scrollRect:OnEndDrag(eventData)
  end
  if self.chips_scroll then
    self.chips_scroll:OnEndDrag(eventData)
  end
end

local function OnDrag(self, eventData)
  if self.chips_scrollRect then
    self.chips_scrollRect:OnDrag(eventData)
  end
  if self.chips_scroll then
    self.chips_scroll:OnDrag(eventData)
  end
end

UILWTWSkillChipUpgradeView.OnCreate = OnCreate
UILWTWSkillChipUpgradeView.OnDestroy = OnDestroy
UILWTWSkillChipUpgradeView.OnEnable = OnEnable
UILWTWSkillChipUpgradeView.OnDisable = OnDisable
UILWTWSkillChipUpgradeView.OnAddListener = OnAddListener
UILWTWSkillChipUpgradeView.OnRemoveListener = OnRemoveListener
UILWTWSkillChipUpgradeView.ComponentDefine = ComponentDefine
UILWTWSkillChipUpgradeView.DataDefine = DataDefine
UILWTWSkillChipUpgradeView.ComponentDestroy = ComponentDestroy
UILWTWSkillChipUpgradeView.DataDestroy = DataDestroy
UILWTWSkillChipUpgradeView.OnOpen = OnOpen
UILWTWSkillChipUpgradeView.UpdateView = UpdateView
UILWTWSkillChipUpgradeView.OnSkillChipItemClick = OnSkillChipItemClick
UILWTWSkillChipUpgradeView.OnSkillChipItemLongPress = OnSkillChipItemLongPress
UILWTWSkillChipUpgradeView.OnAutoSelectBtnClick = OnAutoSelectBtnClick
UILWTWSkillChipUpgradeView.OnSelectedItemChanged = OnSelectedItemChanged
UILWTWSkillChipUpgradeView.ChangeSelectItem = ChangeSelectItem
UILWTWSkillChipUpgradeView.OnLongPressTimer = OnLongPressTimer
UILWTWSkillChipUpgradeView.AddLongPressTimer = AddLongPressTimer
UILWTWSkillChipUpgradeView.RemoveLongPressTimer = RemoveLongPressTimer
UILWTWSkillChipUpgradeView.OnSkillChipItemPointerUp = OnSkillChipItemPointerUp
UILWTWSkillChipUpgradeView.RefreshChipBasicInfo = RefreshChipBasicInfo
UILWTWSkillChipUpgradeView.RefreshLevelExpInfo = RefreshLevelExpInfo
UILWTWSkillChipUpgradeView.OnUnsetClick = OnUnsetClick
UILWTWSkillChipUpgradeView.OnUnsetLongPressStart = OnUnsetLongPressStart
UILWTWSkillChipUpgradeView.OnUnsetPointerUp = OnUnsetPointerUp
UILWTWSkillChipUpgradeView.OnChipUpgrade = OnChipUpgrade
UILWTWSkillChipUpgradeView.OnBeginDrag = OnBeginDrag
UILWTWSkillChipUpgradeView.OnEndDrag = OnEndDrag
UILWTWSkillChipUpgradeView.OnDrag = OnDrag
return UILWTWSkillChipUpgradeView
