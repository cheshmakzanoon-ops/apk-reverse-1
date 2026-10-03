local Resource = CS.GameEntry.Resource
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameIdleBattleSceneManager = BaseClass("T11IdleGameIdleBattleSceneManager")
local T11IdleGameIdleBattleScene = require("DataCenter/T11IdleGame/IdleBattle/Battle/Scene/T11IdleGameIdleBattleScene")

function T11IdleGameIdleBattleSceneManager:__init(logic)
  self.logic = logic
  self.sceneDataDict = {}
  self.curShowIndex = 1
  self.scene1 = nil
  self.scene2 = nil
  self.scene3 = nil
  self.sceneParent = nil
  self.sceneRoot01 = nil
  self.sceneRoot02 = nil
  self.sceneRoot03 = nil
end

function T11IdleGameIdleBattleSceneManager:__delete()
  self:Destroy()
end

function T11IdleGameIdleBattleSceneManager:Destroy()
  self.sceneDataDict = nil
  self.curShowIndex = nil
  if self.scene1 then
    self.scene1:Destroy()
    self.scene1 = nil
  end
  if self.scene2 then
    self.scene2:Destroy()
    self.scene2 = nil
  end
  if self.scene3 then
    self.scene3:Destroy()
    self.scene3 = nil
  end
  self.sceneParent = nil
  self.sceneRoot01 = nil
  self.sceneRoot02 = nil
  self.sceneRoot03 = nil
end

function T11IdleGameIdleBattleSceneManager:OnUpdate(dt)
  if self.scene1 then
    self.scene1:OnUpdate(dt)
  end
  if self.scene2 then
    self.scene2:OnUpdate(dt)
  end
  if self.scene3 then
    self.scene3:OnUpdate(dt)
  end
end

function T11IdleGameIdleBattleSceneManager:Init(root, finishCallback)
  self.curShowIndex = 1
  self.sceneParent = root
  local cameraPos, cameraWidth, cameraHeight = self.logic:GetCameraInfo()
  if IsNull(self.sceneParent) then
    return
  end
  
  local function OnSingleSceneLoaded()
    if not self.scene1 or not self.scene1:IsLoaded() then
      return
    end
    if not self.scene2 or not self.scene2:IsLoaded() then
      return
    end
    if not self.scene3 or not self.scene3:IsLoaded() then
      return
    end
    if finishCallback then
      finishCallback()
    end
  end
  
  self.sceneRoot01 = self.sceneParent.transform:Find("bg01").gameObject
  self.sceneRoot02 = self.sceneParent.transform:Find("bg02").gameObject
  self.sceneRoot03 = self.sceneParent.transform:Find("bg03").gameObject
  local startX = 0
  local sceneData1 = self:GetSceneDataByIndex(self.curShowIndex)
  self.scene1 = T11IdleGameIdleBattleScene.New(self, self.sceneRoot01, 1)
  self.scene1:Load(sceneData1.prefabPath, sceneData1.length, function()
    OnSingleSceneLoaded()
  end)
  self.scene1:SetLocalX(startX)
  startX = startX + sceneData1.length
  local sceneData2 = self:GetSceneDataByIndex(self.curShowIndex + 1)
  self.scene2 = T11IdleGameIdleBattleScene.New(self, self.sceneRoot02, 2)
  self.scene2:Load(sceneData2.prefabPath, sceneData2.length, function()
    OnSingleSceneLoaded()
  end)
  self.scene2:SetLocalX(startX)
  startX = startX + sceneData2.length
  local sceneData3 = self:GetSceneDataByIndex(self.curShowIndex + 2)
  self.scene3 = T11IdleGameIdleBattleScene.New(self, self.sceneRoot03, 3)
  self.scene3:Load(sceneData3.prefabPath, sceneData3.length, function()
    OnSingleSceneLoaded()
  end)
  self.scene3:SetLocalX(startX)
  startX = startX + sceneData3.length
end

function T11IdleGameIdleBattleSceneManager:Start()
  local viewWidth = self:GetCameraViewWidth()
  local length1 = self.scene1:GetLength()
  self.scene1:MoveToLocalX(-1 * (viewWidth / 2 + length1 / 2), function(scene)
    self:OnMoveFinish(scene)
  end)
  local length2 = self.scene2:GetLength()
  self.scene2:MoveToLocalX(-1 * (viewWidth / 2 + length2 / 2), function(scene)
    self:OnMoveFinish(scene)
  end)
  local length3 = self.scene3:GetLength()
  self.scene3:MoveToLocalX(-1 * (viewWidth / 2 + length3 / 2), function(scene)
    self:OnMoveFinish(scene)
  end)
end

function T11IdleGameIdleBattleSceneManager:OnMoveFinish(scene)
  self.curShowIndex = self.curShowIndex + 1
  local targetShowIndex = self.curShowIndex + 3
  local sceneData = self:GetSceneDataByIndex(targetShowIndex)
  scene:Clear()
  scene:Load(sceneData.prefabPath, sceneData.length, nil)
  local newInitX = self:GetPreviousScenePosX(scene) + sceneData.length
  scene:SetLocalX(newInitX)
  local viewWidth = self:GetCameraViewWidth()
  scene:MoveToLocalX(-1 * (viewWidth / 2 + sceneData.length / 2), function(sceneNew)
    self:OnMoveFinish(sceneNew)
  end)
end

function T11IdleGameIdleBattleSceneManager:GetPreviousScenePosX(scene)
  if self.scene1 == scene then
    return self.scene3:GetLocalX()
  end
  if self.scene2 == scene then
    return self.scene1:GetLocalX()
  end
  if self.scene3 == scene then
    return self.scene2:GetLocalX()
  end
  return 0
end

function T11IdleGameIdleBattleSceneManager:GetOtherScenesLengthSum(scene)
  local sum = 0
  if self.scene1 and self.scene1 ~= scene then
    sum = sum + self.scene1:GetLength()
  end
  if self.scene2 and self.scene2 ~= scene then
    sum = sum + self.scene2:GetLength()
  end
  if self.scene3 and self.scene3 ~= scene then
    sum = sum + self.scene3:GetLength()
  end
  return sum
end

function T11IdleGameIdleBattleSceneManager:Pause()
  self.scene1:Pause()
  self.scene2:Pause()
  self.scene3:Pause()
end

function T11IdleGameIdleBattleSceneManager:Resume()
  self.scene1:Resume()
  self.scene2:Resume()
  self.scene3:Resume()
end

function T11IdleGameIdleBattleSceneManager:GetSceneDataByIndex(index)
  if self.logic == nil then
    return Const.DefaultSceneData
  end
  local infoData = self.logic:GetInfoData()
  if infoData == nil then
    return Const.DefaultSceneData
  end
  local levelTemplate = infoData:GetLevelTemplate()
  if levelTemplate == nil then
    return Const.DefaultSceneData
  end
  local sceneData = levelTemplate:GetSceneDataByIndex(index)
  return sceneData or Const.DefaultSceneData
end

function T11IdleGameIdleBattleSceneManager:GetCameraViewWidth()
  if self.logic then
    local cameraPos, cameraWidth, cameraHeight = self.logic:GetCameraInfo()
    return cameraWidth
  end
  return 0
end

return T11IdleGameIdleBattleSceneManager
