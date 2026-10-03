local MultipleParkourPlayer = BaseClass("MultipleParkourPlayer")
local resPath = "Assets/_Art_LastWar/Models/Characters/Soldier/bubing02/prefab/A_Hero_bubing02_lv.prefab"
local teamResPath = "Assets/_Art_LastWar/Models/Characters/Soldier/bubing02/prefab/A_Hero_bubing02_new.prefab"
local otherResPath = "Assets/_Art_LastWar/Models/Characters/Soldier/bubing02/prefab/A_Hero_bubing02_huang.prefab"
local Resource = CS.GameEntry.Resource
local MultipleParkourPlayerBarCell = require("DataCenter.MultipleParkour.Team.MultipleParkourPlayerBarCell")
local MultipleParkourPlayerBubbleCell = require("DataCenter.MultipleParkour.Team.MultipleParkourPlayerBubbleCell")
local ParkourAnimName = {
  Idle = "Default",
  Run = "parkour_run",
  Left = "parkour_left",
  Right = "parkour_right",
  FellDown = "parkour_ground",
  Lay = "parkour_ground_idle",
  GetUp = "parkour_getup",
  Win = "parkour_win",
  WinIdle = "parkour_win_idle"
}

function MultipleParkourPlayer:__init(mgr, team, parent, localPos, playerData)
  self.mgr = mgr
  self.team = team
  self.parent = parent
  self.localPos = Vector3.New(localPos.x, localPos.y, localPos.z)
  self.playerData = playerData
  self.dead = false
  local res = otherResPath
  if playerData.mySelf then
    res = resPath
  elseif team.myTeamId > 0 and team.myTeamId == playerData.teamId then
    res = teamResPath
  end
  self.req = Resource:InstantiateAsync(res)
  self.req:completed("+", function(request)
    self.gameObject = request.gameObject
    self.transform = request.gameObject.transform
    self.transform:SetParent(self.parent)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_eulerAngles(ResetEulerAngles.x, ResetEulerAngles.y, ResetEulerAngles.z)
    self.transform:Set_localPosition(self.localPos.x, self.localPos.y, self.localPos.z)
    self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if self.dead then
      self.transform:SetParent(nil)
      self:PlaySimpleAnim(ParkourAnimName.FellDown)
    else
      if self.head == nil then
        self.head = MultipleParkourPlayerBarCell.New()
        self.head:Load(self, self.transform, 2)
      end
      self:PlaySimpleAnim(ParkourAnimName.Idle)
    end
  end)
end

function MultipleParkourPlayer:__delete()
  self:Destroy()
end

function MultipleParkourPlayer:SetData(playerData)
  self.playerData = playerData
end

function MultipleParkourPlayer:UpdatePos(x, z, ignoreAnim)
  if self.localPos.x ~= x or self.localPos.z ~= z then
    local left = true
    if x > self.localPos.x then
      left = false
    end
    self.localPos.x = x
    self.localPos.z = z
    if not IsNull(self.transform) then
      self.transform:DOKill()
      self.transform:DOLocalMove(self.localPos, 0.3)
    end
    if not ignoreAnim then
      if left then
        self:PlaySimpleAnim(ParkourAnimName.Left)
      else
        self:PlaySimpleAnim(ParkourAnimName.Right)
      end
      self:PlayQueued(ParkourAnimName.Run)
    end
  end
end

function MultipleParkourPlayer:UpdateScore()
  if self.head then
    self.head:UpdateScore()
  end
  if self.mgr:IsEndless() then
    return self.playerData.dead
  end
  return false
end

function MultipleParkourPlayer:Destroy()
  if self.head then
    self.head:Delete()
    self.head = nil
  end
  if self.bubble then
    self.bubble:Delete()
    self.bubble = nil
  end
  if not IsNull(self.transform) then
    self.transform:DOKill()
  end
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  if self.req then
    self.req:Destroy()
    self.req = nil
    self.gameObject = nil
    self.transform = nil
  end
  self.playerData = nil
  self.mgr = nil
  self.team = nil
  self.parent = nil
  self.bossResult = nil
end

function MultipleParkourPlayer:EnterMarch()
  self:PlaySimpleAnim(ParkourAnimName.Run)
end

function MultipleParkourPlayer:EnterBoss()
  self:PlaySimpleAnim(ParkourAnimName.Idle)
end

function MultipleParkourPlayer:UpdateBossPos(lastZ, curZ, playSound)
  if self.bossResult then
    return false
  end
  if lastZ > self.localPos.z and curZ <= self.localPos.z then
    local rushRandom = math.random()
    if rushRandom < 0.15 then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_bus_hit)
    end
    if playSound then
      local screamRandom = math.random()
      if screamRandom < 0.33 then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_soldier_shout_01)
      elseif screamRandom < 0.66 then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_soldier_shout_02)
      else
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_soldier_shout_03)
      end
    end
    return true
  end
