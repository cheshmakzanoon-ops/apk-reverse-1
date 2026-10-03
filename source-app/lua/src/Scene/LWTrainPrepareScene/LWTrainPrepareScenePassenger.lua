local LWTrainPrepareScenePassenger = BaseClass("LWTrainPrepareScenePassenger")
local Resource = CS.GameEntry.Resource
local path = "Assets/_Art_LastWar/Models/Characters/Soldier/bubing_huochezhan/prefab/A_Hero_bubing_huochezhan.prefab"

function LWTrainPrepareScenePassenger:__init(container, root, coach, index, startX, startZ, data, vip)
  self.container = container
  self.valid = true
  self.root = root
  self.coach = coach
  self.index = index
  self.data = data
  self.uid = data.uid
  self.formX = startX
  self.fromZ = startZ
  self.tweenPos = Vector3.New(startX, 0, startZ)
  self.showBubble = false
  self.VIP = vip
  self:Load(self.VIP)
end

function LWTrainPrepareScenePassenger:__delete()
  self.container = nil
  self.valid = nil
  self.root = nil
  self.go = nil
  self.transform = nil
  self.anim = nil
  self.showBubble = nil
  self:ClearSequence()
  self:ClearBubbleDelay()
  self:Unload()
end

function LWTrainPrepareScenePassenger:Load(vip)
  if self.req then
    return
  end
  self.req = Resource:InstantiateAsync(path)
  self.req:completed("+", function(request)
    if not self.valid then
      request:Destroy()
      return
    end
    local go = request.gameObject
    self.go = fo
    self.transform = go.transform
    self.transform:SetParent(self.root)
    if self.VIP then
      self.transform:Set_localScale(2, 2, 2)
    else
      self.transform:Set_localScale(1.5, 1.5, 1.5)
    end
    self.transform:Set_localEulerAngles(ResetEulerAngles.x, ResetEulerAngles.y, ResetEulerAngles.z)
    self.transform:Set_localPosition(self.formX, 0, self.fromZ)
    self.anim = go:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    local moveX = self.x
    local moveZ = self.z
    self.x = self.formX
    self.z = self.fromZ
    self:MoveTo(moveX, moveZ, nil, vip)
    self:ShowBubble()
  end)
end

function LWTrainPrepareScenePassenger:Unload()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  if self.bubble then
    self.bubble:Delete()
    self.bubble = nil
  end
end

function LWTrainPrepareScenePassenger:ShowBubble()
  if self.showBubble then
    self.showBubble = false
    if self.bubble == nil then
      self.bubble = self.container:GetBubble()
    end
    if self.bubble == nil then
      return
    end
    local bubbleTip = self.container:GetPassengerBubbleLange()
    self.bubble:SetData(self.data, self.transform, bubbleTip)
    self.bubbleDelay = TimerManager:GetInstance():DelayInvoke(function()
      self:HideBubble()
    end, 3)
  end
end

function LWTrainPrepareScenePassenger:SetPos(x, z)
  self.x = x
  self.z = z
end

function LWTrainPrepareScenePassenger:MoveTo(x, z, showBubble, vip)
  self.move = false
  if self.x ~= x then
    self.x = x
    self.move = true
  end
  if self.z ~= z then
    self.z = z
    self.move = true
  end
  if self.move and self.transform then
    self.move = false
    self.tweenPos.x = x
    self.tweenPos.z = z
    self:ClearSequence()
    local curX, curY, curZ = self.transform:Get_localPosition()
    local dirX = x - curX
    local dirZ = z - curZ
    if vip then
    else
      self.transform:Set_forward(dirX, 0, dirZ)
    end
    self:PlaySimpleAnim("run")
    if showBubble then
      self:ForceShowBubble()
    end
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:Append(self.transform:DOLocalMove(self.tweenPos, 2))
    self.sequence:OnComplete(function()
      self.sequence = nil
      self:Reset()
    end)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.platform_soilder_walk, false)
  end
end

function LWTrainPrepareScenePassenger:ForceShowBubble()
  self:ClearBubbleDelay()
  self.showBubble = true
  self:ShowBubble()
end

function LWTrainPrepareScenePassenger:PlaySimpleAnim(anim)
  if self.anim then
    self.anim:Play(anim)
  end
end

function LWTrainPrepareScenePassenger:PlayQueued(anim)
  if self.anim then
    self.anim:PlayQueued(anim)
  end
end

function LWTrainPrepareScenePassenger:ClearSequence()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function LWTrainPrepareScenePassenger:ClearBubbleDelay()
  if self.bubbleDelay then
    self.bubbleDelay:Stop()
    self.bubbleDelay = nil
  end
end

function LWTrainPrepareScenePassenger:Reset()
  self.transform:Set_forward(1, 0, 0)
  self:PlaySimpleAnim("Default")
end

function LWTrainPrepareScenePassenger:HideBubble()
  if self.bubble then
    self.container:PushBubble(self.bubble)
    self.bubble = nil
  end
end

return LWTrainPrepareScenePassenger
