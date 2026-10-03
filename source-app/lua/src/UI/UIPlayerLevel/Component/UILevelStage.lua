local UILevelStage = BaseClass("UILevelStage", UIBaseContainer)
local base = UIBaseContainer
local LevelManager = DataCenter.PlayerLevelManager
local this_path = ""
local slider_path = "Slider"
local bubble_path = "Bubble"
local box_path = "Bubble/Box"
local check_path = "Bubble/Check"
local info_path = "Bubble/Info"
local red_path = "Bubble/Red"
local red_text_path = "Bubble/Red/RedText"
local lock_path = "Bubble/Lock"
local career_lv_path = "Bubble/CareerLv"
local exp_path = "LevelBg/Exp"
local level_path = "LevelBg/Level"
local max_level_path = "MaxLevelBg/MaxLevel"
local cur_path = "Cur"
local cur_exp_path = "Cur/CurExp"
local CurOffset = Vector2.New(-70, -71.9)
local WhiteBgPath = string.format(LoadPath.UIPlayerLevel, "UIPlayerLevel_img_bubble_1")
local YellowBgPath = string.format(LoadPath.UIPlayerLevel, "UIPlayerLevel_img_bubble_2")

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
  self.canvas_group = self:AddComponent(UICanvasGroup, this_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.bubble_btn = self:AddComponent(UIButton, bubble_path)
  self.bubble_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.box_btn = self:AddComponent(UIButton, box_path)
  self.check_go = self:AddComponent(UIBaseContainer, check_path)
  self.info_btn = self:AddComponent(UIButton, info_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.red_go = self:AddComponent(UIBaseContainer, red_path)
  self.red_text = self:AddComponent(UIText, red_text_path)
  self.lock_go = self:AddComponent(UIBaseContainer, lock_path)
  self.exp_text = self:AddComponent(UIText, exp_path)
  self.level_text = self:AddComponent(UIText, level_path)
  self.max_level_text = self:AddComponent(UIText, max_level_path)
  self.cur_go = self:AddComponent(UIBaseContainer, cur_path)
  self.cur_exp_text = self:AddComponent(UIText, cur_exp_path)
  self.career_lv_text = self:AddComponent(UIText, career_lv_path)
end

local function ComponentDestroy(self)
  self.canvas_group = nil
  self.slider = nil
  self.bubble_btn = nil
  self.box_btn = nil
  self.check_go = nil
  self.info_btn = nil
  self.red_go = nil
  self.red_text = nil
  self.lock_go = nil
  self.exp_text = nil
  self.level_text = nil
  self.max_level_text = nil
  self.cur_go = nil
  self.cur_exp_text = nil
  self.career_lv_text = nil
end

local function DataDefine(self)
  self.level = 0
  self.onInfoClick = nil
end

local function DataDestroy(self)
  self.level = nil
  self.onInfoClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetLevel(self, level)
  self.level = level
  local template = LevelManager:GetTemplate(level)
  if template == nil then
    self.canvas_group:SetAlpha(0)
    return
  end
  self.canvas_group:SetAlpha(1)
  local playerLevel = LevelManager:GetLevel()
  local received = LevelManager:HasReceivedLevelReward(level)
  if level ~= LevelManager:GetMaxLevel() then
    self.slider:SetActive(true)
    if level > playerLevel then
      self.slider:SetValue(0)
      self.cur_go:SetActive(false)
    elseif level < playerLevel then
      self.slider:SetValue(1)
      self.cur_go:SetActive(false)
    else
      local percent = LevelManager:GetLevelPercent()
      local sliderWidth = self.slider:GetSizeDelta().x
      self.slider:SetValue(percent)
      self.cur_go:SetActive(true)
      self.cur_go:SetAnchoredPosition(Vector2.New(percent * sliderWidth, 0) + CurOffset)
    end
  else
    self.slider:SetActive(false)
    self.cur_go:SetActive(false)
  end
  if LevelManager:HasContent(level) then
    self.bubble_btn:SetActive(true)
    self.check_go:SetActive(received)
    if DataCenter.PlayerCareerManager:EnabledShow() and template.unlockCareerLv then
      self.career_lv_text:SetActive(true)
      self.career_lv_text:SetText(NumToRoman(template.unlockCareerLv))
    else
      self.career_lv_text:SetActive(false)
    end
    self.box_btn:LoadSprite(LevelManager:GetIcon(level))
    self.box_btn:SetNativeSize()
    local size = self.box_btn:GetSizeDelta()
    size.y = size.y / size.x * 100
    size.x = 100
    self.box_btn:SetSizeDelta(size)
    if level > playerLevel then
      self.lock_go:SetActive(true)
      self.red_go:SetActive(false)
      self.check_go:SetActive(false)
      self.bubble_btn:LoadSprite(WhiteBgPath)
      self.bubble_btn:SetInteractable(true)
      self.box_btn:SetOnClick(function()
        self:OnInfoClick()
      end)
    elseif not received then
      self.lock_go:SetActive(false)
      self.red_go:SetActive(true)
      self.check_go:SetActive(false)
      self.bubble_btn:LoadSprite(YellowBgPath)
      self.bubble_btn:SetInteractable(false)
      self.box_btn:SetOnClick(function()
        self:OnBoxClick()
      end)
    else
      self.lock_go:SetActive(false)
      self.red_go:SetActive(false)
      self.check_go:SetActive(true)
      self.bubble_btn:LoadSprite(WhiteBgPath)
      self.bubble_btn:SetInteractable(false)
      self.box_btn:SetOnClick(function()
        self:OnInfoClick()
      end)
    end
  else
    self.bubble_btn:SetActive(false)
  end
  self.exp_text:SetText(string.GetFormattedSeperatorNum(template.totalExp))
  self.level_text:SetText(level)
  self.cur_exp_text:SetText(string.GetFormattedSeperatorNum(LevelManager:GetTotalExp()))
end

local function OnBoxClick(self)
  SFSNetwork.SendMessage(MsgDefines.PlayerReceiveLevelRewardMessage, self.level)
end

local function OnInfoClick(self)
  if self.onInfoClick then
    self:onInfoClick()
  end
end

UILevelStage.OnCreate = OnCreate
UILevelStage.OnDestroy = OnDestroy
UILevelStage.ComponentDefine = ComponentDefine
UILevelStage.ComponentDestroy = ComponentDestroy
UILevelStage.DataDefine = DataDefine
UILevelStage.DataDestroy = DataDestroy
UILevelStage.OnAddListener = OnAddListener
UILevelStage.OnRemoveListener = OnRemoveListener
UILevelStage.OnEnable = OnEnable
UILevelStage.OnDisable = OnDisable
UILevelStage.Data = Data
UILevelStage.SetLevel = SetLevel
UILevelStage.OnBoxClick = OnBoxClick
UILevelStage.OnInfoClick = OnInfoClick
return UILevelStage
