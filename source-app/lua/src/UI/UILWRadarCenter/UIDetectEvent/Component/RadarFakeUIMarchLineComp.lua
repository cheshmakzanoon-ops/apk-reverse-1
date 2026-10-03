local slider_path = "p_comp_ui_march_slider"
local effect_root_path = "p_comp_ui_march_slider/p_trans_ui_march_effect_root"
local prefab_path = "Assets/Main/Prefabs/UI/UILWRadarCenter/Eff_ui_radar_line.prefab"
local base = UIBaseContainer
local RadarFakeUIMarchLineComp = BaseClass("RadarFakeUIMarchLineComp", UIBaseContainer)

function RadarFakeUIMarchLineComp:ComponentDefine()
  self.slider = self:AddComponent(UISlider, slider_path)
  self.effect_root = self:AddComponent(UIBaseContainer, effect_root_path)
end

function RadarFakeUIMarchLineComp:ComponentDestroy()
  self.slider = nil
  self.effect_root = nil
end

function RadarFakeUIMarchLineComp:DataDefine()
  self.TickAct = false
end

function RadarFakeUIMarchLineComp:DataDestroy()
  self.TickAct = false
  self.Data = nil
end

function RadarFakeUIMarchLineComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RadarFakeUIMarchLineComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RadarFakeUIMarchLineComp:OnAddListener()
  base.OnAddListener(self)
end

function RadarFakeUIMarchLineComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RadarFakeUIMarchLineComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function RadarFakeUIMarchLineComp:InitData(data)
  if data ~= nil then
    self.Data = data
    self.TickAct = self:InRange()
    return true
  end
  return false
end

function RadarFakeUIMarchLineComp:InitUi()
  local state = self.Data.EventData.state
  if state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH or state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD then
    local item = self.view:GetEventPointByUuid(self.Data.EventData.uuid)
    if item ~= nil then
      local endPos = item:GetAnchoredPosition()
      local scale = CommonUtil.ArabicAutoMirrorFactor()
      local startPos = self.view:GetSelfPos()
      startPos.x = startPos.x * scale
      local endPosFixed = Vector2.New(endPos.x * scale, endPos.y - 50)
      local deltaDirection = endPosFixed - startPos
      local zeroDirection = Vector2.New(1, 0)
      local angle = Vector2.Angle(zeroDirection, deltaDirection)
      angle = angle * (deltaDirection.y >= 0 and 1 or -1)
      if self.slider then
        self.slider:SetActive(true)
        self.slider.rectTransform:Set_anchoredPosition(startPos.x, startPos.y)
        self.slider.transform:Set_localEulerAngles(0, 0, angle)
        local sizeX = Vector2.Magnitude(deltaDirection)
        self.slider:SetSizeDeltaXY(sizeX * 2, 60)
      end
      self:Update()
    end
  else
    self.slider:SetActive(false)
  end
end

function RadarFakeUIMarchLineComp:Clear()
end

function RadarFakeUIMarchLineComp:InRange()
  if self.Data == nil then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.Data.StartTime and curTime < self.Data.EndTime then
    return true
  end
  return false
end

function RadarFakeUIMarchLineComp:Update()
  if not self.TickAct then
    return
  end
  if self:InRange() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local progress = Mathf.Clamp01((curTime - self.Data.StartTime) / (self.Data.EndTime - self.Data.StartTime))
    if self.slider ~= nil then
      self.slider:SetValue(progress)
    end
  else
    self.TickAct = false
    if self.view ~= nil then
      local item = self.view:GetEventPointByUuid(self.Data.EventData.uuid)
      if item ~= nil then
        item:PlayVfx()
      end
    end
    if self.slider ~= nil then
      self.slider:SetActive(false)
    end
  end
end

return RadarFakeUIMarchLineComp
