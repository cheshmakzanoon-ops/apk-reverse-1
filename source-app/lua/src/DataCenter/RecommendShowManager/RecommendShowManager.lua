local RecommendShowManager = BaseClass("RecommendShowManager")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local WorldArrow = require("Scene.WorldArrow.WorldArrow")

local function __init(self)
  self.param = {}
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self.param = nil
end

local function Startup()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.BuildResourcesStart, self.BuildResourcesStartSignal)
  EventManager:GetInstance():AddListener(EventId.GatherResourceItemFinish, self.GatherResourceItemFinishSignal)
  EventManager:GetInstance():AddListener(EventId.BuildResourcesSecond, self.BuildResourcesSecondSignal)
  EventManager:GetInstance():AddListener(EventId.OnWorldInputPointUp, self.OnWorldInputPointUpSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BuildResourcesStart, self.BuildResourcesStartSignal)
  EventManager:GetInstance():RemoveListener(EventId.GatherResourceItemFinish, self.GatherResourceItemFinishSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildResourcesSecond, self.BuildResourcesSecondSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnWorldInputPointUp, self.OnWorldInputPointUpSignal)
end

local function CheckClickBuild(self, buildId)
  local result
  for k, v in pairs(self.param) do
    if v.buildId == buildId then
      self:ChangeState(v, RecommendShowState.ShowPanel)
      result = v
    end
  end
  return result
end

local function ResetState(self)
  if self.param ~= nil then
    for k, v in pairs(self.param) do
      self:ChangeState(v, RecommendShowState.ShowBuild)
    end
  end
end

local function ChangeState(self, param, state)
  if param.state ~= state then
    param.state = state
    self:RefreshActiveAndPos(param)
    self:ShowHead(param)
  end
end

local function LoadArrow(self, param)
  param.request = ResourceManager:InstantiateAsync(ArrowPrefabName[param.fingerType])
  param.request:completed("+", function()
    if param.request.isError then
      return
    end
    param.request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    param.effect = WorldArrow.New()
    param.effect:OnCreate(param.request)
    local data = {}
    if param.buildUuid ~= nil then
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.buildUuid)
      if buildData ~= nil then
        data.position = buildData:GetCenterVec()
        data.modelHeight = CS.SceneManager.World:GetBuildingHeight(data.pointId)
        data.arrowType = ArrowType.Building
        data.showTime = 0
      end
    end
    param.effect:ReInit(data)
    self:RefreshActiveAndPos(param)
  end)
end

local function RefreshActiveAndPos(self, param)
  if param.request ~= nil and param.request.gameObject ~= nil then
    if param.state == RecommendShowState.ShowBuild then
      param.request.gameObject:SetActive(true)
      if param.buildUuid ~= nil then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.buildUuid)
        if buildData ~= nil then
          param.request.gameObject.transform.position = buildData:GetCenterVec()
        end
      end
    else
      param.request.gameObject:SetActive(false)
    end
  end
end

local function AddOneParam(self, showType, showPara, buildId, buildUuid, guideId, buildUuidList, showHeadPara, focusPos, fingerType, noSave, waitAnimType)
  if self.param[showType] == nil then
    local param = {}
    param.buildId = buildId
    param.showPara = showPara
    param.buildUuid = buildUuid
    param.buildUuidList = buildUuidList
    param.showType = showType
    param.showHeadPara = showHeadPara
    param.focusPos = focusPos
    param.fingerType = fingerType
    param.waitAnimType = waitAnimType
    if guideId == nil then
      guideId = 0
    else
      param.guideId = guideId
    end
    param.state = self:GetInitState(showType)
    self.param[showType] = param
    if focusPos ~= nil then
      if CS.SceneManager.World ~= nil then
        CS.SceneManager.World.CanMoving = false
      end
      if param.state == RecommendShowState.ShowBuild then
        GoToUtil.GotoPos(focusPos, -1, 1)
      end
    end
    self:LoadArrow(param)
    self:ShowHead(param)
    if not noSave then
      self:SaveParamToNet()
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshRecommendShow, showType)
    self:CheckBuildPos(showType, true)
  end
end

local function RemoveOne(self, showType, noDoGuide)
  local param = self.param[showType]
  if param ~= nil then
    if param.request ~= nil then
      param.request:Destroy()
    end
    self:RemoveHead(param)
    self.param[showType] = nil
    if CS.SceneManager.World ~= nil then
      CS.SceneManager.World.CanMoving = self:IsCanMoving()
    end
    if not noDoGuide and param.guideId ~= nil and param.guideId > 0 then
      DataCenter.GuideManager:SetCurGuideId(param.guideId)
      DataCenter.GuideManager:DoGuide()
    end
    self:SaveParamToNet()
    EventManager:GetInstance():Broadcast(EventId.RefreshRecommendShow, showType)
  end
end

