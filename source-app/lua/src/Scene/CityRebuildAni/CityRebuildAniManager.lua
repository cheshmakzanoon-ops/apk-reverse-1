local CityRebuildAniManager = BaseClass("CityRebuildAniManager", CEventable)
local BuildHelpNpcData = require("Scene.BuildHelpNpc.BuildHelpNpcData")
local BuildHelpNpcUnit = require("Scene.CityRebuildAni.RebuildHelpNpcUnit")
local BuildHelpNpcGroup = require("Scene.BuildHelpNpc.BuildHelpNpcGroup")
local p_entryPath = "ModelGo/point/p_entry"
local p_exitPath = "ModelGo/point/p_exit"
local CameraToWallTime = 4
local FirePersonBornTime = 3
local CameraToHospitalTime = 1.5
local HospitalAniTimeDelay = 2
local BornNurseNumber = 5
local UnitSpeed = 8
local everyOneTime = 0.5
local HospitalEffectDelayTime = 1.5
local AfterCelebrateReleaseTime = 2
local SUMTIME = 18
local EndTimePop = 3
local oneSecond = 1000
local NurseOffsetZ = 5

local function __init(self)
  self.needAddNpcList = {}
  self.npcModelList = {}
  self.cd = 0
  self.helpNpcGroupDict = {}
  self:AddListener()
end

local function Startup(self)
  self.unitSpeed = UnitSpeed
end

local function __delete(self)
  self:RemoveUpdateTimer()
  self:ClearAllModel()
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  if self.delayTimeFire then
    self.delayTimeFire:Stop()
    self.delayTimeFire = nil
  end
  if self.delayTimeRelease then
    self.delayTimeRelease:Stop()
    self.delayTimeRelease = nil
  end
  if self.delayTimePlayFireNext then
    self.delayTimePlayFireNext:Stop()
    self.delayTimePlayFireNext = nil
  end
  self.needAddNpcList = nil
  self.npcModelList = nil
  self.helpNpcGroupDict = nil
  self.march = nil
  self.startTime = nil
  self.lastTime = nil
  self.count = nil
  self.index = nil
  self.hangUpBuild = nil
  self.playOne = nil
  self.playTwo = nil
  self.playFire = nil
  self.playHospitalAni = nil
  self.gotoHospital = nil
end

local function InitCarAndNpc(self)
  self:AddUpdateTimer()
end

local function AddUpdateTimer(self)
  self:RemoveUpdateTimer()
  UIManager:GetInstance():SetUIMainEnable(false)
  self.unitSpeed = UnitSpeed
  self.startTime = UITimeManager:GetInstance():GetServerTime()
  self.lastTime = self.startTime
  self.count = 0
  self.index = 0
  self.buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILD_HOSPITL)
  self.hangUpBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD)
  if self.hangUpBuild then
    DataCenter.BuildBubbleManager:CheckShowBubble(self.hangUpBuild.uuid)
  end
  self.playOne = false
  self.playTwo = false
  self.playFire = false
  self.playHospitalAni = DataCenter.CityRebuildDataManager:GetCureState()
  self.gotoHospital = true
  self:GetFirePosList()
  self.march = DataCenter.CityRebuildDataManager:GetMarchInfo()
  DataCenter.LWGateTruckGoodsManager:SetBuildObjState(false)
  DataCenter.CityRebuildCarManager:OnInitCar()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdatePlayAni()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

local function RemoveUpdateTimer(self)
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

