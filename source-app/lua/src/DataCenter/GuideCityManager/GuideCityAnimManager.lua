local GuideCityAnimManager = BaseClass("GuideCityAnimManager")
local ResourceManager = CS.GameEntry.Resource
local GuideStartScene = require("Scene.GuideStartScene.GuideStartScene")
local SavePeopleScene = require("Scene.GuideStartScene.SavePeopleScene")
local ShowOstrichScene = require("Scene.ShowOstrichScene.ShowOstrichScene")
local ShowMigrateScene = require("Scene.ShowMigrateScene.ShowMigrateScene")
local ShowBusinessPlaneArriveScene = require("Scene.ShowBusinessPlaneArriveScene.ShowBusinessPlaneArriveScene")
local ShowCowScene = require("Scene.ShowCowScene.ShowCowScene")
local ShowRobotScene = require("Scene.ShowRobotScene.ShowRobotScene")
local FromMjBuildMainBuildScene = require("Scene.FromMjBuildMainBuildScene.FromMjBuildMainBuildScene")
local MainZeroUpgradeScene = require("Scene.MainZeroUpgradeScene.MainZeroUpgradeScene")
local SecondMigrateScene = require("Scene.ShowMigrateScene.SecondMigrateScene")
local TilePlaneRuin = require("Scene.TilePlaneRuin.TilePlaneRuin")
local PirateFightBobScene = require("Scene.PirateScene.PirateFightBobScene")
local PirateComeScene = require("Scene.PirateScene.PirateComeScene")
local PirateAwayScene = require("Scene.PirateScene.PirateAwayScene")
local RadarScanScene = require("Scene.RadarScanScene.RadarScanScene")
local ShowFakePlayerFlagScene = require("Scene.ShowFakePlayerFlagScene.ShowFakePlayerFlagScene")
local RadarWorldScanScene = require("Scene.RadarScanScene.RadarWorldScanScene")
local PickUpWeaponScene = require("Scene.PickUpWeaponScene.PickUpWeaponScene")
local ShowRadarMonsterScene = require("Scene.RadarScanScene.ShowRadarMonsterScene")
local GuluOutFromBaseScene = require("Scene.GuideTimeline1Scene.GuluOutFromBaseScene")
local DefendWallScene = require("Scene.DefendWallScene.DefendWallScene")
local SecondDomeExpandScene = require("Scene.DomeExpandScene.SecondDomeExpandScene")
local ConnectElectricityScene = require("Scene.ConnectElectricityScene.ConnectElectricityScene")
local Chapter2CameraMoveScene = require("Scene.Chapter2CameraMoveScene.Chapter2CameraMoveScene")
local FirstDomeExpandScene = require("Scene.DomeExpandScene.FirstDomeExpandScene")
local Localization = CS.GameEntry.Localization
local RemoveShowOstrichEffectTime = 4.0
local MainCamera

function GuideCityAnimManager:MainCameraSetActive(active)
  if MainCamera == nil then
    MainCamera = CS.UnityEngine.Camera.main
  end
  if MainCamera ~= nil then
    MainCamera.gameObject:SetActive(active)
  end
end

function GuideCityAnimManager:__init()
  self.model = {}
  self.instanceReq = {}
  self:AddListener()
  self.useGuideTimelineMarker = false
  self.isNeedStart = {}
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimeCallBack()
  end
  
  self.buildParam = nil
  self.needHideLockLandList = nil
end

function GuideCityAnimManager:__delete()
  self:DeleteTimer()
  self.timer_action = nil
  self.timer = nil
  self:RemoveListener()
  self.useGuideTimelineMarker = nil
  self.isNeedStart = nil
  self.buildParam = nil
  self.needHideLockLandList = nil
  self:DestroyAllObject()
end

function GuideCityAnimManager:Startup()
end

function GuideCityAnimManager:AddListener()
  if self.guideTimelineMarkerSignal == nil then
    function self.guideTimelineMarkerSignal(id)
      self:GuideTimelineMarkerSignal(id)
    end
    
    EventManager:GetInstance():AddListener(EventId.GuideTimelineMarker, self.guideTimelineMarkerSignal)
  end
  if self.refreshGuideSignal == nil then
    function self.refreshGuideSignal(id)
      self:RefreshGuideSignal(id)
    end
    
    EventManager:GetInstance():AddListener(EventId.RefreshGuide, self.refreshGuideSignal)
  end
  if self.gotoTimeSignal == nil then
    function self.gotoTimeSignal(id)
      self:GotoTimeSignal(id)
    end
    
    EventManager:GetInstance():AddListener(EventId.GotoTime, self.gotoTimeSignal)
  end
end

