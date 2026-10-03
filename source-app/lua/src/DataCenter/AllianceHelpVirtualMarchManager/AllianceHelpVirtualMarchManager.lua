local AllianceHelpVirtualMarchManager = BaseClass("AllianceHelpVirtualMarchManager")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local UPDATE_TIMER_DELTATIME = 0.03
local VirtualMarch = DataClass("VirtualMarchData", VirtualMarchParam)
local VirtualMarchParam = {
  memberInfo = {},
  startPointV3 = Vector3.New(0, 0, 0),
  endPointV3 = Vector3.New(0, 0, 0),
  troopIns = nil,
  speed = 1,
  troopAnim = nil,
  dir = nil,
  isReached = false
}

local function __init(self)
  self:AddListener()
  self.updateTimer = nil
  self.marchSpeed = nil
  self.virtualMarchesArr = {}
  self.myBasePointV3 = nil
  self.hasStarted = nil
  self.alMemberArr = {}
  self.enemyInfo = {}
  self.isLogin = nil
  self.virtualMemberList = {}
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function __delete(self)
  self:RemoveListener()
  self:DeleteTimer()
  self.updateTimer = nil
  self.marchSpeed = nil
  self.virtualMarchesArr = nil
  self.myBasePointV3 = nil
  self.hasStarted = nil
  self.alMemberArr = nil
  self.enemyInfo = nil
  self.isLogin = nil
end

local function TestVirtualMarch(self)
  local member1 = {
    name = "member1",
    pointId = 41749949,
    alAbbr = "mem"
  }
  local member2 = {
    name = "member2",
    pointId = 1774624,
    alAbbr = "mem"
  }
  local member3 = {
    name = "member3",
    pointId = 40290749,
    alAbbr = "mem"
  }
  local tb = {}
  table.insert(tb, member1)
  table.insert(tb, member2)
  table.insert(tb, member3)
  local testEnemy = {
    name = "enemy",
    pointId = 40290749,
    alAbbr = "ene"
  }
  self:OnGetDefenceFailInfo(tb, testEnemy, true)
end

local function OnGetDefenceFailInfo(self, alMemberList, enemyInfo, isLogin)
  self.alMemberArr = alMemberList
  self.enemyInfo = enemyInfo
  self.isLogin = isLogin
  self.hasMessage = true
  if isLogin then
    if LuaEntry.Player:GetMainWorldPos() <= 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDefenceFailTip, enemyInfo.alAbbr, enemyInfo.name)
    end
  else
    self:ShowVirtualMarches()
  end
end

local function ShowVirtualMarches(self)
  self:CreateMarches(self.alMemberArr)
  if not self.updateTimer then
    self.updateTimer = TimerManager:GetInstance():GetTimer(UPDATE_TIMER_DELTATIME, self.TimerAction, self, false, false, false)
    self.updateTimer:Start()
  end
end

local function CreateMarches(self)
  self.virtualMemberList = {}
  for i, v in ipairs(self.alMemberArr) do
    self:CreateTroop(v)
  end
end

local function CreateTroop(self, memberInfo)
  local request = ResourceManager:InstantiateAsync(CS.GameDefines.EntityAssets.WorldVirtualTroop)
  request:completed("+", function()
    if request.isError then
      return
    end
    local newMarch = VirtualMarch.New()
    newMarch.memberInfo = memberInfo
    newMarch.startPointV3 = self:GetStartPointV3(memberInfo)
    newMarch.endPointV3 = self:GetEndPointV3()
    local deltaV3 = {}
    deltaV3.x = newMarch.endPointV3.x - newMarch.startPointV3.x
    deltaV3.y = newMarch.endPointV3.y - newMarch.startPointV3.y
    deltaV3.z = newMarch.endPointV3.z - newMarch.startPointV3.z
    newMarch.dir = Vector3.Normalize(deltaV3)
    newMarch.speed = self:GetMarchSpeed()
    newMarch.troopIns = request.gameObject
    newMarch.troopName = request.gameObject.transform:GetComponentInChildren(typeof(CS.SuperTextMesh))
    local realName = "[" .. memberInfo.alAbbr .. "] " .. memberInfo.name
    newMarch.troopName.text = realName
    newMarch.troopName.color32 = WorldBlueColor32
    newMarch.troopAnim = request.gameObject.transform:GetComponentInChildren(typeof(CS.GPUSkinningAnimator))
    if not newMarch.troopAnim then
      newMarch.troopAnim = request.gameObject.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    end
    self:CreateTroopLine(newMarch)
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.name = memberInfo.name
    table.insert(self.virtualMarchesArr, newMarch)
    self:InitTroop(newMarch)
    self:AddIntoVirtualList(realName, newMarch.startPointV3, newMarch.endPointV3, newMarch.speed)
  end)
