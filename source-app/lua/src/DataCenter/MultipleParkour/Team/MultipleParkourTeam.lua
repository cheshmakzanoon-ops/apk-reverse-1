local MultipleParkourTeam = BaseClass("MultipleParkourTeam")
local MultipleParkourPlayer = require("DataCenter.MultipleParkour.Team.MultipleParkourPlayer")
local MultipleParkourTeamFormation = require("DataCenter.MultipleParkour.Team.MultipleParkourTeamFormation")
local GameObject = CS.UnityEngine.GameObject
local teamOffsetX = 2.5
local teamPadX = 2
local teamOffsetZ = 1.5
local teamCountX = 2
local Const = require("Scene.LWBattle.Const")

function MultipleParkourTeam:__init(x, z, mgr, teamPosCount)
  local go = GameObject("MultipleParkourTeam")
  self.gameObject = go
  self.transform = go.transform
  self.curPos = Vector3.New(x, 0, z)
  self.teamPosCount = teamPosCount
  self:SetPosition(x, z)
  self.mgr = mgr
  self.players = {}
  self.toRemovePlayers = {}
  self.myTeamId = 0
  self.rewardPos = nil
end

function MultipleParkourTeam:__delete()
  self:Destroy()
end

function MultipleParkourTeam:Destroy()
  for _, v in pairs(self.players) do
    v:Delete()
  end
  self.players = nil
  for _, v in pairs(self.toRemovePlayers) do
    v:Delete()
  end
  self.toRemovePlayers = nil
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
  if self.formationLeft then
    self.formationLeft:Delete()
    self.formationLeft = nil
  end
  if self.formationRight then
    self.formationRight:Delete()
    self.formationRight = nil
  end
  self.rewardPos = nil
end

function MultipleParkourTeam:InitData()
  self.formationRight = MultipleParkourTeamFormation.New(teamPadX, self.teamPosCount, false)
  local start = teamOffsetX * (teamCountX - 1) + teamPadX
  start = -start
  self.formationLeft = MultipleParkourTeamFormation.New(start, self.teamPosCount, true)
  self.formationLeft:Init(teamOffsetX, teamOffsetZ, teamCountX)
  self.formationRight:Init(teamOffsetX, teamOffsetZ, teamCountX)
end

function MultipleParkourTeam:SetMyTeamId(myTeamId)
  self.myTeamId = myTeamId
end

function MultipleParkourTeam:Load(PlayerDataMap)
  for _, v in pairs(PlayerDataMap) do
    local playerData = v
    local layout = playerData.select
    if layout == Const.MultipleParkourDoorLayout.Left then
      local pos = self.formationLeft:GetPos(playerData.teamIndex)
      local playerLeft = MultipleParkourPlayer.New(self.mgr, self, self.transform, pos, playerData)
      self.players[playerData.playerId] = playerLeft
    elseif layout == Const.MultipleParkourDoorLayout.Right then
      local pos = self.formationRight:GetPos(playerData.teamIndex)
      local playerRight = MultipleParkourPlayer.New(self.mgr, self, self.transform, pos, playerData)
      self.players[playerData.playerId] = playerRight
    end
  end
end

function MultipleParkourTeam:UpdatePlayer(PlayerDataMap, syncScore, syncAnim)
  for _, v in pairs(PlayerDataMap) do
    local playerData = v
    local layout = playerData.select
    if layout == Const.MultipleParkourDoorLayout.Left then
      local pos = self.formationLeft:GetPos(playerData.teamIndex)
      local playerId = playerData.playerId
      local playerLeft = self.players[playerId]
      if playerLeft then
        playerLeft:UpdatePos(pos.x, pos.z, not syncAnim)
        if syncScore then
          local dead = playerLeft:UpdateScore()
          if dead then
            self.mgr:PlayerDead(playerId)
            playerLeft:EnterDead()
            self.players[playerId] = nil
            self.toRemovePlayers[playerId] = playerLeft
          end
        end
      end
    elseif layout == Const.MultipleParkourDoorLayout.Right then
      local pos = self.formationRight:GetPos(playerData.teamIndex)
      local playerId = playerData.playerId
      local playerRight = self.players[playerId]
      if playerRight then
        playerRight:UpdatePos(pos.x, pos.z, not syncAnim)
        if syncScore then
          local dead = playerRight:UpdateScore()
          if dead then
            self.mgr:PlayerDead(playerId)
            playerRight:EnterDead()
            self.players[playerId] = nil
            self.toRemovePlayers[playerId] = playerRight
          end
        end
      end
    end
  end
end

