local base = UIBaseContainer
local BirthdayAgeSelectContent = BaseClass("BirthdayAgeSelectContent", base)
local Localization = CS.GameEntry.Localization
local ShowMenuImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1"
local HideMenuImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2"
local age_txt_path = "AgeTxt"
local age_select_bar_path = "AgeSelectBar"
local age_menu_icon_path = "AgeSelectBar/MenuBtn/AgeMenuIcon"
local age_btn_text_path = "AgeSelectBar/AgeBtnText"

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
  self.age_txt = self:AddComponent(UITextMeshProUGUIEx, age_txt_path)
  self.age_select_bar = self:AddComponent(UIButton, age_select_bar_path)
  self.age_menu_icon = self:AddComponent(UIImage, age_menu_icon_path)
  self.age_btn_text = self:AddComponent(UITextMeshProUGUIEx, age_btn_text_path)
  self.age_txt_btn = self:AddComponent(UIButton, age_txt_path)
  self.age_select_bar:SetOnClick(function()
    self:OnAgeSelectBarClick()
  end)
  self.age_txt_btn:SetOnClick(function()
    self:OnAgeTxtClick()
  end)
end

local function ComponentDestroy(self)
  self.age_txt = nil
  self.age_select_bar = nil
  self.age_menu_icon = nil
  self.age_btn_text = nil
end

local function DataDefine(self)
  self.data = nil
  self.ageMenuShow = false
end

local function DataDestroy(self)
  self.data = nil
  self.ageMenuShow = nil
end

function BirthdayAgeSelectContent:SetAgeListData(ageListData)
  self.ageListData = ageListData
end

function BirthdayAgeSelectContent:SetData(data)
  self.data = data
  self.ageMenuShow = false
  self:RefreshView()
end

function BirthdayAgeSelectContent:RefreshView()
  if self.data == nil then
    return
  end
  if self.ageMenuShow then
    self.age_menu_icon:LoadSprite(ShowMenuImage)
  else
    self.age_menu_icon:LoadSprite(HideMenuImage)
  end
  local isHaveSelect = false
  local selectIndex = -1
  if self.data.age and self.ageListData then
    for i, v in ipairs(self.ageListData) do
      if tonumber(v[BirthdayAgeKeyMeaning.key]) == self.data.age then
        selectIndex = i
        isHaveSelect = true
        break
      end
    end
  end
  if isHaveSelect then
    local ageData = self.ageListData[selectIndex]
    self.age_btn_text:SetLocalText(ageData[BirthdayAgeKeyMeaning.strKey], ageData[BirthdayAgeKeyMeaning.ageMin], ageData[BirthdayAgeKeyMeaning.ageMax])
  else
    self.age_btn_text:SetLocalText("birthday_tips_53")
  end
  self.age_txt:SetLocalText("birthday_1_limit_15")
end

function BirthdayAgeSelectContent:OnAgeSelectBarClick()
  if self.data == nil then
    return
  end
  if self.ageMenuShow then
    return
  end
  self.ageMenuShow = true
  self:RefreshView()
  local age_list = {}
  for i, v in ipairs(self.ageListData) do
    table.insert(age_list, {
      str = Localization:GetString(v[BirthdayAgeKeyMeaning.strKey], v[BirthdayAgeKeyMeaning.ageMin], v[BirthdayAgeKeyMeaning.ageMax]),
      key = tonumber(v[BirthdayAgeKeyMeaning.key])
    })
  end
  self.view:OnSetMenuShow(self.age_btn_text, age_list, self.data.age, function(key)
    self.data.age = key
    EventManager:GetInstance():Broadcast(EventId.BirthdaySetPanelShowDataChange)
  end)
end

function BirthdayAgeSelectContent:OnAgeTxtClick()
  local strTip = Localization:GetString("birthday_desc_2_limit")
  UIUtil.ShowBubbleTips(strTip, self.age_txt_btn.transform.position, -20, 30, 0, nil, nil, {reversal = true})
end

BirthdayAgeSelectContent.OnCreate = OnCreate
BirthdayAgeSelectContent.OnDestroy = OnDestroy
BirthdayAgeSelectContent.OnEnable = OnEnable
BirthdayAgeSelectContent.OnDisable = OnDisable
BirthdayAgeSelectContent.ComponentDefine = ComponentDefine
BirthdayAgeSelectContent.ComponentDestroy = ComponentDestroy
BirthdayAgeSelectContent.DataDefine = DataDefine
BirthdayAgeSelectContent.DataDestroy = DataDestroy
return BirthdayAgeSelectContent
