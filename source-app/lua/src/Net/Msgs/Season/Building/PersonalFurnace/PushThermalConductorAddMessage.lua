local PushThermalConductorAddMessage = BaseClass("PushThermalConductorAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushThermalConductorAddMessage:OnCreate()
  base.OnCreate(self)
end

function PushThermalConductorAddMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  local theWorld = CS.SceneManager.World
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if theWorld == nil then
    return
  end
  local buildInfo = theWorld:GetPointInfo(t.pointId)
  local add = toInt(t.add)
  local isSelf = buildInfo and buildInfo.playerName == LuaEntry.Player.name
  local hasPlot = false
  if buildInfo and buildInfo.pointType == CS.WorldPointType.PlayerBuilding then
    hasPlot = DataCenter.ThermalConductorTemplateManager:ShowPlot(t, buildInfo)
  end
  if hasPlot or not isSelf then
    local text = CS.GameEntry.Localization:GetString("season_s2_common_temperature", 0 < add and "+" .. add or add)
    local color = 0 < add and UIUtil.HexToColor32("fd7442") or UIUtil.HexToColor32("5CB4FF")
    UIUtil.ShowBuildingPopText(t.pointId, text, 4, color)
    local obj = CS.SceneManager.World:GetObjectByPoint(t.pointId)
    if obj ~= nil then
      local gameObject = obj:GetGameObject()
      if gameObject ~= nil then
        local tempObj = gameObject.transform:Find("ModelGo/TemperatureLabel(Clone)")
        local trans = tempObj and tempObj.transform
        if tempObj ~= nil then
          DOTween.Sequence():Append(trans:DOScale(Vector3.New(1.6, 1.6, 1), 0.1)):AppendInterval(0.1):Append(trans:DOScale(ResetScale, 0.3))
        end
      end
    end
  end
end

return PushThermalConductorAddMessage