function GuideCityAnimManager:RemoveListener()
  if self.guideTimelineMarkerSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.GuideTimelineMarker, self.guideTimelineMarkerSignal)
    self.guideTimelineMarkerSignal = nil
  end
  if self.refreshGuideSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.RefreshGuide, self.refreshGuideSignal)
    self.refreshGuideSignal = nil
  end
  if self.gotoTimeSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.GotoTime, self.gotoTimeSignal)
    self.gotoTimeSignal = nil
  end
end

function GuideCityAnimManager:LoadScene()
  local request = ResourceManager:InstantiateAsync(UIAssets.GuideStartScene)
  self.instanceReq[GuideAnimObjectType.Scene] = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = GuideStartScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.Scene] = effect
    self.useGuideTimelineMarker = true
    CityPioneerFog:GetInstance():SetFogVisible(false)
    CS.SceneManager.World:SetTouchInputControllerEnable(false)
    DataCenter.CanUnlockFogManager:SetFogActive(false)
    effect:ReInit()
    if self.isNeedStart[GuideAnimObjectType.Scene] then
      effect:StartPlay()
    end
  end)
  pcall(function()
    CS.SceneManager.World:SetStaticVisibleChunk(10)
  end)
end

function GuideCityAnimManager:RemoveScene()
  self.useGuideTimelineMarker = false
  CS.SceneManager.World.Enabled = true
  CityPioneerFog:GetInstance():SetFogVisible(true)
  CS.SceneManager.World:SetTouchInputControllerEnable(true)
  DataCenter.CanUnlockFogManager:SetFogActive(true)
  self:DestroyOneObj(GuideAnimObjectType.Scene)
  pcall(function()
    CS.SceneManager.World:SetStaticVisibleChunk(1)
  end)
end

function GuideCityAnimManager:DestroyAllObject()
  if self.instanceReq then
    for k, v in pairs(self.instanceReq) do
      v:Destroy()
    end
    self.instanceReq = nil
  end
  if self.model then
    for k, v in pairs(self.model) do
      v:OnDestroy()
    end
    self.model = nil
  end
end

function GuideCityAnimManager:DestroyOneObj(animType)
  if self.model[animType] ~= nil then
    self.model[animType]:OnDestroy()
    self.model[animType] = nil
  end
  if self.instanceReq[animType] ~= nil then
    self.instanceReq[animType]:Destroy()
    self.instanceReq[animType] = nil
  end
end

function GuideCityAnimManager:GetModelByType(animType)
  return self.model[animType]
end

function GuideCityAnimManager:RefreshGuideSignal()
  local guideType = DataCenter.GuideManager:GetGuideType()
  if guideType == GuideType.PlayMovie then
    local scene = self:GetModelByType(GuideAnimObjectType.Scene)
    if scene ~= nil then
      scene:RefreshGuideSignal()
    end
  end
  if not DataCenter.GuideManager:InGuide() then
    self:GuideTimelineMarkerSignal(GuideTimeLineShowMarkerType.End)
  end
end

function GuideCityAnimManager:LoadSavePeopleScene(pointId)
  local request = ResourceManager:InstantiateAsync(UIAssets.SavePeopleScene)
  self.instanceReq[GuideAnimObjectType.SavePeople] = request
  request:completed("+", function()
    CS.SceneManager.World.Enabled = false
    CityPioneerFog:GetInstance():SetFogVisible(false)
    CS.SceneManager.World:SetTouchInputControllerEnable(false)
    DataCenter.CanUnlockFogManager:SetFogActive(false)
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = SavePeopleScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.SavePeople] = effect
    local param = {}
    param.pointId = pointId
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemoveSavePeopleScene()
  CS.SceneManager.World.Enabled = true
  CityPioneerFog:GetInstance():SetFogVisible(true)
  CS.SceneManager.World:SetTouchInputControllerEnable(true)
  DataCenter.CanUnlockFogManager:SetFogActive(true)
  self:DestroyOneObj(GuideAnimObjectType.SavePeople)
end

