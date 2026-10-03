local PlotBuildBubble = BaseClass("PlotBuildBubble")

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  function self.timer_action()
    self:Update()
  end
  
  self:AddTimer()
  self.tipTxt = self.transform:Find("ArrowTip/nameBg/name"):GetComponent(typeof(CS.SuperTextMesh))
end

local function ComponentDestroy(self)
  self:DeleteTimer()
end

local function DataDefine(self)
  self.param = nil
  self.curPosition = nil
end

local function DataDestroy(self)
  self.param = nil
  self.curPosition = nil
end

local function ReInit(self, param, bUuid)
  self.param = param
  self.bUuid = bUuid
  self.plotIndex = 1
  self.plotData = {}
  local plotId = self.param * 100 + self.plotIndex
  local miss = false
  while not miss do
    local plot = LocalController.instance():getLine(TableName.LW_Plot, plotId)
    if plot == nil then
      miss = true
    else
      table.insert(self.plotData, plot)
    end
    plotId = plotId + 1
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.plotTime = curTime
  self:ShowPanel()
end

local function ShowPanel(self)
  if self.plotData[self.plotIndex] ~= nil then
    self.tipTxt.text = CS.GameEntry.Localization:GetString(self.plotData[self.plotIndex].content)
  end
end

local function Update(self)
  if self.param == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local nextTime = 800
  if curTime > self.plotTime + nextTime then
    self.plotIndex = self.plotIndex + 1
    self.plotTime = curTime
    if self.plotData[self.plotIndex] ~= nil then
      self:ShowPanel()
    else
      EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubbleRefresh, self.bUuid)
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function OnLodChange(self, lod)
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(lod < 3)
  end
end

PlotBuildBubble.OnCreate = OnCreate
PlotBuildBubble.OnDestroy = OnDestroy
PlotBuildBubble.ComponentDefine = ComponentDefine
PlotBuildBubble.ComponentDestroy = ComponentDestroy
PlotBuildBubble.DataDefine = DataDefine
PlotBuildBubble.DataDestroy = DataDestroy
PlotBuildBubble.ReInit = ReInit
PlotBuildBubble.ShowPanel = ShowPanel
PlotBuildBubble.Update = Update
PlotBuildBubble.DeleteTimer = DeleteTimer
PlotBuildBubble.AddTimer = AddTimer
PlotBuildBubble.OnLodChange = OnLodChange
return PlotBuildBubble
