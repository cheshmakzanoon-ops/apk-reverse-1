local UILWTWSkillChipManageView = BaseClass("UILWTWSkillChipManageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local SkillChipSimpleAttrLineItem = require("UI.UILWTWSkillChip.UILWTWSkillChipManage.Component.SkillChipSimpleAttrLineItem")
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local SkillChipManageSmallItem = require("UI.UILWTWSkillChip.UILWTWSkillChipManage.Component.SkillChipManageSmallItem")
local content_path = "PopUpTitle/Common_bg_orange2/Content"
local empty_content_path = "PopUpTitle/Common_bg_orange2/EmptyContent"
local get_more_btn_path = "PopUpTitle/Common_bg_orange2/EmptyContent/GetMoreBtn"
local basic_info_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo"
local chip_item_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/ChipItem"
local name_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/NameText"
local type_icon_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/ChipType/TypeIcon"
local type_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/ChipType/TypeText"
local power_number_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/PowerInfo/PowerNumberText"
local attribute_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/Attributes/Attribute%d"
local attribute_container_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/Attributes"
local skill_desc_scroll_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/textScroll"
local skill_desc_txt_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/textScroll/viewport/content/skillDescTxt"
local chips_area_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea"
local empty_tip_text_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/EmptyTipText"
local chips_scroll_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/ChipsScroll"
local chips_scroll_content_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/ChipsScroll/Viewport/ChipContent"
local funcitons_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons"
local equip_btn_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/EquipBtn"
local close_btn_path = "PopUpTitle/CloseBtn"
local panel_path = "panel"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local attr_check_mark_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/toggleGroup/attrToggle/Background/attrCheckmark"
local skill_checkmark_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/toggleGroup/skillToggle/Background/skillCheckmark"
local all_type_checkmark_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/chipHeroTypeToggleGroup/allTypeToggle/Background/allTypeCheckmark"
local tank_type_checkmark_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/chipHeroTypeToggleGroup/tankTypeToggle/Background/tankTypeCheckmark"
local missile_type_checkmark_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/chipHeroTypeToggleGroup/missileTypeToggle/Background/missileTypeCheckmark"
local airplane_checkmark_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/chipHeroTypeToggleGroup/airPlaneTypeToggle/Background/AirplaneCheckmark"
local attr_toggle_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/toggleGroup/attrToggle"
local skill_toggle_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/toggleGroup/skillToggle"
local all_type_toggle_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/chipHeroTypeToggleGroup/allTypeToggle"
local tank_type_toggle_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/chipHeroTypeToggleGroup/tankTypeToggle"
local missile_type_toggle_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/chipHeroTypeToggleGroup/missileTypeToggle"
local air_plane_type_toggle_path = "PopUpTitle/Common_bg_orange2/Content/ChipsArea/chipHeroTypeToggleGroup/airPlaneTypeToggle"
local hero_spine_container_path = "PopUpTitle/Common_bg_orange2/EmptyContent/guide/heroSpineContainer"
local guide_desc_text_path = "PopUpTitle/Common_bg_orange2/EmptyContent/guide/guideDescText"
local INFO_TYPE = {SKILL = 1, ATTR = 2}

local function DefineCallbacks(self)
  self.clickCallback = BindCallback(self, self.OnSkillChipItemClick)
  self.longPressCallback = BindCallback(self, self.OnSkillChipItemLongPress)
  self.beginDragCallback = BindCallback(self, self.OnBeginDrag)
  self.endDragCallback = BindCallback(self, self.OnEndDrag)
  self.dragCallback = BindCallback(self, self.OnDrag)
end

local function RemoveCallbacks(self)
  self.clickCallback = nil
  self.longPressCallback = nil
  self.beginDragCallback = nil
  self.endDragCallback = nil
  self.dragCallback = nil
end

local SKILLCHIP_TYPE_TITLE = {
  [1] = "uav_chips_title6",
  [2] = "uav_chips_title7",
  [3] = "uav_chips_title8",
  [4] = "uav_chips_title9"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  DefineCallbacks(self)
  self:DataDefine()
  self.type, self.setId = self:GetUserData()
  self.curSelectUuid = nil
  if SKILLCHIP_TYPE_TITLE[self.type] then
    self.title_text:SetLocalText(SKILLCHIP_TYPE_TITLE[self.type])
  else
    self.title_text:SetLocalText("uav_chips_title6")
  end
  self:ChangeSkillChipHeroType(0)
  if not table.IsNullOrEmpty(self.chipsDataList) then
    self:SetCurSelectChipInfo(self.chipsDataList[1])
  end
  self:ChangeInfoType(INFO_TYPE.SKILL)
  self:OnOpen()
end

local function ClearScroll(self)
  if self.chips_scroll then
    self.chips_scroll_content:RemoveComponents(SkillChipManageSmallItem)
    self.chips_scroll:ClearAllItems()
  end
end

local function OnDestroy(self)
  self:DestroyHeroSpine()
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

local function OnGetItemByRowColumn(self, loopScroll, index, rowIndex, columnIndex)
  if self.chipsDataList ~= nil then
    local count = #self.chipsDataList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("UILWTWSkillChipManageSmallItem")
    local script = self.chips_scroll_content:GetComponent(item.gameObject.name, SkillChipManageSmallItem)
    if script == nil then
      local objectName = GetItemNameSequence(self)
      item.gameObject.name = objectName
      script = self.chips_scroll_content:AddComponent(SkillChipManageSmallItem, objectName)
      script:SetOnClick(self.clickCallback)
      script:SetOnLongPress(self.longPressCallback)
      script:SetOnBeginDrag(self.beginDragCallback)
      script:SetOnEndDrag(self.endDragCallback)
      script:SetOnDrag(self.dragCallback)
    end
    script:SetActive(true)
    script:SetLocalScaleXYZ(0.78, 0.78, 0.78)
    script:SetData(self.chipsDataList[index])
    script:SetMaster(self.chipsDataList[index]:GetMasterSet())
    script:SetCount(self.chipsDataList[index]:GetNum())
    script:SetSelected(self.curSelectChipInfo and self.curSelectChipInfo.uuid == self.chipsDataList[index].uuid)
    return item
  end
end

local function ComponentDefine(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.empty_content = self:AddComponent(UIBaseContainer, empty_content_path)
  self.get_more_btn = self:AddComponent(UIButton, get_more_btn_path)
  self.get_more_btn:SetOnClick(function()
    TacticalWeaponUtils.ShowSkillChipLackWindow()
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
  self.attrbutes_container = self:AddComponent(UIBaseContainer, attribute_container_path)
  self.skill_desc_scroll = self:AddComponent(UIScrollRect, skill_desc_scroll_path)
  self.skill_desc = self:AddComponent(UIText, skill_desc_txt_path)
  self.chips_area = self:AddComponent(UIBaseContainer, chips_area_path)
  self.empty_tip_text = self:AddComponent(UIText, empty_tip_text_path)
  self.chips_scroll = self:AddComponent(UILoopGridView, chips_scroll_path)
  self.chips_scroll:InitGridView(0, function(loopScroll, index, item)
    return OnGetItemByRowColumn(self, loopScroll, index)
  end)
  self.chips_scrollRect = self:AddComponent(UIScrollRect, chips_scroll_path)
  self.chips_scroll_content = self:AddComponent(UIBaseContainer, chips_scroll_content_path)
  self.funcitons = self:AddComponent(UIBaseContainer, funcitons_path)
  self.equip_btn = self:AddComponent(UIButton, equip_btn_path)
  self.equip_btn:SetOnClick(function()
    if self.curSelectChipInfo then
      if not self.curSelectChipInfo:IsFree() then
        local chipName = self.curSelectChipInfo:GetName()
        local setId = self.curSelectChipInfo:GetMasterSet()
        UIUtil.ShowMessage(Localization:GetString("drone_skillChip_tips_3", chipName, setId), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          SFSNetwork.SendMessage(MsgDefines.TWSkillChipPutOn, self.setId, {
            [self.curSelectChipInfo.type] = self.curSelectChipInfo.uuid
          })
          self.ctrl:CloseSelf()
        end)
      else
        SFSNetwork.SendMessage(MsgDefines.TWSkillChipPutOn, self.setId, {
          [self.curSelectChipInfo.type] = self.curSelectChipInfo.uuid
        })
        self.ctrl:CloseSelf()
      end
    end
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.attr_check_mark = self:AddComponent(UIBaseContainer, attr_check_mark_path)
  self.skill_checkmark = self:AddComponent(UIBaseContainer, skill_checkmark_path)
  self.all_type_checkmark = self:AddComponent(UIBaseContainer, all_type_checkmark_path)
  self.tank_type_checkmark = self:AddComponent(UIBaseContainer, tank_type_checkmark_path)
  self.missile_type_checkmark = self:AddComponent(UIBaseContainer, missile_type_checkmark_path)
  self.airplane_checkmark = self:AddComponent(UIBaseContainer, airplane_checkmark_path)
  self.attr_toggle = self:AddComponent(UIButton, attr_toggle_path)
  self.attr_toggle:SetOnClick(function()
    self:ChangeInfoType(INFO_TYPE.ATTR)
  end)
  self.skill_toggle = self:AddComponent(UIButton, skill_toggle_path)
  self.skill_toggle:SetOnClick(function()
    self:ChangeInfoType(INFO_TYPE.SKILL)
  end)
  self.all_type_toggle = self:AddComponent(UIButton, all_type_toggle_path)
  self.all_type_toggle:SetOnClick(function()
    self:ChangeSkillChipHeroType(0, true)
  end)
  self.tank_type_toggle = self:AddComponent(UIButton, tank_type_toggle_path)
  self.tank_type_toggle:SetOnClick(function()
    self:ChangeSkillChipHeroType(1, true)
  end)
  self.missile_type_toggle = self:AddComponent(UIButton, missile_type_toggle_path)
  self.missile_type_toggle:SetOnClick(function()
    self:ChangeSkillChipHeroType(2, true)
  end)
  self.air_plane_type_toggle = self:AddComponent(UIButton, air_plane_type_toggle_path)
  self.air_plane_type_toggle:SetOnClick(function()
    self:ChangeSkillChipHeroType(3, true)
  end)
  self.spine_container = self:AddComponent(UIBaseContainer, hero_spine_container_path)
  self.guide_desc_text = self:AddComponent(UIText, guide_desc_text_path)
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.chips_scroll = nil
  self.chips_scrollRect = nil
  self.chips_scroll_content = nil
  self.get_more_btn = nil
  self.basic_info = nil
  self.chip_item = nil
  self.name_text = nil
  self.type_icon = nil
  self.type_text = nil
  self.power_number_text = nil
  self.attributes = nil
  self.chips_area = nil
  self.empty_tip_text = nil
  self.funcitons = nil
  self.equip_btn = nil
  self.close_btn = nil
  self.panel = nil
  self.title_text = nil
  self.content = nil
  self.empty_content = nil
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnSkillChipUpdate(self)
  self.chipsDataList = self.ctrl.RefershEquipDataList(self.type, self.curHeroType or 0, self.setId)
  if self.curSelectUuid then
    local isExist = false
    for i, v in pairs(self.chipsDataList) do
      if v.uuid == self.curSelectUuid then
        isExist = true
        break
      end
    end
    if not isExist then
      if not table.IsNullOrEmpty(self.chipsDataList) then
        self:SetCurSelectChipInfo(self.chipsDataList[1])
      else
        self.curSelectChipInfo = nil
        self.curSelectUuid = nil
      end
    end
  elseif not table.IsNullOrEmpty(self.chipsDataList) then
    self:SetCurSelectChipInfo(self.chipsDataList[1])
  end
  self:UpdateView()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TWSkillUpdate, self.OnSkillChipUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.TWSkillUpdate, self.OnSkillChipUpdate)
end

local function OnOpen(self)
  self:UpdateView()
end

local function RefreshSkillChipInfo(self)
  if not self.curSelectChipInfo then
    return
  end
  if self.curInfotype == INFO_TYPE.ATTR then
    local properties = self.curSelectChipInfo:GetSortedProperties()
    for i = 1, 3 do
      local value = properties[i].value
      local id = properties[i].id
      if value and 0 < value then
        self.attributes[i]:SetActive(true)
        self.attributes[i]:SetData(id, value)
      else
        self.attributes[i]:SetActive(false)
      end
    end
  else
    local skillInfo = self.curSelectChipInfo:GetSkillInfo()
    self.skill_desc:SetText(skillInfo:GetDesc(false, "#5FEF87"))
  end
end

local function ChangeInfoType(self, infoType)
  if self.curInfotype == infoType then
    return
  end
  self.curInfotype = infoType
  if self.curInfotype == INFO_TYPE.ATTR then
    self.attr_check_mark:SetActive(true)
    self.skill_checkmark:SetActive(false)
    self.skill_desc_scroll:SetActive(false)
    self.attrbutes_container:SetActive(true)
  else
    self.attr_check_mark:SetActive(false)
    self.skill_checkmark:SetActive(true)
    self.skill_desc_scroll:SetActive(true)
    self.attrbutes_container:SetActive(false)
  end
  RefreshSkillChipInfo(self)
end

local function ChangeSkillChipHeroType(self, heroType, updateGrid)
  if self.curHeroType == heroType then
    return
  end
  self.all_type_checkmark:SetActive(heroType == 0)
  self.tank_type_checkmark:SetActive(heroType == 1)
  self.missile_type_checkmark:SetActive(heroType == 2)
  self.airplane_checkmark:SetActive(heroType == 3)
  self.chipsDataList = self.ctrl.RefershEquipDataList(self.type, heroType, self.setId)
  if updateGrid == nil or updateGrid then
    if table.IsNullOrEmpty(self.chipsDataList) then
      self.chips_scroll:SetActive(false)
    else
      self.chips_scroll:SetActive(true)
      self.chips_scroll:SetListItemCount(table.count(self.chipsDataList))
      self.chips_scroll:RefreshAllShownItem()
    end
  end
end

local function SetCurSelectChipInfo(self, chipInfo)
  if not chipInfo then
    return
  end
  if self.curSelectChipInfo == chipInfo then
    return
  end
  self.curSelectChipInfo = chipInfo
  self.curSelectUuid = chipInfo.uuid
  self.chip_item:SetData(chipInfo)
  self.name_text:SetText(chipInfo:GetName())
  self.type_icon:LoadSprite(TacticalWeaponUtils.GetSkillChipTypeIcon(chipInfo:GetType()))
  self.type_text:SetText(TacticalWeaponUtils.GetSkillChipTypeText(chipInfo:GetType()))
  self.power_number_text:SetText(chipInfo:GetPower())
  RefreshSkillChipInfo(self)
end

local EMPTY_GUIDE_DESC = {
  [1] = "uav_chips_desc14",
  [2] = "uav_chips_desc15",
  [3] = "uav_chips_desc16",
  [4] = "uav_chips_desc17"
}

local function UpdateView(self)
  if table.count(self.chipsDataList) <= 0 then
    self.empty_content:SetActive(true)
    self:LoadHeroSpine()
    self.content:SetActive(false)
    if EMPTY_GUIDE_DESC[self.type] then
      self.guide_desc_text:SetText(Localization:GetString(EMPTY_GUIDE_DESC[self.type]))
    else
      self.guide_desc_text:SetText(Localization:GetString("uav_chips_desc14"))
    end
  else
    self.empty_content:SetActive(false)
    self.content:SetActive(true)
    if table.IsNullOrEmpty(self.chipsDataList) then
      self.chips_scroll:SetActive(false)
    else
      self.chips_scroll:SetActive(true)
      self.chips_scroll:SetListItemCount(table.count(self.chipsDataList))
      self.chips_scroll:RefreshAllShownItem()
    end
  end
end

local function GetItemIndexByUuid(self, uuid)
  if not uuid then
    return
  end
  for i, v in pairs(self.chipsDataList) do
    if v.uuid == uuid then
      return i
    end
  end
end

local function OnSkillChipItemClick(self, item, chipInfo)
  if not chipInfo then
    return
  end
  if self.curSelectUuid == chipInfo.uuid then
    return
  end
  local prevSelectId = self.curSelectUuid
  SetCurSelectChipInfo(self, chipInfo)
  if prevSelectId then
    local itemIndex = GetItemIndexByUuid(self, prevSelectId)
    if itemIndex then
      self.chips_scroll:RefreshItemByIndex(itemIndex - 1)
    end
  end
  local itemIndex = GetItemIndexByUuid(self, chipInfo.uuid)
  if itemIndex then
    self.chips_scroll:RefreshItemByIndex(itemIndex - 1)
  end
end

local function OnSkillChipItemLongPress(self, item, chipInfo)
  if not chipInfo then
    return
  end
  local pivotItem = item.click_btn ~= nil and item.click_btn or item
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, chipInfo, false)
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

local DISPLAY_SPINE_HERO_ID = 40020

local function LoadHeroSpine(self)
  if self.spineLoadRequest then
    return
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(DISPLAY_SPINE_HERO_ID)
  if not heroTemplate then
    return
  end
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), heroTemplate.appearance, "show_model_path")
  local spinePath_B = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), heroTemplate.appearance, "show_model_path_B")
  if not string.IsNullOrEmpty(spinePath_B) and CommonUtil.IsJapanABTest() then
    spinePath = spinePath_B
  end
  self.spineLoadRequest = self:GameObjectInstantiateAsync(spinePath, function(request)
    if IsNull(request.gameObject) then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.spine_container.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end)
