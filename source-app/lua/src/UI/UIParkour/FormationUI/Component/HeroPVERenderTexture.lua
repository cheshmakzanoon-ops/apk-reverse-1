local HeroPVERenderTexture = BaseClass("HeroPVERenderTexture", UIBaseContainer)
local GameQualitySettings = require("Util.GameQualitySettings")
local base = UIBaseContainer
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
HeroPVERenderTexture.openedRef = 0

local function OnCreate(self)
  base.OnCreate(self)
  self.cameraComp = CS.UnityEngine.Camera.main
end

local function ReleaseCamera(self)
  if not IsNull(self.camera) then
    CS.UnityEngine.GameObject.Destroy(self.camera)
    self.camera = nil
  end
end

local function OnDestroy(self)
  self.cameraComp = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnRenderTexture(self, camera)
  if IsNull(camera) then
    Logger.LogError("#zlh# OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local scale = 1
    if not GameQualitySettings.IsHighGearQuality() then
      scale = 0.8
    end
    local rtWidth = self.rtWidth
    local rtHeight = self.rtHeight
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "BattleEdit"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    self.rawImage:SetColor(Color.New(1, 1, 1, 1))
  end
  camera.targetTexture = self.renderTexture
end

local function ReleaseTexture(self)
  self.rawImage:SetTexture(nil)
  if not IsNull(self.cameraComp) then
    self.cameraComp.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

local function ResetPositions(self)
  DataCenter.LWBattleManager:GetCurBattleLogic():ResetHeroPos()
end

local function MoveHeroSlotPos(self, index, screenPos)
  local ray = self.cameraComp:ScreenPointToRay(Vector3.New(screenPos.x, screenPos.y, 0))
  local origin = ray.origin
  local direction = ray.direction
  local t = -origin.y / direction.y
  local x = origin.x + t * direction.x
  local z = origin.z + t * direction.z
  local pos = Vector3.New(x, 0, z)
  DataCenter.LWBattleManager:GetCurBattleLogic():SetHeroPos(index, pos)
end

local function HeroSlotMoveToIndex(self, index, dstIndex, time)
  DataCenter.LWBattleManager:GetCurBattleLogic():HeroMoveToIndex(index, dstIndex, time)
end

HeroPVERenderTexture.OnCreate = OnCreate
HeroPVERenderTexture.OnDestroy = OnDestroy
HeroPVERenderTexture.OnEnable = OnEnable
HeroPVERenderTexture.OnDisable = OnDisable
HeroPVERenderTexture.OnRenderTexture = OnRenderTexture
HeroPVERenderTexture.ReleaseTexture = ReleaseTexture
HeroPVERenderTexture.ResetPositions = ResetPositions
HeroPVERenderTexture.MoveHeroSlotPos = MoveHeroSlotPos
HeroPVERenderTexture.HeroSlotMoveToIndex = HeroSlotMoveToIndex
return HeroPVERenderTexture
