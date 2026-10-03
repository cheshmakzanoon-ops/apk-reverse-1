local base = UIBaseContainer
local DispatchTreasureCurveAnimNode = BaseClass("DispatchTreasureCurveAnimNode", base)
local TargetPointContent_path = "TargetPointContent"
local PlayerPoint_path = "PlayerPoint"
local CtrlPoint_path = "CtrlPoint"
local TargetImg_path = "TargetImg"
local CircleImg_path = "PathContent/CircleImg"
local MapScale = 0.65
local FullMoveTime = 1.3
local CheckDisTimeStep = 0
local CheckDistance = 20

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:DataDefine()
end

local function OnDisable(self)
  if self.CircleImgObj then
    self.CircleImgObj:GameObjectRecycleAll()
  end
  self:DataDestroy()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.TargetPointContent = self:AddComponent(UIBaseContainer, TargetPointContent_path)
  self.PlayerPoint = self:AddComponent(UIBaseContainer, PlayerPoint_path)
  self.CtrlPoint = self:AddComponent(UIBaseContainer, CtrlPoint_path)
  self.TargetImg = self:AddComponent(UIImage, TargetImg_path)
  self.CircleImg = self:AddComponent(UIImage, CircleImg_path)
  self.targetPoints = {}
  local targetContentTrans = self.TargetPointContent.transform
  local childCount = targetContentTrans.childCount
  for i = 0, childCount - 1 do
    local trans = targetContentTrans:GetChild(i)
    local comp = self.TargetPointContent:AddComponent(UIBaseComponent, trans.gameObject)
    table.insert(self.targetPoints, comp)
  end
  self.CircleImgObj = self.CircleImg.gameObject
  self.CircleImgObj:SetActive(false)
  self.CircleImgObj:GameObjectCreatePool()
  self.CircleParentTrans = self.CircleImgObj.transform.parent
end

local function ComponentDestroy(self)
  self.TargetPointContent = nil
  self.PlayerPoint = nil
  self.CtrlPoint = nil
  self.TargetImg = nil
  self.CircleImg = nil
  self.targetPoints = nil
  self.CircleImgObj = nil
end

local function DataDefine(self)
  self.ownPos = nil
  self.targetPos = nil
  self.ctrlPos = nil
  self.endCallback = nil
  self.moveTime = 0
  self.finshedAnim = true
  self.deltaTime = 0
  self.deltaDis = 0
  self.lastPos = Vector2.zero
  self.circleIndex = 0
end

local function DataDestroy(self)
  self.ownPos = nil
  self.targetPos = nil
  self.ctrlPos = nil
  self.endCallback = nil
  self.moveTime = nil
  self.finshedAnim = nil
  self.deltaTime = nil
  self.deltaDis = nil
  self.lastPos = nil
  self.circleIndex = nil
end

local function ShowCurveAnim(self, endCallback)
  self.endCallback = endCallback
  self.ownPos = Vector2.zero
  local pointInfo = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  if pointInfo then
    self.ownPos.x = pointInfo.x * MapScale * CommonUtil.ArabicAutoMirrorFactor()
    self.ownPos.y = pointInfo.y * MapScale
  end
  self.PlayerPoint:SetAnchoredPosition(self.ownPos)
  local targetPoint = self:GetRandomTargetPoint()
  self.targetPos = targetPoint:GetAnchoredPosition()
  self.ctrlPos = self:GetRandomCtrlPos(self.ownPos, self.targetPos)
  self.CtrlPoint:SetAnchoredPosition(self.ctrlPos)
  self.moveTime = 0
  self.finshedAnim = false
  self.deltaTime = 0
  self.deltaDis = 0
  self.lastPos = self.ownPos
  self.circleIndex = 0
  self:CreateCircleImg(self.ownPos)
  self.TargetImg:SetAnchoredPosition(self.targetPos)
  self.TargetImg:SetActive(true)
end

