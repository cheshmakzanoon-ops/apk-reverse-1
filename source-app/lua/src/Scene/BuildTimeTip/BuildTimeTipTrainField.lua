local BuildTimeTipTrainField = BaseClass("BuildTimeTipTrainField")
local SceneBuildTimeTipCircle = require("Scene.BuildTimeTip.SceneBuildTimeTipCircle")
local ResourceManager = CS.GameEntry.Resource
local tipsContainer_path = "container"
local tipsAnim_path = ""

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DelAllTimeTips()
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.transTipsContainerN = self.transform:Find(tipsContainer_path)
  self.tipsAnimN = self.transform:Find(tipsAnim_path):GetComponent(typeof(CS.SimpleAnimation))
end

local function ComponentDestroy(self)
  self.transTipsContainerN = nil
  self.tipsAnimN = nil
end

local function DataDefine(self)
  self.timeTipDic = {}
end

local function DataDestroy(self)
  self.timeTipDic = nil
end

local function ReInit(self, paramList)
  for i, v in pairs(self.timeTipDic) do
    local needDel = true
    for m, n in ipairs(paramList) do
      if v.param.buildTimeType == n.buildTimeType then
        needDel = false
        break
      end
    end
    if needDel then
      self:DeleteBuildTimeByType(v.param.buildTimeType)
    end
  end
  table.sort(paramList, function(a, b)
    if a.buildTimeType ~= b.buildTimeType then
      return a.buildTimeType < b.buildTimeType
    else
      return false
    end
  end)
  for i, v in ipairs(paramList) do
    v.name = tostring(i)
  end
  for i, v in ipairs(paramList) do
    local param = v
    if not self.timeTipDic[param.buildTimeType] then
      self.timeTipDic[param.buildTimeType] = {}
    end
    self.timeTipDic[param.buildTimeType].param = param
    if not self.timeTipDic[param.buildTimeType].model then
      local request = ResourceManager:InstantiateAsync(param.model)
      self.timeTipDic[param.buildTimeType].model = request
      self.timeTipDic[param.buildTimeType].modelLoaded = false
      request:completed("+", function()
        if not (self.timeTipDic and param) or not self.timeTipDic[param.buildTimeType] then
          request:Destroy()
          return
        end
        request.gameObject.transform:SetParent(self.transTipsContainerN)
        if SeasonUtil.IsSeasonPlayerBuilding(param.buildId) then
          request.gameObject.transform:Set_localScale(0.5, 0.1, 1.0)
        else
          request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        end
        request.gameObject.name = "BuildTime" .. param.name
        local buildTimeTip
        if param.buildTimeType == BuildTimeType.BuildTime_Upgrading or param.buildTimeType == BuildTimeType.BuildTime_FootSoldier or param.buildTimeType == BuildTimeType.BuildTime_CarSoldier or param.buildTimeType == BuildTimeType.BuildTime_BowSoldier then
          buildTimeTip = SceneBuildTimeTipCircle.New()
        else
          return
        end
        local tempParam = self.timeTipDic[param.buildTimeType].param
        buildTimeTip:OnCreate(request)
        self.timeTipDic[param.buildTimeType].timeTip = buildTimeTip
        buildTimeTip:ReInit({tempParam})
        self.timeTipDic[param.buildTimeType].modelLoaded = true
      end)
    else
      if self.timeTipDic[param.buildTimeType].timeTip and self.timeTipDic[param.buildTimeType].modelLoaded then
        self.timeTipDic[param.buildTimeType].timeTip.gameObject.name = "BuildTime" .. param.name
        self.timeTipDic[param.buildTimeType].timeTip:ReInit({param})
      end
      self:PlayNewTipAnim()
    end
    self:UpdatePosition()
  end
end

