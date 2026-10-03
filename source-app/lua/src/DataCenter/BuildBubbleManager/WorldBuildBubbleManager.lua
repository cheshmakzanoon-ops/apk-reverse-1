local WorldBuildBubbleManager = BaseClass("WorldBuildBubbleManager")
local BuildBubbleTip = require("UI.BuildBubbleTip.View.BuildBubbleTip")
local ResourceManager = CS.GameEntry.Resource
local TileBgScale1 = Vector3.New(0.7, 0.7, 0.7)
local TileBgScale2 = Vector3.New(1, 1, 1)
local TileBgScale3 = Vector3.New(0.6, 0.6, 0.6)
local AssistanceIconScale = Vector3.New(2.5, 2.5, 2.5)

local function __init(self)
  self.allBuildBubble = {}
  self.loadingBuildBubble = {}
  self.buildTypeBubbleType = {}
  self.assistedBuild = {}
  self.lodCache = 1
  self:AddListener()
end

local function __delete(self)
  self:ClearAll()
  self.loadingBuildBubble = nil
  self.allBuildBubble = nil
  self.buildTypeBubbleType = nil
  self.assistedBuild = nil
  self.lodCache = nil
  self:RemoveListener()
end

local function ClearAll(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.allBuildBubble) do
    self.allBuildBubble[k]:OnDestroy()
    self.allBuildBubble[k].request:Destroy()
  end
  for k, v in pairs(self.loadingBuildBubble) do
    if v ~= nil then
      v:Destroy()
    end
  end
  self.loadingBuildBubble = {}
  self.allBuildBubble = {}
  Setting:SetPrivateString("LastCleanTime", tostring(now))
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.OnEnterPveLevel)
  EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.OnExitPveLevel)
  EventManager:GetInstance():AddListener(EventId.MarchItemUpdateSelf, self.UpdateMarchSignal)
  EventManager:GetInstance():AddListener(EventId.UpdateMarchItem, self.UpdateMarchItemSignal)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.ShowBuildDetail, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.HideBuildDetail, self.BuildOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_IN_VIEW, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceBuildHelpNew, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.Build_Time_End, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.BuildUpgradeStart, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.BuildInViewSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.OnEnterPveLevel)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.OnExitPveLevel)
  EventManager:GetInstance():RemoveListener(EventId.MarchItemUpdateSelf, self.UpdateMarchSignal)
  EventManager:GetInstance():RemoveListener(EventId.UpdateMarchItem, self.UpdateMarchItemSignal)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.ShowBuildDetail, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.HideBuildDetail, self.BuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_IN_VIEW, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceBuildHelpNew, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.Build_Time_End, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeStart, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.BuildInViewSignal)
end

local function Startup()
end

local function UpdateMarchItemSignal()
  DataCenter.BuildBubbleManager:RefreshAssistanceBubble()
end

local function UpdateMarchSignal()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_WORMHOLE_SUB)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.WorldBuildBubbleManager:CheckShowBubble(buildUuid)
end

local function RefreshAssistanceBubble(self)
  local bUuidList = {}
  for bUuid, _ in pairs(self.assistedBuild) do
    table.insert(bUuidList, bUuid)
  end
  self.assistedBuild = {}
  local marchInfos = DataCenter.WorldMarchDataManager:GetMarchesTargetForMineLite()
  for _, marchInfo in pairs(marchInfos) do
    if marchInfo:GetMarchStatus() == MarchStatus.ASSISTANCE then
      local bUuid = marchInfo.targetUuid
      self.assistedBuild[bUuid] = true
      table.insert(bUuidList, bUuid)
    end
  end
  for _, bUuid in ipairs(bUuidList) do
    self:CheckShowBubble(bUuid)
  end
end

