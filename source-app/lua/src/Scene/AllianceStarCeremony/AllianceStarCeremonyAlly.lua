local base = require("Scene.AllianceStarCeremony.AllianceStarCeremonyBaseUnit")
local AllianceStarCeremonyAlly = BaseClass("AllianceStarCeremonyAlly", base)

function AllianceStarCeremonyAlly:__init()
  self.showBubble = false
  self.showInteractionIcon = false
  self.openInteractionAnim = false
  self.index = nil
end

function AllianceStarCeremonyAlly:__delete()
  self.showBubble = false
  self.showInteractionIcon = false
  if self.allyInfo then
    self.allyInfo:SetAlly(nil)
    self.allyInfo = nil
  end
  self.interactionAnimDelay = nil
  self:ClearRandomAnim()
  self:ClearReadPersonRewardAnim()
  self.index = nil
end

function AllianceStarCeremonyAlly:SetIndex(index)
  self.index = index
end

function AllianceStarCeremonyAlly:GetIndex()
  return self.index
end

function AllianceStarCeremonyAlly:ShowBubble()
  self.showBubble = true
end

function AllianceStarCeremonyAlly:CloseBubble()
  self.showBubble = false
end

function AllianceStarCeremonyAlly:ShowInteractionIcon()
  self.showInteractionIcon = true
end

function AllianceStarCeremonyAlly:CloseInteractionIcon()
  self.showInteractionIcon = false
end

function AllianceStarCeremonyAlly:RefreshAllyInfo(allyInfo)
  if self.allyInfo then
    self.allyInfo:SetAlly(nil)
  end
  if allyInfo then
    allyInfo:SetAlly(self)
  end
  self.allyInfo = allyInfo
end

function AllianceStarCeremonyAlly:GetAllyInfo()
  return self.allyInfo
end

function AllianceStarCeremonyAlly:GetPoint()
  local point
  if self.skinParam and self.skinParam.parent then
    point = self.skinParam.parent
  end
  return point
end

function AllianceStarCeremonyAlly:Update(dt)
  if self.interactionAnimDelay and self.interactionAnimDelay > 0 then
    self.interactionAnimDelay = self.interactionAnimDelay - dt
    if self.interactionAnimDelay <= 0 then
      self.interactionAnimDelay = nil
      self:PlaySimpleAnim("idle")
      self:ResetRandomAnimCD()
    end
  elseif self.readPersonRewardDelay then
    self.readPersonRewardDelay = self.readPersonRewardDelay - dt
    if 0 >= self.readPersonRewardDelay then
      local animName = self.readPersonReward
      if animName then
        self:PlaySimpleAnim(animName)
        self:CrossFadeQueued("idle", 0.2, CS.UnityEngine.QueueMode.CompleteOthers)
        if self.readPersonRewardAllyBubbleParam then
          EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyAddCustomBubble, self.readPersonRewardAllyBubbleParam)
        end
        self:ClearReadPersonRewardAnim()
      end
      self:ResetRandomAnimCD()
    end
  elseif self.randomAnimDelay then
    self.randomAnimDelay = self.randomAnimDelay - dt
    if 0 >= self.randomAnimDelay then
      local animName = table.randomArrayValue(self.allyRandomAnimInfo.animList)
      self:PlaySimpleAnim(animName)
      self:CrossFadeQueued("idle", 0.2, CS.UnityEngine.QueueMode.CompleteOthers)
      self:ResetRandomAnimCD()
    end
  end
end

function AllianceStarCeremonyAlly:PlayInteractionAnim(animName)
  if not self.openInteractionAnim then
    return
  end
  self.interactionAnimDelay = self:GetAnimLength(animName)
  self:PlaySimpleAnim(animName)
end

function AllianceStarCeremonyAlly:SetRandomAnimAndDelay(allyRandomAnimInfo)
  self.allyRandomAnimInfo = allyRandomAnimInfo
  self.randomAnimDelay = math.random(0, 1)
end

function AllianceStarCeremonyAlly:ResetRandomAnimCD()
  if self.allyRandomAnimInfo then
    self.randomAnimDelay = self.allyRandomAnimInfo.cd + math.random(0, 1)
  end
end

function AllianceStarCeremonyAlly:ClearRandomAnim()
  self.allyRandomAnimInfo = nil
  self.randomAnimDelay = nil
end

function AllianceStarCeremonyAlly:PlayReadPersonRewardAnim(animName, cd, allyBubbleParam)
  self.readPersonReward = animName
  self.readPersonRewardCD = cd
  self.readPersonRewardDelay = self.readPersonRewardCD
  self.readPersonRewardAllyBubbleParam = allyBubbleParam
end

function AllianceStarCeremonyAlly:ClearReadPersonRewardAnim()
  self.readPersonReward = nil
  self.readPersonRewardCD = nil
  self.readPersonRewardDelay = nil
  self.readPersonRewardAllyBubbleParam = nil
end

function AllianceStarCeremonyAlly:LoadResCallback(obj)
  local scene = DataCenter.AllianceStarManager.ceremonyScene
  if scene and scene.allyRandomAnimInfo then
    self:SetRandomAnimAndDelay(scene.allyRandomAnimInfo)
  end
end

return AllianceStarCeremonyAlly
