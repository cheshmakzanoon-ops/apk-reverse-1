local UpgradeTreasureBoxSceneCtrl = BaseClass("UpgradeTreasureBoxSceneCtrl")
local ResourceManager = CS.GameEntry.Resource
local model_path = "Model"

function UpgradeTreasureBoxSceneCtrl:__init()
  self.groupId = nil
  self.boxDic = {}
  self.allBoxList = {}
  self.requestList = {}
end

function UpgradeTreasureBoxSceneCtrl:__delete()
  self.groupId = nil
  self.boxDic = nil
  self.allBoxList = nil
  self.requestList = nil
end

function UpgradeTreasureBoxSceneCtrl:Init(rtCpt, groupId, initQuality)
  if not rtCpt then
    Logger.LogError("UpgradeTreasureBoxSceneCtrl:Init rtCpt is nil")
    return
  end
  if not groupId then
    Logger.LogError("UpgradeTreasureBoxSceneCtrl:Init groupId is nil")
    return
  end
  self.rtCpt = rtCpt
  self.groupId = groupId
  self.boxParent = self.rtCpt:GetSceneNode(model_path)
  self:CreateTreasureBox(initQuality)
end

function UpgradeTreasureBoxSceneCtrl:CreateTreasureBox(initQuality)
  local boxInfoList = DataCenter.UpgradeTreasureBoxManager:GetAllBoxInfo(self.groupId)
  if not boxInfoList or table.count(boxInfoList) == 0 then
    Logger.LogError("UpgradeTreasureBoxSceneCtrl:CreateTreasureBox boxInfoList is nil or empty")
    return
  end
  for _, req in ipairs(self.requestList) do
    if req then
      req:Destroy()
    end
  end
  self.requestList = {}
  local loadedCount = 0
  for k, v in ipairs(boxInfoList) do
    local path = v.box_prefab
    local request = ResourceManager:InstantiateAsync(path)
    table.insert(self.requestList, request)
    request:completed("+", function(handle)
      if handle.isError then
        return
      end
      if IsNull(self.boxParent) then
        handle:Destroy()
        return
      end
      local go = handle.gameObject
      go:SetActive(false)
      go.transform:SetParent(self.boxParent.transform)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localRotation(0, 0, 0, 1)
      local ani = go:GetComponentInChildren(typeof(CS.SimpleAnimation))
      self.boxDic[v.color] = ani
      self.allBoxList[v.color] = go
      loadedCount = loadedCount + 1
      if loadedCount == table.count(boxInfoList) then
        self:PlayBoxAni(initQuality, "born")
      end
    end)
  end
end

function UpgradeTreasureBoxSceneCtrl:PlayBoxAni(quality, name, delayTime, lastQualityColor)
  if not self.boxDic or table.count(self.boxDic) == 0 then
    Logger.LogError("PlayBoxAni boxDic is nil or empty")
    return
  end
  if string.IsNullOrEmpty(name) then
    Logger.LogError("PlayBoxAni name is nil or empty")
    return
  end
  if delayTime and 0 < delayTime then
    if self.delayTimer then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      for k, v in pairs(self.allBoxList) do
        v:SetActive(k == quality)
      end
      local ani = self.boxDic[quality]
      local length = ani:GetClipLength(name)
      local normalize = delayTime / length
      ani:Stop()
      ani:SampleAnimationAtTime(name, normalize)
      ani:Play(name)
    end, delayTime)
    local lastQuality = self.boxDic[lastQualityColor]
    if lastQuality then
      lastQuality:Play(name)
    end
  else
    for k, v in pairs(self.allBoxList) do
      v:SetActive(k == quality)
    end
    local ani = self.boxDic[quality]
    if ani then
      ani:Play(name)
    end
  end
end

function UpgradeTreasureBoxSceneCtrl:Destroy()
  for _, req in ipairs(self.requestList) do
    if req then
      req:Destroy()
    end
  end
  self.boxDic = nil
  self.allBoxList = nil
  self.requestList = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

return UpgradeTreasureBoxSceneCtrl