local function OnUpdatePlayAni(self)
  local deltaTime = UITimeManager:GetInstance():GetServerTime()
  if not self.playOne then
    local wall = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILD_GATE)
    local toPos
    if wall then
      toPos = wall:GetCenterVec()
    end
    GoToUtil.GotoPos(toPos, CS.SceneManager.World.InitZoom, CameraToWallTime, function()
      if self.delayTimeFire then
        self.delayTimeFire:Stop()
        self.delayTimeFire = nil
      end
      self.delayTimeFire = TimerManager:GetInstance():DelayInvoke(function()
        for key, value in pairs(self.firePosList) do
          DataCenter.BuildHelpStopFireManager:ShowEffectByRebuild(key, value)
        end
        DataCenter.CityRebuildDataManager:SendStopCityFireMessage()
        if not self.playHospitalAni then
          self.delayTimeRelease = TimerManager:GetInstance():DelayInvoke(function()
            self:EndAnimator()
          end, EndTimePop)
        end
        self.delayTimePlayFireNext = TimerManager:GetInstance():DelayInvoke(function()
          self.playFire = true
        end, HospitalAniTimeDelay)
      end, FirePersonBornTime)
    end)
    self.playOne = true
  elseif not self.playTwo and self.playHospitalAni and self.playFire then
    if self.gotoHospital then
      local toPos
      if self.buildData then
        toPos = self.buildData:GetCenterVec()
      end
      GoToUtil.GotoPos(toPos, CS.SceneManager.World.InitZoom, CameraToHospitalTime, function()
        self:HideOrShowBubbleTip(false)
      end)
      self.gotoHospital = false
    end
    if deltaTime - self.lastTime > everyOneTime * oneSecond and self.count < BornNurseNumber then
      self.lastTime = deltaTime
      self.count = self.count + 1
      if self.march and #self.march >= self.count then
        self.march[self.count].picVer = self.march[self.count].picver
        self:AddHelpNpc(self.buildData.uuid, self.march[self.count], nil, self.march[self.count].name)
      else
        self:AddHelpNpc(self.buildData.uuid, nil, nil, nil)
      end
    end
    if self.count >= BornNurseNumber then
      self.playTwo = true
    end
  end
  if self.playHospitalAni and not self.playTwo then
    self:HideOrShowBubbleTip(false)
  end
  if self.needAddNpcList and #self.needAddNpcList > 0 then
    local data = table.remove(self.needAddNpcList, 1)
    self:CreatedBuildHelpModel(data)
  end
end

local function PlayHospitalAni(self)
  if self.playTwo and self.buildData then
    self:ShowBuildHospitalEffect(self.buildData.pointId)
    self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
      self:HideOrShowBubbleTip(true)
      self.delayTimeRelease = TimerManager:GetInstance():DelayInvoke(function()
        self:EndAnimator()
      end, AfterCelebrateReleaseTime)
    end, HospitalEffectDelayTime)
  end
end

local function EndAnimator(self)
  DataCenter.CityRebuildDataManager:SetRebuildRewardInfoNull()
  if self.hangUpBuild then
    DataCenter.BuildBubbleManager:CheckShowBubble(self.hangUpBuild.uuid)
  end
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  local alliance = DataCenter.CityRebuildDataManager:GetAllianceInfoInfo()
  if alliance and alliance.uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceInvite, alliance.uid)
  end
  UIManager:GetInstance():SetUIMainEnable(true)
  DataCenter.CityRebuildDataManager:FlyReward()
  self:RemoveUpdateTimer()
  self:HideBuildHospitalEffect(self.buildData.pointId)
  self.buildData = nil
  self.__blockerHandleID = nil
  self:ClearAllModel()
  DataCenter.LWGateTruckGoodsManager:SetBuildObjState(true)
  DataCenter.CityRebuildCarManager:OnReleaseCity()
  self:Delete()
end

local function HideOrShowBubbleTip(self, show)
  local list = DataCenter.BuildManager:GetFunbuildListByItemID(BuildingTypes.LW_BUILD_HOSPITL)
  local hide = false
  if list then
    for key, value in ipairs(list) do
      if show then
        DataCenter.BuildBubbleManager:ShowPastureBubble(value.uuid)
      else
        hide = DataCenter.BuildBubbleManager:HidePastureBubbleWithShow(value.uuid)
      end
    end
  end
  return hide
end

local function ShowBuildHospitalEffect(self, pointId)
  if IsNull(CS.SceneManager.World) then
    return
  end
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(pointId)
  if cityObj then
    local effectTime = cityObj.gameObject.transform:Find("ModelGo/QJParent")
    if effectTime then
      effectTime.gameObject:SetActive(true)
    end
  end
end

local function HideBuildHospitalEffect(self, pointId)
  if IsNull(CS.SceneManager.World) then
    return
  end
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(pointId)
  if cityObj then
    local effectTime = cityObj.gameObject.transform:Find("ModelGo/QJParent")
    if effectTime then
      effectTime.gameObject:SetActive(false)
    end
  end
end

