local base = require("Scene.Monopoly.Performance.Performance.MonopolyPerBase")
local MonopolyUnlockSparkComponent = BaseClass("MonopolyUnlockSparkComponent", base)
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local scaleTime = 1
local moveTime = 0.8
local destroyTime = 0.3
local endPath = "Eff_s0_03_build_icon_end"
local iconPath = "Eff_s0_03_build_icon_fly_jinmendaqiao"

function MonopolyUnlockSparkComponent:__init(mgr, id, lineData)
  self.landId = tonumber(lineData:getValue("land_id"))
  self.endEffect = nil
  self.iconEffect = nil
  self.posOffsetX = 0
  self.posOffsetY = 0
  self.posOffsetZ = 0
  local param = lineData:getValue("param")
  if not string.IsNullOrEmpty(param) then
    local paramArr = string.split(param, ",")
    if paramArr[3] then
      self.posOffsetX = tonumber(paramArr[1])
      self.posOffsetY = tonumber(paramArr[2])
      self.posOffsetZ = tonumber(paramArr[3])
    end
  end
end

function MonopolyUnlockSparkComponent:__delete()
end

function MonopolyUnlockSparkComponent:OnDestroy()
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  end
  if self.sequence then
    self.sequence:Kill()
  end
  if self.touchCamera then
    self.touchCamera:Follow(nil, 0)
  end
  self.landId = nil
  self.endEffect = nil
  self.iconEffect = nil
  self.touchCamera = nil
  self.touchCamera = nil
  base.OnDestroy(self)
end

function MonopolyUnlockSparkComponent:Begin()
  base.Begin(self)
end

function MonopolyUnlockSparkComponent:OnResLoaded(handle)
  base.OnResLoaded(self, handle)
  local data = DataCenter.LandLockManager:GetLandLockDataById(self.landId)
  local pointId = data:GetPointId()
  local pos = SceneUtils.TileIndexToWorld(pointId)
  self.gameObject.transform:Set_position(pos.x + self.posOffsetX, pos.y + self.posOffsetY, pos.z + self.posOffsetZ)
  self.endEffect = self.gameObject.transform:Find(endPath).gameObject
  self.endEffect:SetActive(false)
  self.iconEffect = self.gameObject.transform:Find(iconPath).gameObject
  self.iconEffect:SetActive(true)
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, scaleTime + moveTime + destroyTime)
  local camera = CS.UnityEngine.Camera.main
  self.touchCamera = camera:GetComponent(typeof(MobileTouchCamera))
  self.touchCamera:Follow(self.gameObject, 0.4)
  local targetPos = DataCenter.LWCivilizationSparkManager:GetBuildPos()
  self.sequence = DOTween.Sequence()
  self.sequence:AppendInterval(scaleTime)
  self.sequence:Append(self.gameObject.transform:DOMove(targetPos, moveTime):SetEase(CS.DG.Tweening.Ease.InOutCubic))
  self.sequence:AppendCallback(function()
    self.touchCamera:Follow(nil, 0)
    self.endEffect:SetActive(true)
    self.iconEffect:SetActive(false)
  end)
  self.sequence:AppendInterval(destroyTime)
  self.sequence:AppendCallback(function()
    self.endEffect:SetActive(false)
    self.mgr:TryTriggerPerformanceEnd(self.id)
  end)
end

function MonopolyUnlockSparkComponent:End()
  base.End(self)
end

return MonopolyUnlockSparkComponent
