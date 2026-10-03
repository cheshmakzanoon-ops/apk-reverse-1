local HSRViewManager = BaseClass("HSRViewManager")
local HSRView = require("DataCenter.LWRailway.HighSpeedRailway.HSRView")
local Resource = CS.GameEntry.Resource

function HSRViewManager:__init()
  self.checkCd = 1
  self.hsrView = nil
  self.needShowHSR = false
  self:AddListeners()
end

function HSRViewManager:__delete()
  self:RemoveListeners()
  self:ClearAllView()
end

function HSRViewManager:Init()
end

function HSRViewManager:ClearAllView()
  self:RemoveBubble()
  self:RemoveNorthDoor()
  self:RemoveSouthDoor()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.delayCheckView then
    self.delayCheckView:Stop()
    self.delayCheckView = nil
  end
  if self.hsrView then
    self.hsrView:Destroy()
    self.hsrView = nil
  end
end

function HSRViewManager:AddListeners()
  EventManager:GetInstance():AddListener(EventId.WorldCameraViewChanged, self.OnWorldCameraViewChanged)
  EventManager:GetInstance():AddListener(EventId.BeforeLeaveWorld, self.OnExitWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorldState, self.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.OnChangeCameraLod)
  EventManager:GetInstance():AddListener(EventId.OnEnterCrossServer, self.OnCrossServer)
  EventManager:GetInstance():AddListener(EventId.OnQuitCrossServer, self.OnCrossServer)
  EventManager:GetInstance():AddListener(EventId.HSRHeadDataRefresh, self.OnHSRHeadDataRefresh)
end

function HSRViewManager:RemoveListeners()
  EventManager:GetInstance():RemoveListener(EventId.WorldCameraViewChanged, self.OnWorldCameraViewChanged)
  EventManager:GetInstance():RemoveListener(EventId.BeforeLeaveWorld, self.OnExitWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorldState, self.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.OnChangeCameraLod)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCrossServer, self.OnCrossServer)
  EventManager:GetInstance():RemoveListener(EventId.OnQuitCrossServer, self.OnCrossServer)
  EventManager:GetInstance():RemoveListener(EventId.HSRHeadDataRefresh, self.OnHSRHeadDataRefresh)
end

function HSRViewManager.OnCrossServer()
  local self = DataCenter.HSRViewManager
  if self.curServerId and SeasonUtil.IsInSameMap(self.curServerId, ServerEnum.View) then
    return
  end
  self.OnEnterWorld()
end

function HSRViewManager.OnEnterWorld()
  local self = DataCenter.HSRViewManager
  self.curServerId = LuaEntry.Player:GetCurServerId()
  self:ClearAllView()
  self.needShowHSR = SeasonUtil.IsInSameGroup(LuaEntry.Player:GetCurServerId())
  if self.runInNineNationBasicMode == nil then
    self.runInNineNationBasicMode = SeasonUtil.IsInSeasonNineNationBasicMode(true)
  end
  if not self.runInNineNationBasicMode then
    self.needShowHSR = false
  end
  if self.needShowHSR then
    if self.updateTimer == nil then
      function self.updateTimer()
        self:OnUpdate()
      end
      
      UpdateManager:GetInstance():AddUpdate(self.updateTimer)
    end
  elseif self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function HSRViewManager.OnExitWorld()
  DataCenter.HSRViewManager:ClearAllView()
end

function HSRViewManager.OnWorldCameraViewChanged(rect)
  local self = DataCenter.HSRViewManager
  if rect then
    self.rectMinX = rect[1]
    self.rectMinY = rect[2]
    self.rectMaxX = rect[3]
    self.rectMaxY = rect[4]
    if self.delayCheckView then
      self.delayCheckView:Stop()
    end
    if self.needShowHSR then
      self.delayCheckView = TimerManager:GetInstance():DelayInvoke(function()
        self.checkCd = 1
        self:CheckTrainInOutView()
        self:CheckBubbleInOutView()
      end, 0.1)
    end
  end
end

function HSRViewManager:OnUpdate()
  if self.hsrView then
    self.hsrView:OnUpdate()
  end
  self.checkCd = self.checkCd - Time.deltaTime
  if self.checkCd < 0 then
    self.checkCd = 1
    self:CheckTrainInOutView()
  end
end

function HSRViewManager:CheckTrainInOutView()
  if not self.needShowHSR then
    return
  end
  local hsrData = DataCenter.HSRDataManager:GetHSRData()
  if hsrData and hsrData:IsInView(self.rectMinX, self.rectMinY, self.rectMaxX, self.rectMaxY) then
    if not self.hsrView then
      self.hsrView = HSRView.New()
      self.hsrView:Init(hsrData)
    end
  elseif self.hsrView then
    self.hsrView:Destroy()
    self.hsrView = nil
  end
end

function HSRViewManager:IsInViewRect(worldPos)
  local tilePos = SceneUtils.WorldToUniqueTile(worldPos)
  return self.rectMinX <= tilePos.x and tilePos.x <= self.rectMaxX and self.rectMinY <= tilePos.y and tilePos.y <= self.rectMaxY
