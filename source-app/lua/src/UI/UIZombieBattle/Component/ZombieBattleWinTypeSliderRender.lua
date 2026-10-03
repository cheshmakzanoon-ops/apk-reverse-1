local base = UIBaseContainer
local ZombieBattleWinTypeSliderRender = BaseClass("ZombieBattleWinTypeSliderRender", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("Scene.LWBattle.Const")
local text_path = "Slider/FillArea/Text"
local slider_path = "Slider"

function ZombieBattleWinTypeSliderRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ZombieBattleWinTypeSliderRender:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ZombieBattleWinTypeSliderRender:ComponentDefine()
  self.slider = self:AddComponent(UISlider, slider_path)
  self.sliderText = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.canvasGroup = self:TryAddComponent(UICanvasGroup, "")
end

function ZombieBattleWinTypeSliderRender:ComponentDestroy()
  self.slider = nil
  self.sliderText = nil
  self.canvasGroup = nil
end

function ZombieBattleWinTypeSliderRender:DataDefine()
  self.punchOK = 0
end

function ZombieBattleWinTypeSliderRender:DataDestroy()
  self.winType = nil
  self.winType2Index = nil
  self.punchOK = 0
  if IsNotNull(self.winConditionTextTweener) then
    self.winConditionTextTweener:Kill()
  end
  self.winConditionTextTweener = nil
end

function ZombieBattleWinTypeSliderRender:GetType()
  return self.winType
end

function ZombieBattleWinTypeSliderRender:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BarrageWinConditionRefresh, self.UpdateWinConditionBar)
end

function ZombieBattleWinTypeSliderRender:OnRemoveListener()
  self:RemoveUIListener(EventId.BarrageWinConditionRefresh, self.UpdateWinConditionBar)
  base.OnRemoveListener(self)
end

function ZombieBattleWinTypeSliderRender:InitData(winType, winType2Index)
  self.winType = winType
  self.winType2Index = winType2Index or 1
  self:UpdateWinConditionBar(winType)
end

function ZombieBattleWinTypeSliderRender:UpdateWinConditionBar(winType)
  if self.winType ~= winType then
    return
  end
  local battleMgr = DataCenter.ZombieBattleManager
  local slideValue = 0
  local slideText = ""
  local punch = false
  local alpha = 1
  if winType == Const.StageWinType.KillTargetMonster then
    local curValue = battleMgr.killTargetNum
    local needValue = battleMgr.pveTemplate.winCondition.needKillNum
    slideValue = math.max(0, needValue - curValue) / needValue
    slideText = string.format("%d", math.max(0, needValue - curValue))
    punch = true
  elseif winType == Const.StageWinType.KillMonster then
    local curValue = battleMgr.killNum
    local needValue = battleMgr.pveTemplate.winCondition.needKillNum
    slideValue = math.max(0, needValue - curValue) / needValue
    slideText = string.format("%d", math.max(0, needValue - curValue))
    punch = true
  elseif winType == Const.StageWinType.ClearLastTrigger then
    local isLastTrigger = battleMgr:IsFinalWayPoint()
    alpha = isLastTrigger and 1 or 0
    if isLastTrigger then
      local curValue = battleMgr.killTargetNum
      local needValue = battleMgr.finalTriggerLimit
      slideValue = curValue / needValue
      slideText = string.format("%d", math.min(curValue, needValue))
      punch = true
    end
  elseif winType == Const.StageWinType.WayPoint then
    if battleMgr.wayPoint then
      local finalPos = battleMgr.wayPoint[#battleMgr.wayPoint].pos
      local startPos = battleMgr.wayPoint[1].pos
      local curPos = battleMgr.squad:GetPosition()
      slideValue = (curPos.z - startPos.z) / (finalPos.z - startPos.z)
      local distanceZ = finalPos.z - curPos.z
      slideText = string.format("%d km", math.max(0, math.floor(distanceZ)))
    end
  elseif winType == Const.ParkourWinType.Time then
    local needValue = battleMgr.pveTemplate.winCondition.timeLimit
    local curValue = battleMgr.useTime
    slideValue = (needValue - curValue) / needValue
    slideText = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(needValue - curValue)
  end
  if self.canvasGroup then
    self.canvasGroup:SetAlpha(alpha)
  end
  self.slider:SetValue(Mathf.Clamp(slideValue, 0, 1))
  self.sliderText:SetText(slideText)
  if punch then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now > self.punchOK then
      self.punchOK = now + PUNCH_CD * 1000
      self.sliderText.transform:DOKill()
      self.sliderText.transform:Set_localScale(1, 1, 1)
      self.winConditionTextTweener = self.sliderText.transform:DOPunchScale(Vector3.New(1, 1, 1), PUNCH_CD, 1, 0.4)
    end
  end
end

return ZombieBattleWinTypeSliderRender
