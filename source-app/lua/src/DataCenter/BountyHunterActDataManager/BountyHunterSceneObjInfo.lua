local BountyHunterSceneObjInfo = BaseClass("BountyHunterSceneObjInfo")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local start_pos_point_path = "BountyHunterSceneLogicPointRoot/StartPosPoint"
local enter_pos_point_path = "BountyHunterSceneLogicPointRoot/EnterPosPoint"
local right_pos_point_path = "BountyHunterSceneLogicPointRoot/RightPosPoint"
local left_pos_point_path = "BountyHunterSceneLogicPointRoot/LeftPosPoint"

local function __init(self)
  self.hunterLocalPos = nil
  self.enterLocalPos = nil
  self.rightLocalPos = nil
  self.leftLocalPos = nil
  self.sceneLoadReq = nil
  self.sceneObj = nil
end

local function __delete(self)
  self.hunterLocalPos = nil
  self.enterLocalPos = nil
  self.rightLocalPos = nil
  self.leftLocalPos = nil
  if self.sceneLoadReq ~= nil then
    self.sceneLoadReq:Destroy()
    self.sceneLoadReq = nil
  end
  self.sceneObj = nil
end

function BountyHunterSceneObjInfo:ParseSceneObjPoint()
  if not self.sceneObj then
    return
  end
  self.hunterLocalPos = self.sceneObj.transform:Find(start_pos_point_path).transform.position
  self.enterLocalPos = self.sceneObj.transform:Find(enter_pos_point_path).transform.position
  self.rightLocalPos = self.sceneObj.transform:Find(right_pos_point_path).transform.position
  self.leftLocalPos = self.sceneObj.transform:Find(left_pos_point_path).transform.position
end

function BountyHunterSceneObjInfo:IsLoading()
  return self.sceneObj == nil and self.sceneLoadReq ~= nil
end

function BountyHunterSceneObjInfo:IsLoadedFinish()
  return self.sceneObj ~= nil
end

function BountyHunterSceneObjInfo:LoadScene(scenePath, parent, loadCallback)
  if not scenePath then
    return
  end
  self.sceneLoadReq = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoadReq:completed("+", function()
    if self.sceneLoadReq.isError then
      self.sceneLoadReq = nil
      return
    end
    self.sceneObj = self.sceneLoadReq.gameObject
    self.sceneObj:SetActive(true)
    if parent then
      self.sceneObj.transform:SetParent(parent.transform)
      self.sceneObj.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      self.sceneObj.transform:Set_localRotation(0, 0, 0)
    end
    self.sceneObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    if loadCallback then
      loadCallback()
    end
  end)
end

function BountyHunterSceneObjInfo:CalWorldPos(curSceneObjInfo, dir)
  curSceneObjInfo:ParseSceneObjPoint()
  local curSceneRotation = curSceneObjInfo.sceneObj.transform.rotation.eulerAngles.y
  local targetDoorWorldPos
  if dir == BountyHunterSceneDoorType.Right then
    self.sceneObj.transform.rotation = Quaternion.Euler(0, curSceneRotation + 90, 0)
    targetDoorWorldPos = curSceneObjInfo:GetDoorWorldPosByDir(BountyHunterSceneDoorType.Right)
  elseif dir == BountyHunterSceneDoorType.Left then
    self.sceneObj.transform.rotation = Quaternion.Euler(0, curSceneRotation - 90, 0)
    targetDoorWorldPos = curSceneObjInfo:GetDoorWorldPosByDir(BountyHunterSceneDoorType.Left)
  else
    self.sceneObj.transform.rotation = Quaternion.Euler(0, curSceneRotation - 90, 0)
    targetDoorWorldPos = curSceneObjInfo:GetDoorWorldPosByDir(BountyHunterSceneDoorType.Left)
  end
  self:ParseSceneObjPoint()
  local selfEnterWorldPos = self:GetDoorWorldPosByDir(BountyHunterSceneDoorType.Enter)
  local offset = targetDoorWorldPos - selfEnterWorldPos
  local finalPos = self.sceneObj.transform.position + offset
  self.sceneObj.transform.position = finalPos
end

function BountyHunterSceneObjInfo:GetDoorWorldPosByDir(dir)
  if dir == BountyHunterSceneDoorType.Enter then
    return self.enterLocalPos
  elseif dir == BountyHunterSceneDoorType.Right then
    return self.rightLocalPos
  elseif dir == BountyHunterSceneDoorType.Left then
    return self.leftLocalPos
  else
    return self.rightLocalPos
  end
end

function BountyHunterSceneObjInfo:ResetTransform()
  if not self.sceneObj then
    return
  end
  self.sceneObj.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self.sceneObj.transform:Set_localRotation(0, 0, 0)
end

function BountyHunterSceneObjInfo:GetCurSceneWorldPos()
  if self:IsLoading() then
    return Vector3.New(0, 0, 0)
  end
  return self.sceneObj.transform.position
end

function BountyHunterSceneObjInfo:Destroy()
  if self.sceneLoadReq ~= nil then
    self.sceneLoadReq:Destroy()
    self.sceneLoadReq = nil
  end
  self.sceneObj = nil
end

BountyHunterSceneObjInfo.__init = __init
BountyHunterSceneObjInfo.__delete = __delete
return BountyHunterSceneObjInfo