local function GetRandomCtrlPos(self, pos1, pos2)
  local halfPos = (pos1 + pos2) * 0.5
  local randomX = math.random(1, 2)
  local randomY = math.random(1, 2)
  local RandomCtrlMinValue = 100
  local RandomCtrlMaxValue = 200
  local randomPosX = 0
  if randomX == 1 then
    randomPosX = math.random(RandomCtrlMinValue, RandomCtrlMaxValue)
  else
    randomPosX = math.random(-RandomCtrlMaxValue, -RandomCtrlMinValue)
  end
  local randomPosY = 0
  if randomY == 1 then
    randomPosY = math.random(RandomCtrlMinValue, RandomCtrlMaxValue)
  else
    randomPosY = math.random(-RandomCtrlMaxValue, -RandomCtrlMinValue)
  end
  return Vector2.New(halfPos.x + randomPosX, halfPos.y + randomPosY)
end

local function GetRandomTargetPoint(self)
  local point = self.targetPoints[1]
  local minIndex = 1
  local minDis = Vector2.Distance(point:GetAnchoredPosition(), self.ownPos)
  for i = 2, #self.targetPoints do
    local dis = Vector2.Distance(self.targetPoints[i]:GetAnchoredPosition(), self.ownPos)
    if minDis > dis then
      minDis = dis
      minIndex = i
    end
  end
  local randomPoints = {}
  for i = 1, #self.targetPoints do
    if i ~= minIndex then
      table.insert(randomPoints, self.targetPoints[i])
    end
  end
  local randomIndex = math.random(1, #randomPoints)
  return randomPoints[randomIndex]
end

local function CalculateCubicBezierPointFor2C(self, t)
  local p0 = self.ownPos
  local p1 = self.ctrlPos
  local p2 = self.targetPos
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

local function OnFinshAnim(self)
  print("Finsh moveAnim")
  self.moveTime = 0
  self.finshedAnim = true
  self.CircleImgObj:GameObjectRecycleAll()
  if self.endCallback then
    self.endCallback()
    self.endCallback = nil
  end
end

local function CreateCircleImg(self, anchorPos)
  local goItem = self.CircleImgObj:GameObjectSpawn(self.CircleImgObj.transform.parent)
  goItem.name = "CirecleImg" .. self.circleIndex
  self.circleIndex = self.circleIndex + 1
  local rectTrans = goItem:GetComponent(typeof(CS.UnityEngine.RectTransform))
  rectTrans:Set_anchoredPosition(anchorPos.x * CommonUtil.ArabicAutoMirrorFactor(), anchorPos.y)
  goItem:SetActive(true)
end

local function Update(self)
  if self.finshedAnim or self.moveTime == nil then
    return
  end
  if self.moveTime > FullMoveTime then
    self:OnFinshAnim()
    return
  end
  self.moveTime = self.moveTime + Time.deltaTime
  self.deltaTime = self.deltaTime + Time.deltaTime
  if self.deltaTime > CheckDisTimeStep then
    self.deltaTime = 0
    local bezierPos = self:CalculateCubicBezierPointFor2C(self.moveTime / FullMoveTime)
    local dis = Vector2.Distance(self.lastPos, bezierPos)
    self.deltaDis = self.deltaDis + dis
    self.lastPos = bezierPos
    if self.deltaDis > CheckDistance then
      self.deltaDis = 0
      self:CreateCircleImg(bezierPos)
    end
  end
end

DispatchTreasureCurveAnimNode.OnCreate = OnCreate
DispatchTreasureCurveAnimNode.OnDestroy = OnDestroy
DispatchTreasureCurveAnimNode.OnEnable = OnEnable
DispatchTreasureCurveAnimNode.OnDisable = OnDisable
DispatchTreasureCurveAnimNode.ComponentDefine = ComponentDefine
DispatchTreasureCurveAnimNode.ComponentDestroy = ComponentDestroy
DispatchTreasureCurveAnimNode.DataDefine = DataDefine
DispatchTreasureCurveAnimNode.DataDestroy = DataDestroy
DispatchTreasureCurveAnimNode.ShowCurveAnim = ShowCurveAnim
DispatchTreasureCurveAnimNode.GetRandomTargetPoint = GetRandomTargetPoint
DispatchTreasureCurveAnimNode.GetRandomCtrlPos = GetRandomCtrlPos
DispatchTreasureCurveAnimNode.CalculateCubicBezierPointFor2C = CalculateCubicBezierPointFor2C
DispatchTreasureCurveAnimNode.OnFinshAnim = OnFinshAnim
DispatchTreasureCurveAnimNode.CreateCircleImg = CreateCircleImg
DispatchTreasureCurveAnimNode.Update = Update
return DispatchTreasureCurveAnimNode
