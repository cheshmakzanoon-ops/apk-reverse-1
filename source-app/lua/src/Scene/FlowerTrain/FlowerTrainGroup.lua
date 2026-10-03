local FlowerTrainGroup = BaseClass("FlowerTrainGroup")
local SingleFlowerTrain = require("Scene.FlowerTrain.SingleFlowerTrain")
local GameObject = CS.UnityEngine.GameObject
local Resource = CS.GameEntry.Resource

function FlowerTrainGroup:__init()
  self.marchInfo = nil
  self.allSingleTrainDataList = {}
  self.allSingleTrainList = {}
  self.allSingleTrainDic = {}
end

function FlowerTrainGroup:__delete()
  self:Destroy()
end

function FlowerTrainGroup:Init(flowerTrainData, marchInfo, parent, cameraFollowTransform, flowerTrainCustomRoot)
  self.parent = parent
  self.flowerTrainCustomRoot = flowerTrainCustomRoot
  self.cameraFollowTransform = cameraFollowTransform
  self.marchInfo = marchInfo
  self.marchUuid = marchInfo.uuid or "unknown"
  self:CreatePoint()
  self:Refresh(flowerTrainData)
end

function FlowerTrainGroup:CreatePoint()
  self.gameObject = GameObject("FlowerTrainGroup" .. self.marchUuid)
  self.transform = self.gameObject.transform
  self.transform:SetParent(self.parent)
  self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self.transform:Set_localPosition(0, 0, 0)
end

function FlowerTrainGroup:CreateOrUpdateSingleTrains()
  for index, singleTrainData in ipairs(self.allSingleTrainDataList) do
    local singleTrain = self:GetSingleTrain(singleTrainData:GetFlowerTrainUuid())
    if not singleTrain then
      self:AddOneSingleTrain(index, singleTrainData, self.transform, self.cameraFollowTransform)
    else
      singleTrain:UpdateSingleFlowerTrain(index, singleTrainData)
    end
  end
end

function FlowerTrainGroup:AddOneSingleTrain(index, singleTrainData, parent, cameraFollowTransform)
  local singleTrain = SingleFlowerTrain.New()
  singleTrain:Init(index, singleTrainData, parent, cameraFollowTransform, self.flowerTrainCustomRoot)
  self.allSingleTrainDic[singleTrainData.uuid] = singleTrain
  table.insert(self.allSingleTrainList, singleTrain)
end

function FlowerTrainGroup:GetSingleTrain(singleTrainUid)
  return self.allSingleTrainDic[singleTrainUid]
end

function FlowerTrainGroup:Refresh(flowerTrainData)
  self.allSingleTrainDataList = flowerTrainData:GetAllSingleTrainDataList()
  self:CreateOrUpdateSingleTrains()
end

function FlowerTrainGroup:OnUpdate(now)
  if self.allSingleTrainList then
    for _, singleTrain in ipairs(self.allSingleTrainList) do
      singleTrain:OnUpdate(now)
    end
  end
end

function FlowerTrainGroup:Update1000MS()
  if self.allSingleTrainList then
    for _, singleTrain in ipairs(self.allSingleTrainList) do
      singleTrain:Update1000MS()
    end
  end
end

function FlowerTrainGroup:ClearAllSingleTrain()
  for _, singleTrain in ipairs(self.allSingleTrainList) do
    singleTrain:Destroy()
  end
  self.allSingleTrainList = {}
  self.allSingleTrainDic = {}
end

function FlowerTrainGroup:Destroy()
  self:ClearAllSingleTrain()
  self.allSingleTrainList = nil
  self.allSingleTrainDic = nil
  self.marchInfo = nil
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
end

function FlowerTrainGroup:OnChangeCameraLod(lod)
  if not self.allSingleTrainList then
    return
  end
  for _, singleTrain in ipairs(self.allSingleTrainList) do
    singleTrain:OnChangeCameraLod(lod)
  end
end

function FlowerTrainGroup:OnDisplayModeUpdate(displayLv)
  if not self.allSingleTrainList then
    return
  end
  for _, singleTrain in ipairs(self.allSingleTrainList) do
    singleTrain:OnDisplayModeUpdate(displayLv)
  end
end

return FlowerTrainGroup