local function GetBuildNeedShowBuildBubble(self, uuid)
  if SceneUtils.GetIsInWorld() == false then
    return
  end
  if BattleFieldUtil.InBattleField() then
    return
  end
  local data = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if data ~= nil then
    local buildState = data.state
    if buildState ~= BuildingStateType.FoldUp and data:IsUpgradeFinish() == false and data.destroyStartTime <= 0 then
      local buildId = data.itemId
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      local list = self:GetBuildBubbleTypeListByBuildType(data.itemId, buildTemplate, data.level)
      if list ~= nil and buildTemplate ~= nil then
        local isContinue = true
        local param = {}
        param.modelHeight = CS.SceneManager.World:GetBuildingHeight(data.pointId)
        for k, v in ipairs(list) do
          if isContinue then
            if v == BuildBubbleType.Assistance then
              if self.assistedBuild[data.uuid] == true then
                isContinue = false
                param.iconName = string.format(LoadPath.CommonNewPath, "Common_icon_march_assistance")
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                param.model = UIAssets.BuildStateIcon
                param.buildBubbleType = v
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.callBack = self.OnClickCallBack
                param.uuid = data.uuid
                param.bgScale = self:GetBgScale(param)
                param.iconScale = self:GetIconScale(param)
                param.buildId = buildTemplate.id
              end
            elseif v == BuildBubbleType.UpgradeAllianceHelp then
              if LuaEntry.Player:IsInAlliance() and 0 < data.updateTime and (data.isHelped == AllianceHelpState.No or data.isHelped == AllianceHelpState.RuinsHelped) and 0 < data.level then
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.UpgradeAllianceHelp)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.model = UIAssets.BuildStateIcon
                isContinue = false
                param.buildBubbleType = v
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.callBack = self.OnClickCallBack
                param.uuid = uuid
                param.bgScale = self:GetBgScale(param)
                param.iconScale = self:GetIconScale(param)
                param.buildId = buildId
              end
            elseif v == BuildBubbleType.WormHoleSub then
              local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
              for _, march in pairs(selfMarch) do
                if march:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or march:GetMarchTargetType() == MarchTargetType.GO_WORM_HOLE then
                  param.model = UIAssets.BuildStateIcon4
                  param.iconName = string.format(LoadPath.UIBuildBubble, "UIworld_icon_trans")
                  param.bgName = string.format(LoadPath.UIBuildBubble, "UIworld_garbage_iconbg01")
                  isContinue = false
                  param.buildBubbleType = v
                  param.pos = data.pointId
                  param.tileX = buildTemplate.tileX
                  param.tileY = buildTemplate.tileY
                  param.callBack = self.OnClickCallBack
                  param.uuid = data.uuid
                  param.bgScale = self:GetBgScale(param)
                  param.iconScale = self:GetIconScale(param)
                  param.buildId = buildTemplate.id
                  param.startTime = march.startTime
                  param.endTime = march.endTime
                  break
                end
              end
            elseif v == BuildBubbleType.CrossWormHoleSub then
              local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
              for _, march in pairs(selfMarch) do
                if march:GetMarchStatus() == MarchStatus.CROSS_SERVER or march:GetMarchTargetType() == MarchTargetType.CROSS_SERVER_WORM then
                  param.model = UIAssets.BuildStateIcon4
                  param.iconName = string.format(LoadPath.UIBuildBubble, "UIworld_icon_trans")
                  param.bgName = string.format(LoadPath.UIBuildBubble, "UIworld_garbage_iconbg01")
                  isContinue = false
                  param.buildBubbleType = v
                  param.pos = data.pointId
                  param.tileX = buildTemplate.tileX
                  param.tileY = buildTemplate.tileY
                  param.callBack = self.OnClickCallBack
                  param.uuid = data.uuid
                  param.bgScale = self:GetBgScale(param)
                  param.iconScale = self:GetIconScale(param)
                  param.buildId = buildTemplate.id
                  param.startTime = march.startTime
                  param.endTime = march.endTime
                  break
                end
              end
            elseif v == BuildBubbleType.WormHoleSubZero then
              local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.APS_BUILD_WORMHOLE_SUB)
              if 0 < #buildList and buildList[1].level == 0 and buildList[1].state ~= BuildingStateType.Upgrading then
                local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
                for _, march in pairs(selfMarch) do
                  if march:GetMarchTargetType() == MarchTargetType.BUILD_WORM_HOLE then
                    return nil
                  end
                end
                param.model = UIAssets.BuildStateIcon
                param.iconName = string.format(LoadPath.UIBuildBtns, "uibuild_btn_xiujian")
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
                param.buildBubbleType = v
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.callBack = self.OnClickCallBack
                param.uuid = data.uuid
                param.bgScale = self:GetBgScale(param)
                param.iconScale = self:GetIconScale(param)
                param.buildId = buildTemplate.id
              end
            end
          end
        end
        if not isContinue then
          return param
        end
      end
    elseif buildState ~= BuildingStateType.FoldUp and data.destroyStartTime > 0 then
      local buildId = data.itemId
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      local list = self:GetBuildBubbleTypeListByBuildType(data.itemId, buildTemplate, data.level)
      if list ~= nil and buildTemplate ~= nil then
        local isContinue = true
        local param = {}
        param.modelHeight = CS.SceneManager.World:GetBuildingHeight(data.pointId)
        for k, v in ipairs(list) do
          if isContinue then
            if v == BuildBubbleType.BuildFixFinishEnd then
              local now = UITimeManager:GetInstance():GetServerTime()
              if 0 < data.destroyEndTime and now >= data.destroyEndTime and data.state ~= BuildingStateType.FoldUp then
                param.model = UIAssets.BuildStateIcon
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BuildFixFinishEnd)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                isContinue = false
                param.buildBubbleType = v
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.callBack = self.OnClickCallBack
                param.uuid = data.uuid
                param.bgScale = self:GetBgScale(param)
                param.iconScale = self:GetIconScale(param)
                param.buildId = buildTemplate.id
              end
            elseif v == BuildBubbleType.FixBuildingAllianceHelp then
              local now = UITimeManager:GetInstance():GetServerTime()
              if LuaEntry.Player:IsInAlliance() and now < data.destroyEndTime and (data.isHelped == AllianceHelpState.No or data.isHelped == AllianceHelpState.UpgradeHelped) and 0 < data.level then
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.UpgradeAllianceHelp)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                param.model = UIAssets.BuildStateIcon
                isContinue = false
                param.buildBubbleType = v
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.callBack = self.OnClickCallBack
                param.uuid = uuid
                param.bgScale = self:GetBgScale(param)
                param.iconScale = self:GetIconScale(param)
                param.buildId = buildId
              end
            end
          end
        end
        if not isContinue then
          return param
        end
      end
    end
  end
  return nil
