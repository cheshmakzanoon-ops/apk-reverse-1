local base = require("DataCenter.BattleField.BattleAnim.BattleObj")
local BattleObjBuild = BaseClass("BattleObjBuild", base)
local WorldTroopLineWinter = require("DataCenter.WorldTroopLine.WorldTroopLineWinter")
local BattleBullet = require("DataCenter.BattleField.BattleAnim.BattleBullet")
local DOTween = CS.DG.Tweening.DOTween
local Resource = CS.GameEntry.Resource
local MyStrNull = string.IsNullOrEmpty
local MyRand = math.random
local MyTbInsert = table.insert
local WS_Aim = "WS_Aim_"
local WS_Line = "WS_Line_"
local WS_Bullet = "WS_Bullet_"
local WS_Boom = "WS_Boom_"
local Bullet_Height_Min = 3
local Bullet_Height_Max = 7

function BattleObjBuild:OnDestroy()
  if self.seqBulletFly ~= nil then
    self.seqBulletFly:Pause()
    self.seqBulletFly:Kill()
    self.seqBulletFly = nil
  end
  if self.seqRotation ~= nil then
    self.seqRotation:Pause()
    self.seqRotation:Kill()
    self.seqRotation = nil
  end
  if self.boomReqs ~= nil then
    for _, req in pairs(self.boomReqs) do
      req:Destroy()
    end
    self.boomReqs = {}
  end
  if self.aimReqs ~= nil then
    for _, req in pairs(self.aimReqs) do
      req:Destroy()
    end
    self.aimReqs = {}
  end
  if self.troopLines ~= nil then
    for _, line in pairs(self.troopLines) do
      line:Destroy()
      line:Delete()
    end
    self.troopLines = {}
  end
  if self.lineReqs ~= nil then
    for _, req in pairs(self.lineReqs) do
      req:Destroy()
    end
    self.lineReqs = {}
  end
  base.OnDestroy(self)
end

function BattleObjBuild:ReInit()
  base.ReInit(self)
  if self:BaseCheck() or not self.isBuild then
    return
  end
  local detailInfo = self.detailInfo
  local state = detailInfo.State
  self.attackSec = 0
  local occupied, bFixing
  if self.bfType == BattleFieldType.WinterStorm then
    occupied = state == WinterEntityState.Occupied
    bFixing = state == WinterEntityState.Fixing
  elseif self.bfType == BattleFieldType.EpidemicZone then
    occupied = state == EpidemicBuildState.Occupied
    bFixing = false
    if state == EpidemicBuildState.Normal then
      local openTime = detailInfo.OpenTime
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      if openTime > curTime then
        bFixing = true
      end
    end
  end
  local animStr
  if occupied then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local findTime = detailInfo.FindAimTime or 0
    local pis = self:GetTargetEnemyPointIndex()
    if pis == nil or #pis == 0 then
      animStr = BattleFieldObjActType.IDLE
    elseif curSec < findTime then
      animStr = BattleFieldObjActType.AIM
      self:RotationToTarget(self:GetUpPoint(), math.min(findTime - curSec, 0.5))
    else
      animStr = BattleFieldObjActType.ATK
      local clipL = 1
      if IsNotNull(self.animation) then
        clipL = self.animation:GetClipLength(animStr)
      end
      if curSec >= findTime + clipL then
        animStr = BattleFieldObjActType.AIM
      else
        self.attackSec = curSec
      end
      self:RotationToTarget(self:GetUpPoint(), 0)
    end
    self:ShowAllAimEff()
  else
    animStr = bFixing and BattleFieldObjActType.FIX or BattleFieldObjActType.IDLE
    self:HideAllAimEff()
  end
  if animStr == BattleFieldObjActType.IDLE and not MyStrNull(self.animStr) then
  else
    self:PlayAnim(animStr)
  end
  self:UpdateBaseRotation()
end

function BattleObjBuild:Update(curTime)
  if self.bullets then
    for _, v in pairs(self.bullets) do
      v:Update()
    end
  end
end

function BattleObjBuild:GetTargetEnemyPointIndex()
  if self:BaseCheck() then
    return nil
  end
  if self.ownerUid ~= nil then
    if self.skillTargetPId ~= nil then
      return {
        self.skillTargetPId
      }
    end
    return nil
  end
  local tarUuids = self.targetEnemyUUID
  if tarUuids == nil or tarUuids.Count == 0 then
    return nil
  end
  local infos = {}
  for i = 0, tarUuids.Count - 1 do
    local targetInfo = CS.SceneManager.World:GetPointInfoByUuid(tarUuids[i])
    if targetInfo ~= nil then
      MyTbInsert(infos, targetInfo.pointIndex)
    end
  end
  return infos
end

function BattleObjBuild:GetUpPoint()
  if IsNotNull(self.upPoint) then
    return self.upPoint.transform
  end
  return self.transform
end

