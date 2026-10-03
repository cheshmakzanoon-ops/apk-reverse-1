local PVELevelTimeLimit = BaseClass("PVELevelTimeLimit", UIBaseContainer)
local base = UIBaseContainer
local used_desc_path = "UsedDesc"
local used_time_path = "UsedTime"
local total_time_path = "TotalTime"
local stars_path = "Stars"
local canvas_group_path = "Stars/S%s"
local star_path = "Stars/S%s/Star%s"
local time_path = "Stars/S%s/Time%s"
local flag_path = "Stars/S%s/Flag%s"
local STAR_COUNT = 3
local CHECK_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_duihao2"
local CROSS_PATH = "Assets/Main/Sprites/Guide/Common_cha2"

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
  self.used_desc_text = self:AddComponent(UIText, used_desc_path)
  self.used_desc_text:SetLocalText(400052)
  self.used_time_text = self:AddComponent(UIText, used_time_path)
  self.total_time_text = self:AddComponent(UIText, total_time_path)
  self.stars_go = self:AddComponent(UIBaseContainer, stars_path)
  self.canvas_groups = {}
  self.star_gos = {}
  self.time_texts = {}
  self.flag_images = {}
  for i = 1, STAR_COUNT do
    self.canvas_groups[i] = self:AddComponent(UICanvasGroup, string.format(canvas_group_path, i))
    self.star_gos[i] = self:AddComponent(UIBaseContainer, string.format(star_path, i, i))
    self.time_texts[i] = self:AddComponent(UIText, string.format(time_path, i, i))
    self.flag_images[i] = self:AddComponent(UIImage, string.format(flag_path, i, i))
  end
end

local function ComponentDestroy(self)
  self.used_desc_text = nil
  self.used_time_text = nil
  self.total_time_text = nil
  self.stars_go = nil
  self.canvas_groups = nil
  self.star_gos = nil
  self.time_texts = nil
  self.flag_images = nil
end

local function DataDefine(self)
  self.pveTemplate = nil
  self.usedTime = 0
  self.showStar = false
end

local function DataDestroy(self)
  self.pveTemplate = nil
  self.usedTime = nil
  self.showStar = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, levelId)
  self.pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(levelId)
  if not self.pveTemplate:IsTimeLimited() then
    return
  end
  self.used_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(0))
  self.showStar = self.pveTemplate:IsStarLevel()
  if self.showStar then
    self.stars_go:SetActive(true)
    self.total_time_text:SetActive(false)
    for i = 1, STAR_COUNT do
      local time = self.pveTemplate.timeLimitList[i] * 1000
      self.time_texts[i]:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(time))
      self.flag_images[i]:LoadSprite(CHECK_PATH)
      self.canvas_groups[i]:SetAlpha(1)
    end
  else
    self.stars_go:SetActive(false)
    self.total_time_text:SetActive(true)
    self.total_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(self.pveTemplate.timeLimitList[1] * 1000))
  end
end

local function SetUsedTime(self, usedTime)
  self.usedTime = usedTime
  self.used_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(usedTime))
  if self.showStar then
    for i = 1, STAR_COUNT do
      local time = self.pveTemplate.timeLimitList[i] * 1000
      if usedTime <= time then
        self.flag_images[i]:LoadSprite(CHECK_PATH)
        self.canvas_groups[i]:SetAlpha(1)
      else
        self.flag_images[i]:LoadSprite(CROSS_PATH)
        self.canvas_groups[i]:SetAlpha(0.7)
      end
    end
  end
end

PVELevelTimeLimit.OnCreate = OnCreate
PVELevelTimeLimit.OnDestroy = OnDestroy
PVELevelTimeLimit.ComponentDefine = ComponentDefine
PVELevelTimeLimit.ComponentDestroy = ComponentDestroy
PVELevelTimeLimit.DataDefine = DataDefine
PVELevelTimeLimit.DataDestroy = DataDestroy
PVELevelTimeLimit.OnEnable = OnEnable
PVELevelTimeLimit.OnDisable = OnDisable
PVELevelTimeLimit.OnAddListener = OnAddListener
PVELevelTimeLimit.OnRemoveListener = OnRemoveListener
PVELevelTimeLimit.ReInit = ReInit
PVELevelTimeLimit.SetUsedTime = SetUsedTime
return PVELevelTimeLimit