function GuideCityAnimManager:GuideTimelineMarkerSignal(id)
  if self.useGuideTimelineMarker then
    if id == GuideTimeLineShowMarkerType.End then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UITimelineJump, {anim = false, playEffect = false})
      if self:GetModelByType(GuideAnimObjectType.Scene) ~= nil then
        self:RemoveScene()
      end
      if self:GetModelByType(GuideAnimObjectType.ShowMigrateScene) ~= nil then
        self:RemoveMigrateScene()
      end
      if self:GetModelByType(GuideAnimObjectType.ShowBusinessPlaneArriveScene) ~= nil then
        self:RemoveBusinessPlaneArriveScene()
      end
      if self:GetModelByType(GuideAnimObjectType.ShowRobotScene) ~= nil then
        self:RemoveShowRobotScene()
      end
      if self:GetModelByType(GuideAnimObjectType.ShowFromMjBuildMainBuildScene) ~= nil then
        self:RemoveFromMjBuildMainBuildScene()
      end
      if self:GetModelByType(GuideAnimObjectType.MainZeroUpgradeScene) ~= nil then
        self:RemoveMainZeroUpgradeScene()
      end
      if self:GetModelByType(GuideAnimObjectType.PirateFightBobScene) ~= nil then
        self:RemovePirateFightBobScene()
      end
      if self:GetModelByType(GuideAnimObjectType.PirateComeScene) ~= nil then
        self:RemovePirateComeScene()
      end
      if self:GetModelByType(GuideAnimObjectType.PirateAwayScene) ~= nil then
        self:RemovePirateAwayScene()
      end
      if self:GetModelByType(GuideAnimObjectType.SecondExpandDomeScene) ~= nil then
        self:RemoveSecondExpandDomeScene()
      end
      local model = self:GetModelByType(GuideAnimObjectType.ShowCowScene)
      if model ~= nil then
        model:OnEnd()
        self:RemoveShowCowScene()
      end
      model = self:GetModelByType(GuideAnimObjectType.ShowOstrichEgg)
      if model ~= nil then
        model:OnEnd()
        self:RemoveShowOstrichScene()
      end
      if self:GetModelByType(GuideAnimObjectType.SecondMigrateScene) ~= nil then
        self:RemoveSecondMigrateScene()
      end
      if self:GetModelByType(GuideAnimObjectType.TilePlaneRuin) ~= nil then
        self:RemoveTilePlaneRuin()
      end
      if self:GetModelByType(GuideAnimObjectType.PickUpWeaponScene) ~= nil then
        self:RemovePickUpWeaponScene()
      end
      if self:GetModelByType(GuideAnimObjectType.GuluOutFromBaseScene) ~= nil then
        self:RemoveGuluOutFromBaseScene()
      end
      if self:GetModelByType(GuideAnimObjectType.DefendWallScene) ~= nil then
        self:RemoveDefendWallScene()
      end
      if self:GetModelByType(GuideAnimObjectType.ConnectElectricityScene) ~= nil then
        self:RemoveConnectElectricityScene()
      end
      if self:GetModelByType(GuideAnimObjectType.Chapter2CameraMoveScene) ~= nil then
        self:RemoveChapter2CameraMoveScene()
      end
      self:CheckDoNext()
    else
      self:SetTimeLineContinuePlay(false)
      local model = self:GetModelByType(GuideAnimObjectType.MainZeroUpgradeScene)
      if model ~= nil then
        model:PlayDomedAnim()
      end
      model = self:GetModelByType(GuideAnimObjectType.SecondExpandDomeScene)
      if model ~= nil then
        model:GuideTimelineMarkerSignal()
      end
      local template = DataCenter.GuideManager:GetCurTemplate()
      if template ~= nil then
        if template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete then
          local para2 = template.para2
          if para2 ~= nil then
            DataCenter.GuideManager:SetCurGuideId(tonumber(template.para2))
            DataCenter.GuideManager:DoGuide()
          end
        else
          for k, v in ipairs(template.jumptype) do
            if v == GuideJumpType.TimelineJump and template.jumpid ~= 0 then
              DataCenter.GuideManager:SetNoGotoTime(true)
              DataCenter.GuideManager:SetCurGuideId(template.jumpid)
              DataCenter.GuideManager:DoGuide()
            end
          end
        end
      end
    end
  end
end

function GuideCityAnimManager:SetTimeLineContinuePlay(isContinue)
  if self.model[GuideAnimObjectType.Scene] ~= nil then
    self.model[GuideAnimObjectType.Scene]:SetTimeLineContinuePlay(isContinue)
  end
end

function GuideCityAnimManager:CheckDoNext()
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and (template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete) then
    DataCenter.GuideManager:DoNext()
  end
end

function GuideCityAnimManager:LoadShowOstrichScene(uuid, productId)
  local isSend = true
  local list = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.OstrichBarn)
  if list ~= nil then
    table.walksort(list, function(leftKey, rightKey)
      return list[leftKey].qid < list[rightKey].qid
    end, function(k, v)
      if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Finish or v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Free then
        isSend = false
      end
    end)
  end
  if isSend then
    SFSNetwork.SendMessage(MsgDefines.FarmFarming, {uuid}, productId)
  end
end

function GuideCityAnimManager:GotoTimeSignal(time)
  if time ~= nil then
    self:GotoTime(tonumber(time))
  end
end