local function GetPosList(startPos, endPos)
  local posList = DataCenter.InnerCityMapManager:FindPath(startPos, endPos)
  if posList then
    if #posList == 0 then
      table.insert(posList, startPos)
      table.insert(posList, endPos)
    elseif 2 < #posList then
      table.remove(posList, 1)
      table.insert(posList, 1, startPos)
      table.remove(posList, #posList)
      table.insert(posList, #posList + 1, endPos)
    end
  else
    posList = {}
    table.insert(posList, startPos)
    table.insert(posList, endPos)
  end
  return posList
end

local function AddListener(self)
end

local function BeforeReleaseCity(self)
  self:ClearAllModel()
end

local function ClearAllModel(self)
  self.needAddNpcList = {}
  for i = 1, #self.npcModelList do
    if self.npcModelList[i] then
      self.npcModelList[i]:Delete()
    end
  end
  self.npcModelList = {}
  for k, v in pairs(self.helpNpcGroupDict) do
    v:Delete()
  end
  self.helpNpcGroupDict = {}
end

local function AddHelpNpc(self, buildUUid, playerHead, helperSysName, helpName)
  if not CS.SceneManager:IsInCity() then
    return
  end
  local buildUUid = buildUUid
  local allianceCenter = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ALLIANCE_CENTER)
  if not allianceCenter or buildUUid == allianceCenter.uid then
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUUid)
  if buildData == nil then
    return
  end
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  if buildDesTemplate == nil or string.IsNullOrEmpty(buildDesTemplate.helpBuildAniPath) then
    return
  end
  local data = BuildHelpNpcData:New()
  data:InitData(self:GetBulidExitPos(allianceCenter), self:GetBulidEntryPos(buildData), UIAssets.RebuildNursePlayers, playerHead, helperSysName, helpName)
  table.insert(self.needAddNpcList, data)
end

local function CreatedBuildHelpModel(self, data)
  local unit = BuildHelpNpcUnit:New()
  if Vector3.Distance(data.birthPos, data.endPos) <= 0.001 then
    if data.arriveCallBack then
      data.arriveCallBack()
    end
  else
    local posList = GetPosList(data.birthPos, data.endPos)
    data.posList = posList
    data.speed = self.unitSpeed
    
    function data.arriveCallBack()
      self.index = self.index + 1
      if self.index == self.count then
        self:PlayHospitalAni()
      else
      end
    end
    
    unit:SetData(data)
    unit:CreateModel()
    table.insert(self.npcModelList, unit)
  end
end

local function GetBulidEntryPos(self, buildData)
  local pos = Vector3.New(0, 0, 0)
  if buildData then
    local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
    if cityObj and cityObj.gameObject then
      local cityTrans = cityObj.gameObject.transform
      local entry = cityTrans:Find(p_entryPath)
      if entry then
        pos = entry.position
      else
        pos = cityTrans.position
      end
    end
  end
  pos = pos + Vector3.New(0, 0, NurseOffsetZ)
  return pos
end

local function GetBulidExitPos(self, buildData)
  if not buildData then
    return Vector3.New(0, 0, 0)
  end
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
  if cityObj then
    return cityObj.gameObject.transform:Find(p_exitPath).position
  end
  return Vector3.New(0, 0, 0)
end

local function RefreshHelpNpcGroup(self, bUuid, shownum, isFinish)
  if not CS.SceneManager:IsInCity() then
    return
  end
  if bUuid == nil then
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil then
    self:RemoveHelpNpcGroup(bUuid)
    return
  end
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  if buildDesTemplate == nil or string.IsNullOrEmpty(buildDesTemplate.helpBuildAniPath) then
    self:RemoveHelpNpcGroup(bUuid)
    return
  end
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
  local upGradeTrans
  if cityObj then
    local upGradeObj = cityObj:GetUpgradeObj()
    upGradeTrans = upGradeObj.transform
  end
  if upGradeTrans == nil then
    self:RemoveHelpNpcGroup(bUuid)
    return
  end
  local showNum = 4
  if shownum then
    showNum = shownum
  end
  if 0 < showNum then
    local prefabPath = buildDesTemplate.helpBuildAniPath
    local parent = upGradeTrans
    local buildHelpNpcGroup = self.helpNpcGroupDict[bUuid]
    if buildHelpNpcGroup and (buildHelpNpcGroup.prefabPath ~= prefabPath or buildHelpNpcGroup.parent ~= parent) then
      self:RemoveHelpNpcGroup(bUuid)
      buildHelpNpcGroup = nil
    end
    if buildHelpNpcGroup == nil then
      buildHelpNpcGroup = BuildHelpNpcGroup.New()
      self.helpNpcGroupDict[bUuid] = buildHelpNpcGroup
    end
    buildHelpNpcGroup:ReInit(prefabPath, parent, showNum, buildData.updateTime, isFinish)
  else
    self:RemoveHelpNpcGroup(bUuid)
  end