end

function HSRViewManager:GetCurLod()
  if self.Lod == nil then
    if CS.SceneManager.World then
      self.Lod = CS.SceneManager.World:GetLodLevel()
    else
      self.Lod = 10
    end
  end
  return self.Lod
end

function HSRViewManager:ClearHSRView()
  if self.hsrView then
    self.hsrView:Destroy()
    self.hsrView = nil
  end
end

function HSRViewManager.OnChangeCameraLod(lod)
  DataCenter.HSRViewManager.Lod = lod
end

function HSRViewManager:GetHSRViewFollowGO(uuid)
  if self.hsrView and self.hsrView.hsrData.uuid == uuid then
    return self.hsrView:GetFollowGO()
  end
end

local NorthDoorTileX = 1500
local NorthDoorTileY = 2000
local SouthDoorTileX = 1500
local SouthDoorTileY = 1000

function HSRViewManager:CheckBubbleInOutView()
  if not self.needShowHSR then
    return
  end
  local theServerId = LuaEntry.Player:GetCurServerId()
  local _, point = SeasonUtil.GetCenterCityId(theServerId)
  local tilePos = SceneUtils.IndexToTilePos(point, ForceChangeScene.World)
  tilePos.x = WorldTileCount + tilePos.x
  tilePos.y = WorldTileCount + tilePos.y
  local isInView = self.rectMinX <= tilePos.x and tilePos.x <= self.rectMaxX and self.rectMinY <= tilePos.y and tilePos.y <= self.rectMaxY
  if isInView and not self.bubble then
    local worldPos = SceneUtils.UniqueTileToWorld(tilePos)
    self:ShowBubble(worldPos)
  elseif not isInView and self.bubble then
    self:RemoveBubble()
  end
end

function HSRViewManager:CheckDoorInOutView()
  local isInView = self.rectMinX <= NorthDoorTileX and NorthDoorTileX <= self.rectMaxX and self.rectMinY <= NorthDoorTileY and NorthDoorTileY <= self.rectMaxY
  if isInView and not self.northDoor then
    self:ShowNorthDoor()
  elseif not isInView and self.northDoor then
    self:RemoveNorthDoor()
  end
  isInView = self.rectMinX <= SouthDoorTileX and SouthDoorTileX <= self.rectMaxX and self.rectMinY <= SouthDoorTileY and SouthDoorTileY <= self.rectMaxY
  if isInView and not self.southDoor then
    self:ShowSouthDoor()
  elseif not isInView and self.southDoor then
    self:RemoveSouthDoor()
  end
end

function HSRViewManager:RemoveBubble()
  if self.bubbleTrigger then
    self.bubbleTrigger.onPointerClick = nil
    self.bubbleTrigger = nil
  end
  if self.bubble then
    self.bubble:Destroy()
    self.bubble = nil
  end
end

function HSRViewManager:ShowBubble(worldPos)
  self:RemoveBubble()
  self.bubble = Resource:InstantiateAsync("Assets/Main/SeasonRes/S5/Prefabs/World/HSRBubble.prefab")
  self.bubble:completed("+", function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    local transform = go.transform
    transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    transform:Set_eulerAngles(0, 0, 0)
    transform:Set_position(worldPos.x, 14, worldPos.z)
    self.bubbleTrigger = transform:Find("Go/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
    if self.bubbleTrigger then
      function self.bubbleTrigger.onPointerClick()
        RailwayUtil.TryOpenHSRMain()
      end
    end
  end)
end

function HSRViewManager:RemoveNorthDoor()
  if self.northDoor then
    self.northDoor:Destroy()
    self.northDoor = nil
  end
end

function HSRViewManager:RemoveSouthDoor()
  if self.southDoor then
    self.southDoor:Destroy()
    self.southDoor = nil
  end
end

function HSRViewManager:ShowNorthDoor()
  self:RemoveNorthDoor()
  self.northDoor = Resource:InstantiateAsync("Assets/Main/SeasonRes/S5/Prefabs/World/beimen.prefab")
  self.northDoor:completed("+", function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    local transform = go.transform
    transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    transform:Set_eulerAngles(0, 0, 0)
    transform:Set_position(2998.86, 0, 4002.74)
  end)
end

function HSRViewManager:ShowSouthDoor()
  self:RemoveSouthDoor()
  self.southDoor = Resource:InstantiateAsync("Assets/Main/SeasonRes/S5/Prefabs/World/nanmen.prefab")
  self.southDoor:completed("+", function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    local transform = go.transform
    transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    transform:Set_localScale(2, 2, 2)
    transform:Set_eulerAngles(0, 0, 0)
    transform:Set_position(2998.606, 0, 1995.92)
  end)
end

function HSRViewManager:OnHSRHeadDataRefresh()
  local self = DataCenter.HSRViewManager
  if self.hsrView then
    self.hsrView:OnHSRHeadDataRefresh()
  end
end

return HSRViewManager