function BattleObjBuild:PlayBullet()
  if self:BaseCheck() then
    return
  end
  local pis = self:GetTargetEnemyPointIndex()
  if pis == nil or #pis == 0 then
    return
  end
  for i, v in ipairs(pis) do
    self:DoPlayBullet(v, i)
  end
end

function BattleObjBuild:DoPlayBullet(targetPoint, idx)
  local buildId = self.detailInfo.BuildId
  local boom_effect = self.config.boom_effect
  local bulletEffect = self.config.bullet_effect
  if MyStrNull(bulletEffect) then
    local seq = DOTween.Sequence()
    seq:AppendInterval(self.config.attack_duration)
    
    function seq.onComplete()
      self.seqBulletFly = nil
      self:PlayBoomEff(buildId, boom_effect, targetPoint, idx)
    end
    
    self.seqBulletFly = seq
    return
  end
  self:CreateBullet(buildId, bulletEffect, boom_effect, targetPoint, idx)
end

function BattleObjBuild:CreateBullet(buildId, bulletEffect, boom_effect, targetPoint, idx)
  local request = Resource:InstantiateAsync(bulletEffect)
  request:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    local firePoint, bWorld = self:GetFirePointTF()
    if self:BaseCheck() or IsNull(go) or IsNull(firePoint) then
      req:Destroy()
      return
    end
    go.name = WS_Bullet .. buildId .. "_" .. idx
    local goTF = go.transform
    goTF:SetParent(CS.SceneManager.World.DynamicObjNode)
    local posFrom
    if bWorld then
      posFrom = SceneUtils.TileIndexToWorld(self.pointIndex, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
    else
      local pointTrans = firePoint.transform
      local px, py, pz = pointTrans:Get_localPosition()
      posFrom = pointTrans:TransformPoint(px, py, pz)
    end
    goTF:Set_localPosition(posFrom.x, posFrom.y, posFrom.z)
    self:PlayEff(go, true)
    local posTo = SceneUtils.TileIndexToWorld(targetPoint, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
    if 1 < idx then
      local random = MyRand(5, 10) / 10
      posTo.x = posTo.x + (MyRand(0, 1) and -1 or 1) * random
      posTo.z = posTo.z + (MyRand(0, 1) and -1 or 1) * random
    end
    local startV3 = Vector3.New(posFrom.x, posFrom.y, posFrom.z)
    local endV3 = Vector3.New(posTo.x, posTo.y, posTo.z)
    local curveTime = self.config.attack_duration
    if self.bullets == nil then
      self.bullets = {}
    end
    local bullet = self.bullets[idx]
    if bullet == nil then
      bullet = BattleBullet.New()
      self.bullets[idx] = bullet
    end
    local height
    if self.skillId == nil then
      height = MyRand(Bullet_Height_Min, Bullet_Height_Max)
    else
      height = 1
    end
    bullet:ReInit(req, startV3, endV3, curveTime, height, function()
      self.StopEff(go)
      if type(req.Destroy) == "function" then
        req:Destroy()
      end
      self:PlayBoomEff(buildId, boom_effect, targetPoint, idx)
    end)
  end)
end

function BattleObjBuild:PlayBoomEff(buildId, boom_effect, targetPoint, idx)
  if self:BaseCheck() or MyStrNull(boom_effect) then
    return
  end
  if self.boomReqs == nil then
    self.boomReqs = {}
  end
  local request = self.boomReqs[idx]
  if request ~= nil then
    if request.isDone then
      local _go = request.gameObject
      if IsNotNull(_go) then
        self:DoBoomEffPlay(_go, targetPoint)
      end
    end
    return
  end
  request = Resource:InstantiateAsync(boom_effect)
  self.boomReqs[idx] = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if type(req.Destroy) == "function" then
        req:Destroy()
      end
      self.boomReqs[idx] = nil
      return
    end
    _go.name = WS_Boom .. buildId .. "_" .. idx
    _go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    self:DoBoomEffPlay(_go, targetPoint)
  end)
end

