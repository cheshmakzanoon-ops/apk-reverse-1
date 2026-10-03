local PushWorldMoveMessage = BaseClass("PushWorldMoveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local serverId = t.serverId
  local worldId = t.worldId
  local mainWorldPos = LuaEntry.Player:GetMainWorldPos()
  if t.reason == "VIRUS_EXPLODE" and 0 < mainWorldPos and SceneUtils.GetIsInWorld() and CS.SceneManager.World ~= nil then
    local effectPath = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_Common_duboom_002.prefab"
    CS.SceneManager.World:CreateBattleVFX(effectPath, 7, function(go)
      if SceneUtils.GetIsInWorld() and go ~= nil then
        local curServerId = serverId or LuaEntry.Player:GetCurServerId()
        go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        go.transform.position = SceneUtils.TileIndexToWorld(mainWorldPos, ForceChangeScene.World, curServerId)
        go.transform:Set_localScale(1, 1, 1)
        go:SetActive(true)
      end
    end)
    DataCenter.LWSoundManager:PlaySound(1000012, false)
    DataCenter.BuildManager:DelayWorldMoveHandle(t, 240, 2.5)
    return
  elseif (t.reason == "SummonSandworm" or t.reason == "CatchSandWorm") and 0 < mainWorldPos and CS.SceneManager.World ~= nil then
    local worldPos = SceneUtils.TileIndexToWorld(mainWorldPos, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(worldPos, 240, 0.2, nil, serverId)
    DataCenter.BuildManager:DelayWorldMoveHandle(t, 240, 5)
    return
  end
  DataCenter.BuildManager:WorldMvHandle(t, 240)
  EventManager:GetInstance():Broadcast(EventId.UpdatePlayerHeadIcon)
  if t ~= nil and t.reason == "LOCK_HART" then
    local jumpTimer = TimerManager:GetInstance():GetTimer(MOVE_CITY_EFFECT_DURATION, function()
      SFSNetwork.SendMessage(MsgDefines.SummonLockhartBoss, 0, false)
    end, nil, true, false, false)
    jumpTimer:Start()
  end
end

PushWorldMoveMessage.OnCreate = OnCreate
PushWorldMoveMessage.HandleMessage = HandleMessage
return PushWorldMoveMessage