function GuideCityAnimManager:GotoTime(time)
  for k, v in pairs(self.model) do
    if v.GotoTime ~= nil then
      v:GotoTime(time)
    end
  end
end

function GuideCityAnimManager:StartPlay(animType)
  if self.model[animType] ~= nil then
    self.model[animType]:StartPlay()
  else
    self.isNeedStart[animType] = true
  end
end

function GuideCityAnimManager:LoadShowGarbageScene()
  DataCenter.GuideManager:SendSaveGuideMessage(SaveNoShowGarbage, "")
  SFSNetwork.SendMessage(MsgDefines.RefreshCityGarbage)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:AfterLoadShowOstrichScene(queueType, qUuid, pos)
  self.useGuideTimelineMarker = true
  DataCenter.GuideManager:SetNoShowUIMain(true)
  DataCenter.BuildBubbleManager:HideBubbleNode()
  local request = ResourceManager:InstantiateAsync(UIAssets.ShowOstrichScene)
  self.instanceReq[GuideAnimObjectType.ShowOstrichEgg] = request
  local param = {}
  param.qUuid = qUuid
  param.pos = pos
  param.queueType = queueType
  param.nameDes = Localization:GetString(GameDialogDefine.SHOW_OSTRICH_NAME)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = ShowOstrichScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.ShowOstrichEgg] = effect
    effect:ReInit(param)
    CityPioneerFog:GetInstance():SetFogVisible(false)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_guide_ostrich, false)
  end)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:RemoveShowOstrichScene()
  self.useGuideTimelineMarker = false
  DataCenter.GuideManager:SetNoShowUIMain(false)
  CS.SceneManager.World:SetTouchInputControllerEnable(true)
  self:DestroyOneObj(GuideAnimObjectType.ShowOstrichEgg)
  CityPioneerFog:GetInstance():SetFogVisible(true)
end

function GuideCityAnimManager:PlayShowOstrichEffect(time, pos)
  self:LoadShowOstrichEffect(pos)
  self:AddTimer(RemoveShowOstrichEffectTime)
end

function GuideCityAnimManager:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function GuideCityAnimManager:AddTimer(time)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

function GuideCityAnimManager:LoadShowOstrichEffect(pos)
  local request = ResourceManager:InstantiateAsync(UIAssets.ShowOstrichEffect)
  self.instanceReq[GuideAnimObjectType.ShowOstrichAnim] = request
  request:completed("+", function()
    CS.SceneManager.World:SetTouchInputControllerEnable(false)
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_localPosition(pos.x, pos.y, pos.z)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetPayReward, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideUnlockMask, {anim = true, playEffect = false})
  end)
end

function GuideCityAnimManager:TimeCallBack()
  self:DeleteTimer()
  self:RemoveShowOstrichEffect()
end

function GuideCityAnimManager:RemoveShowOstrichEffect()
  CS.SceneManager.World:SetTouchInputControllerEnable(true)
  self:DestroyOneObj(GuideAnimObjectType.ShowOstrichAnim)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideUnlockMask, {anim = true, playEffect = false})
end

function GuideCityAnimManager:GetGuideObj(objType)
  if self.model[objType] ~= nil then
    return self.model[objType]:GetGuideObj()
  end
end

function GuideCityAnimManager:LoadMigrateScene(hideLockLandList)
  self.useGuideTimelineMarker = true
  DataCenter.BuildBubbleManager:HideBubbleNode()
  local request = ResourceManager:InstantiateAsync(UIAssets.ShowMigrateScene)
  self.instanceReq[GuideAnimObjectType.ShowMigrateScene] = request
  local param = {}
  local pointId = SceneUtils.TilePosToIndex(DataCenter.BuildManager.main_city_pos)
  param.pos = SceneUtils.TileIndexToWorld(pointId)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = ShowMigrateScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.ShowMigrateScene] = effect
    effect:ReInit(param)
    self:HideLockLandTile(hideLockLandList)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_guide_migrate, false)
  end)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:RemoveMigrateScene()
  self:ShowLockLandTile()
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.ShowMigrateScene)
end

function GuideCityAnimManager:LoadBusinessPlaneArriveScene()
  self.useGuideTimelineMarker = true
  DataCenter.GuideManager:SetNoShowUIMain(true)
  DataCenter.BuildBubbleManager:HideBubbleNode()
  local request = ResourceManager:InstantiateAsync(UIAssets.ShowBusinessPlaneArriveScene)
  self.instanceReq[GuideAnimObjectType.ShowBusinessPlaneArriveScene] = request
  local param = {}
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  if buildData ~= nil then
    param.pos = buildData:GetCenterVec()
  end
  param.des = Localization:GetString(GameDialogDefine.BUSINESSPLANE)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = ShowBusinessPlaneArriveScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.ShowBusinessPlaneArriveScene] = effect
    effect:ReInit(param)
    self:MainCameraSetActive(false)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_guide_plane_arrive, false)
  end)
  CityPioneerFog:GetInstance():SetFogVisible(false)
  pcall(function()
    CS.SceneManager.World:SetStaticVisibleChunk(10)
  end)
