local base = UIBaseContainer
local ParkourWinTypeSliderRender = BaseClass("ParkourWinTypeSliderRender", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("Scene.LWBattle.Const")
local text_path = "Slider/FillArea/Text"
local slider_path = "Slider"

function ParkourWinTypeSliderRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ParkourWinTypeSliderRender:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ParkourWinTypeSliderRender:ComponentDefine()
  self.slider = self:AddComponent(UISlider, slider_path)
  self.sliderText = self:AddComponent(UITextMeshProUGUIEx, text_path)
end

function ParkourWinTypeSliderRender:ComponentDestroy()
  self.slider = nil
  self.sliderText = nil
end

function ParkourWinTypeSliderRender:DataDefine()
  self.punchOK = 0
end

function ParkourWinTypeSliderRender:DataDestroy()
  self.winType = nil
  self.winType2Index = nil
  self.punchOK = 0
  if IsNotNull(self.winConditionTextTweener) then
    self.winConditionTextTweener:Kill()
  end
  self.winConditionTextTweener = nil
end

function ParkourWinTypeSliderRender:GetType()
  return self.winType
end

function ParkourWinTypeSliderRender:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ParkourWinConditionRefresh, self.UpdateWinConditionBar)
end

function ParkourWinTypeSliderRender:OnRemoveListener()
  self:RemoveUIListener(EventId.ParkourWinConditionRefresh, self.UpdateWinConditionBar)
  base.OnRemoveListener(self)
end

function ParkourWinTypeSliderRender:InitData(winType, winType2Index)
  self.winType = winType
  self.winType2Index = winType2Index or 1
  self:UpdateWinConditionBar(winType)
end

function ParkourWinTypeSliderRender:UpdateWinConditionBar(winType)
  if self.winType ~= winType then
    return
  end
  local battleMgr = DataCenter.LWBattleManager.logic
  local winCondition = DataCenter.LWBattleManager.logic:GetWinConditionDataByWinType(winType)
  if winCondition == nil then
    return
  end
  local slideValue = 0
  local slideText = ""
  local punch = false
  if winType == Const.ParkourWinType.KillTargetMonster then
    local needKillTarget = winCondition.needKillTarget
    local curValue = 0
    local needValue = 0
    for k, v in pairs(needKillTarget) do
      curValue = curValue + v.finish
      needValue = needValue + v.need
    end
    slideValue = math.max(0, needValue - curValue) / needValue
    slideText = string.format("%d", math.max(0, needValue - curValue))
    punch = true
  elseif winType == Const.ParkourWinType.KillMonster then
    local curValue = battleMgr.killNum
    local needValue = winCondition.needKillNum
    slideValue = math.max(0, needValue - curValue) / needValue
    slideText = string.format("%d", math.max(0, needValue - curValue))
    punch = true
  elseif winType == Const.ParkourWinType.SaveWorker then
    local curValue = battleMgr.saveNum
    local needValue = winCondition.needSaveNum
    slideValue = curValue / needValue
    slideText = string.format("%d", math.min(curValue, needValue))
    punch = true
  elseif winType == Const.ParkourWinType.FinishPoint then
    local finalPos = battleMgr.data.endLine
    local startPos = 0
    local curPos = battleMgr.team:GetPositionZ()
    slideValue = (curPos - startPos) / (finalPos - startPos)
    local remain = math.floor(finalPos - curPos)
    remain = remain < 0 and 0 or remain
    slideText = string.format("%d m", remain)
  elseif winType == Const.ParkourWinType.Time then
    local curValue = battleMgr.useTime or 0
    local needValue = winCondition.needTime or 1
    slideValue = (needValue - curValue) / needValue
    slideText = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(needValue - curValue)
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

return ParkourWinTypeSliderRender
