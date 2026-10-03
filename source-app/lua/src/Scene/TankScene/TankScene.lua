local TankScene = BaseClass("TankScene")
local RotationAnimTime = 0.2
local MovePerGridSpeed = 4
local RotationAngleSpeed = 540
local RotationDeltaX = 0.8
local RotationDeltaY = 0.45
local effect_go_path = "EffectGo"
local AnimName = {Idle = "death", Walk = "run"}

function TankScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function TankScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function TankScene:ComponentDefine()
  self.gpu_anim = self.transform:GetComponentInChildren(typeof(CS.GPUSkinningAnimator), true)
  
  function self.gpu_anim.PlayEndCallBack(aniName)
    self:OnPlayEnd(aniName)
  end
  
  self.effect_go = self.transform:Find(effect_go_path)
end

function TankScene:ComponentDestroy()
  self.gpu_anim.PlayEndCallBack = nil
  self.gpu_anim = nil
  self.effect_go = nil
  self.gameObject = nil
  self.transform = nil
end

function TankScene:DataDefine()
  self.param = {}
  self.isWalk = false
  self.walkIndex = 1
  
  function self.__update_handle()
    self:Update()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
  self.isRotation = false
  self.startRotation = nil
  self.endRotation = nil
  self.rotationTime = 0
  self.isFollow = false
end

function TankScene:DataDestroy()
  self.param = {}
  if self.__update_handle ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
  self.isWalk = false
  self.walkIndex = 1
  self.isRotation = false
  self.startRotation = nil
  self.endRotation = nil
  self.rotationTime = 0
  self.isFollow = false
end

function TankScene:ReInit(param)
  self.param = param
  if self.param.posArr ~= nil then
    local count = table.count(self.param.posArr)
    if count <= 1 then
      self.isWalk = false
    else
      self.moveArr = {}
      if count == 2 then
        local startPos = SceneUtils.TileToWorld(self.param.posArr[1])
        local endPos = SceneUtils.TileToWorld(self.param.posArr[2])
        local dur = Vector3.New(startPos.x - endPos.x, startPos.y - endPos.y, startPos.z - endPos.z)
        local rotation = Quaternion.LookRotation(dur, Vector3.up)
        local posVec = {}
        posVec.startPos = startPos
        posVec.endPos = endPos
        posVec.startRotation = rotation
        posVec.endRotation = rotation
        posVec.time = Vector3.Distance(posVec.startPos, posVec.endPos) / MovePerGridSpeed
        table.insert(self.moveArr, posVec)
      else
        local lastVec, lastPos
        for k, v in ipairs(self.param.posArr) do
          local curPos = SceneUtils.TileToWorld(v)
          local posVec = {}
          if k == 1 then
            posVec.startPos = curPos
            table.insert(self.moveArr, posVec)
          elseif k == count then
            local rotation, startNearPos, endNearPos = self:GetPathVec(lastPos, curPos)
            lastVec.endPos = startNearPos
            lastVec.endRotation = rotation
            posVec.startPos = startNearPos
            posVec.endPos = endNearPos
            posVec.startRotation = rotation
            posVec.endRotation = rotation
            posVec.time = Vector3.Distance(posVec.startPos, posVec.endPos) / MovePerGridSpeed
            table.insert(self.moveArr, posVec)
          elseif k == 2 then
            local rotation, startNearPos, endNearPos = self:GetPathVec(lastPos, curPos)
            lastVec.endPos = endNearPos
            lastVec.startRotation = rotation
            lastVec.endRotation = rotation
            lastVec.time = Vector3.Distance(lastVec.startPos, lastVec.endPos) / MovePerGridSpeed
            posVec.startPos = endNearPos
            posVec.startRotation = rotation
            posVec.time = RotationAnimTime
            table.insert(self.moveArr, posVec)
          else
            local rotation, startNearPos, endNearPos = self:GetPathVec(lastPos, curPos)
            lastVec.endPos = startNearPos
            lastVec.endRotation = rotation
            local movePosVec = {}
            movePosVec.startPos = startNearPos
            movePosVec.endPos = endNearPos
            movePosVec.startRotation = rotation
            movePosVec.endRotation = rotation
            movePosVec.time = Vector3.Distance(movePosVec.startPos, movePosVec.endPos) / MovePerGridSpeed
            table.insert(self.moveArr, movePosVec)
            posVec.startPos = endNearPos
            posVec.startRotation = rotation
            posVec.time = RotationAnimTime
            table.insert(self.moveArr, posVec)
          end
          lastVec = posVec
          lastPos = curPos
        end
      end
      self.curTime = 0
      self.walkIndex = 1
      self.transform.rotation = self.moveArr[self.walkIndex].endRotation
      self.isWalk = true
    end
    self.transform.position = SceneUtils.TileToWorld(self.param.posArr[1])
  end
  if self.param.angle ~= nil then
    self.curTime = 0
    self.isRotation = true
    self.startRotation = self.transform.rotation
    self.endRotation = Quaternion.Euler(0, self.param.angle, 0)
    self.rotationTime = math.abs((self.param.angle - self.transform.rotation.eulerAngles.y) / RotationAngleSpeed)
  else
    self.isRotation = false
    if not self.isWalk then
      self.param.follow = false
      self:CheckNext()
    end
  end
  self:RefreshAnim()
  self:RefreshFollow()
