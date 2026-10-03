local BuildQueueGuide = BaseClass("BuildQueueGuide")
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local CitySpaceManAnimationListener = CS.CitySpaceManAnimationListener
local ResourceManager = CS.GameEntry.Resource
local UniversalAdditionalCameraData = CS.UnityEngine.Rendering.Universal.UniversalAdditionalCameraData
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local FIRST_CONTRACT_TL = "Assets/Main/Prefabs/LWBuildQueue/gongrenlianxiang_timeline01.prefab"
local LightPath = "City/Scene_City2(Clone)/Light_City"
local LightTrack = "Light"
local firstContractTLReq, firstContractTLIns
local TL_OFFSET = 5

local function ShowCollectEffect(build)
  TimerManager:GetInstance():DelayInvoke(function()
    local icon = DataCenter.RewardManager:GetPicByType(RewardType.WORKER)
    local tar = Vector3.New(-1917, 1240, 0)
    local pos = CS.CSUtils.WorldPositionToUISpacePosition(SceneUtils.TileIndexToWorld(build.pointId))
    local mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if mainUI and mainUI.View then
      tar = mainUI.View:GetSavePos(UIMainSavePosType.BuildQueue)
    end
    UIUtil.DoFlyCustom(icon, "", 10, pos, tar, nil, nil, function(i)
      if i == 1 then
        obj = CS.UnityEngine.GameObject.Find("GameFramework/UI/UIContainer/UIResource/UIMain/safeArea/leftLayer/BuildQueue/icon")
        obj.transform:DOKill()
        obj.transform:DOPunchScale(Vector3.New(0.3, 0.3, 0.3), 1.6, 13, 0)
      end
      if i == 10 then
        obj = CS.UnityEngine.GameObject.Find("GameFramework/UI/UIContainer/UIResource/UIMain/safeArea/leftLayer/BuildQueue/text")
        obj.transform:DOKill()
        obj.transform:DOPunchScale(Vector3.New(0.5, 0.5, 0.5), 0.5, 3, 0)
      end
    end, nil, nil, nil, 0, nil)
  end, 0.2)
end

local function FirstContract(self, upgrade, mainCamerafocus)
  if firstContractTLReq ~= nil or firstContractTLIns ~= nil then
    return
  end
  local light = CS.UnityEngine.GameObject.Find(LightPath)
  firstContractTLReq = ResourceManager:InstantiateAsync(FIRST_CONTRACT_TL)
  firstContractTLReq:completed("+", function()
    for name, _ in pairs(UIManager:GetInstance().windows) do
      if name ~= UIWindowNames.UIMain then
        UIManager:GetInstance():DestroyWindow(name)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildQueueFirstContract)
    local camera = firstContractTLReq.gameObject:GetComponentInChildren(typeof(UniversalAdditionalCameraData))
    camera.cameraStack:Add(CS.GameEntry.UICamera)
    firstContractTLIns = firstContractTLReq.gameObject:GetComponent(typeof(PlayableDirector))
    firstContractTLIns.transform:Set_position(-999, 0, -999)
    local lightTrackBind
    local arr = firstContractTLIns.playableAsset:GetOutputTracks()
    for i = 0, arr.Length - 1 do
      local output = arr[i]
      if output.name == LightTrack then
        lightTrackBind = output
        break
      end
    end
    firstContractTLIns:SetGenericBinding(lightTrackBind, light)
    local Listener = firstContractTLReq.gameObject:GetComponent(typeof(CitySpaceManAnimationListener))
    
    function Listener.animation_attackBegin()
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIBuildQueueFirstContract) then
        firstContractTLIns:Pause()
        local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIBuildQueueFirstContract)
        window.View.tl = firstContractTLIns
        window.View:EnableClick()
      end
    end
    
    local data = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILD_WORKER_HOUSE)
    local cityObj, pos
    if upgrade then
      function Listener.animation_attackDone()
        if data then
          local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(data.uuid)
          
          if buildData then
            cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
          end
        end
        if cityObj then
          pos = cityObj:GetTransform().position
          if firstContractTLIns then
            firstContractTLIns.transform:Set_position(pos.x, pos.y, pos.z - TL_OFFSET)
          end
          cityObj.transform:Set_position(pos.x, pos.y - 100, pos.z)
        end
      end
    else
      function Listener.animation_attackDone()
        if data then
          local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(data.uuid)
          
          if buildData then
            cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
            ShowCollectEffect(buildData)
          end
        end
        if firstContractTLReq then
          firstContractTLReq:Destroy()
          firstContractTLReq = nil
          firstContractTLIns = nil
        end
        Listener.animation_attackBegin = nil
        Listener.animation_attackDone = nil
        Listener.animation_playEnd = nil
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildQueueFirstContract)
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        if cityObj and mainCamerafocus then
          local cam = CS.UnityEngine.Camera.main
          cam:GetComponent(typeof(MobileTouchCamera)):LookAt(cityObj:GetTransform().position)
        end
      end
    end
    
    function Listener.animation_playEnd()
      if firstContractTLReq then
        firstContractTLReq:Destroy()
        firstContractTLReq = nil
        firstContractTLIns = nil
      end
      Listener.animation_attackBegin = nil
      Listener.animation_attackDone = nil
      Listener.animation_playEnd = nil
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildQueueFirstContract)
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
      if cityObj and mainCamerafocus then
        if pos then
          cityObj.transform:Set_position(pos.x, pos.y, pos.z)
        end
        cityObj:ChangeToBox()
        local cam = CS.UnityEngine.Camera.main
        cam:GetComponent(typeof(MobileTouchCamera)):LookAt(cityObj:GetTransform().position)
      end
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(data.uuid)
      ShowCollectEffect(buildData)
    end
  end)
end

BuildQueueGuide.FirstContract = FirstContract
return BuildQueueGuide
