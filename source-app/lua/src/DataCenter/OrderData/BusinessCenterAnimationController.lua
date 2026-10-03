local BusinessCenterAnimationController = BaseClass("BusinessCenterAnimationController", Singleton)
local AniName = {
  IDLE = "idle",
  LEAVE = "feichu",
  BACK = "feihui",
  BACK_1 = "feihui_02",
  NEW_PLANE = "idle_01"
}
local AniState = {
  STATE_NULL = 0,
  STATE_IDLE = 1,
  STATE_LEAVE = 2,
  STATE_BACK = 3,
  STATE_NEW_PLANE = 4
}
local leave_smoke = "ModelGo/Normal/A_build_hygs_sampler/A_build@hygs_skin/To_unity/Root/VFX_yunshuche_smoke_zou"
local leave_fire_left = "ModelGo/Normal/A_build_hygs_sampler/A_build@hygs_skin/To_unity/Root/joint1/joint2/joint4/guadian_L/VFX_yunshuche_fire02_zou"
local leave_fire_right = "ModelGo/Normal/A_build_hygs_sampler/A_build@hygs_skin/To_unity/Root/joint1/joint2/joint3/guadian_R/VFX_yunshuche_fire01_zou"
local leave_fire_back = "ModelGo/Normal/A_build_hygs_sampler/A_build@hygs_skin/To_unity/Root/joint1/joint2/guadian/VFX_yunshuche_hou_zou"
local back_smoke = "ModelGo/Normal/A_build_hygs_sampler/A_build@hygs_skin/To_unity/Root/VFX_yunshuche_smoke_hui"
local back_fire_left = "ModelGo/Normal/A_build_hygs_sampler/A_build@hygs_skin/To_unity/Root/joint1/joint2/joint4/guadian_L/VFX_yunshuche_fire02_hui"
local back_fire_right = "ModelGo/Normal/A_build_hygs_sampler/A_build@hygs_skin/To_unity/Root/joint1/joint2/joint3/guadian_R/VFX_yunshuche_fire01_hui"
local back_fire_back = "ModelGo/Normal/A_build_hygs_sampler/A_build@hygs_skin/To_unity/Root/joint1/joint2/guadian/VFX_yunshuche_hou_hui"

local function __init(self)
  self.curAniState = AniState.STATE_NULL
  EventManager:GetInstance():AddListener(EventId.BuildConnect, self.OnBuildConnect)
end

local function __delete(self)
  self.curAniState = AniState.STATE_NULL
  EventManager:GetInstance():RemoveListener(EventId.BuildConnect, self.OnBuildConnect)
end

local function ShowAnimation(self, animationName, state)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  if buildData == nil or buildData.level <= 0 or CS.SceneManager.World == nil then
    return false
  end
  local city = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
  if city == nil then
    return false
  end
  local time = city:PlayAnim(animationName)
  if time <= 0 then
    return false
  end
  self:AddEffect(city.gameObject, state)
  return true, time * 1000
end

local function ShowNewPlaneAnimation(self)
  return self:ShowAnimation(AniName.NEW_PLANE, AniState.STATE_NEW_PLANE)
end

local function ShowLeaveAnimation(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Plane_Leave, false)
  return self:ShowAnimation(AniName.LEAVE, AniState.STATE_LEAVE)
end

local function ShowBackAnimation(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Plane_Arrive, false)
  local aniName = AniName.BACK
  if DataCenter.ResidentOrderDataManager:IsGuideSpecialBubbleShow() == false then
    aniName = AniName.BACK_1
  end
  local flag, time = self:ShowAnimation(aniName, AniState.STATE_BACK)
  if flag == true and DataCenter.ResidentOrderDataManager:IsGuideSpecialBubbleShow() == true then
    self.backTime = time + 1000
  end
  return flag
end

local function ShowIdleAnimation(self)
  return self:ShowAnimation(AniName.IDLE, AniState.STATE_IDLE)
end

local function GetBackTime(self)
  if DataCenter.ResidentOrderDataManager:IsGuideSpecialBubbleShow() == false then
    return DefaultBackTime_1
  end
  return self.backTime or DefaultBackTime
end

