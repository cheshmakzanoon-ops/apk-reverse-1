local base = UIBaseContainer
local BirthdayZodContent = BaseClass("BirthdayZodContent", base)
local Localization = CS.GameEntry.Localization
local star_show_txt_path = "StarShowTxt"
local star_show_select_path = "StarShowSelect"
local star_show_tiao_path = "StarShowSelect/StarShowTiao"
local start_show_btn_path = "StarShowSelect/StartShowBtn"

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
  self.star_show_txt = self:AddComponent(UITextMeshProUGUIEx, star_show_txt_path)
  self.star_show_select = self:AddComponent(UIButton, star_show_select_path)
  self.star_show_tiao = self:AddComponent(UIImage, star_show_tiao_path)
  self.start_show_btn = self:AddComponent(UIBaseContainer, start_show_btn_path)
  self.star_show_select:SetOnClick(function()
    self:ShowStarSelect()
  end)
end

local function ComponentDestroy(self)
  self.star_show_txt = nil
  self.star_show_select = nil
  self.star_show_tiao = nil
  self.start_show_btn = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
end

function BirthdayZodContent:SetData(data)
  self.data = data
  self:RefreshView()
  self.star_show_txt:SetLocalText("birthday_2_limit_15")
end

function BirthdayZodContent:RefreshView()
  if self.data == nil then
    return
  end
  local isShow = self.data.zodType ~= BirthdayZodType.Hide
  self.star_show_tiao:SetActive(isShow)
  if isShow then
    self.start_show_btn:SetAnchoredPositionXY(18, 0)
  else
    self.start_show_btn:SetAnchoredPositionXY(-18, 0)
  end
end

function BirthdayZodContent:ShowStarSelect()
  if self.data.zodType == BirthdayZodType.Hide then
    self.data.zodType = BirthdayZodType.ShowAll
  else
    self.data.zodType = BirthdayZodType.Hide
  end
  EventManager:GetInstance():Broadcast(EventId.BirthdaySetPanelShowDataChange)
end

BirthdayZodContent.OnCreate = OnCreate
BirthdayZodContent.OnDestroy = OnDestroy
BirthdayZodContent.OnEnable = OnEnable
BirthdayZodContent.OnDisable = OnDisable
BirthdayZodContent.ComponentDefine = ComponentDefine
BirthdayZodContent.ComponentDestroy = ComponentDestroy
BirthdayZodContent.DataDefine = DataDefine
BirthdayZodContent.DataDestroy = DataDestroy
return BirthdayZodContent