end

local function DestroyHeroSpine(self)
  if self.spineLoadRequest then
    self.spineLoadRequest:Destroy()
    self.spineLoadRequest = nil
  end
end

UILWTWSkillChipManageView.OnCreate = OnCreate
UILWTWSkillChipManageView.OnDestroy = OnDestroy
UILWTWSkillChipManageView.OnEnable = OnEnable
UILWTWSkillChipManageView.OnDisable = OnDisable
UILWTWSkillChipManageView.OnAddListener = OnAddListener
UILWTWSkillChipManageView.OnRemoveListener = OnRemoveListener
UILWTWSkillChipManageView.ComponentDefine = ComponentDefine
UILWTWSkillChipManageView.DataDefine = DataDefine
UILWTWSkillChipManageView.ComponentDestroy = ComponentDestroy
UILWTWSkillChipManageView.DataDestroy = DataDestroy
UILWTWSkillChipManageView.OnOpen = OnOpen
UILWTWSkillChipManageView.UpdateView = UpdateView
UILWTWSkillChipManageView.SetCurSelectChipInfo = SetCurSelectChipInfo
UILWTWSkillChipManageView.OnSkillChipItemClick = OnSkillChipItemClick
UILWTWSkillChipManageView.OnSkillChipItemLongPress = OnSkillChipItemLongPress
UILWTWSkillChipManageView.OnSkillChipUpdate = OnSkillChipUpdate
UILWTWSkillChipManageView.OnBeginDrag = OnBeginDrag
UILWTWSkillChipManageView.OnEndDrag = OnEndDrag
UILWTWSkillChipManageView.OnDrag = OnDrag
UILWTWSkillChipManageView.ChangeInfoType = ChangeInfoType
UILWTWSkillChipManageView.ChangeSkillChipHeroType = ChangeSkillChipHeroType
UILWTWSkillChipManageView.LoadHeroSpine = LoadHeroSpine
UILWTWSkillChipManageView.DestroyHeroSpine = DestroyHeroSpine
return UILWTWSkillChipManageView
