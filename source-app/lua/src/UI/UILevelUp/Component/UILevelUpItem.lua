local UILevelUpItem = BaseClass("UIGiftTypeButton", UIBaseContainer)
local base = UIBaseContainer
local LevelManager = DataCenter.PlayerLevelManager
local root_path = "Root"
local icon_path = "Root/Icon"
local new_path = "Root/New"
local count_path = "Root/Count"
local name_path = "Root/Name"
local bg_path = "Root/Bg"
local career_lv_path = "Root/CareerLv"
local BigWidth = 277
local MiddleWidth = 245
local SmallWidth = 245

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
  self.root_go = self:AddComponent(UIBaseContainer, root_path)
  self.icon_img = self:AddComponent(UIImage, icon_path)
  self.new_go = self:AddComponent(UIBaseContainer, new_path)
  self.count_text = self:AddComponent(UIText, count_path)
  self.name_text = self:AddComponent(UIText, name_path)
  self.bg_go = self:AddComponent(UIBaseContainer, bg_path)
  self.career_lv_text = self:AddComponent(UIText, career_lv_path)
end

local function ComponentDestroy(self)
  self.root_go = nil
  self.icon_img = nil
  self.new_go = nil
  self.count_text = nil
  self.name_text = nil
  self.bg_go = nil
  self.career_lv_text = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
end

local function SetData(self, data)
  self.data = data
  self.icon_img:LoadSprite(data.icon)
  self.icon_img:SetNativeSize()
  local width
  if data.type == LevelManager.ContentInfoType.Build then
    width = BigWidth
  elseif data.type == LevelManager.ContentInfoType.Normal then
    width = SmallWidth
  else
    width = MiddleWidth
  end
  local size = self.icon_img:GetSizeDelta()
  size.y = size.y / size.x * width
  size.x = width
  self.icon_img:SetSizeDelta(size)
  if data.type == LevelManager.ContentInfoType.Effect and data.effect.key == EffectDefine.ADD_FIELD_NUM then
    self.count_text:SetText("+" .. data.effect.value)
    self.name_text:SetLocalText(100317)
  else
    self.count_text:SetText(data.count)
    self.name_text:SetText(data.name)
  end
  self.count_text:SetActive(data.type ~= LevelManager.ContentInfoType.Career)
  self.name_text:SetActive(true)
  self.new_go:SetActive(data.unlock)
  self.bg_go:SetActive(true)
  if DataCenter.PlayerCareerManager:EnabledShow() and data.type == LevelManager.ContentInfoType.Career then
    self.career_lv_text:SetActive(true)
    self.career_lv_text:SetText(data.count)
  else
    self.career_lv_text:SetActive(false)
  end
end

local function Show(self, show)
  if self.root_go then
    self.root_go:SetActive(show)
  end
end

local function ShowIconOnly(self)
  if self.root_go then
    self.new_go:SetActive(false)
    self.count_text:SetActive(false)
    self.name_text:SetActive(false)
    self.bg_go:SetActive(false)
  end
end

UILevelUpItem.OnDestroy = OnDestroy
UILevelUpItem.OnCreate = OnCreate
UILevelUpItem.ComponentDefine = ComponentDefine
UILevelUpItem.ComponentDestroy = ComponentDestroy
UILevelUpItem.DataDefine = DataDefine
UILevelUpItem.DataDestroy = DataDestroy
UILevelUpItem.SetData = SetData
UILevelUpItem.Show = Show
UILevelUpItem.ShowIconOnly = ShowIconOnly
return UILevelUpItem