end

local function RemoveHelpNpcGroup(self, bUuid)
  if self.helpNpcGroupDict and self.helpNpcGroupDict[bUuid] then
    self.helpNpcGroupDict[bUuid]:Delete()
    self.helpNpcGroupDict[bUuid] = nil
  end
end

local function GetFirePosList(self)
  if self.firePosList == nil then
    self.firePosList = {}
    local posArray = LuaEntry.DataConfig:TryGetStr("alliance_rescue_config", "k8")
    if not string.IsNullOrEmpty(posArray) then
      local posList = string.split(posArray, ";")
      for _, data in ipairs(posList) do
        local xz = string.split(data, ",")
        if #xz == 2 then
          local pos = Vector3.New(tonumber(xz[1]), 0, tonumber(xz[2]))
          table.insert(self.firePosList, pos)
        end
      end
    end
  end
end

local function ChangeToWorldEvent()
  if DataCenter.CityRebuildDataManager:CheckCanPopRebuildUI() then
    DataCenter.CityRebuildDataManager:SendMarchMessage(true)
  end
end

local function StartAnimator(self, inCity)
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(1, SUMTIME)
  if inCity then
    self:InitCarAndNpcModel()
  else
    SceneUtils.ChangeToCity(function()
      self:InitCarAndNpcModel()
    end)
  end
end

local function InitCarAndNpcModel(self)
  local pos = Vector3.New(98.3, 0, 36.28)
  GoToUtil.GotoCityPos(pos, nil, nil, function()
    DataCenter.CityRebuildAniManager:InitCarAndNpc()
  end)
end

CityRebuildAniManager.__init = __init
CityRebuildAniManager.__delete = __delete
CityRebuildAniManager.Startup = Startup
CityRebuildAniManager.AddListener = AddListener
CityRebuildAniManager.BeforeReleaseCity = BeforeReleaseCity
CityRebuildAniManager.ClearAllModel = ClearAllModel
CityRebuildAniManager.AddHelpNpc = AddHelpNpc
CityRebuildAniManager.CreatedBuildHelpModel = CreatedBuildHelpModel
CityRebuildAniManager.GetBulidEntryPos = GetBulidEntryPos
CityRebuildAniManager.GetBulidExitPos = GetBulidExitPos
CityRebuildAniManager.RefreshHelpNpcGroup = RefreshHelpNpcGroup
CityRebuildAniManager.RemoveHelpNpcGroup = RemoveHelpNpcGroup
CityRebuildAniManager.OnUpdatePlayAni = OnUpdatePlayAni
CityRebuildAniManager.AddUpdateTimer = AddUpdateTimer
CityRebuildAniManager.RemoveUpdateTimer = RemoveUpdateTimer
CityRebuildAniManager.ShowBuildHospitalEffect = ShowBuildHospitalEffect
CityRebuildAniManager.HideOrShowBubbleTip = HideOrShowBubbleTip
CityRebuildAniManager.PlayHospitalAni = PlayHospitalAni
CityRebuildAniManager.InitCarAndNpc = InitCarAndNpc
CityRebuildAniManager.GetFirePosList = GetFirePosList
CityRebuildAniManager.ChangeToWorldEvent = ChangeToWorldEvent
CityRebuildAniManager.HideBuildHospitalEffect = HideBuildHospitalEffect
CityRebuildAniManager.EndAnimator = EndAnimator
CityRebuildAniManager.StartAnimator = StartAnimator
CityRebuildAniManager.InitCarAndNpcModel = InitCarAndNpcModel
return CityRebuildAniManager