end

function TankScene:RefreshAnim()
  if self.isWalk then
    self.gpu_anim:Play(AnimName.Walk)
  elseif self.isRotation then
    self.gpu_anim:Play(AnimName.Walk)
  else
    self.gpu_anim:Play(AnimName.Idle)
    if self.param.showEffect then
      self.effect_go.gameObject:SetActive(true)
    end
  end
end

function TankScene:OnPlayEnd(aniName)
end

function TankScene:GetPathVec(startPos, endPos)
  if endPos.x == startPos.x then
    if endPos.z > startPos.z then
      return Quaternion.Euler(0, 180, 0), {
        x = startPos.x,
        y = 0,
        z = startPos.z + RotationDeltaX
      }, {
        x = startPos.x,
        y = 0,
        z = endPos.z - RotationDeltaY
      }
    else
      return Quaternion.Euler(0, 0, 0), {
        x = startPos.x,
        y = 0,
        z = startPos.z - RotationDeltaX
      }, {
        x = startPos.x,
        y = 0,
        z = endPos.z + RotationDeltaY
      }
    end
  elseif endPos.x > startPos.x then
    return Quaternion.Euler(0, -90, 0), {
      x = startPos.x + RotationDeltaX,
      y = 0,
      z = startPos.z
    }, {
      x = endPos.x - RotationDeltaY,
      y = 0,
      z = startPos.z
    }
  else
    return Quaternion.Euler(0, 90, 0), {
      x = startPos.x - RotationDeltaX,
      y = 0,
      z = startPos.z
    }, {
      x = endPos.x + RotationDeltaY,
      y = 0,
      z = startPos.z
    }
  end
end

function TankScene:Update()
  if self.isWalk then
    self.curTime = self.curTime + Time.deltaTime
    local percent = self.curTime / self.moveArr[self.walkIndex].time
    if 1 <= percent then
      self.curTime = 0
      self.transform.position = self.moveArr[self.walkIndex].endPos
      self.transform.rotation = self.moveArr[self.walkIndex].endRotation
      if self.walkIndex + 1 > table.count(self.moveArr) then
        self.isWalk = false
        self:RefreshAnim()
        if self.isRotation then
          self.startRotation = self.transform.rotation
          self.endRotation = Quaternion.Euler(0, self.param.angle, 0)
          self.rotationTime = math.abs((self.param.angle - self.transform.rotation.eulerAngles.y) / RotationAngleSpeed)
        else
          self:CheckNext()
        end
      else
        self.walkIndex = self.walkIndex + 1
      end
    else
      self.transform.position = Vector3.Lerp(self.moveArr[self.walkIndex].startPos, self.moveArr[self.walkIndex].endPos, percent)
      if self.moveArr[self.walkIndex].startRotation ~= self.moveArr[self.walkIndex].endRotation then
        self.transform.rotation = Quaternion.Lerp(self.moveArr[self.walkIndex].startRotation, self.moveArr[self.walkIndex].endRotation, percent)
      end
    end
  elseif self.isRotation then
    self.curTime = self.curTime + Time.deltaTime
    local percent = self.curTime / self.rotationTime
    if 1 <= percent then
      self.curTime = 0
      self.transform.rotation = self.endRotation
      self.isRotation = false
      self:RefreshAnim()
      self:CheckNext()
    else
      self.transform.rotation = Quaternion.Lerp(self.startRotation, self.endRotation, percent)
    end
  end
  if self.isFollow then
    CS.SceneManager.World:Lookat(self.transform.position)
  end
end

function TankScene:GetPosition()
  return self.transform.position
end

function TankScene:CheckNext()
  self.isFollow = false
  if self.param.nextType == GuideNpcDoNextType.WaitWalk then
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil and template.type == GuideType.PlayMovie and tonumber(template.para1) == GuidePlayMovieType.TankScene then
      DataCenter.GuideManager:DoNext()
    end
  elseif self.param.nextType == GuideNpcDoNextType.WaitWalkDelete then
    DataCenter.GuideNeedLoadManager:DestroyTankScene()
  end
end

function TankScene:RefreshFollow()
  self.isFollow = self.param.follow
end

return TankScene