end

function GuideCityAnimManager:RemoveBusinessPlaneArriveScene()
  DataCenter.GuideManager:SetNoShowUIMain(false)
  DataCenter.GuideManager:SendSaveGuideMessage(SaveNoShowBusinessPlaneArrive, "")
  DataCenter.ResidentOrderDataManager:DoWhenAnimationGuideFinish()
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.ShowBusinessPlaneArriveScene)
  CityPioneerFog:GetInstance():SetFogVisible(true)
  pcall(function()
    CS.SceneManager.World:SetStaticVisibleChunk(1)
  end)
  self:MainCameraSetActive(true)
end

function GuideCityAnimManager:AfterLoadShowCowScene(queueType, qUuid, pos)
  self.useGuideTimelineMarker = true
  DataCenter.GuideManager:SetNoShowUIMain(true)
  DataCenter.BuildBubbleManager:HideBubbleNode()
  local request = ResourceManager:InstantiateAsync(UIAssets.ShowCowScene)
  self.instanceReq[GuideAnimObjectType.ShowCowScene] = request
  local param = {}
  param.qUuid = qUuid
  param.pos = pos
  param.queueType = queueType
  param.nameDes = Localization:GetString(GameDialogDefine.SHOW_ROW_NAME)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = ShowCowScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.ShowCowScene] = effect
    effect:ReInit(param)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_guide_cattle, false)
  end)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:RemoveShowCowScene()
  self.useGuideTimelineMarker = false
  DataCenter.GuideManager:SetNoShowUIMain(false)
  CS.SceneManager.World:SetTouchInputControllerEnable(true)
  self:DestroyOneObj(GuideAnimObjectType.ShowCowScene)
end

function GuideCityAnimManager:LoadShowRobotScene()
  self.useGuideTimelineMarker = true
  DataCenter.GuideManager:SetNoShowUIMain(true)
  DataCenter.BuildBubbleManager:HideBubbleNode()
  local request = ResourceManager:InstantiateAsync(UIAssets.ShowRobotScene)
  self.instanceReq[GuideAnimObjectType.ShowRobotScene] = request
  local param = {}
  local pointId = SceneUtils.TilePosToIndex(DataCenter.BuildManager.main_city_pos)
  param.pos = SceneUtils.TileIndexToWorld(pointId)
  param.nameDes = Localization:GetString(GameDialogDefine.SHOW_ROBOT_NAME)
  param.des = Localization:GetString(GameDialogDefine.SHOW_ROBOT_DES)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = ShowRobotScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.ShowRobotScene] = effect
    effect:ReInit(param)
    self:MainCameraSetActive(false)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_guide_robot, false)
  end)
  CityPioneerFog:GetInstance():SetFogVisible(false)
  pcall(function()
    CS.SceneManager.World:SetStaticVisibleChunk(10)
  end)
end

function GuideCityAnimManager:RemoveShowRobotScene()
  if self.buildParam ~= nil then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildParam.buildingId)
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.buildParam.buildingId)
    if buildData ~= nil and buildTemplate ~= nil then
      local now = UITimeManager:GetInstance():GetServerTime()
      local buildTime = buildTemplate:GetBuildTime() + 1000
      buildData.state = BuildingStateType.Upgrading
      buildData.startTime = now
      buildData.updateTime = now + buildTime
      DataCenter.GuideManager:SetCanShowBuild(true)
      EventManager:GetInstance():Broadcast(EventId.ShowAllGuideObject)
      EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, buildData.uuid)
      CS.SceneManager.World:Lookat(buildData:GetCenterVec())
      TimerManager:GetInstance():DelayInvoke(function()
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, buildData.uuid)
      end, buildTime)
    end
    self:SetBuildParam()
  end
  DataCenter.GuideManager:SetNoShowUIMain(false)
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.ShowRobotScene)
  CityPioneerFog:GetInstance():SetFogVisible(true)
  pcall(function()
    CS.SceneManager.World:SetStaticVisibleChunk(1)
  end)
  self:MainCameraSetActive(true)
end

local function SetBuildParam(self, param)
  self.buildParam = param
end