local function SaveParamToNet(self)
  local str = ""
  local tempStr = ""
  local buildUuidList = ""
  local headPara = ""
  local focusPos = ""
  for k, v in pairs(self.param) do
    for k1, v1 in ipairs(v.buildUuidList) do
      if buildUuidList ~= "" then
        buildUuidList = buildUuidList .. ","
      end
      buildUuidList = buildUuidList .. v1
    end
    for k2, v2 in pairs(v.showHeadPara) do
      if headPara ~= "" then
        headPara = headPara .. ","
      end
      headPara = headPara .. k2 .. "#" .. v2.dialog .. "#" .. v2.modelName .. "#" .. v2.modelPosition
    end
    if v.focusPos ~= nil then
      focusPos = v.focusPos.x .. "," .. v.focusPos.y .. "," .. v.focusPos.z
    end
    tempStr = v.showType .. ";" .. v.showPara .. ";" .. v.buildId .. ";" .. v.buildUuid .. ";" .. v.guideId .. ";" .. buildUuidList .. ";" .. headPara .. ";" .. focusPos .. ";" .. v.fingerType
    if str ~= "" then
      str = str .. "|"
    end
    str = str .. tempStr
  end
  DataCenter.GuideManager:SaveRecommendShow(str)
end

local function InitParamFromNet(self)
  local str = DataCenter.GuideManager:GetRecommendShow()
  if str ~= nil and str ~= "" then
    local spl = string.split(str, "|")
    for k, v in ipairs(spl) do
      local spl1 = string.split(v, ";")
      local count = table.count(spl1)
      if 9 <= count then
        local uuidList = {}
        local list = string.split(spl1[6], ",")
        for k1, v1 in ipairs(list) do
          table.insert(uuidList, tonumber(v1))
        end
        local headPara = {}
        local list1 = string.split(spl1[7], ",")
        for k1, v1 in ipairs(list1) do
          local spl2 = string.split_ss_array(v1, "#")
          if table.count(spl2) >= 4 then
            local temp = {}
            temp.dialog = spl2[2]
            temp.modelName = spl2[3]
            temp.modelPosition = tonumber(spl2[4])
            headPara[tonumber(spl2[1])] = temp
          end
        end
        local focusPos
        local focus = spl1[8]
        if focus ~= nil and focus ~= "" then
          local list2 = string.split(focus, ",")
          if table.count(list2) >= 3 then
            focusPos = {}
            focusPos.x = list2[1]
            focusPos.y = list2[2]
            focusPos.z = list2[3]
          end
        end
        self:AddOneParam(tonumber(spl1[1]), tonumber(spl1[2]), tonumber(spl1[3]), tonumber(spl1[4]), tonumber(spl1[5]), uuidList, headPara, focusPos, tonumber(spl1[9]), true, UIGuideMoveArrowNeedWaitType.No)
      end
    end
  end
end

local function IsPanelShow(self, showType, para)
  return self.param[showType] ~= nil and self.param[showType].showPara == para
end

local function BuildResourcesStartSignal()
  if CS.SceneManager:IsInCity() then
    DataCenter.RecommendShowManager:CheckBuildPos(RecommendShowType.FarmPlant)
  end
end

local function GatherResourceItemFinishSignal()
  if CS.SceneManager:IsInCity() then
    DataCenter.RecommendShowManager:CheckBuildPos(RecommendShowType.FarmGet)
  end
end

local function IsHaveShowRecommend(self)
  return table.count(self.param) > 0
end

local function GetPanelShowPara(self, showType)
  if self.param[showType] ~= nil then
    return self.param[showType].showPara
  end
end

local function CheckBuildPos(self, showType, noDoGuide)
  local param = self.param[showType]
  if param ~= nil then
    if showType == RecommendShowType.FarmPlant then
      local buildIdList = DataCenter.QueueDataManager:GetBuildUuidInFreeQueueByType(NewQueueType.Field)
      if buildIdList == nil or table.count(buildIdList) == 0 then
        self:RemoveOne(RecommendShowType.FarmPlant, noDoGuide)
      else
        for k, v in ipairs(param.buildUuidList) do
          if table.hasvalue(buildIdList, v) then
            if param.buildUuid ~= v then
              param.buildUuid = v
              self:RefreshActiveAndPos(param)
              self:SaveParamToNet()
            end
            break
          end
        end
      end
    elseif showType == RecommendShowType.FarmGet then
      local complete = true
      local buildIdList = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueByType(NewQueueType.Field)
      if buildIdList ~= nil then
        for k, v in ipairs(param.buildUuidList) do
          if table.hasvalue(buildIdList, v) then
            if param.buildUuid ~= v then
              param.buildUuid = v
              self:RefreshActiveAndPos(param)
              self:SaveParamToNet()
            end
            complete = false
            break
          end
        end
      end
      if complete then
        self:RemoveOne(RecommendShowType.FarmGet, noDoGuide)
      end
    elseif showType == RecommendShowType.FeedOstrich then
      local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(param.buildUuid)
      if queueList ~= nil and table.count(queueList) > 0 then
        for k1, v1 in pairs(queueList) do
          if v1:GetQueueState() == NewQueueState.Work then
            self:RemoveOne(RecommendShowType.FeedOstrich, noDoGuide)
          end
        end
      end
    end
  end