end

local function GetBuildBubbleTypeListByBuildType(self, buildType, template, level)
  local list = {}
  if buildType == BuildingTypes.APS_BUILD_WORMHOLE_SUB then
    table.insert(list, BuildBubbleType.WormHoleSubZero)
    table.insert(list, BuildBubbleType.WormHoleSub)
  elseif buildType == BuildingTypes.WORM_HOLE_CROSS then
    table.insert(list, BuildBubbleType.CrossWormHoleSub)
  end
  table.insert(list, BuildBubbleType.Assistance)
  table.insert(list, BuildBubbleType.UpgradeAllianceHelp)
  table.insert(list, BuildBubbleType.BuildFixFinishEnd)
  table.insert(list, BuildBubbleType.FixBuildingAllianceHelp)
  table.sort(list, self.CompareBuildType)
  self.buildTypeBubbleType[buildType] = list
  return list
end

local function CompareBuildType(buildBubbleType1, buildBubbleType2)
  return BuildBubbleTypeOrder[buildBubbleType1] < BuildBubbleTypeOrder[buildBubbleType2]
end

local function CheckShowBubble(self, bUuid)
  local param = self:GetBuildNeedShowBuildBubble(bUuid)
  if param == nil or param.buildBubbleType == BuildBubbleType.UpgradeAllianceHelp then
    self:DeleteOneBuildBubble(bUuid)
  else
    self:ShowOneBuildBubble(bUuid, param)
  end
end

local function DeleteOneBuildBubble(self, bUuid)
  if self.loadingBuildBubble[bUuid] ~= nil then
    self.loadingBuildBubble[bUuid]:Destroy()
    self.loadingBuildBubble[bUuid] = nil
  end
  if self.allBuildBubble[bUuid] ~= nil then
    self.allBuildBubble[bUuid]:OnDestroy()
    self.allBuildBubble[bUuid].request:Destroy()
    self.allBuildBubble[bUuid] = nil
  end
end

local function GetBgScale(self, param)
  if param.tileX == BuildTilesSize.One or param.tileY == BuildTilesSize.One then
    return TileBgScale1
  else
    return TileBgScale2
  end
end

local function GetIconScale(self, param)
  if param.buildBubbleType == BuildBubbleType.Assistance then
    return AssistanceIconScale
  end
  return ResetScale
end

local function ShowOneBuildBubble(self, bUuid, param)
  if self.loadingBuildBubble[bUuid] ~= nil then
    self.loadingBuildBubble[bUuid]:Destroy()
    self.loadingBuildBubble[bUuid] = nil
  end
  if self.allBuildBubble[bUuid] ~= nil and param.model == self.allBuildBubble[bUuid].param.model then
    self.allBuildBubble[bUuid]:ReInit(param)
  else
    if self.allBuildBubble[bUuid] ~= nil then
      self:DeleteOneBuildBubble(bUuid)
    end
    local request = ResourceManager:InstantiateAsync(param.model)
    self.loadingBuildBubble[bUuid] = request
    request:completed("+", function()
      self.loadingBuildBubble[bUuid] = nil
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.BuildBubbleNode)
      request.gameObject.transform:Set_localScale(0, ResetScale.y, ResetScale.z)
      request.gameObject.name = "BuildBubble" .. bUuid
      local buildBubbleTip
      buildBubbleTip = BuildBubbleTip.New()
      buildBubbleTip:OnCreate(request)
      self.allBuildBubble[bUuid] = buildBubbleTip
      self.allBuildBubble[bUuid]:ReInit(param)
    end)
  end