function GuideCityAnimManager:LoadFromMjBuildMainBuildScene()
  self.useGuideTimelineMarker = true
  local request = ResourceManager:InstantiateAsync(UIAssets.FromMjBuildMainBuildScene)
  self.instanceReq[GuideAnimObjectType.ShowFromMjBuildMainBuildScene] = request
  local param = {}
  local pointId = SceneUtils.TilePosToIndex(DataCenter.BuildManager.main_city_pos)
  param.pos = SceneUtils.TileIndexToWorld(pointId)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = FromMjBuildMainBuildScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.ShowFromMjBuildMainBuildScene] = effect
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemoveFromMjBuildMainBuildScene()
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.ShowFromMjBuildMainBuildScene)
end

function GuideCityAnimManager:LoadMainZeroUpgradeScene()
  self.useGuideTimelineMarker = true
  local request = ResourceManager:InstantiateAsync(UIAssets.MainZeroUpgradeScene)
  self.instanceReq[GuideAnimObjectType.MainZeroUpgradeScene] = request
  local param = {}
  local pointId = SceneUtils.TilePosToIndex(DataCenter.BuildManager.main_city_pos)
  param.pos = SceneUtils.TileIndexToWorld(pointId)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = MainZeroUpgradeScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.MainZeroUpgradeScene] = effect
    effect:ReInit(param)
    DataCenter.CityPrologueBuildManager:RemoveOneBuild(pointId)
  end)
end

function GuideCityAnimManager:RemoveMainZeroUpgradeScene()
  local model = DataCenter.GuideCityAnimManager:GetModelByType(GuideAnimObjectType.MainZeroUpgradeScene)
  if model ~= nil then
    local cameraPos = model:GetCameraPos()
    if cameraPos ~= nil then
      CS.SceneManager.World:AutoZoom(cameraPos.y, 0)
    end
  end
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.MainZeroUpgradeScene)
  DataCenter.GuideCityManager:SetCityRootActive(false)
  DataCenter.GuideManager:SetCanShowBuild(true)
  EventManager:GetInstance():Broadcast(EventId.ShowAllGuideObject)
  DataCenter.GuideManager:SetNoShowUIMain(false)
  DataCenter.CityDomeManager:ShowCityDomeSignal()
end

function GuideCityAnimManager:HideLockLandTile(needHideLockLandList)
  self.needHideLockLandList = needHideLockLandList
  if self.needHideLockLandList ~= nil then
    for k, v in pairs(self.needHideLockLandList) do
      local data = DataCenter.LandLockManager:GetLandLockDataById(v)
      if data ~= nil and data.state ~= LandLockState.Finished then
        CS.SceneManager.World:HideObject(data:GetPointId())
      end
    end
  end
end

function GuideCityAnimManager:ShowLockLandTile()
  if self.needHideLockLandList ~= nil then
    for k, v in pairs(self.needHideLockLandList) do
      local data = DataCenter.LandLockManager:GetLandLockDataById(v)
      if data ~= nil and data.state ~= LandLockState.Finished then
        CS.SceneManager.World:ShowObject(data:GetPointId())
      end
    end
  end
  self.needHideLockLandList = nil
end

function GuideCityAnimManager:LoadSecondMigrateScene(hideLockLandList)
  self.useGuideTimelineMarker = true
  local request = ResourceManager:InstantiateAsync(UIAssets.SecondMigrateScene)
  self.instanceReq[GuideAnimObjectType.SecondMigrateScene] = request
  local param = {}
  local pointId = SceneUtils.TilePosToIndex(DataCenter.BuildManager.main_city_pos)
  param.pos = SceneUtils.TileIndexToWorld(pointId)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = SecondMigrateScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.SecondMigrateScene] = effect
    effect:ReInit(param)
    self:MainCameraSetActive(false)
    self:HideLockLandTile(hideLockLandList)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_guide_second_migrate, false)
  end)
end

function GuideCityAnimManager:RemoveSecondMigrateScene()
  self:ShowLockLandTile()
  self:MainCameraSetActive(true)
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.SecondMigrateScene)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:LoadTilePlaneRuin(landLockId)
  DataCenter.GuideManager:SetNoShowUIMain(true)
  self.useGuideTimelineMarker = true
  local request = ResourceManager:InstantiateAsync(UIAssets.TilePlaneRuin)
  self.instanceReq[GuideAnimObjectType.TilePlaneRuin] = request
  local param = {}
  param.landLockId = landLockId
  local data = DataCenter.LandLockManager:GetLandLockDataById(landLockId)
  if data ~= nil then
    param.pos = SceneUtils.TileIndexToWorld(data:GetPointId())
  end
  param.des = Localization:GetString(GameDialogDefine.BUSINESSPLANE)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = TilePlaneRuin.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.TilePlaneRuin] = effect
    effect:ReInit(param)
    self:MainCameraSetActive(false)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_guide_plane_arrive, false)
    CityPioneerFog:GetInstance():SetFogVisible(false)
  end)
