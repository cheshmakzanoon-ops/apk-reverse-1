local UITroopSkillItem = BaseClass("UITroopSkillItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local icon_path = "Icon"
local circle_path = "Icon/Circle"
local time_path = "Time"
local glow_path = "Glow"
local ICON_WIDTH = 70

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
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.circle_image = self:AddComponent(UIImage, circle_path)
  self.time_text = self:AddComponent(UIText, time_path)
  self.glow_go = self:AddComponent(UIBaseContainer, glow_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.icon_image = nil
  self.circle_image = nil
  self.time_text = nil
  self.glow_go = nil
end

local function DataDefine(self)
  self.state = CareerSkillState.Unknown
  self.skill = nil
  self.totalCdTime = 0
  self.isGlowing = false
  self.timer = nil
end

local function DataDestroy(self)
  self.state = nil
  self.skill = nil
  self.totalCdTime = nil
  self.isGlowing = nil
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
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

local function SetData(self, skill)
  self.skill = skill
  local template = DataCenter.PlayerCareerManager:GetCareerEffectTemplate(skill.id)
  self.totalCdTime = template.cdTime * 1000
  self.icon_image:LoadSprite(template:GetIconPath())
  self.icon_image:SetNativeSize()
  local size = self.icon_image.rectTransform.sizeDelta
  size.y = size.y / size.x * ICON_WIDTH
  size.x = ICON_WIDTH
  self.icon_image.rectTransform.sizeDelta = size
  if self.timer then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():GetTimer(0.5, self.RefreshTime, self, false, false, false)
  self.timer:Start()
  self:RefreshTime()
end

local function RefreshTime(self)
  if self.time_text then
    local curTime = math.ceil(UITimeManager:GetInstance():GetServerTime())
    local usingTime = math.max(self.skill.time - curTime, 0)
    local usedTime = math.max(self.skill.cdTime - curTime, 0)
    if 0 < usingTime then
      self.state = CareerSkillState.Using
      local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(usingTime)
      self.time_text:SetText(restTimeStr)
      self.circle_image:SetFillAmount(0)
      self:ShowGlow(true)
    elseif 0 < usedTime then
      self.state = CareerSkillState.Used
      local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(usedTime)
      self.time_text:SetText(restTimeStr)
      self.circle_image:SetFillAmount(usedTime / self.totalCdTime)
      self:ShowGlow(false)
    else
      self.state = CareerSkillState.Ready
      self.time_text:SetText("")
      self.circle_image:SetFillAmount(0)
      self:ShowGlow(false)
    end
  end
end

local function ShowGlow(self, show)
  if self.isGlowing ~= show then
    self.glow_go:SetActive(show)
    self.isGlowing = show
  end
end

local function OnClick(self)
  if self.skill.type == CareerSkillType.AdmiralTroopSkill then
    local template = DataCenter.PlayerCareerManager:GetCareerEffectTemplate(self.skill.id)
    local name, desc = DataCenter.PlayerCareerManager:GetEffectTip(self.skill.id)
    if self.state == CareerSkillState.Ready then
      UIUtil.ShowMessage(desc, 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, nil, function()
        DataCenter.PlayerCareerManager:UseSkill(self.skill.id)
      end, nil, template.name)
    else
      local param = {}
      param.type = "desc"
      param.title = name
      param.desc = desc
      param.alignObject = self.btn
      if self.state == CareerSkillState.Using then
        param.desc = param.desc .. [[


]] .. Localization:GetString("129001")
      elseif self.state == CareerSkillState.Used then
        param.desc = param.desc .. [[


]] .. Localization:GetString("100381")
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end
end

UITroopSkillItem.OnCreate = OnCreate
UITroopSkillItem.OnDestroy = OnDestroy
UITroopSkillItem.ComponentDefine = ComponentDefine
UITroopSkillItem.ComponentDestroy = ComponentDestroy
UITroopSkillItem.DataDefine = DataDefine
UITroopSkillItem.DataDestroy = DataDestroy
UITroopSkillItem.OnAddListener = OnAddListener
UITroopSkillItem.OnRemoveListener = OnRemoveListener
UITroopSkillItem.OnEnable = OnEnable
UITroopSkillItem.OnDisable = OnDisable
UITroopSkillItem.State = State
UITroopSkillItem.SetData = SetData
UITroopSkillItem.RefreshTime = RefreshTime
UITroopSkillItem.ShowGlow = ShowGlow
UITroopSkillItem.OnClick = OnClick
return UITroopSkillItem
