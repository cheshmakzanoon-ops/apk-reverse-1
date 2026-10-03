local base = UIBaseView
local UILWTWSkillChipBagView = BaseClass("UILWTWSkillChipBagView", base)
local SkillChipBagItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipBagItem")
local chips_grid_path = "PopUpTitle/root/chipsScroll"
local chips_content_path = "PopUpTitle/root/chipsScroll/viewport/content"
local chipReset_btn_path = "PopUpTitle/root/bottom/chipResetBtn"
local sortType_txt_path = "PopUpTitle/root/bottom/sortType/sortTypeTxt"
local sortTypeFoldState_img_path = "PopUpTitle/root/bottom/sortType/foldStateIcon"
local sortType_btn_path = "PopUpTitle/root/bottom/sortType"
local close_btn_path = "PopUpTitle/CloseBtn"
local closeMask_btn_path = "panel"
local sortTypeMenuMask_btn_path = "chooseSortTypeMenu"
local tabs_container_path = "PopUpTitle/root/tabs"
local empty_txt_path = "PopUpTitle/root/EmptyResultText"
local selectedTabs_path = {
  "PopUpTitle/root/tabs/tab0/selected",
  "PopUpTitle/root/tabs/tab1/selected1",
  "PopUpTitle/root/tabs/tab2/selected2",
  "PopUpTitle/root/tabs/tab3/selected3"
}
local tabBtns_path = {
  "PopUpTitle/root/tabs/tab0/btn",
  "PopUpTitle/root/tabs/tab1/btn1",
  "PopUpTitle/root/tabs/tab2/btn2",
  "PopUpTitle/root/tabs/tab3/btn3"
}
local sortConditionBg_path = {
  "chooseSortTypeMenu/menuBg/chipTypeCondition/bg",
  "chooseSortTypeMenu/menuBg/starCondition/bg1",
  "chooseSortTypeMenu/menuBg/rankingCondition/bg2",
  "chooseSortTypeMenu/menuBg/powerCondition/bg3"
}
local sortConditionStateIcon_path = {
  "chooseSortTypeMenu/menuBg/chipTypeCondition/selectedIcon",
  "chooseSortTypeMenu/menuBg/starCondition/selectedIcon1",
  "chooseSortTypeMenu/menuBg/rankingCondition/selectedIcon2",
  "chooseSortTypeMenu/menuBg/powerCondition/selectedIcon3"
}
local sortdConditionBtns_path = {
  "chooseSortTypeMenu/menuBg/chipTypeCondition",
  "chooseSortTypeMenu/menuBg/starCondition",
  "chooseSortTypeMenu/menuBg/rankingCondition",
  "chooseSortTypeMenu/menuBg/powerCondition"
}
local SORT_TYPE = {
  CHIP_TYPE = 1,
  STAR = 2,
  LEVEL = 3,
  QUALITY = 4
}

local function ClearScroll(self)
  if self.chips_grid then
    self.chips_content:RemoveComponents(SkillChipBagItem)
    self.chips_grid:ClearAllItems()
  end
end

local function RefreshSortType(self)
  self.chips = self.ctrl.GetChipsData(self.curChipType, self.curSortType)
  if table.count(self.chips) <= 0 then
    self.chips_grid:SetActive(false)
    self.empty_txt:SetActive(true)
    self.sortType_btn:SetActive(false)
  else
    self.chips_grid:SetActive(true)
    self.empty_txt:SetActive(false)
    self.chips_grid:SetListItemCount(table.count(self.chips))
    self.chips_grid:RefreshAllShownItem()
    self.sortType_btn:SetActive(true)
  end
end

