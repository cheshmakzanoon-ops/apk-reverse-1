local PveDropRewardManager = BaseClass("PveDropRewardManager")
local PveDropRewardObject = require("Scene.PVEBattleLevel.PveDropReward.PveDropRewardObject")
local DropPositionOffset = {
  Vector3.New(0, 0, -2),
  Vector3.New(2, 0, 0),
  Vector3.New(0, 0, 2),
  Vector3.New(-2, 0, 0),
  Vector3.New(2, 0, -2),
  Vector3.New(2, 0, 2),
  Vector3.New(-2, 0, 2),
  Vector3.New(-2, 0, -2)
}

function PveDropRewardManager:__init()
  self.dropReward = {}
  self.delayTimer = {}
end

function PveDropRewardManager:__delete()
  self.dropReward = {}
  self.delayTimer = {}
end

function PveDropRewardManager:InitDropReward()
  self.dropReward = {}
  local allReward = DataCenter.PveDropRewardInfoManager:GetAllDropRewardInfo()
  for k, v in pairs(allReward) do
    self:AddOneDropReward(v)
  end
end

function PveDropRewardManager:GetDropReward(uuid)
  return self.dropReward[uuid]
end

function PveDropRewardManager:AddOneDropReward(info)
  if info ~= nil then
    local param = {}
    param.position = SceneUtils.TileToWorld({
      x = info.x,
      y = info.y
    })
    param.info = info
    param.isShow = true
    local id = info.uuid
    if self.dropReward[id] == nil then
      self.dropReward[id] = PveDropRewardObject.New()
    end
    self.dropReward[id]:ReInit(param)
    DataCenter.BattleLevel.selectionMgr:Refresh()
  end
end

function PveDropRewardManager:RemoveOneDropReward(id)
  if self.dropReward[id] ~= nil then
    self.dropReward[id]:Destroy()
    self.dropReward[id] = nil
    DataCenter.BattleLevel.selectionMgr:Remove(PveSelectionType.DropReward, id)
    DataCenter.BattleLevel.selectionMgr:Refresh()
  end
end

function PveDropRewardManager:RemoveAll()
  for k, v in pairs(self.dropReward) do
    v:Destroy()
  end
  self.dropReward = {}
  for k, v in pairs(self.delayTimer) do
    v:Stop()
  end
  self.delayTimer = {}
end

function PveDropRewardManager:OnPlayerMoveSignal(pos)
  for k, v in pairs(self.dropReward) do
    v:OnPlayerMoveSignal(pos)
  end
end

function PveDropRewardManager:PveDropRewardAddSignal(uuid)
  self:AddOneDropReward(DataCenter.PveDropRewardInfoManager:GetDropRewardInfoByUuid(uuid))
end

function PveDropRewardManager:PveDropRewardRemoveSignal(uuid)
  self:RemoveOneDropReward(uuid)
end

function PveDropRewardManager:GetOnePveDropRewardPosition(pos)
  local realPosX, realPosY, tempPos, x, y, usePos
  if pos == nil or pos.x == 0 and pos.z == 0 then
    return 0, 0
  else
    usePos = pos
  end
  for k, v in ipairs(DropPositionOffset) do
    tempPos = v + usePos
    x, y = SceneUtils.WorldToTileFloatXY(tempPos)
    if DataCenter.PveDropRewardInfoManager:GetDropRewardInfoByPosXY(x, y) == nil and DataCenter.BattleLevel.fog:IsUnlock(tempPos) and DataCenter.BattleLevel.collectionMgr:CanWalk(tempPos) then
      local list = DataCenter.BattleLevel.triggerMgr:GetTriggersByPointId(SceneUtils.WorldToTileIndex(tempPos))
      if list == nil or #list == 0 then
        if CS.CSUtils.Hit2 ~= nil then
          local newForward = Vector3.Normalize(v)
          local realDistance = Vector3.Distance(Vector3.zero, v)
          local ret, hitInfo = CS.CSUtils.Hit2(usePos, newForward, 0.4, realDistance)
          if ret == false then
            realPosX = x
            realPosY = y
          end
        else
          realPosX = x
          realPosY = y
          break
        end
      end
    end
  end
  if realPosX ~= nil and realPosY ~= nil then
    return realPosX, realPosY
  end
  return SceneUtils.WorldToTileFloatXY(usePos)
end

function PveDropRewardManager:RefreshCameraRotation(rot)
  for k, v in pairs(self.dropReward) do
    v:RefreshCameraRotation(rot)
  end
end

function PveDropRewardManager:FlyDropReward(uuid, srcWorldPos)
  local srcPos = DataCenter.BattleLevel:WorldToScreenPoint(srcWorldPos)
  local delay = 0
  local info = DataCenter.PveDropRewardInfoManager:GetDropRewardInfoByUuid(uuid)
  if info ~= nil and info.resArr ~= nil then
    local rewardType = RewardType.RESOURCE_ITEM
    local showTime
    for k, v in ipairs(info.resArr) do
      local targetPos = DataCenter.BattleLevel:WorldToScreenPoint(info:GetPosition())
      local pic = DataCenter.RewardManager:GetPicByType(rewardType, v.id)
      local tmp = DataCenter.RewardManager:GetRewardNumsInPveScene(v.num, false, rewardType)
      local delayTime, totalTime = UIUtil.DoJumpFly(pic, tmp, srcPos, targetPos, delay)
      if showTime == nil then
        showTime = delayTime
      end
      delay = delay + 0.3
    end
    if showTime == nil then
      self:AddOneDropReward(info)
    else
      self.delayTimer[uuid] = TimerManager:GetInstance():DelayInvoke(function()
        self.delayTimer[uuid]:Stop()
        self.delayTimer[uuid] = nil
        self:AddOneDropReward(info)
      end, showTime)
    end
  end
end

return PveDropRewardManager
