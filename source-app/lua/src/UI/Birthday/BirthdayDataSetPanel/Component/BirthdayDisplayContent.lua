local base = UIBaseContainer
local BirthdayDisplayContent = BaseClass("BirthdayDisplayContent", base)
local Localization = CS.GameEntry.Localization
local NotInBirthdayImgPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_dangao_icon2.png"
local InBirthdayImgPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_dangao_icon.png"
local display_txt_path = "DisplayTxt"
local display_item_icon_path = "DisplayItem/DisplayItemIcon"
local display_birthday_num_path = "DisplayItem/DisplayBirthdayNum"

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
  self.display_txt = self:AddComponent(UITextMeshProUGUIEx, display_txt_path)
  self.display_item_icon = self:AddComponent(UIImage, display_item_icon_path)
  self.display_birthday_num = self:AddComponent(UITextMeshProUGUIEx, display_birthday_num_path)
end

local function ComponentDestroy(self)
  self.display_txt = nil
  self.display_item_icon = nil
  self.display_birthday_num = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function BirthdayDisplayContent:SetData(data)
  self.data = data
  self.display_txt:SetLocalText("birthday_tips_10")
  if self.data.birthdayMonth and self.data.birthdayDay then
    local isZodShow = self.data.zodType and self.data.zodType ~= BirthdayZodType.Hide
    if isZodShow then
      local iconPath = DataCenter.BirthdayDataManager:GetConstellationImgPathByDate(self.data.birthdayMonth .. "-" .. self.data.birthdayDay)
      self.display_item_icon:LoadSprite(iconPath)
    else
      self.display_item_icon:LoadSprite(InBirthdayImgPath)
    end
    self.display_birthday_num:SetLocalText("birthday_tips_2", self.data.birthdayMonth, self.data.birthdayDay)
  else
    self.display_item_icon:LoadSprite(NotInBirthdayImgPath)
    self.display_birthday_num:SetLocalText("birthday_tips_1")
  end
end

BirthdayDisplayContent.OnCreate = OnCreate
BirthdayDisplayContent.OnDestroy = OnDestroy
BirthdayDisplayContent.OnEnable = OnEnable
BirthdayDisplayContent.OnDisable = OnDisable
BirthdayDisplayContent.ComponentDefine = ComponentDefine
BirthdayDisplayContent.ComponentDestroy = ComponentDestroy
BirthdayDisplayContent.DataDefine = DataDefine
BirthdayDisplayContent.DataDestroy = DataDestroy
return BirthdayDisplayContent
