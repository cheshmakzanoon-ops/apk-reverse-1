local UIPveActTaskItem = BaseClass("UIPveActTaskItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local bg_path = "Bg"
local icon_path = "Bg/Image/Icon"
local name_path = "Bg/Name"
local id_path = "Bg/Id"
local num_path = "Bg/Image/Num"
local reward_path = "Bg/Reward"
local reward_desc_path = "Bg/Reward/RewardDesc"
local reward_icon_path = "Bg/Reward/RewardIcon"
local reward_count_path = "Bg/Reward/RewardCount"
local find_path = "Bg/Find"
local complete_path = "Bg/Complete"
local complete_text_path = "Bg/Complete/CompleteText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg_btn = self:AddComponent(UIButton, bg_path)
  self.bg_btn:SetOnClick(function()
    self:OnBgClick()
  end)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.name_text = self:AddComponent(UIText, name_path)
  self.id_text = self:AddComponent(UIText, id_path)
  self.num_text = self:AddComponent(UIText, num_path)
  self.reward_go = self:AddComponent(UIBaseContainer, reward_path)
  self.reward_desc_text = self:AddComponent(UIText, reward_desc_path)
  self.reward_desc_text:SetLocalText(130065)
  self.reward_icon_image = self:AddComponent(UIImage, reward_icon_path)
  self.reward_count_text = self:AddComponent(UIText, reward_count_path)
  self.find_go = self:AddComponent(UIBaseContainer, find_path)
  self.complete_go = self:AddComponent(UIBaseContainer, complete_path)
  self.complete_text = self:AddComponent(UIText, complete_text_path)
  self.complete_text:SetLocalText(170008)
end

local function ComponentDestroy(self)
  self.bg_btn = nil
  self.icon_image = nil
  self.name_text = nil
  self.id_text = nil
  self.num_text = nil
  self.reward_go = nil
  self.reward_desc_text = nil
  self.reward_icon_image = nil
  self.reward_count_text = nil
  self.find_go = nil
  self.complete_go = nil
  self.complete_text = nil
end

local function DataDefine(self)
  self.data = nil
  self.template = nil
end

local function DataDestroy(self)
  self.data = nil
  self.template = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, data)
  if data == nil then
    return
  end
  self.data = data
  self.template = DataCenter.QuestTemplateManager:GetQuestTemplate(data.id)
  if self.template == nil then
    return
  end
  local needNum = tonumber(self.template.para2)
  self.icon_image:LoadSprite(string.format(LoadPath.UITask, self.template.icon))
  self.name_text:SetText(self.template:GetDesc())
  self.id_text:SetText(data.id)
  self.id_text:SetActive(false)
  if data.state == 0 then
    self.bg_btn:LoadSprite("Assets/Main/Sprites/UI/UIPveAct/integral_bg_column")
    self.num_text:SetText(data.num .. "/" .. needNum)
    self.reward_go:SetActive(true)
    self.reward_count_text:SetText(data.exp)
    self.find_go:SetActive(true)
    self.complete_go:SetActive(false)
    CS.UIGray.SetGray(self.bg_btn.transform, false, true)
  elseif data.state == 1 then
    self.bg_btn:LoadSprite("Assets/Main/Sprites/UI/UIPveAct/integral_bg_column2")
    self.num_text:SetText(needNum .. "/" .. needNum)
    self.reward_go:SetActive(true)
    self.reward_count_text:SetText(data.exp)
    self.find_go:SetActive(false)
    self.complete_go:SetActive(false)
    CS.UIGray.SetGray(self.bg_btn.transform, false, true)
  else
    self.bg_btn:LoadSprite("Assets/Main/Sprites/UI/UIPveAct/integral_bg_column")
    self.num_text:SetText(needNum .. "/" .. needNum)
    self.reward_go:SetActive(false)
    self.find_go:SetActive(false)
    self.complete_go:SetActive(true)
    CS.UIGray.SetGray(self.bg_btn.transform, true, false)
  end
end

local function OnBgClick(self)
  self.view:OnTaskItemClick(self)
end

UIPveActTaskItem.OnCreate = OnCreate
UIPveActTaskItem.OnDestroy = OnDestroy
UIPveActTaskItem.ComponentDefine = ComponentDefine
UIPveActTaskItem.ComponentDestroy = ComponentDestroy
UIPveActTaskItem.DataDefine = DataDefine
UIPveActTaskItem.DataDestroy = DataDestroy
UIPveActTaskItem.OnEnable = OnEnable
UIPveActTaskItem.OnDisable = OnDisable
UIPveActTaskItem.SetData = SetData
UIPveActTaskItem.OnBgClick = OnBgClick
return UIPveActTaskItem