function BattleObjBuild:DoBoomEffPlay(go, targetPoint)
  local worldPos = SceneUtils.TileIndexToWorld(targetPoint, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
  go.transform:Set_localPosition(worldPos.x, worldPos.y, worldPos.z)
  self:PlayEff(go)
end

function BattleObjBuild:RotationToTarget(transform, time)
  if self:BaseCheck() or IsNull(transform) then
    return
  end
  local pis = self:GetTargetEnemyPointIndex()
  if pis == nil or #pis == 0 then
    return
  end
  local pointIndex = pis[1]
  local px, py, pz = transform:Get_localPosition()
  local startV3 = transform:TransformPoint(px, py, pz)
  local targetPos = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
  local targetV3 = Vector3.New(targetPos.x, targetPos.y, targetPos.z)
  self:RotationToPos(transform, startV3, targetV3, time)
end

function BattleObjBuild:RotationToPos(transform, startV3, targetV3, time)
  local moveForward = Vector3.Normalize(targetV3 - startV3)
  local rotation = Quaternion.LookRotation(moveForward)
  if self.seqRotation ~= nil then
    self.seqRotation:Pause()
    self.seqRotation:Kill()
  end
  self.seqRotation = nil
  if rotation == nil then
    return
  end
  rotation.x = 0
  rotation.z = 0
  if time == 0 then
    transform.rotation = rotation
  end
  local seq = DOTween.Sequence()
  seq:Append(transform:DORotate(rotation.eulerAngles, time))
  
  function seq.onComplete()
    self.seqRotation = nil
  end
  
  self.seqRotation = seq
end

function BattleObjBuild:HideAllAimEff()
  local world = CS.SceneManager.World
  if world == nil or self:BaseCheck() then
    return
  end
  if not table.IsNullOrEmpty(self.aimReqs) then
    for _, req in pairs(self.aimReqs) do
      local aimEffObj = req ~= nil and req.gameObject or nil
      if IsNotNull(aimEffObj) then
        aimEffObj:SetActive(false)
      end
    end
  end
  if not table.IsNullOrEmpty(self.troopLines) then
    for _, line in pairs(self.troopLines) do
      if line ~= nil and IsNotNull(line.transform) and IsNotNull(line.transform.gameObject) then
        line.transform.gameObject:SetActive(false)
      end
    end
  end
end

function BattleObjBuild:ShowAllAimEff()
  if self:BaseCheck() then
    return
  end
  local pis = self:GetTargetEnemyPointIndex()
  if table.IsNullOrEmpty(pis) then
    self:HideAllAimEff()
    return
  end
  for i, pointIndex in ipairs(pis) do
    local targetPos = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
    self:InitLine(targetPos, i)
    self:InitAim(targetPos, i)
  end
end

function BattleObjBuild:InitLine(targetPos, idx)
  local line_effect = self.config.aim_line_effect
  if MyStrNull(line_effect) then
    return
  end
  if self.troopLines == nil then
    self.troopLines = {}
  end
  local tmpLine = self.troopLines[idx]
  local bMy
  if self.bfType == BattleFieldType.WinterStorm then
    bMy = self.detailInfo.Side == DataCenter.ActWinterStormManager:GetMySide()
  else
    bMy = self.detailInfo.Role == DataCenter.ActEpidemicZoneManager:GetCurRole()
  end
  if tmpLine ~= nil then
    self:ShowLine(tmpLine, targetPos, bMy)
    return
  end
  if self.lineReqs == nil then
    self.lineReqs = {}
  end
  if self.lineReqs[idx] ~= nil then
    return
  end
  local buildId = self.detailInfo.BuildId
  local request = Resource:InstantiateAsync(line_effect)
  self.lineReqs[idx] = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      req:Destroy()
      self.lineReqs[idx] = nil
      return
    end
    _go.name = WS_Line .. buildId .. "_" .. idx
    _go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    local troopLine = WorldTroopLineWinter.New(_go.transform)
    if troopLine ~= nil then
      self.troopLines[idx] = troopLine
      self:ShowLine(troopLine, targetPos, bMy)
    end
  end)
end

function BattleObjBuild:ShowLine(troopLine, targetPos, bMy)
  if troopLine == nil or troopLine.transform == nil or IsNull(troopLine.transform.gameObject) then
    return
  end
  troopLine.transform.gameObject:SetActive(true)
  troopLine:Clear()
  troopLine:SetColor(bMy)
  troopLine:SetScale(1)
  local startPos = SceneUtils.TileIndexToWorld(self.pointIndex, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
  local myV3 = Vector3.New(startPos.x, startPos.y, startPos.z)
  local tarV3 = Vector3.New(targetPos.x, targetPos.y, targetPos.z)
  troopLine:SetRotation(Vector3.Normalize(tarV3 - myV3))
  troopLine:InitStart(myV3)
  troopLine:InitEnd(tarV3)
  troopLine:UpdatePath(myV3)
end

function BattleObjBuild:InitAim(targetPos, idx)
  local aim_effect = self.config.aim_effect
  if MyStrNull(aim_effect) then
    return
  end
  if self.aimReqs == nil then
    self.aimReqs = {}
  end
  local request = self.aimReqs[idx]
  if request ~= nil then
    if request.isDone then
      local _go = request.gameObject
      if IsNotNull(_go) then
        self:ShowAim(_go, targetPos)
      end
    end
    return
  end
  local buildId = self.detailInfo.BuildId
  request = Resource:InstantiateAsync(aim_effect)
  self.aimReqs[idx] = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if type(req.Destroy) == "function" then
        req:Destroy()
      end
      self.aimReqs[idx] = nil
      return
    end
    _go.name = WS_Aim .. buildId .. "_" .. idx
    _go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    self:ShowAim(_go, targetPos)
  end)
end

function BattleObjBuild:ShowAim(aimEffObj, targetPos)
  aimEffObj.transform:Set_localPosition(targetPos.x, targetPos.y, targetPos.z)
  aimEffObj:SetActive(true)
end

return BattleObjBuild