end

function GuideCityAnimManager:RemoveTilePlaneRuin()
  CityPioneerFog:GetInstance():SetFogVisible(true)
  DataCenter.GuideManager:SetNoShowUIMain(false)
  self:MainCameraSetActive(true)
  self.useGuideTimelineMarker = false
  local model = self.model[GuideAnimObjectType.TilePlaneRuin]
  if model ~= nil then
  end
  self:DestroyOneObj(GuideAnimObjectType.TilePlaneRuin)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:LoadPirateFightBobScene(landLockId)
  DataCenter.GuideManager:SetNoShowUIMain(true)
  self.useGuideTimelineMarker = true
  local request = ResourceManager:InstantiateAsync(UIAssets.PirateFightBobScene)
  self.instanceReq[GuideAnimObjectType.PirateFightBobScene] = request
  local param = {}
  param.landLockId = landLockId
  local data = DataCenter.LandLockManager:GetLandLockDataById(landLockId)
  if data ~= nil then
    param.pos = SceneUtils.TileIndexToWorld(data:GetPointId())
  end
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = PirateFightBobScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.PirateFightBobScene] = effect
    effect:ReInit(param)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Pirate_Fight_Bob, false)
  end)
end

function GuideCityAnimManager:RemovePirateFightBobScene()
  DataCenter.GuideManager:SetNoShowUIMain(false)
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.PirateFightBobScene)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:LoadPirateComeScene(landLockId)
  DataCenter.GuideManager:SetNoShowUIMain(true)
  self.useGuideTimelineMarker = true
  local request = ResourceManager:InstantiateAsync(UIAssets.PirateComeScene)
  self.instanceReq[GuideAnimObjectType.PirateComeScene] = request
  local param = {}
  param.landLockId = landLockId
  local data = DataCenter.LandLockManager:GetLandLockDataById(landLockId)
  if data ~= nil then
    param.pos = SceneUtils.TileIndexToWorld(data:GetPointId())
  end
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = PirateComeScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.PirateComeScene] = effect
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemovePirateComeScene()
  DataCenter.GuideManager:SetNoShowUIMain(false)
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.PirateComeScene)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:LoadPirateAwayScene(landLockId)
  DataCenter.GuideManager:SetNoShowUIMain(true)
  self.useGuideTimelineMarker = true
  local request = ResourceManager:InstantiateAsync(UIAssets.PirateAwayScene)
  self.instanceReq[GuideAnimObjectType.PirateAwayScene] = request
  local param = {}
  param.landLockId = landLockId
  local data = DataCenter.LandLockManager:GetLandLockDataById(landLockId)
  if data ~= nil then
    param.pos = SceneUtils.TileIndexToWorld(data:GetPointId())
  end
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = PirateAwayScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.PirateAwayScene] = effect
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemovePirateAwayScene()
  DataCenter.GuideManager:SetNoShowUIMain(false)
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.PirateAwayScene)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:LoadRadarScanScene()
  DataCenter.BuildBubbleManager:HideBubbleNode()
  local request = ResourceManager:InstantiateAsync(UIAssets.RadarScanScene)
  self.instanceReq[GuideAnimObjectType.RadarScanScene] = request
  local param = {}
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if buildData ~= nil then
    param.pos = buildData:GetCenterVec()
  end
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = RadarScanScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.RadarScanScene] = effect
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemoveRadarScanScene()
  DataCenter.BuildBubbleManager:ShowBubbleNode()
  self:DestroyOneObj(GuideAnimObjectType.RadarScanScene)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:LoadShowFakePlayerFlagScene(pos)
  local request = ResourceManager:InstantiateAsync(UIAssets.ShowFakePlayerFlagScene)
  self.instanceReq[GuideAnimObjectType.ShowFakePlayerFlagScene] = request
  local param = {}
  param.pos = pos
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = ShowFakePlayerFlagScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.ShowFakePlayerFlagScene] = effect
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemoveShowFakePlayerFlagScene()
  self:DestroyOneObj(GuideAnimObjectType.ShowFakePlayerFlagScene)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:LoadRadarWorldScanScene()
  local request = ResourceManager:InstantiateAsync(UIAssets.RadarWorldScanScene)
  self.instanceReq[GuideAnimObjectType.RadarWorldScanScene] = request
  local param = {}
  param.pos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = RadarWorldScanScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.RadarWorldScanScene] = effect
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemoveRadarWorldScanScene()
  self:DestroyOneObj(GuideAnimObjectType.RadarWorldScanScene)
end

