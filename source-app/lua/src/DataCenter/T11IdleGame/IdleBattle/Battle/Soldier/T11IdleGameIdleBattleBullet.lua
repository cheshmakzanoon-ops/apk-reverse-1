local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameIdleBattleBullet = BaseClass("T11IdleGameIdleBattleBullet")
local speedTmp = Vector3.zero

function T11IdleGameIdleBattleBullet:__init()
  self.req = nil
  self.obj = nil
  self.trans = nil
  self.duration = -1
  self.speed = 0
  self.onHitCallback = nil
  self.startPos = nil
  self.id = 0
end

function T11IdleGameIdleBattleBullet:__delete()
  self:Clear()
  self:Destroy()
end

function T11IdleGameIdleBattleBullet:Clear()
  self.duration = nil
  self.speed = nil
  self.onHitCallback = nil
  self.startPos = nil
  self.id = nil
end

function T11IdleGameIdleBattleBullet:Destroy()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.obj = nil
  self.trans = nil
end

function T11IdleGameIdleBattleBullet:Init(asset, startPos, endPos, speed, id, onHitCallback)
  self.onHitCallback = onHitCallback
  self.startPos = startPos
  self.id = id
  self.duration = -1
  if self.req then
    self:InitBulletEffect(startPos, endPos, speed)
  else
    self.req = CS.GameEntry.Resource:InstantiateAsync(asset, ObjectPoolTag.Battle)
    self.req:completed("+", function(req)
      if req.isError then
        return
      end
      if IsNotNull(req.gameObject) then
        self.obj = req.gameObject
        self.trans = req.gameObject.transform
        self:InitBulletEffect(startPos, endPos, speed)
      end
    end)
  end
end

function T11IdleGameIdleBattleBullet:InitBulletEffect(startPos, endPos, speed)
  if IsNull(self.trans) then
    return
  end
  self.speed = speed
  self.trans.gameObject:SetActive(true)
  self.trans.position = startPos
  self.trans:LookAt(endPos)
  local distance = Vector3.New(endPos.x - startPos.x, 0, endPos.z - startPos.z):Magnitude()
  if speed == 0 then
    self.duration = 1
  else
    self.duration = distance / speed
  end
end

function T11IdleGameIdleBattleBullet:OnUpdate(deltaTime)
  if self.trans and self.duration >= 0 then
    speedTmp.z = self.speed * deltaTime
    self.trans:Translate(speedTmp)
    self.duration = self.duration - deltaTime
    if self.duration < 0 then
      self:OnBulletHit()
    end
  end
end

function T11IdleGameIdleBattleBullet:OnBulletHit()
  self:Hide()
  if self.onHitCallback then
    self.onHitCallback(self)
  end
end

function T11IdleGameIdleBattleBullet:Hide()
  if self.trans then
    self.trans.gameObject:SetActive(false)
    self.trans.position = self.startPos
  end
  self.duration = -1
end

function T11IdleGameIdleBattleBullet:GetId()
  return self.id
end

return T11IdleGameIdleBattleBullet
