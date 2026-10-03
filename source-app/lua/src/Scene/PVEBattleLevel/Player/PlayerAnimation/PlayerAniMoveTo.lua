local base = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniBase")
local PlayerAniMoveTo = BaseClass("PlayerAniMoveTo", base)
local speed = 4

function PlayerAniMoveTo:__init(spaceman)
  self.startPos = Vector3.New(0, 0, 0)
  self.endPos = nil
  self.curTime = 0
  self.speed = 0
  self.posArr = {}
  self.index = 1
end

function PlayerAniMoveTo:OnEnter()
  base.OnEnter(self)
  self:SetSpeed()
  self.posArr = self.m_citySpaceMan:GetMoveToEndPosArr()
  self.index = 0
  self:CheckNextPos()
end

function PlayerAniMoveTo:OnExit()
  if self.posArr ~= nil then
    self.m_citySpaceMan:SetPosition(self.posArr[#self.posArr])
  end
  if DataCenter.GuideManager:GetGuideType() == GuideType.PrologueShowSetManPosition then
    DataCenter.GuideManager:DoNext()
  end
end

function PlayerAniMoveTo:OnUpdate()
  self.curTime = self.curTime + Time.deltaTime
  if self.curTime < self.allTime then
    self.m_citySpaceMan:SetPosition(Vector3.Lerp(self.startPos, self.endPos, self.curTime / self.allTime))
  else
    self.m_citySpaceMan:SetPosition(self.endPos)
    self:CheckNextPos()
  end
end

function PlayerAniMoveTo:SetSpeed()
  self.speed = speed
  local buffValue = self.m_citySpaceMan.battleLevel:GetBuffEffectValueByType(PveBuffType.Speed)
  if 0 < buffValue then
    self.speed = self.speed * buffValue
  end
  local speedMulti = self.m_citySpaceMan.battleLevel:GetSpeedMulti()
  self.speed = self.speed * speedMulti
end

function PlayerAniMoveTo:RefreshBuff()
  self:SetSpeed()
end

function PlayerAniMoveTo:CheckNextPos()
  if #self.posArr < self.index + 1 then
    self.m_citySpaceMan:LeaveMoveTo()
  else
    if self.index == 0 then
      local pos = self.m_citySpaceMan:GetPosition()
      self.startPos.x = pos.x
      self.startPos.z = pos.z
    else
      self.startPos.x = self.posArr[self.index].x
      self.startPos.z = self.posArr[self.index].z
    end
    self.index = self.index + 1
    self.endPos = self.posArr[self.index]
    local lookRot = Quaternion.LookRotation(Vector3.Normalize(self.endPos - self.startPos), Vector3.up)
    self.m_citySpaceMan:SetRotation(lookRot)
    local distance = Vector3.Distance(self.endPos, self.startPos)
    self.allTime = distance / self.speed
    self.curTime = 0
  end
end

return PlayerAniMoveTo
