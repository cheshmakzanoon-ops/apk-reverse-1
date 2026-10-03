local BaseObject = BaseClass("BaseObject")
local Resource = CS.GameEntry.Resource

function BaseObject:__init(mgr)
  self.modelHeight = 0
  self.fun = nil
  self.data = nil
  self.state = nil
  self.mgr = mgr
  self:OnInit()
end

function BaseObject:OnInit()
end

function BaseObject:__delete()
  self.data = nil
  self.simpleAnim = nil
  self.state = nil
  self.modelHeight = nil
  self.fun = nil
  self.mgr = nil
  self:OnDelete()
end

function BaseObject:OnDelete()
end

function BaseObject:SetData(data)
  self.data = data
  self:ChangeState(data.state)
end

function BaseObject:ChangeState(state)
  if state == self.state then
    return
  end
  self.state = state
  self:RefreshManifestation()
end

function BaseObject:RefreshManifestation()
  if self.state == MonopolyPlacealityType.ArrivalBefore then
    self:ArrivalBefore()
  elseif self.state == MonopolyPlacealityType.Arrive then
    self:Arrive()
  elseif self.state == MonopolyPlacealityType.EventBefore then
    self:EventBefore()
  elseif self.state == MonopolyPlacealityType.EventEnd then
    self:EventEnd()
  elseif self.state == MonopolyPlacealityType.Leave then
    self:Leave()
  elseif self.state == MonopolyPlacealityType.Occupy then
    self:Occupy()
  end
  self:OnRefreshManifestation()
end

function BaseObject:OnRefreshManifestation()
end

function BaseObject:SBattleFire()
  self.SBattle = true
  if self:IsLock() then
    self.SBattle = false
    DataCenter.MonopolyManager:SetSpontaneousBattle(false)
    return
  end
  self:Fire()
end

function BaseObject:CreateObject(path, callBack)
  local Res = Resource:InstantiateAsync(path)
  Res:completed("+", function(req)
    if not req then
      return
    end
    if callBack then
      callBack(req)
    end
  end)
  return Res
end

function BaseObject:ArrivalBefore()
end

function BaseObject:PlayAnim(animName)
  if self.simpleAnim then
    local length = self:GetClicpLength(animName)
    if length == 0 then
      return
    end
    if self.simpleAnim:IsPlaying(animName) then
      self.simpleAnim:Rewind(animName)
    else
      self.simpleAnim:Play(animName)
    end
  end
end

function BaseObject:GetClicpLength(animName)
  if self.simpleAnim then
    return self.simpleAnim:GetClipLength(animName)
  end
end

function BaseObject:Arrive()
end

function BaseObject:EventBefore()
end

function BaseObject:Fire()
end

function BaseObject:EventEnd()
end

function BaseObject:Occupy()
end

function BaseObject:Leave()
end

function BaseObject:RefreshBubble()
end

return BaseObject
