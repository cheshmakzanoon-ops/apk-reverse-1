local ShareExecute = {}
local Localization = CS.GameEntry.Localization

local function Execute_PointShare(t)
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  if t.x == nil or t.y == nil then
    return
  end
  local _x = tonumber(t.x) or 1
  local _y = tonumber(t.y) or 1
  local worldId = tonumber(t.worldId) or 0
  local serverId = tonumber(t.sid) or LuaEntry.Player:GetSelfServerId()
  local v2 = {}
  v2.x = _x
  v2.y = _y
  local pointId = SceneUtils.TilePosToIndex(v2, ForceChangeScene.World)
  local worldPos = SceneUtils.TileToWorld(v2, ForceChangeScene.World)
  if 0 < worldId then
    local worldType = tonumber(t.worldType) or 0
    if worldId == LuaEntry.Player:GetCurWorldId() then
      EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
      GoToUtil.GotoDragonPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      end, serverId, worldId, worldType)
    elseif 0 < LuaEntry.Player:GetCurWorldId() then
      UIUtil.ShowTipsId(458147)
    elseif BattleFieldUtil.TryEnterBattlefieldFromShare({
      worldId = worldId,
      worldType = worldType,
      pointId = pointId,
      serverId = serverId,
      allianceId = t.allianceId,
      actDragonGroup = t.actDragonGroup
    }) then
      EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
    end
  elseif 0 >= LuaEntry.Player:GetCurWorldId() then
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
    if not IsNull(CS.SceneManager.World) then
      GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        ShareExecute.GotoWorldPosCallback(SceneUtils.TilePosToIndex(v2))
      end, serverId)
    end
  elseif worldId == 0 and serverId == LuaEntry.Player:GetSelfServerId() then
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
    CrossServerUtil.OnBackSelfServerFromDragonWorld()
    SceneUtils.ChangeToWorld(function()
      GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      end, serverId, worldId)
    end)
  else
    UIUtil.ShowTipsId(458147)
  end
end

local function GotoWorldPosCallback(pointId)
end

local function Execute_StorageShopShare(t)
  if not SceneUtils.CheckCanGotoWorld(120018, false) then
    return
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
  local pointId = t.tradePoint
  local playerUid = t.uid
  if playerUid and tonumber(playerUid) > 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, playerUid)
  end
end

local function Execute_AllianceTaskShare(t)
  EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceTask)
end

local function Execute_AllianceInvite(t, chatData)
  local tid = t.aid
  local name = t.name or ""
  if t.aid == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, name, tid)
end

local function Execute_AllianceRankChange(t)
  return nil
end

local function Execute_March(t)
  RailwayUtil.JumpToTrainByMarchUuid(t.marchUuid, t.serverId, t.worldId)
end

local ExecuteTable = {
  [PostType.Text_PointShare] = Execute_PointShare,
  [PostType.Text_PointShare_Alliance] = Execute_PointShare,
  [PostType.Text_AllianceInvite] = Execute_AllianceInvite,
  [PostType.Text_AllianceRankChange] = Execute_AllianceRankChange,
  [PostType.Text_AllianceOfficialChange] = Execute_AllianceRankChange,
  [PostType.Text_StorageShopShare] = Execute_StorageShopShare,
  [PostType.Text_AllianceTaskShare] = Execute_AllianceTaskShare,
  [PostType.March] = Execute_March,
  [PostType.SuppliesPositionShare] = Execute_PointShare,
  [PostType.HELP_STOP_FIRE] = Execute_PointShare,
  [PostType.GHOST_RECON_SHARE_POINT] = Execute_PointShare,
  [PostType.MIGRATE_INVITE] = Execute_AllianceInvite,
  [PostType.INVASION_BOSS_SHARE] = Execute_PointShare
}

function ShareExecute.Execute(chatData, t)
  local f = ExecuteTable[chatData.post]
  if f and t then
    f(t, chatData)
  else
    ChatPrint("share execute not found! type : " .. tostring(post))
  end
end

ShareExecute.GotoWorldPosCallback = GotoWorldPosCallback
return ShareExecute
