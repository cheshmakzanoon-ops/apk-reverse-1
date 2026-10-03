local InvasionSummonProgressItemBase = BaseClass("InvasionSummonProgressItemBase", UIBaseContainer)
local base = UIBaseContainer
local math_floor = math.floor
local tostring = _ENV.tostring
local DOTween = _ENV.DOTween
local monsterHeadPath = "Assets/Main/Sprites/UI/UIMonsterInvasion/%s.png"
local progress_slider_path = "Bg/ProgressSlider"
local progress_text_group_path = "Bg/ProgressSlider/ProgressTextGroup"
local cur_progress_text_path = "Bg/ProgressSlider/ProgressTextGroup/CurProgressText"
local max_progress_text_path = "Bg/ProgressSlider/ProgressTextGroup/MaxProgressText"
local bg_path = "Bg"
local localDuration = 1

local function OnCreate(self)
  base.OnCreate(self)
  self:CommonComponentDefine()
  self:CommonDataDefine()
end

local function OnDestroy(self)
  self:CommonComponentDestroy()
  self:CommonDataDestroy()
  base.OnDestroy(self)
end

local function CommonComponentDefine(self)
  self:ComponentDefine()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(BindCallback(self, self.OnItemClick))
  self.progress_slider = self:AddComponent(UISlider, progress_slider_path)
  self.progress_text_group = self:AddComponent(UIBaseContainer, progress_text_group_path)
  self.cur_progress_text = self:AddComponent(UITextMeshProUGUIEx, cur_progress_text_path)
  self.max_progress_text = self:AddComponent(UITextMeshProUGUIEx, max_progress_text_path)
end

local function ComponentDefine(self)
end

local function CommonComponentDestroy(self)
  self:RemoveListeners()
  self:ComponentDestroy()
  self.bg = nil
  self.progress_slider = nil
  self.progress_text_group = nil
  self.cur_progress_text = nil
  self.max_progress_text = nil
end

local function ComponentDestroy(self)
end

local function CommonDataDefine(self)
  self:AddListeners()
  self.progress = 0
  local _, summon_score = DataCenter.ActivityMonsterInvasionDataManager:GetInvasionSummonProgress()
  self.summon_score = summon_score
  if self.summon_score == nil or 0 >= self.summon_score then
    self.bg:SetActive(false)
  else
    self.bg:SetActive(true)
  end
  self.seq = nil
  self.curNum = nil
  self:DataDefine()
end

local function DataDefine(self)
end

local function CommonDataDestroy(self)
  self.progress = nil
  self.summon_score = nil
  self:StopTween()
  self.curNum = nil
  self:DataDestroy()
end

local function DataDestroy(self)
end

local function AddListeners(self)
end

local function RemoveListeners(self)
end

local function ReInit(self, progress)
end

local function OnItemClick(self)
end

local function UpdateProgress(self)
  if self.progress and self.summon_score and self.progress <= self.summon_score then
    self.progress_slider:SetValue(self.progress / self.summon_score)
    self.cur_progress_text:SetText(tostring(self.progress))
    self.max_progress_text:SetText(tostring(self.summon_score))
  end
end

local function DisplayProgressTween(self, targetVal)
end

local function OnTweenFinished(self)
end

local function InitHeadIcon(self, icons, index)
  if icons then
    local len = #icons
    index = index or 1
    if len >= index then
      self.monster_head:LoadSprite(string.format(monsterHeadPath, icons[index]))
    end
  end
end

local function DoProgressTween(self, curVal, targetVal, duration)
  if curVal and targetVal and curVal < targetVal then
    duration = duration or localDuration
    self:StopTween()
    self.curNum = curVal
    self.seq = DOTween.Sequence()
    self.seq:Append(0, DOTween.To(function(x)
      self.curNum = math_floor(x + 0.5)
      self.cur_progress_text:SetText(tostring(self.curNum))
    end, curVal, targetVal, duration * 0.6))
    self.seq:Insert(0, self.progress_slider:DOValue(targetVal / self.summon_score, duration))
    self.seq:AppendCallback(function()
      self.curNum = targetVal
      self.cur_progress_text:SetText(tostring(self.curNum))
      self:OnTweenFinished()
    end)
  end
end

local function StopTween(self)
  if self.seq ~= nil then
    self.seq:Kill()
    self.seq = nil
  end
end

InvasionSummonProgressItemBase.OnCreate = OnCreate
InvasionSummonProgressItemBase.OnDestroy = OnDestroy
InvasionSummonProgressItemBase.CommonComponentDefine = CommonComponentDefine
InvasionSummonProgressItemBase.ComponentDefine = ComponentDefine
InvasionSummonProgressItemBase.CommonComponentDestroy = CommonComponentDestroy
InvasionSummonProgressItemBase.ComponentDestroy = ComponentDestroy
InvasionSummonProgressItemBase.CommonDataDefine = CommonDataDefine
InvasionSummonProgressItemBase.DataDefine = DataDefine
InvasionSummonProgressItemBase.CommonDataDestroy = CommonDataDestroy
InvasionSummonProgressItemBase.DataDestroy = DataDestroy
InvasionSummonProgressItemBase.AddListeners = AddListeners
InvasionSummonProgressItemBase.RemoveListeners = RemoveListeners
InvasionSummonProgressItemBase.ReInit = ReInit
InvasionSummonProgressItemBase.OnItemClick = OnItemClick
InvasionSummonProgressItemBase.UpdateProgress = UpdateProgress
InvasionSummonProgressItemBase.OnTweenFinished = OnTweenFinished
InvasionSummonProgressItemBase.DisplayProgressTween = DisplayProgressTween
InvasionSummonProgressItemBase.InitHeadIcon = InitHeadIcon
InvasionSummonProgressItemBase.DoProgressTween = DoProgressTween
InvasionSummonProgressItemBase.StopTween = StopTween
return InvasionSummonProgressItemBase