local function PlayNewTipAnim(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local hasAppearAnim = false
  for k, v in pairs(self.timeTipDic) do
    if curTime - v.param.startTime < 1000 then
      hasAppearAnim = true
      break
    end
  end
  local tipsCount = table.count(self.timeTipDic)
  local animName = ""
  if tipsCount == 2 then
    if hasAppearAnim then
      animName = "TrainFieldTimeTipAnim_12"
    else
      animName = "TrainFieldTimeTipAnim_2"
    end
  else
    animName = "TrainFieldTimeTipAnim_1"
  end
  self.tipsAnimN = self.transform:Find(tipsAnim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.tipsAnimN.gameObject:SetActive(false)
  self.tipsAnimN.gameObject:SetActive(true)
  self.tipsAnimN:Play(animName)
end

local function GetParamList(self)
  local paramList = {}
  for i, v in pairs(self.timeTipDic) do
    table.insert(paramList, v.param)
  end
  return paramList
end

local function CheckIfTimeTipExist(self, paramList)
  return true
end

local function DeleteBuildTimeByType(self, tipType)
  local tempTip = self.timeTipDic[tipType]
  if tempTip and tempTip.timeTip then
    if tempTip.model then
      tempTip.model:Destroy()
    end
    if tempTip.timeTip then
      tempTip.timeTip:OnDestroy()
    end
  end
  self.timeTipDic[tipType] = nil
  local tempList = self:GetParamList()
  self:ReInit(tempList)
end

local function DelAllTimeTips(self)
  if self.timeTipDic and table.count(self.timeTipDic) > 0 then
    for i, v in pairs(self.timeTipDic) do
      if v.model then
        v.model:Destroy()
      end
      if v.timeTip then
        v.timeTip:OnDestroy()
      end
    end
  end
  self.timeTipDic = {}
end

local function CheckTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local hasEnd = false
  for i, v in pairs(self.timeTipDic) do
    local changeTime = v.param.endTime - curTime
    if changeTime <= 0 then
      self:DeleteBuildTimeByType(v.param.buildTimeType)
      hasEnd = true
    end
  end
  return hasEnd
end

local function UpdatePosition(self)
  local param
  for i, v in pairs(self.timeTipDic) do
    param = v.param
    break
  end
  if param ~= nil then
    local theType
    if SeasonUtil.IsSeasonPlayerBuilding(param.buildId) then
      theType = ForceChangeScene.World
    end
    self.transform.position = BuildingUtils.GetBuildModelCenterVec(param.pos, param.tileX, param.tileY, theType)
  end
end

local function UpdateTime(self, timeType, startTime, endTime)
  local tempTip = self.timeTipDic[timeType]
  if tempTip then
    tempTip.param.startTime = startTime
    tempTip.param.endTime = endTime
    if tempTip.timeTip then
      tempTip.timeTip:ReInit({
        tempTip.param
      })
    end
  end
end

local function RefreshActive(self, isActive)
  self.transTipsContainerN.gameObject:SetActive(isActive)
end

BuildTimeTipTrainField.OnCreate = OnCreate
BuildTimeTipTrainField.OnDestroy = OnDestroy
BuildTimeTipTrainField.ComponentDefine = ComponentDefine
BuildTimeTipTrainField.ComponentDestroy = ComponentDestroy
BuildTimeTipTrainField.DataDefine = DataDefine
BuildTimeTipTrainField.DataDestroy = DataDestroy
BuildTimeTipTrainField.ReInit = ReInit
BuildTimeTipTrainField.PlayNewTipAnim = PlayNewTipAnim
BuildTimeTipTrainField.CheckIfTimeTipExist = CheckIfTimeTipExist
BuildTimeTipTrainField.DelAllTimeTips = DelAllTimeTips
BuildTimeTipTrainField.DeleteBuildTimeByType = DeleteBuildTimeByType
BuildTimeTipTrainField.CheckTime = CheckTime
BuildTimeTipTrainField.UpdatePosition = UpdatePosition
BuildTimeTipTrainField.UpdateTime = UpdateTime
BuildTimeTipTrainField.GetParamList = GetParamList
BuildTimeTipTrainField.RefreshActive = RefreshActive
return BuildTimeTipTrainField
