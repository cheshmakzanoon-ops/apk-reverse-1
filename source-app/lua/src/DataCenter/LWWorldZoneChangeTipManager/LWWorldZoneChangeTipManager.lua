local LWWorldZoneChangeTipManager = BaseClass("LWWorldZoneChangeTipManager")

function LWWorldZoneChangeTipManager:__init()
  function self.timer_action(tmp)
    self:RefreshZoneChange()
  end
  
  self.ShowLodMin = 1
  self.ShowLodMax = 5
  self.lastZone = nil
  
  function self.ChangeCameraLodSignal(lod)
    self:OnLodChanged(lod)
  end
  
  self:AddListener()
end

function LWWorldZoneChangeTipManager:__delete()
  self:RemoveListener()
end

function LWWorldZoneChangeTipManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

function LWWorldZoneChangeTipManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

function LWWorldZoneChangeTipManager:Startup()
end

function LWWorldZoneChangeTipManager:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

function LWWorldZoneChangeTipManager:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  self.lastZone = nil
  self:TryCloseWindow()
end

function LWWorldZoneChangeTipManager:OnLodChanged(lod)
  if lod < self.ShowLodMin or lod > self.ShowLodMax then
    self:TryCloseWindow()
    return
  end
end

function LWWorldZoneChangeTipManager:RefreshZoneChange()
  if BattleFieldUtil.InBattleField() then
    return
  end
  local worldId = LuaEntry.Player:GetCurWorldId()
  if worldId ~= 0 then
    return
  end
  local zone = CS.SceneManager.GetCurZoneId()
  if zone == self.lastZone then
    return
  end
  self.lastZone = zone
  EventManager:GetInstance():Broadcast(EventId.WorldZoneTipChanged, tostring(zone))
  local lod = toInt(DisplaySettings.currentLod)
  if lod < self.ShowLodMin or lod > self.ShowLodMax then
    return
  end
  if zone == 0 then
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldZoneChangeTip) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldZoneChangeTip, {anim = true}, tostring(zone))
  end
end

function LWWorldZoneChangeTipManager:TryCloseWindow()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldZoneChangeTip) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldZoneChangeTip, {anim = false})
  end
end

function LWWorldZoneChangeTipManager:ShowServerChangeTip(serverId)
  if BattleFieldUtil.InBattleField() then
    return
  end
  local worldId = LuaEntry.Player:GetCurWorldId()
  if worldId ~= 0 then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshKingInfo)
  local lod = toInt(DisplaySettings.currentLod)
  if lod <= self.ShowLodMax then
    return
  end
  self:TryCloseWindow()
  local info = SeasonUtil.GetSeasonInfo(serverId)
  if info ~= nil and info:GetServerSubdivisionType() == SeasonMapType.NineNationRainforest then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWWorldServerChangeTipS6) then
      local view = UIManager:GetInstance():GetWindow(UIWindowNames.UILWWorldServerChangeTipS6)
      if view and view.View then
        view.View:WorldZoneTipChanged(serverId)
      end
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldServerChangeTipS6, {anim = true}, serverId)
    end
  elseif UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldServerChangeTip) then
    local view = UIManager:GetInstance():GetWindow(UIWindowNames.UIWorldServerChangeTip)
    if view and view.View then
      view.View:WorldZoneTipChanged(serverId)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldServerChangeTip, {anim = true}, serverId)
  end
end

return LWWorldZoneChangeTipManager
