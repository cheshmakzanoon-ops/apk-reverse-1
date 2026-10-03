local base = UIBaseContainer
local BirthdayVisibleContent = BaseClass("BirthdayVisibleContent", base)
local Localization = CS.GameEntry.Localization
local ShowMenuImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1"
local HideMenuImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2"
local visible_txt_path = "VisibleTxt"
local visible_select_bar_path = "VisibleSelectBar"
local visible_menu_icon_path = "VisibleSelectBar/MenuBtn/VisibleMenuIcon"
local visible_btn_text_path = "VisibleSelectBar/VisibleBtnText"

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
  self.visible_txt = self:AddComponent(UITextMeshProUGUIEx, visible_txt_path)
  self.visible_select_bar = self:AddComponent(UIButton, visible_select_bar_path)
  self.visible_menu_icon = self:AddComponent(UIImage, visible_menu_icon_path)
  self.visible_btn_text = self:AddComponent(UITextMeshProUGUIEx, visible_btn_text_path)
  self.visible_select_bar:SetOnClick(function()
    self:OnVisibleSelectBarClick()
  end)
end

local function ComponentDestroy(self)
  self.visible_txt = nil
  self.visible_select_bar = nil
  self.visible_menu_icon = nil
  self.visible_btn_text = nil
end

local function DataDefine(self)
  self.data = nil
  self.visibleMenuShow = false
end

local function DataDestroy(self)
  self.data = nil
  self.visibleMenuShow = nil
end

function BirthdayVisibleContent:SetData(data)
  self.data = data
  self.visibleMenuShow = false
  self:RefreshView()
end

function BirthdayVisibleContent:RefreshView()
  if self.data == nil then
    return
  end
  if self.visibleMenuShow then
    self.visible_menu_icon:LoadSprite(ShowMenuImage)
  else
    self.visible_menu_icon:LoadSprite(HideMenuImage)
  end
  self.visible_btn_text:SetText(DataCenter.BirthdayDataManager:GetVisibleNameByType(self.data.displayType))
  self.visible_txt:SetLocalText("birthday_tips_11")
end

function BirthdayVisibleContent:OnVisibleSelectBarClick()
  if self.data == nil then
    return
  end
  if self.visibleMenuShow then
    return
  end
  self.visibleMenuShow = true
  self:RefreshView()
  local visible_list = {
    {
      str = DataCenter.BirthdayDataManager:GetVisibleNameByType(BirthdayShowArea.OnlySelf),
      key = BirthdayShowArea.OnlySelf
    },
    {
      str = DataCenter.BirthdayDataManager:GetVisibleNameByType(BirthdayShowArea.Alliance),
      key = BirthdayShowArea.Alliance
    },
    {
      str = DataCenter.BirthdayDataManager:GetVisibleNameByType(BirthdayShowArea.All),
      key = BirthdayShowArea.All
    }
  }
  self.view:OnSetMenuShow(self.visible_btn_text, visible_list, self.data.displayType, function(key)
    self.data.displayType = key
    EventManager:GetInstance():Broadcast(EventId.BirthdaySetPanelShowDataChange)
  end)
end

BirthdayVisibleContent.OnCreate = OnCreate
BirthdayVisibleContent.OnDestroy = OnDestroy
BirthdayVisibleContent.OnEnable = OnEnable
BirthdayVisibleContent.OnDisable = OnDisable
BirthdayVisibleContent.ComponentDefine = ComponentDefine
BirthdayVisibleContent.ComponentDestroy = ComponentDestroy
BirthdayVisibleContent.DataDefine = DataDefine
BirthdayVisibleContent.DataDestroy = DataDestroy
return BirthdayVisibleContent