local function ChooseSortType(self, sortType, refreshSortType)
  if self.curSortType == sortType then
    return
  end
  if sortType == SORT_TYPE.CHIP_TYPE then
    self.sortType_txt:SetLocalText("uav_chips_desc7")
  elseif sortType == SORT_TYPE.STAR then
    self.sortType_txt:SetLocalText("uav_chips_desc8")
  elseif sortType == SORT_TYPE.LEVEL then
    self.sortType_txt:SetLocalText("uav_chips_desc9")
  elseif sortType == SORT_TYPE.QUALITY then
    self.sortType_txt:SetLocalText("uav_chips_desc10")
  end
  for i = 1, 4 do
    if i == sortType then
      self.sortConditionBg[i]:SetColorRGBA255(250, 212, 156, 255)
      self.sortConditionStateIcon[i]:SetActive(true)
    else
      self.sortConditionBg[i]:SetColorRGBA255(233, 221, 215, 255)
      self.sortConditionStateIcon[i]:SetActive(false)
    end
  end
  self.curSortType = sortType
  if refreshSortType == nil or refreshSortType == true then
    RefreshSortType(self)
  end
end

local function ChooseChipType(self, chipType, refreshSortType)
  if self.curChipType == chipType then
    return
  end
  for i = 1, 4 do
    if i - 1 == chipType then
      self.selectedTabs[i]:SetActive(true)
    else
      self.selectedTabs[i]:SetActive(false)
    end
  end
  self.curChipType = chipType
  if refreshSortType == nil or refreshSortType == true then
    RefreshSortType(self)
  end
end

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function OnGetItemByRowColumn(self, loopScroll, index, rowIndex, columnIndex)
  if self.chips then
    local count = #self.chips
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("UILWTWSkillChipBagItem")
    local script = self.chips_content:GetComponent(item.gameObject.name, SkillChipBagItem)
    if script == nil then
      local objectName = GetItemNameSequence(self)
      item.gameObject.name = objectName
      script = self.chips_content:AddComponent(SkillChipBagItem, objectName)
    end
    script:SetActive(true)
    local itemInfo = self.chips[index]
    script:SetData(itemInfo)
    local master = itemInfo:GetMasterSet()
    script:SetMaster(master)
    local count = itemInfo:GetNum()
    script:SetCount(count)
    return item
  end
end

local function ShowSortTypeMenu(self)
  self.sortTypeMenuMask_btn:SetActive(true)
  self.sortTypeFoldState_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png")
end