function GuideCityAnimManager:LoadPickUpWeaponScene()
  self.useGuideTimelineMarker = true
  local request = ResourceManager:InstantiateAsync(UIAssets.PickUpWeaponScene)
  self.instanceReq[GuideAnimObjectType.PickUpWeaponScene] = request
  local param = {}
  param.pos = CitySpaceMan:GetInstance():GetPosition()
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = PickUpWeaponScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.PickUpWeaponScene] = effect
    effect:ReInit(param)
    CitySpaceMan:GetInstance():SetVisible(false)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_guide_pick_weapon, false)
  end)
end

function GuideCityAnimManager:RemovePickUpWeaponScene()
  CitySpaceMan:GetInstance():SetVisible(true)
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.PickUpWeaponScene)
  DataCenter.GuideManager:DoNext()
end

function GuideCityAnimManager:LoadShowRadarMonsterScene(eventInfo)
  local effect = ShowRadarMonsterScene.New()
  effect:OnCreate()
  self.model[GuideAnimObjectType.ShowRadarMonsterScene] = effect
  local param = {}
  param.eventInfo = eventInfo
  effect:ReInit(param)
end

function GuideCityAnimManager:RemoveShowRadarMonsterScene()
  self:DestroyOneObj(GuideAnimObjectType.ShowRadarMonsterScene)
end

function GuideCityAnimManager:LoadGuluOutFromBaseScene(param)
  self.useGuideTimelineMarker = true
  local request = ResourceManager:InstantiateAsync(UIAssets.GuluOutFromBaseScene)
  self.instanceReq[GuideAnimObjectType.GuluOutFromBaseScene] = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = GuluOutFromBaseScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.GuluOutFromBaseScene] = effect
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemoveGuluOutFromBaseScene()
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.GuluOutFromBaseScene)
end

function GuideCityAnimManager:LoadDefendWallScene(param)
  self.useGuideTimelineMarker = true
  local request = ResourceManager:InstantiateAsync(UIAssets.DefendWallScene)
  self.instanceReq[GuideAnimObjectType.DefendWallScene] = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = DefendWallScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.DefendWallScene] = effect
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemoveDefendWallScene()
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.DefendWallScene)
end

function GuideCityAnimManager:LoadSecondExpandDomeScene()
  self.useGuideTimelineMarker = true
  local param = {}
  param.pos = DataCenter.CityDomeManager:GetDomePos()
  local request = ResourceManager:InstantiateAsync(UIAssets.SecondExpandDomeScene)
  self.instanceReq[GuideAnimObjectType.SecondExpandDomeScene] = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = SecondDomeExpandScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.SecondExpandDomeScene] = effect
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemoveSecondExpandDomeScene()
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.SecondExpandDomeScene)
  DataCenter.CityDomeManager:ChangeRangeCallBack()
end

function GuideCityAnimManager:LoadConnectElectricityScene()
  self.useGuideTimelineMarker = true
  local param = {}
  local request = ResourceManager:InstantiateAsync(UIAssets.ConnectElectricityScene)
  self.instanceReq[GuideAnimObjectType.ConnectElectricityScene] = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = ConnectElectricityScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.ConnectElectricityScene] = effect
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemoveConnectElectricityScene()
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.ConnectElectricityScene)
end

function GuideCityAnimManager:LoadChapter2CameraMoveScene()
  self.useGuideTimelineMarker = true
  local param = {}
  local request = ResourceManager:InstantiateAsync(UIAssets.Chapter2CameraMoveScene)
  self.instanceReq[GuideAnimObjectType.Chapter2CameraMoveScene] = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = Chapter2CameraMoveScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.Chapter2CameraMoveScene] = effect
    effect:ReInit(param)
    self:MainCameraSetActive(false)
  end)
end

function GuideCityAnimManager:RemoveChapter2CameraMoveScene()
  self:MainCameraSetActive(true)
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.Chapter2CameraMoveScene)
end

function GuideCityAnimManager:LoadFirstExpandDomeScene()
  self.useGuideTimelineMarker = true
  local param = {}
  param.pos = DataCenter.CityDomeManager:GetDomePos()
  local request = ResourceManager:InstantiateAsync(UIAssets.FirstExpandDomeScene)
  self.instanceReq[GuideAnimObjectType.FirstExpandDomeScene] = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = FirstDomeExpandScene.New()
    effect:OnCreate(request)
    self.model[GuideAnimObjectType.FirstExpandDomeScene] = effect
    effect:ReInit(param)
  end)
end

function GuideCityAnimManager:RemoveFirstExpandDomeScene()
  self.useGuideTimelineMarker = false
  self:DestroyOneObj(GuideAnimObjectType.FirstExpandDomeScene)
  DataCenter.CityDomeManager:ChangeRangeCallBack()
end

return GuideCityAnimManager
