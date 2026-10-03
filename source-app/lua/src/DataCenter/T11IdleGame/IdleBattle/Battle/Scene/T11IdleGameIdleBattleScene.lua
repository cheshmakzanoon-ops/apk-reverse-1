local Resource = CS.GameEntry.Resource
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameIdleBattleScene = BaseClass("T11IdleGameIdleBattleScene")
local ResourceManager = CS.GameEntry.Resource

function T11IdleGameIdleBattleScene:__init(owner, root, index)
  self.owner = owner
  self.root = root
  self.index = index
  self.prefabPath = ""
  self.length = 0
  self.req = nil
  self.obj = nil
  self.tween = nil
  self.targetX = 0
  self.curX = 0
  self.moveToTargetCallback = nil
  self.isMoving = false
end

function T11IdleGameIdleBattleScene:__delete()
  self:Destroy()
end

function T11IdleGameIdleBattleScene:Destroy()
  self:Clear()
  self.owner = nil
  self.root = nil
  self.index = nil
end

function T11IdleGameIdleBattleScene:Clear()
  self.prefabPath = nil
  self.length = nil
  if self.tween ~= nil then
    self.tween:Kill()
    self.tween = nil
  end
  self.targetX = nil
  self.curX = nil
  self.moveToTargetCallback = nil
  self.isMoving = nil
  self:DestroyScene()
end

function T11IdleGameIdleBattleScene:Load(prefabPath, length, finishCallback)
  self.prefabPath = prefabPath
  self.length = length
  local req = ResourceManager:InstantiateAsync(prefabPath)
  req:completed("+", function(request)
    if request.isError or IsNull(self.root) then
      return
    end
    request.gameObject.transform:SetParent(self.root.transform)
    request.gameObject.transform:Set_localPosition(0, 0, 0)
    request.gameObject.transform:Set_localEulerAngles(0, 0, 0)
    self.sceneObj = request.gameObject
    if finishCallback then
      finishCallback()
    end
  end)
  self.req = req
end

function T11IdleGameIdleBattleScene:IsLoaded()
  return IsNotNull(self.sceneObj)
end

function T11IdleGameIdleBattleScene:DestroyScene()
  if self.req ~= nil then
    self.req:Destroy()
  end
  self.req = nil
  self.sceneObj = nil
end

function T11IdleGameIdleBattleScene:SetLocalX(x)
  local _, y, z = self.root.transform:Get_localPosition()
  self.root.transform:Set_localPosition(x, y, z)
  self.curX = x
end

function T11IdleGameIdleBattleScene:GetLocalX()
  return self.curX
end

function T11IdleGameIdleBattleScene:GetLength()
  return self.length
end

function T11IdleGameIdleBattleScene:GetIndex()
  return self.index
end

function T11IdleGameIdleBattleScene:OnUpdate(dt)
  if not self.curX or not self.targetX then
    return
  end
  if not self.isMoving then
    return
  end
  if self.curX <= self.targetX and self.moveToTargetCallback then
    self.moveToTargetCallback(self)
  end
  local curX = self.curX
  local moveX = dt * Const.SceneMoveSpeed
  local newX = curX + moveX
  self:SetLocalX(newX)
end

function T11IdleGameIdleBattleScene:MoveToLocalX(xPos, finishCallback)
  self.targetX = xPos
  self.moveToTargetCallback = finishCallback
  self.isMoving = true
end

function T11IdleGameIdleBattleScene:Pause()
  self.isMoving = false
end

function T11IdleGameIdleBattleScene:Resume()
  self.isMoving = true
end

return T11IdleGameIdleBattleScene
