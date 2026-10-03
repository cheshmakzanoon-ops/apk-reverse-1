local CityNpc = BaseClass("CityNpc")
local Resource = CS.GameEntry.Resource
local RotationAnimTime = 0.2
local MovePerGridSpeed = 4
local RotationAngleSpeed = 540
local RotationDeltaX = 0.8
local RotationDeltaY = 0.45
local AnimName = {
  Idle = "idle",
  Walk = "walk",
  Cheer = "cheer"
}
local NpcFuncType = {Task = 1, Wounded = 2}

function CityNpc:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function CityNpc:OnDestroy()
  EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {
    target = self.transform
  })
  self:ComponentDestroy()
  self:DataDestroy()
end

function CityNpc:ComponentDefine()
  self.anim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
end

function CityNpc:ComponentDestroy()
  self.anim = nil
  self.gameObject = nil
  self.transform = nil
end

function CityNpc:DataDefine()
  self.param = nil
  self.isWalk = false
  self.walkIndex = 1
  
  function self.__update_handle()
    self:Update()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
  self.isFollow = false
  self.world = CS.SceneManager.World
  self.isRotation = false
  self.startRotation = nil
  self.endRotation = nil
  self.rotationTime = 0
  self.effect = {}
end

function CityNpc:DataDestroy()
  self:ClearEffect()
  self.param = nil
  self.isWalk = nil
  self.walkIndex = nil
  if self.__update_handle ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
  self.isFollow = nil
  self.world = nil
  self.isRotation = nil
  self.startRotation = nil
  self.endRotation = nil
  self.rotationTime = nil
  self.effect = {}
end

function CityNpc:ReInit(param)
  self.param = param
  self:ShowPanel()
  if self.param ~= nil then
    self:RefreshFollow()
    self:CheckShowBubble()
    if self.param.npcFuncType == NpcFuncType.Task then
      self:CheckShowTaskBubble()
    elseif self.param.npcFuncType == NpcFuncType.Wounded then
      self:CheckShowWoundedBubble()
    end
  end
end

function CityNpc:ShowPanel()
  if self.param.posArr ~= nil then
    local count = table.count(self.param.posArr)
    if count <= 1 then
      self.isWalk = false
      self:CheckNext()
    else
      self.moveArr = {}
      if count == 2 then
        local startPos = SceneUtils.TileToWorld(self.param.posArr[1])
        local endPos = SceneUtils.TileToWorld(self.param.posArr[2])
        local rotation, startNearPos, endNearPos = self:GetPathVec(startPos, endPos)
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
    if self.param ~= nil then
      self.transform.position = SceneUtils.TileToWorld(self.param.posArr[1])
    end
  end
  if self.param ~= nil then
    if self.param.angle ~= nil then
      self.curTime = 0
      self.isRotation = true
      self.startRotation = self.transform.rotation
      self.endRotation = Quaternion.Euler(0, self.param.angle, 0)
      self.rotationTime = math.abs((self.param.angle - self.transform.rotation.eulerAngles.y) / RotationAngleSpeed)
    else
      self.isRotation = false
    end
    self:RefreshAnim()
  end
end

function CityNpc:ChangeAnim(animName)
  self.param.animName = animName
  self:RefreshAnim()
end

function CityNpc:RefreshAnim()
  if self.isWalk then
    self.anim:Play(AnimName.Walk)
  elseif self.isRotation then
    self.anim:Play(AnimName.Idle)
  elseif self.param.animName ~= nil and self.param.animName ~= "" then
    if self.param.animName == AnimName.Cheer then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Guide_Get_New_Hero, false)
      self:ShowOneEffect()
    end
    self.anim:Play(self.param.animName)
    self.anim:PlayQueued(AnimName.Idle)
  else
    self.anim:Play(AnimName.Idle)
  end
end

function CityNpc:GetPathVec(startPos, endPos)
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

function CityNpc:Update()
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
    self.world:Lookat(self.transform.position)
  end
end

function CityNpc:GetPosition()
  return self.transform.position
end

function CityNpc:RefreshFollow()
  self.isFollow = self.param.follow
end

function CityNpc:CheckNext()
  if self.param.nextType == GuideNpcDoNextType.WaitWalk then
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil and template.type == GuideType.PrologueShowNpc and template.para2 == self.param.modelName then
      DataCenter.GuideManager:DoNext()
    end
  elseif self.param.nextType == GuideNpcDoNextType.WaitWalkDelete then
    DataCenter.CityNpcManager:RemoveOneNpc(self.param.modelName)
    CityPioneerArchive:GetInstance():Save()
  end
end

function CityNpc:CheckShowBubble()
  local info = DataCenter.HeroEntrustManager:GetHeroEntrustByNpcName(self.param.modelName)
  if info ~= nil and not info:IsAllComplete() then
    local talkParam = {}
    talkParam.talkType = NpcTalkType.HeroEntrust
    talkParam.target = self.transform
    talkParam.offset = Vector3.New(0, 1, 0)
    talkParam.id = info.id
    DataCenter.HeroEntrustBubbleManager:AddOneHeroEntrustBubble(talkParam)
  end
end

function CityNpc:CheckShowTaskBubble()
  if self.param.npcFuncType == NpcFuncType.Task then
    local quest_earlyId = LuaEntry.DataConfig:TryGetNum("quest_pre", "k1")
    local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
    local allNum = DataCenter.ChapterTaskManager:GetAllNum()
    if 0 < allNum and quest_earlyId > chapterId then
      return
    else
      local param = {}
      param.target = self.transform
      param.offset = Vector3.New(0, 1, 0)
      DataCenter.NpcTaskBubbleManager:UpdateTaskBubble(param)
    end
  end
end

function CityNpc:CheckShowWoundedBubble()
  if self.param.npcFuncType == NpcFuncType.Wounded then
    local param = {}
    param.target = self.transform
    param.offset = Vector3.New(0, 1, 0)
    DataCenter.WoundedCompensateManager:UpdateWoundedBubble(param)
  end
end

function CityNpc:ShowOneEffect()
  local id = NameCount
  NameCount = NameCount + 1
  local param = {}
  self.effect[id] = param
  local request = Resource:InstantiateAsync(string.format(UIAssets.BuildUpgradeCompleteEffect, 1))
  param.request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform.position = self.transform.position
  end)
  param.timer = TimerManager:DelayInvoke(function()
    param.timer:Stop()
    self.effect[id] = nil
    param.request:Destroy()
  end, 5)
end

function CityNpc:ClearEffect()
  for k, v in pairs(self.effect) do
    v.timer:Stop()
    v.request:Destroy()
  end
  self.effect = {}
end

return CityNpc
