local BloodyNightStageCell = BaseClass("BloodyNightStageCell", UIBaseContainer)
local base = UIBaseContainer
local localGrayColor = Color.New(0.12549019607843137, 0.12941176470588237, 0.1607843137254902, 255)
local localGreenColor = Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 255)

function BloodyNightStageCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function BloodyNightStageCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BloodyNightStageCell:ComponentDefine()
  self.partText = self:AddComponent(UITextMeshProUGUIEx, "BG/part")
  self.emptyText = self:AddComponent(UITextMeshProUGUIEx, "BG/empty")
  self.emptyText:SetLocalText("rescource_decoration_01")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "BG/title")
  self.infoText = self:AddComponent(UITextMeshProUGUIEx, "BG/ScrollView/Viewport/Content")
  self.timeText = self:AddComponent(UITextMeshProUGUIEx, "bottom/timeInfo/TimeBg/Time")
  self.bgImg = self:AddComponent(UIRawImage, "BG")
  self.timeIcon = self:AddComponent(UIImage, "bottom/timeInfo/TimeIconBg/TimeIcon")
  self.timeInfo = self:AddComponent(UIBaseContainer, "bottom/timeInfo")
  
  function self.timerAction()
    self:OnTimer()
  end
end

function BloodyNightStageCell:ComponentDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.titleText = nil
  self.infoText = nil
  self.timeText = nil
  self.bgImg = nil
  self.timeIcon = nil
  self.timeInfo = nil
  self.heroImg = nil
end

function BloodyNightStageCell:OnTimer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.curStageEndTime - curTime
  if 0 < time then
    self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
  else
    self.timer:Stop()
    self.timer = nil
    self:ReshfTime()
  end
end

function BloodyNightStageCell:DataDestroy()
  self.param = nil
end

function BloodyNightStageCell:SetData(stageTemp, curStageIndex, curStageEndTime)
  self.selfStageIndex = stageTemp.stage
  self.curStageIndex = curStageIndex
  self.curStageEndTime = curStageEndTime
  self.partText:SetText(CS.GameEntry.Localization:GetString("dominator_train_grade_view_2") .. " " .. stageTemp.stage)
  if self.selfStageIndex > self.curStageIndex then
    self.titleText:SetText("")
    self.infoText:SetText("")
    self.emptyText:SetActive(true)
  else
    self.titleText:SetLocalText(stageTemp.stage_name)
    self.infoText:SetLocalText(stageTemp.stage_desc)
    self.emptyText:SetActive(false)
  end
  self.bgImg:LoadSprite(stageTemp.stage_png)
  self:ReshfTime()
end

function BloodyNightStageCell:ReshfTime()
  if self.selfStageIndex < self.curStageIndex then
    self.timeText:SetLocalText(500411)
    self.timeText:SetColor(WhiteColor)
    self.timeIcon:SetColor(WhiteColor)
  elseif self.selfStageIndex > self.curStageIndex then
    self.timeText:SetLocalText(500412)
    self.timeText:SetColor(WhiteColor)
    self.timeIcon:SetColor(WhiteColor)
  else
    local now = UITimeManager:GetInstance():GetServerTime()
    local time = self.curStageEndTime - now
    self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timerAction, self, false, false, false)
    self.timer:Start()
    self.timeText:SetColor(localGreenColor)
    self.timeIcon:SetColor(localGreenColor)
  end
end

return BloodyNightStageCell
