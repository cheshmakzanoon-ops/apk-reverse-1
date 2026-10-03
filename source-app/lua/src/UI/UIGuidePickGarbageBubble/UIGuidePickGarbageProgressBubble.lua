local UIGuidePickGarbageProgressBubble = BaseClass("UIGuidePickGarbageProgressBubble")
local timeText_path = "PosGo/TimeText"

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
  self:AddTimer()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  self:RemoveTimer()
end

local function ComponentDefine(self)
  self.ChangeSceneCircleSlider = self.transform:GetComponent(typeof(CS.ChangeSceneCircleSlider))
  self.timeText = self.transform:Find(timeText_path):GetComponent(typeof(CS.SuperTextMesh))
end

local function ComponentDestroy(self)
  self.ChangeSceneCircleSlider = nil
  self.timeText = nil
end

local function AddTimer(self)
  self:RemoveTimer()
  self.timer = TimerManager:GetInstance():GetTimer(1.0, self.RefreshTime, self, false, false, false)
  self.timer:Start()
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshTime(self)
  if self.timeText ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.endTime - now
    if self.lastTime ~= leftTime then
      self.lastTime = leftTime
      if leftTime <= 0 then
        self.timeText.text = UITimeManager:GetInstance():MilliSecondToFmtString(0)
      else
        self.timeText.text = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      end
    end
  end
end

local function ReInit(self, startTime, endTime, index)
  self.startTime = math.floor(startTime)
  self.endTime = math.ceil(endTime)
  self:ShowPanel(index)
end

local function ShowPanel(self, index)
  self:UpdatePosition(index)
  self:RefreshSliderInterVal()
  self:PlayAppearAnim()
  self:RefreshTime()
end

local function PlayAppearAnim(self)
end

local function RefreshSliderInterVal(self)
  if self.endTime ~= nil and self.startTime ~= nil then
    self.ChangeSceneCircleSlider:Init(self.startTime, self.endTime)
  end
end

local function PlayHideAnim(self)
end

local function UpdatePosition(self, index)
  if self.index ~= index then
    local worldPos = SceneUtils.TileIndexToWorld(index)
    self.transform.position = worldPos
    self.index = index
  end
end

UIGuidePickGarbageProgressBubble.OnCreate = OnCreate
UIGuidePickGarbageProgressBubble.OnDestroy = OnDestroy
UIGuidePickGarbageProgressBubble.ComponentDefine = ComponentDefine
UIGuidePickGarbageProgressBubble.ComponentDestroy = ComponentDestroy
UIGuidePickGarbageProgressBubble.DataDefine = DataDefine
UIGuidePickGarbageProgressBubble.DataDestroy = DataDestroy
UIGuidePickGarbageProgressBubble.ReInit = ReInit
UIGuidePickGarbageProgressBubble.ShowPanel = ShowPanel
UIGuidePickGarbageProgressBubble.UpdatePosition = UpdatePosition
UIGuidePickGarbageProgressBubble.PlayAppearAnim = PlayAppearAnim
UIGuidePickGarbageProgressBubble.RefreshSliderInterVal = RefreshSliderInterVal
UIGuidePickGarbageProgressBubble.PlayHideAnim = PlayHideAnim
UIGuidePickGarbageProgressBubble.AddTimer = AddTimer
UIGuidePickGarbageProgressBubble.RemoveTimer = RemoveTimer
UIGuidePickGarbageProgressBubble.RefreshTime = RefreshTime
return UIGuidePickGarbageProgressBubble
