local base = UIBaseContainer
local BirthdayNumSelectContent = BaseClass("BirthdayNumSelectContent", base)
local Localization = CS.GameEntry.Localization
local HideMenuImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1"
local ShowMenuImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2"
local month_select_bar_path = "MonthSelectBar"
local month_menu_icon_path = "MonthSelectBar/MenuBtn/MonthMenuIcon"
local month_btn_text_path = "MonthSelectBar/MonthBtnText"
local day_select_bar_path = "DaySelectBar"
local day_menu_icon_path = "DaySelectBar/MenuBtn/DayMenuIcon"
local day_btn_text_path = "DaySelectBar/DayBtnText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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

local function ComponentDefine(self)
  self.month_select_bar = self:AddComponent(UIButton, month_select_bar_path)
  self.month_menu_icon = self:AddComponent(UIImage, month_menu_icon_path)
  self.month_btn_text = self:AddComponent(UITextMeshProUGUIEx, month_btn_text_path)
  self.day_select_bar = self:AddComponent(UIButton, day_select_bar_path)
  self.day_menu_icon = self:AddComponent(UIImage, day_menu_icon_path)
  self.day_btn_text = self:AddComponent(UITextMeshProUGUIEx, day_btn_text_path)
  self.month_select_bar:SetOnClick(function()
    self:OnMonthSelectBarClick()
  end)
  self.day_select_bar:SetOnClick(function()
    self:OnDaySelectBarClick()
  end)
end

local function ComponentDestroy(self)
  self.month_select_bar = nil
  self.month_menu_icon = nil
  self.month_btn_text = nil
  self.day_select_bar = nil
  self.day_menu_icon = nil
  self.day_btn_text = nil
end

local function DataDefine(self)
  self.data = nil
  self.monthMenuShow = false
  self.dayMenuShow = false
end

local function DataDestroy(self)
  self.data = nil
  self.monthMenuShow = nil
  self.dayMenuShow = nil
end

function BirthdayNumSelectContent:SetData(data)
  self.data = data
  self.monthMenuShow = false
  self.dayMenuShow = false
  self:RefreshView()
end

function BirthdayNumSelectContent:RefreshView()
  if self.data == nil then
    return
  end
  if self.monthMenuShow then
    self.month_menu_icon:SetEulerAnglesXYZ(0, 0, 0)
  else
    self.month_menu_icon:SetEulerAnglesXYZ(0, 0, 180)
  end
  if self.dayMenuShow then
    self.day_menu_icon:SetEulerAnglesXYZ(0, 0, 0)
  else
    self.day_menu_icon:SetEulerAnglesXYZ(0, 0, 180)
  end
  self.month_btn_text:SetText(DataCenter.BirthdayDataManager:GetMonthStrByNum(self.data.birthdayMonth))
  self.day_btn_text:SetText(DataCenter.BirthdayDataManager:GetDayStrByNum(self.data.birthdayDay))
end

function BirthdayNumSelectContent:OnMonthSelectBarClick()
  if self.data == nil then
    return
  end
  if self.monthMenuShow then
    return
  end
  self.monthMenuShow = true
  self:RefreshView()
  local month_list = {}
  for i = 1, 12 do
    month_list[i] = {
      str = DataCenter.BirthdayDataManager:GetMonthStrByNum(i),
      key = i
    }
  end
  self.view:OnSetMenuShow(self.month_select_bar, month_list, self.data.birthdayMonth, function(key)
    self.data.birthdayMonth = key
    EventManager:GetInstance():Broadcast(EventId.BirthdaySetPanelShowDataChange)
  end)
end

function BirthdayNumSelectContent:OnDaySelectBarClick()
  if self.data == nil then
    return
  end
  if self.dayMenuShow then
    return
  end
  self.dayMenuShow = true
  self:RefreshView()
  local dayNum = 31
  if self.data.birthdayMonth then
    dayNum = MonthMaxDay[self.data.birthdayMonth]
  end
  local day_list = {}
  for i = 1, dayNum do
    day_list[i] = {str = i, key = i}
  end
  self.view:OnSetMenuShow(self.day_select_bar, day_list, self.data.birthdayDay, function(key)
    self.data.birthdayDay = key
    EventManager:GetInstance():Broadcast(EventId.BirthdaySetPanelShowDataChange)
  end)
end

BirthdayNumSelectContent.OnCreate = OnCreate
BirthdayNumSelectContent.OnDestroy = OnDestroy
BirthdayNumSelectContent.OnEnable = OnEnable
BirthdayNumSelectContent.OnDisable = OnDisable
BirthdayNumSelectContent.ComponentDefine = ComponentDefine
BirthdayNumSelectContent.ComponentDestroy = ComponentDestroy
BirthdayNumSelectContent.DataDefine = DataDefine
BirthdayNumSelectContent.DataDestroy = DataDestroy
return BirthdayNumSelectContent