end

local function BuildInViewSignal(data)
  local uuid = tonumber(data)
  DataCenter.WorldBuildBubbleManager:CheckShowBubble(uuid)
end

local function BuildOutViewSignal(data)
  local uuid = tonumber(data)
  DataCenter.WorldBuildBubbleManager:DeleteOneBuildBubble(uuid)
end

local function OnEnterPveLevel()
  DataCenter.WorldBuildBubbleManager:ClearAll()
end

local function OnExitPveLevel()
end

local function ChangeCameraLodSignal(lod)
  DataCenter.WorldBuildBubbleManager:UpdateLod(lod)
end

local function UpdateLod(self, lod)
  self.lodCache = lod
  self:RefreshBubbleNode()
end

local function RefreshBubbleNode(self)
  if not CS.SceneManager:IsInWorld() then
    return
  end
  local node = CS.SceneManager.World.BuildBubbleNode.gameObject
  local active = self.lodCache <= 1
  if BattleFieldUtil.InBattleField() then
    active = true
  end
  node:SetActive(active)
  if active then
    for _, bubble in pairs(self.allBuildBubble) do
      bubble:Show()
    end
  end
end

local function OnClickCallBack(param)
  local guideParam = {}
  guideParam.buildBubbleType = param.buildBubbleType
  if param.buildBubbleType == BuildBubbleType.FixBuildingAllianceHelp then
    SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, param.uuid, AllianceHelpType.FIX_BUILDING, NewQueueType.Default, "")
  elseif param.buildBubbleType == BuildBubbleType.BuildFixFinishEnd then
    DataCenter.BuildManager:CheckSendFixBuildFinish(param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.Assistance then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, param.uuid, LuaEntry.Player.uid, param.pos, AssistanceType.MainCity)
  elseif param.buildBubbleType == BuildBubbleType.WormHoleSub or param.buildBubbleType == BuildBubbleType.CrossWormHoleSub then
  elseif param.buildBubbleType == BuildBubbleType.WormHoleSubZero then
    MarchUtil.OnClickStartMarch(MarchTargetType.BUILD_WORM_HOLE, param.pos, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.UpgradeAllianceHelp then
    SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, param.uuid, AllianceHelpType.Building, NewQueueType.Default, "")
  end
end

WorldBuildBubbleManager.__init = __init
WorldBuildBubbleManager.__delete = __delete
WorldBuildBubbleManager.AddListener = AddListener
WorldBuildBubbleManager.RemoveListener = RemoveListener
WorldBuildBubbleManager.Startup = Startup
WorldBuildBubbleManager.GetBgScale = GetBgScale
WorldBuildBubbleManager.GetIconScale = GetIconScale
WorldBuildBubbleManager.CompareBuildType = CompareBuildType
WorldBuildBubbleManager.GetBuildBubbleTypeListByBuildType = GetBuildBubbleTypeListByBuildType
WorldBuildBubbleManager.GetBuildNeedShowBuildBubble = GetBuildNeedShowBuildBubble
WorldBuildBubbleManager.RefreshAssistanceBubble = RefreshAssistanceBubble
WorldBuildBubbleManager.UpdateMarchSignal = UpdateMarchSignal
WorldBuildBubbleManager.BuildInViewSignal = BuildInViewSignal
WorldBuildBubbleManager.BuildOutViewSignal = BuildOutViewSignal
WorldBuildBubbleManager.ShowOneBuildBubble = ShowOneBuildBubble
WorldBuildBubbleManager.DeleteOneBuildBubble = DeleteOneBuildBubble
WorldBuildBubbleManager.CheckShowBubble = CheckShowBubble
WorldBuildBubbleManager.OnEnterPveLevel = OnEnterPveLevel
WorldBuildBubbleManager.OnExitPveLevel = OnExitPveLevel
WorldBuildBubbleManager.ClearAll = ClearAll
WorldBuildBubbleManager.UpdateMarchItemSignal = UpdateMarchItemSignal
WorldBuildBubbleManager.ChangeCameraLodSignal = ChangeCameraLodSignal
WorldBuildBubbleManager.UpdateLod = UpdateLod
WorldBuildBubbleManager.RefreshBubbleNode = RefreshBubbleNode
WorldBuildBubbleManager.OnClickCallBack = OnClickCallBack
return WorldBuildBubbleManager
