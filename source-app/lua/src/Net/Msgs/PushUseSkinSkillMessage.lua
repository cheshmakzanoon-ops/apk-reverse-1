local PushUseSkinSkillMessage = BaseClass("PushUseSkinSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local skillId = t.skillId
  local pointId = t.pointId
  local castUid = t.castUid
  local worldId = t.worldId
  local serverId = t.serverId
  local worldType = t.worldType
  local curServerId = serverId or LuaEntry.Player:GetCrossServerId()
  local curWorldId = LuaEntry.Player:GetCurWorldId()
  if skillId and 0 < skillId and worldId == curWorldId then
    local skillTemp = DataCenter.DecorationSkillTemplateManager:GetTemplate(skillId)
    if skillTemp then
      do
        local curScene = CS.SceneManager.CurrSceneID
        if 0 < pointId then
          if curScene == SceneManagerSceneID.World then
            self:ShowEffect(pointId, skillTemp, castUid, curServerId, curWorldId, worldType)
          elseif curScene == SceneManagerSceneID.City then
            SceneUtils.ChangeToWorld(function()
              self:ShowEffect(pointId, skillTemp, castUid, curServerId, curWorldId, worldType)
            end)
          end
        end
      end
    end
  end
end

function PushUseSkinSkillMessage:ShowEffect(pointId, skillTemp, castUid, curServerId, curWorldId, worldType)
  local world = CS.SceneManager.World
  local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, curServerId)
  local effectPathList = skillTemp:GetSkillEffectList()
  if not table.IsNullOrEmpty(effectPathList) then
    for i, effect in ipairs(effectPathList) do
      world:CreateBattleVFX(effect[1], effect[2] or 5, function(go)
        go.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
        local showScale = 1
        go.transform:Set_localScale(showScale, showScale, showScale)
        go:SetActive(false)
        go:SetActive(true)
      end)
    end
  end
  if LuaEntry.Player.uid == castUid then
    local zoomVal = skillTemp and skillTemp.camera_height or CS.SceneManager.World.InitZoom
    if BattleFieldUtil.InBattleField() then
      GoToUtil.GotoDragonPos(worldPos, zoomVal, 0.02, function()
      end, curServerId, curWorldId, worldType)
    else
      GoToUtil.GotoWorldPos(worldPos, zoomVal, 0.1)
    end
  end
end

local function GetTestData(self, uid, skillId, pointId)
  local t = {
    castUid = uid or LuaEntry.Player.uid,
    pointId = pointId or LuaEntry.Player.world_main_pos or 495011,
    serverId = LuaEntry.Player.serverId,
    skillId = skillId or 10001,
    worldId = 0
  }
  return t
end

PushUseSkinSkillMessage.GetTestData = GetTestData
PushUseSkinSkillMessage.OnCreate = OnCreate
PushUseSkinSkillMessage.HandleMessage = HandleMessage
return PushUseSkinSkillMessage