local function HideSortTypeMenu(self)
  self.sortTypeMenuMask_btn:SetActive(false)
  self.sortTypeFoldState_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png")
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.tabs_container:SetActive(self.ctrl.HasChips())
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.chips_grid = self:AddComponent(UILoopGridView, chips_grid_path)
  self.chips_content = self:AddComponent(UIBaseContainer, chips_content_path)
  self.chipReset_btn = self:AddComponent(UIButton, chipReset_btn_path)
  self.sortType_txt = self:AddComponent(UIText, sortType_txt_path)
  self.sortTypeFoldState_img = self:AddComponent(UIImage, sortTypeFoldState_img_path)
  self.sortType_btn = self:AddComponent(UIButton, sortType_btn_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.closeMask_btn = self:AddComponent(UIButton, closeMask_btn_path)
  self.sortTypeMenuMask_btn = self:AddComponent(UIButton, sortTypeMenuMask_btn_path)
  self.tabs_container = self:AddComponent(UIBaseContainer, tabs_container_path)
  self.empty_txt = self:AddComponent(UIBaseContainer, empty_txt_path)
  self.selectedTabs = {
    self:AddComponent(UIBaseContainer, selectedTabs_path[1]),
    self:AddComponent(UIBaseContainer, selectedTabs_path[2]),
    self:AddComponent(UIBaseContainer, selectedTabs_path[3]),
    self:AddComponent(UIBaseContainer, selectedTabs_path[4])
  }
  self.tabBtns = {
    self:AddComponent(UIButton, tabBtns_path[1]),
    self:AddComponent(UIButton, tabBtns_path[2]),
    self:AddComponent(UIButton, tabBtns_path[3]),
    self:AddComponent(UIButton, tabBtns_path[4])
  }
  self.sortConditionBg = {
    self:AddComponent(UIImage, sortConditionBg_path[1]),
    self:AddComponent(UIImage, sortConditionBg_path[2]),
    self:AddComponent(UIImage, sortConditionBg_path[3]),
    self:AddComponent(UIImage, sortConditionBg_path[4])
  }
  self.sortConditionStateIcon = {
    self:AddComponent(UIBaseContainer, sortConditionStateIcon_path[1]),
    self:AddComponent(UIBaseContainer, sortConditionStateIcon_path[2]),
    self:AddComponent(UIBaseContainer, sortConditionStateIcon_path[3]),
    self:AddComponent(UIBaseContainer, sortConditionStateIcon_path[4])
  }
  self.sortdConditionBtns = {
    self:AddComponent(UIButton, sortdConditionBtns_path[1]),
    self:AddComponent(UIButton, sortdConditionBtns_path[2]),
    self:AddComponent(UIButton, sortdConditionBtns_path[3]),
    self:AddComponent(UIButton, sortdConditionBtns_path[4])
  }
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeMask_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.chipReset_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSkillChipReset, {anim = true})
  end)
  self.sortType_btn:SetOnClick(function()
    ShowSortTypeMenu(self)
  end)
  self.sortTypeMenuMask_btn:SetOnClick(function()
    HideSortTypeMenu(self)
  end)
  for i = 1, 4 do
    self.sortdConditionBtns[i]:SetOnClick(function()
      ChooseSortType(self, i)
      HideSortTypeMenu(self)
    end)
    self.tabBtns[i]:SetOnClick(function()
      ChooseChipType(self, i - 1)
    end)
  end
  self.chips_grid:InitGridView(0, function(loopScroll, index, item)
    return OnGetItemByRowColumn(self, loopScroll, index)
  end)
  HideSortTypeMenu(self)
  ChooseSortType(self, SORT_TYPE.QUALITY, false)
  ChooseChipType(self, 0, true)
end

local function ComponentDestroy(self)
  self.chips_grid = nil
  self.chips_content = nil
  self.chipReset_btn = nil
  self.sortType_txt = nil
  self.sortTypeFoldState_img = nil
  self.sortType_btn = nil
  self.close_btn = nil
  self.closeMask_btn = nil
  self.sortTypeMenuMask_btn = nil
  self.tabs_container = nil
  self.empty_txt = nil
  self.selectedTabs = nil
  self.tabBtns = nil
  self.sortConditionBg = nil
  self.sortConditionStateIcon = nil
  self.sortdConditionBtns = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnChipDataRefresh(self)
  self.tabs_container:SetActive(self.ctrl.HasChips())
  RefreshSortType(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TWSkillUpdate, OnChipDataRefresh)
  self:AddUIListener(EventId.TWSkillChipUpgrade, OnChipDataRefresh)
  self:AddUIListener(EventId.TWSkillChipStarUp, OnChipDataRefresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.TWSkillUpdate, OnChipDataRefresh)
  self:RemoveUIListener(EventId.TWSkillChipUpgrade, OnChipDataRefresh)
  self:RemoveUIListener(EventId.TWSkillChipStarUp, OnChipDataRefresh)
end

UILWTWSkillChipBagView.OnCreate = OnCreate
UILWTWSkillChipBagView.OnDestroy = OnDestroy
UILWTWSkillChipBagView.OnEnable = OnEnable
UILWTWSkillChipBagView.OnDisable = OnDisable
UILWTWSkillChipBagView.ComponentDefine = ComponentDefine
UILWTWSkillChipBagView.ComponentDestroy = ComponentDestroy
UILWTWSkillChipBagView.DataDefine = DataDefine
UILWTWSkillChipBagView.DataDestroy = DataDestroy
UILWTWSkillChipBagView.OnAddListener = OnAddListener
UILWTWSkillChipBagView.OnRemoveListener = OnRemoveListener
return UILWTWSkillChipBagView