end

local function CreateTroopLine(self, virtualMarch)
  if virtualMarch.troopLine == nil then
    local request = ResourceManager:InstantiateAsync(CS.GameDefines.EntityAssets.TroopLine)
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      local troopLine = request.gameObject:GetComponent(typeof(CS.WorldTroopLine))
      if troopLine ~= nil then
        troopLine:SetColor(Color.New(0.39, 0.58, 0.94, 1))
        virtualMarch.troopLine = troopLine
        troopLine:SetStraightMovePath(virtualMarch.startPointV3, virtualMarch.endPointV3)
      end
    end)
  else
    virtualMarch.troopLine:SetStraightMovePath(virtualMarch.startPointV3, virtualMarch.endPointV3)
  end
end

local function TimerAction(self)
  local allReached = true
  for i, v in ipairs(self.virtualMarchesArr) do
    if not v.isReached then
      allReached = false
      local tempX = v.speed * v.dir.x * UPDATE_TIMER_DELTATIME
      local tempY = v.speed * v.dir.y * UPDATE_TIMER_DELTATIME
      local tempZ = v.speed * v.dir.z * UPDATE_TIMER_DELTATIME
      local tempOffset = Vector3.New(tempX, tempY, tempZ)
      if v.troopIns then
        local tempPos = v.troopIns.transform.position
        v.troopIns.transform.position = tempPos + tempOffset
      end
      if v.troopLine then
        v.troopLine:SetStraightMovePath(v.troopIns.transform.position, v.endPointV3)
      end
      if Vector3.Distance(v.troopIns.transform.position, v.endPointV3) < 1 then
        v.isReached = true
        v.troopIns:SetActive(false)
      end
    end
  end
  if #self.virtualMarchesArr > 0 and allReached then
    self:DeleteTimer()
    self:DestoryAllTroops()
  end
end

local function InitTroop(self, virtualMarch)
  virtualMarch.troopIns.transform.position = virtualMarch.startPointV3
  local dir = Vector3.New(virtualMarch.endPointV3.x - virtualMarch.startPointV3.x, virtualMarch.endPointV3.y - virtualMarch.startPointV3.y, virtualMarch.endPointV3.z - virtualMarch.startPointV3.z)
  virtualMarch.troopIns.transform.rotation = Quaternion.LookRotation(dir, Vector3.New(0, 1, 0))
  if virtualMarch.troopIns and virtualMarch.troopAnim then
    virtualMarch.troopAnim:Play("run")
  end
end