local function RefreshState(self)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  if list == nil or table.count(list) == 0 then
    return
  end
  local state = AniState.STATE_IDLE
  if DataCenter.ResidentOrderDataManager:IsGuideSpecialAnimationShow() == false then
    state = AniState.STATE_NEW_PLANE
  else
    local leftTime = DataCenter.ResidentOrderDataManager:GetOrderSendLeftTime()
    if 0 < leftTime then
      local backTime = self:GetBackTime()
      if leftTime > backTime then
        state = AniState.STATE_LEAVE
      else
        state = AniState.STATE_BACK
      end
    end
  end
  if state ~= self.curAniState or state == AniState.STATE_NEW_PLANE then
    if state == AniState.STATE_IDLE then
      EventManager:GetInstance():Broadcast(EventId.RefreshResidentOrder)
    end
    local result = false
    if state == AniState.STATE_IDLE then
      result = self:ShowIdleAnimation()
    elseif state == AniState.STATE_LEAVE then
      result = self:ShowLeaveAnimation()
    elseif state == AniState.STATE_BACK then
      result = self:ShowBackAnimation()
    elseif state == AniState.STATE_NEW_PLANE then
      result = self:ShowNewPlaneAnimation()
    end
    if result == true then
      self.curAniState = state
    end
  end
end

local function AddEffect(self, gameObject, state)
  if gameObject == nil then
    return
  end
  local leave_left = gameObject.transform:Find(leave_fire_left).gameObject
  local leave_right = gameObject.transform:Find(leave_fire_right).gameObject
  local leave_back = gameObject.transform:Find(leave_fire_back).gameObject
  local leave_down = gameObject.transform:Find(leave_smoke).gameObject
  local back_left = gameObject.transform:Find(back_fire_left).gameObject
  local back_right = gameObject.transform:Find(back_fire_right).gameObject
  local back_back = gameObject.transform:Find(back_fire_back).gameObject
  local back_down = gameObject.transform:Find(back_smoke).gameObject
  if leave_left == nil then
    return
  end
  leave_left:SetActive(false)
  leave_right:SetActive(false)
  leave_back:SetActive(false)
  leave_down:SetActive(false)
  back_left:SetActive(false)
  back_right:SetActive(false)
  back_back:SetActive(false)
  back_down:SetActive(false)
  if state == AniState.STATE_LEAVE then
    leave_left:SetActive(true)
    leave_right:SetActive(true)
    leave_back:SetActive(true)
    leave_down:SetActive(true)
  elseif state == AniState.STATE_BACK then
    back_left:SetActive(true)
    back_right:SetActive(true)
    back_back:SetActive(true)
    back_down:SetActive(true)
  end
end

local function DoWhenBuildInView(self, data)
  local bUuid = data
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil and buildData.itemId == BuildingTypes.FUN_BUILD_BUSINESS_CENTER and DataCenter.BuildManager:IsBuildInView(bUuid) and DataCenter.ResidentOrderDataManager:IsGuideSpecialAnimationShow() == false then
    TimerManager:GetInstance():DelayInvoke(function()
      BusinessCenterAnimationController:GetInstance().curAniState = nil
      BusinessCenterAnimationController:GetInstance():RefreshState()
    end, 0.01)
  end
end

local function OnBuildConnect(data)
  local bUuid = data
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil and buildData.itemId == BuildingTypes.FUN_BUILD_BUSINESS_CENTER and DataCenter.BuildManager:IsBuildInView(bUuid) and DataCenter.ResidentOrderDataManager:IsGuideSpecialAnimationShow() == false then
    TimerManager:GetInstance():DelayInvoke(function()
      BusinessCenterAnimationController:GetInstance().curAniState = nil
      BusinessCenterAnimationController:GetInstance():RefreshState()
    end, 0.01)
  end
end

BusinessCenterAnimationController.ShowAnimation = ShowAnimation
BusinessCenterAnimationController.ShowLeaveAnimation = ShowLeaveAnimation
BusinessCenterAnimationController.ShowBackAnimation = ShowBackAnimation
BusinessCenterAnimationController.ShowIdleAnimation = ShowIdleAnimation
BusinessCenterAnimationController.GetBackTime = GetBackTime
BusinessCenterAnimationController.__init = __init
BusinessCenterAnimationController.__delete = __delete
BusinessCenterAnimationController.RefreshState = RefreshState
BusinessCenterAnimationController.AddEffect = AddEffect
BusinessCenterAnimationController.ShowNewPlaneAnimation = ShowNewPlaneAnimation
BusinessCenterAnimationController.OnBuildConnect = OnBuildConnect
BusinessCenterAnimationController.DoWhenBuildInView = DoWhenBuildInView
return BusinessCenterAnimationController