function MultipleParkourTeam:UpdateSinglePlayer(playerData, syncScore, syncAnim)
  local layout = playerData.select
  if layout == Const.MultipleParkourDoorLayout.Left then
    local pos = self.formationLeft:GetPos(playerData.teamIndex)
    local playerId = playerData.playerId
    local playerLeft = self.players[playerId]
    if playerLeft then
      playerLeft:UpdatePos(pos.x, pos.z, not syncAnim)
      if syncScore then
        local dead = playerLeft:UpdateScore()
        if dead then
          self.mgr:PlayerDead(playerId)
          playerLeft:EnterDead()
          self.players[playerId] = nil
          self.toRemovePlayers[playerId] = playerLeft
        end
      end
    end
  elseif layout == Const.MultipleParkourDoorLayout.Right then
    local pos = self.formationRight:GetPos(playerData.teamIndex)
    local playerId = playerData.playerId
    local playerRight = self.players[playerId]
    if playerRight then
      playerRight:UpdatePos(pos.x, pos.z, not syncAnim)
      if syncScore then
        local dead = playerRight:UpdateScore()
        if dead then
          self.mgr:PlayerDead(playerId)
          playerRight:EnterDead()
          self.players[playerId] = nil
          self.toRemovePlayers[playerId] = playerRight
        end
      end
    end
  end
end

function MultipleParkourTeam:UpdateScore(playerIdMap)
  for _, playerId in pairs(playerIdMap) do
    local player = self.players[playerId]
    if player then
      local dead = player:UpdateScore()
      if dead then
        self.mgr:PlayerDead(playerId)
        player:EnterDead()
        self.players[playerId] = nil
        self.toRemovePlayers[playerId] = player
      end
    end
  end
end

function MultipleParkourTeam:UpdatePlayerScore(playerId)
  local player = self.players[playerId]
  if player then
    local dead = player:UpdateScore()
    if dead then
      self.mgr:PlayerDead(playerId)
      player:EnterDead()
      self.players[playerId] = nil
      self.toRemovePlayers[playerId] = player
    end
  end
end

function MultipleParkourTeam:SetPosition(x, z)
  self.curPos.x = x
  self.curPos.z = z
  self.transform:Set_position(x, 0, z)
end

function MultipleParkourTeam:GetPosition()
  return self.curPos
end

function MultipleParkourTeam:GetPositionZ()
  return self.curPos.z
end

function MultipleParkourTeam:RemovePlayer(playerId)
  local player = self.players[playerId]
  if player then
    player:Delete()
    self.players[playerId] = nil
  end
end

function MultipleParkourTeam:EnterMarch()
  for _, v in pairs(self.players) do
    v:EnterMarch()
  end
end

function MultipleParkourTeam:EnterBoss()
  self.bossHitCount = 0
  for _, v in pairs(self.players) do
    v:EnterBoss()
  end
end

function MultipleParkourTeam:UpdateBossPos(playerId, lastZ, curZ)
  local player = self.players[playerId]
  if player then
    local playSound = false
    if self.bossHitCount == 0 then
      playSound = true
    else
      local x, y = math.modf(self.bossHitCount / 4)
      playSound = y == 0
    end
    local hit = player:UpdateBossPos(lastZ - self.curPos.z, curZ - self.curPos.z, playSound)
    if hit then
      self.bossHitCount = self.bossHitCount + 1
    end
    return hit
  end
  return false
end

function MultipleParkourTeam:EnterBossResult(playerId)
  local player = self.players[playerId]
  if player then
    return player:EnterBossResult()
  end
end

function MultipleParkourTeam:ShowEmoji(playerId, emojiId, height)
  local player = self.players[playerId]
  if player then
    return player:ShowEmoji(emojiId, height)
  end
end

function MultipleParkourTeam:ShowNameAndUpdateHeight(playerId, height)
  local player = self.players[playerId]
  if player then
    player:ShowName(height)
  end
end

function MultipleParkourTeam:GetRewardPos(index)
  if self.rewardPos == nil then
    self.rewardPos = {}
    self.rewardPos[1] = Vector3.New(0, 0, 8)
    self.rewardPos[2] = Vector3.New(-2, 0, 6)
    self.rewardPos[3] = Vector3.New(2, 0, 6)
    self.rewardPos[4] = Vector3.New(-4, 0, 4)
    self.rewardPos[5] = Vector3.New(4, 0, 4)
  end
  return self.rewardPos[index]
end

function MultipleParkourTeam:MoveToRewardPos(playerId, index, time)
  local player = self.players[playerId]
  if player then
    local pos = self:GetRewardPos(index)
    return player:MoveToRewardPos(pos, time)
  end
end

function MultipleParkourTeam:PlayWin(playerId)
  local player = self.players[playerId]
  if player then
    player:PlayWin()
  end
end

function MultipleParkourTeam:GetPlayerCount()
  if self.players then
    return table.count(self.players)
  end
  return 0
end

function MultipleParkourTeam:GetMaxZ()
  if self.formationLeft then
    return self.formationLeft:GetMaxZ()
  end
  return 0
end

return MultipleParkourTeam