local function GetStartPointV3(self, memberInfo)
  local tempSpeed = self:GetMarchSpeed() * CS.SceneManager.World.TileSize
  local point1 = self:GetEndPointV3()
  local point2 = SceneUtils.TileIndexToWorld(memberInfo.pointId)
  local str = LocalController:instance():getStrValue("subsidy", 1, "arrival_time")
  local randTimesArr = string.split(str, "|")
  local timeIndex = math.random(1, #randTimesArr)
  local tempTime = tonumber(randTimesArr[timeIndex]) or 5
  local deltaV3 = {}
  deltaV3.x = point2.x - point1.x
  deltaV3.y = point2.y - point1.y
  deltaV3.z = point2.z - point1.z
  local startPointV3Offset = Vector3.Normalize(deltaV3) * tempTime * tempSpeed
  local startPointV3 = {}
  startPointV3.x = startPointV3Offset.x + point1.x
  startPointV3.y = startPointV3Offset.y + point1.y
  startPointV3.z = startPointV3Offset.z + point1.z
  return startPointV3
end

local function GetEndPointV3(self)
  if not self.myBasePointV3 then
    local mainData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if mainData ~= nil then
      self.myBasePointV3 = SceneUtils.TileIndexToWorld(mainData.pointId)
    end
  end
  return self.myBasePointV3
end

local function GetMarchSpeed(self)
  if not self.marchSpeed then
    self.marchSpeed = LuaEntry.DataConfig:TryGetNum("armyspeed", "k3")
  end
  return self.marchSpeed
end

local function DeleteTimer(self)
  if self.updateTimer ~= nil then
    self.updateTimer:Stop()
    self.updateTimer = nil
  end
end

local function DestoryAllTroops(self)
  for i, v in ipairs(self.virtualMarchesArr) do
    if v and v.troopIns then
      if v.troopIns then
        v.troopIns:Destroy()
      end
      if v.troopLine then
        v.troopLine.gameObject:Destroy()
      end
    end
  end
  self.virtualMarchesArr = {}
  self.hasMessage = false
  self.virtualMemberList = {}
  EventManager:GetInstance():Broadcast(EventId.NoticeMainViewUpdateMarch)
end

local function HasVirtualMarch(self)
  if self.hasMessage ~= nil then
    return self.hasMessage
  end
  return false
end

local function AddIntoVirtualList(self, name, startPos, endPos, speed)
  local oneData = {}
  oneData.isVirtual = true
  oneData.leftName = name
  oneData.rightName = ""
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
  if buildTemplate ~= nil then
    oneData.rightName = Localization:GetString(buildTemplate.name)
  end
  local distance = Vector3.Distance(startPos, endPos)
  local time = distance / speed
  local curTime = UITimeManager:GetInstance():GetServerTime()
  oneData.endTime = curTime + time * 1000
  table.insert(self.virtualMemberList, oneData)
  if #self.virtualMemberList >= table.count(self.alMemberArr) then
    EventManager:GetInstance():Broadcast(EventId.NoticeMainViewUpdateMarch)
  end
end

local function GetVirtualMemberList(self)
  return self.virtualMemberList
end

AllianceHelpVirtualMarchManager.__init = __init
AllianceHelpVirtualMarchManager.AddListener = AddListener
AllianceHelpVirtualMarchManager.RemoveListener = RemoveListener
AllianceHelpVirtualMarchManager.__delete = __delete
AllianceHelpVirtualMarchManager.OnGetDefenceFailInfo = OnGetDefenceFailInfo
AllianceHelpVirtualMarchManager.ShowVirtualMarches = ShowVirtualMarches
AllianceHelpVirtualMarchManager.CreateMarches = CreateMarches
AllianceHelpVirtualMarchManager.CreateTroop = CreateTroop
AllianceHelpVirtualMarchManager.TimerAction = TimerAction
AllianceHelpVirtualMarchManager.InitTroop = InitTroop
AllianceHelpVirtualMarchManager.GetStartPointV3 = GetStartPointV3
AllianceHelpVirtualMarchManager.GetEndPointV3 = GetEndPointV3
AllianceHelpVirtualMarchManager.GetMarchSpeed = GetMarchSpeed
AllianceHelpVirtualMarchManager.DeleteTimer = DeleteTimer
AllianceHelpVirtualMarchManager.DestoryAllTroops = DestoryAllTroops
AllianceHelpVirtualMarchManager.TestVirtualMarch = TestVirtualMarch
AllianceHelpVirtualMarchManager.CreateTroopLine = CreateTroopLine
AllianceHelpVirtualMarchManager.HasVirtualMarch = HasVirtualMarch
AllianceHelpVirtualMarchManager.AddIntoVirtualList = AddIntoVirtualList
AllianceHelpVirtualMarchManager.GetVirtualMemberList = GetVirtualMemberList
return AllianceHelpVirtualMarchManager