end

local function GetRecommendShowParam(self, showType)
  return self.param[showType]
end

local function BuildResourcesSecondSignal(uuid)
  if CS.SceneManager:IsInCity() then
    DataCenter.RecommendShowManager:CheckBuildPos(RecommendShowType.FeedOstrich)
  end
end

local function IsShowByType(self, showType)
  return self:GetRecommendShowParam(showType) ~= nil
end

local function ShowHead(self, param)
  if param.showHeadPara[param.state] ~= nil then
    local headParam = {}
    headParam.dialog = Localization:GetString(param.showHeadPara[param.state].dialog)
    headParam.modelName = param.showHeadPara[param.state].modelName
    headParam.modelPosition = param.showHeadPara[param.state].modelPosition
    headParam.isRecommend = true
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideHeadTalk) then
      EventManager:GetInstance():Broadcast(EventId.RefreshUIGuideHeadTalk, headParam)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false}, headParam)
    end
  else
    self:RemoveHead(param)
  end
end

local function GetHeadParam(self)
  for k, v in pairs(self.param) do
    if v.showHeadPara[v.state] ~= nil then
      return v.showHeadPara[v.state]
    end
  end
end

local function RemoveHead(self, param)
  if param.showHeadPara[param.state] ~= nil and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideHeadTalk) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false})
  end
end

local function OnWorldInputPointUpSignal()
  if CS.SceneManager:IsInCity() and not DataCenter.RecommendShowManager:IsCanMoving() and CS.SceneManager.World ~= nil then
    CS.SceneManager.World.CanMoving = false
  end
end

local function IsCanMoving(self)
  for k, v in pairs(self.param) do
    if v.focusPos ~= nil then
      return false
    end
  end
  return true
end

local function IsCanClickBuild(self, buildId, buildData)
  for k, v in pairs(self.param) do
    if v.focusPos ~= nil then
      if buildId ~= v.buildId then
        return false
      elseif v.showType == RecommendShowType.FarmPlant then
        local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(buildData.uuid)
        if queueData == nil or queueData:GetQueueState() ~= NewQueueState.Free then
          return false
        end
      elseif v.showType == RecommendShowType.FarmGet then
        local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(buildData.uuid)
        if queueData == nil or queueData:GetQueueState() ~= NewQueueState.Finish then
          return false
        end
      end
    end
  end
  return true
end

local function GetInitState(self, showType)
  if showType == RecommendShowType.FarmPlant then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFarm) then
      return RecommendShowState.ShowPanel
    end
  elseif showType == RecommendShowType.FarmGet then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFarmGather) then
      return RecommendShowState.ShowPanel
    end
  elseif showType == RecommendShowType.FeedOstrich and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPasture) then
    return RecommendShowState.ShowPanel
  end
  return RecommendShowState.ShowBuild
end

RecommendShowManager.__init = __init
RecommendShowManager.__delete = __delete
RecommendShowManager.ChangeState = ChangeState
RecommendShowManager.ResetState = ResetState
RecommendShowManager.CheckClickBuild = CheckClickBuild
RecommendShowManager.RefreshActiveAndPos = RefreshActiveAndPos
RecommendShowManager.LoadArrow = LoadArrow
RecommendShowManager.AddOneParam = AddOneParam
RecommendShowManager.RemoveOne = RemoveOne
RecommendShowManager.SaveParamToNet = SaveParamToNet
RecommendShowManager.InitParamFromNet = InitParamFromNet
RecommendShowManager.IsPanelShow = IsPanelShow
RecommendShowManager.Startup = Startup
RecommendShowManager.AddListener = AddListener
RecommendShowManager.RemoveListener = RemoveListener
RecommendShowManager.BuildResourcesStartSignal = BuildResourcesStartSignal
RecommendShowManager.GatherResourceItemFinishSignal = GatherResourceItemFinishSignal
RecommendShowManager.IsHaveShowRecommend = IsHaveShowRecommend
RecommendShowManager.GetPanelShowPara = GetPanelShowPara
RecommendShowManager.CheckBuildPos = CheckBuildPos
RecommendShowManager.GetRecommendShowParam = GetRecommendShowParam
RecommendShowManager.BuildResourcesSecondSignal = BuildResourcesSecondSignal
RecommendShowManager.IsShowByType = IsShowByType
RecommendShowManager.GetHeadParam = GetHeadParam
RecommendShowManager.ShowHead = ShowHead
RecommendShowManager.RemoveHead = RemoveHead
RecommendShowManager.OnWorldInputPointUpSignal = OnWorldInputPointUpSignal
RecommendShowManager.IsCanMoving = IsCanMoving
RecommendShowManager.IsCanClickBuild = IsCanClickBuild
RecommendShowManager.GetInitState = GetInitState
return RecommendShowManager