end

function MultipleParkourPlayer:EnterBossResult()
  if self.bossResult then
    return
  end
  self.bossResult = true
  self:PlaySimpleAnim(ParkourAnimName.FellDown)
  local playerScore = self.playerData.score
  if 0 < playerScore then
    self:PlayQueued(ParkourAnimName.GetUp)
    self:PlayQueued(ParkourAnimName.Idle)
  else
    self:FellDownLerp()
    self:PlayQueued(ParkourAnimName.Lay)
  end
end

function MultipleParkourPlayer:FellDownLerp()
  local teamIndex = self.playerData.teamIndex
  local left = teamIndex % 2 == 1
  local offset = 0.8 + math.random() * 0.5
  if left then
    offset = -offset
  end
  local x = self.localPos.x
  local z = self.localPos.z
  self.localPos.x = x + offset
  self.localPos.z = z - offset
  if not IsNull(self.transform) then
    self.transform:DOKill()
    self.transform:DOLocalMove(self.localPos, 0.6)
  end
end

function MultipleParkourPlayer:MoveToRewardPos(pos, time)
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  if not IsNull(self.transform) then
    self.transform:DOKill()
    self:PlaySimpleAnim(ParkourAnimName.Run)
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:Append(self.transform:DOLocalMove(pos, time))
    self.sequence:OnComplete(function()
      self.sequence = nil
      self:CrossFadeSimpleAnim(ParkourAnimName.Idle)
    end)
  end
end

function MultipleParkourPlayer:PlayWin()
  self:PlaySimpleAnim(ParkourAnimName.Win)
  self:PlayQueued(ParkourAnimName.WinIdle)
end

function MultipleParkourPlayer:ShowEmoji(emojiId, height)
  height = height or 2
  if self.bubble then
    self.bubble:ShowEmoji(emojiId)
    self.bubble:UpdateHeight(height)
  else
    self.bubble = MultipleParkourPlayerBubbleCell.New()
    self.bubble:Load(self, self.transform, height, emojiId)
  end
end

function MultipleParkourPlayer:ShowName(height)
  if self.head then
    self.head:ShowName(height)
  end
end

function MultipleParkourPlayer:EnterDead()
  self.dead = true
  if self.transform then
    self.transform:SetParent(nil)
  end
  self:PlaySimpleAnim(ParkourAnimName.FellDown)
  if self.head then
    self.head:Delete()
    self.head = nil
  end
end

local function CheckAnimName(anim, name)
  if anim == nil or name == nil then
    return nil
  end
  local state = anim:GetState(name)
  if state ~= nil then
    return name
  end
  if name == "death" then
    state = anim:GetState("dead")
    if state ~= nil then
      return "dead"
    end
  end
  if name == "dead" then
    state = anim:GetState("death")
    if state ~= nil then
      return "death"
    end
  end
  return nil
end

function MultipleParkourPlayer:PlaySimpleAnim(name, speed)
  if self.anim then
    local theAnimName = CheckAnimName(self.anim, name)
    if theAnimName == nil then
      return
    end
    self.anim:Play(theAnimName)
    if speed then
      self.anim:SetStateSpeed(theAnimName, speed)
    end
  end
end

function MultipleParkourPlayer:PlayQueued(name)
  if self.anim then
    local theAnimName = CheckAnimName(self.anim, name)
    if theAnimName == nil then
      return
    end
    self.anim:PlayQueued(theAnimName)
  end
end

function MultipleParkourPlayer:RewindAndPlaySimpleAnim(name, speed)
  if self.anim then
    local theAnimName = CheckAnimName(self.anim, name)
    if theAnimName == nil then
      return
    end
    self.anim:Rewind(theAnimName)
    self.anim:Play(theAnimName)
    if speed then
      self.anim:SetStateSpeed(theAnimName, speed)
    end
  end
end

function MultipleParkourPlayer:CrossFadeSimpleAnim(name, speed, fadeTime)
  if self.anim then
    self.anim:CrossFade(name, fadeTime)
    if speed then
      self.anim:SetStateSpeed(name, speed)
    end
  end
end

function MultipleParkourPlayer:RewindSimpleAnim(name)
  if self.anim then
    local theAnimName = CheckAnimName(self.anim, name)
    if theAnimName == nil then
      return
    end
    self.anim:Rewind(theAnimName)
  end
end

function MultipleParkourPlayer:GetAnimLength(name)
  if self.anim then
    self.anim:SetStateSpeed(name, 1)
    return self.anim:GetClipLength(name)
  else
    return 0
  end
end

function MultipleParkourPlayer:StopAnim()
  if self.anim then
    self.anim:Stop()
  end
end

return MultipleParkourPlayer
