local base = UIBaseContainer
local BirthdayAgeItem = BaseClass("BirthdayAgeItem", base)
local Localization = CS.GameEntry.Localization
local select_btn_path = "selectBtn"
local select_img_path = "selectBtn/selectBg/selectImg"
local age_select_txt_path = "selectBtn/AgeSelectTxt"

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
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.select_img = self:AddComponent(UIImage, select_img_path)
  self.age_select_txt = self:AddComponent(UITextMeshProUGUIEx, age_select_txt_path)
  self.select_btn:SetOnClick(function()
    self:OnSelectBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.select_btn = nil
  self.select_img = nil
  self.age_select_txt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function BirthdayAgeItem:SetData(data, selectKey, selectKeyFunc)
  self.data = data
  self.selectKey = selectKey
  self.selectKeyFunc = selectKeyFunc
  self:RefreshView()
end

function BirthdayAgeItem:RefreshView()
  if self.data == nil then
    return
  end
  self.select_img:SetActive(self.selectKey ~= nil and tonumber(self.data[BirthdayAgeKeyMeaning.key]) == self.selectKey)
  self.age_select_txt:SetLocalText(self.data[BirthdayAgeKeyMeaning.strKey], self.data[BirthdayAgeKeyMeaning.ageMin], self.data[BirthdayAgeKeyMeaning.ageMax])
end

function BirthdayAgeItem:OnSelectBtnClick()
  if self.data == nil then
    return
  end
  if self.selectKey and tonumber(self.data[BirthdayAgeKeyMeaning.key]) == self.selectKey then
    return
  end
  self.selectKey = tonumber(self.data[BirthdayAgeKeyMeaning.key])
  if self.selectKeyFunc then
    self.selectKeyFunc(self.selectKey)
  end
end

BirthdayAgeItem.OnCreate = OnCreate
BirthdayAgeItem.OnDestroy = OnDestroy
BirthdayAgeItem.OnEnable = OnEnable
BirthdayAgeItem.OnDisable = OnDisable
BirthdayAgeItem.ComponentDefine = ComponentDefine
BirthdayAgeItem.ComponentDestroy = ComponentDestroy
BirthdayAgeItem.DataDefine = DataDefine
BirthdayAgeItem.DataDestroy = DataDestroy
return BirthdayAgeItem
