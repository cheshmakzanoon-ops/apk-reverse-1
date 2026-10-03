local ParkScene = BaseClass("ParkScene")
local Resource = CS.GameEntry.Resource
local GameQualitySettings = require("Util.GameQualitySettings")
local ScenePath = "Assets/Main/Prefabs/LWRailway/ParkScene.prefab"
local SceneOffset = 10000
local RoadAsset = {
  [0] = "Assets/Main/Sprites/UI/UILWRailway/lrb_tongmenghuoche_budui0.png",
  [1] = "Assets/Main/Sprites/UI/UILWRailway/lrb_tongmenghuoche_budui1.png",
  [2] = "Assets/Main/Sprites/UI/UILWRailway/lrb_tongmenghuoche_budui2.png",
  [3] = "Assets/Main/Sprites/UI/UILWRailway/lrb_tongmenghuoche_budui3.png",
  [4] = "Assets/Main/Sprites/UI/UILWRailway/lrb_tongmenghuoche_budui4.png"
}

function ParkScene:__init(renderTexture)
  self:DataDefine(renderTexture)
  self:LoadScene()
  DataCenter.ActWinterStormManager:TryCancelMatch(WinterStormCancelType.Park)
end

function ParkScene:__delete()
  self:Destroy()
end

function ParkScene:AddListeners()
end

function ParkScene:RemoveListeners()
end

function ParkScene:Destroy()
  self:RemoveListeners()
  self:ComponentDestroy()
  self:UnInitCamera()
  self:DestroyScene()
  self:DataDestroy()
end

function ParkScene:LoadScene()
  if self.sceneLoadRequest then
    return
  end
  local req = Resource:InstantiateAsync(ScenePath)
  req:completed("+", function()
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_localPosition(SceneOffset, 0, SceneOffset)
    SceneOffset = SceneOffset + 20
    self:OnSceneLoadFinish()
  end)
  self.sceneLoadRequest = req
end

function ParkScene:OnSceneLoadFinish()
  self:InitCamera()
  self:ComponentDefine()
  self:AddListeners()
  self:RefreshRoad()
  self:RefreshTank()
  self.sceneLoadFinish = true
end

function ParkScene:ComponentDefine()
  local transform = self.sceneLoadRequest.gameObject.transform
  self.slot = {}
  for i = 1, ArmyFormationSlot.Dominator do
    self.slot[i] = transform:Find("Heroes/Slot" .. i)
  end
  self.road = transform:Find("Static/Road"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
end

function ParkScene:ComponentDestroy()
  self:RemoveTank()
  self.slot = {}
end

function ParkScene:DataDefine(renderTexture)
  self.renderTexture = renderTexture
end

function ParkScene:DataDestroy()
  self.renderTexture = nil
end

function ParkScene:DestroyScene()
  if self.sceneLoadRequest then
    self.sceneLoadRequest:Destroy()
    self.sceneLoadRequest = nil
  end
end

function ParkScene:InitCamera()
  self.camera = self.sceneLoadRequest.gameObject.transform:Find("Camera"):GetComponent(typeof(CS.UnityEngine.Camera))
  GameQualitySettings.TogglePostProcess(true)
  if self.renderTexture ~= nil then
    self.camera.targetTexture = self.renderTexture
  end
end

function ParkScene:UnInitCamera()
  if self.camera then
    self.camera.targetTexture = nil
    self.camera = nil
  end
end

function ParkScene:GetTouchItemScreenPos(modelPos)
  local newPos = PosConverse.WorldToScreenPos(modelPos, self.camera)
  return newPos
end

function ParkScene:SetHero(squadNo, heroInfoList)
  self.squadNo = squadNo
  self.heroList = heroInfoList
  if self.sceneLoadFinish == true then
    self:RefreshRoad()
    self:RefreshTank()
  end
end

function ParkScene:RefreshRoad()
end

function ParkScene:RefreshTank()
  self:RemoveTank()
  if not self.heroList then
    return
  end
  for k, v in pairs(self.heroList) do
    local modelPath, appearanceId, modelSourceType = v:GetHeroModelData(HeroModelType.Battle)
    if not string.IsNullOrEmpty(modelPath) and appearanceId ~= nil then
      self.tank[k] = Resource:InstantiateAsync(modelPath)
      self.tank[k]:completed("+", function(request)
        local gameObject = request.gameObject
        local transform = gameObject.transform
        transform:SetParent(self.slot[k])
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      end)
    end
  end
end

function ParkScene:RemoveTank()
  if self.tank then
    for _, v in pairs(self.tank) do
      v:Destroy()
    end
  end
  self.tank = {}
end

return ParkScene
