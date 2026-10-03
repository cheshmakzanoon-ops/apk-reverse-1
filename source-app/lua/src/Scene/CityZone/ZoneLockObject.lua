local ZoneLockObject = BaseClass("ZoneLockObject")
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local BuildBubbleTip = require("UI.BuildBubbleTip.View.BuildBubbleTip")
local zombie_char_path = "Assets/_Art_LastWar/Models/Characters/Zombies/A_Monster_Zombie01/prefab/A_Monster_Zombie02.prefab"
local root_path = "Root"
local stage_path = "Stage"
local zombie_path = "Zombie"

function ZoneLockObject:__init(req)
  self.req = req
  self.stageActive = true
end

function ZoneLockObject:__delete()
  self.req = nil
  self.stageActive = true
end

function ZoneLockObject:Create(data)
  self.data = data
  self.gameObject = self.req.gameObject
  self.transform = self.req.gameObject.transform
  self.rootTf = self.transform:Find(root_path)
  self.stageTf = self.transform:Find(stage_path)
  self.zombieTf = self.transform:Find(zombie_path)
  self.zombieList = {}
  self.stageBubbleTf = nil
  self.stageBubbleTip = nil
  self:CreateZombie()
  self:CreateStageBubble()
  if self.data.id > 4 then
    return
  end
  self.touchEvent = self.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
  if self.touchEvent then
    function self.touchEvent.onPointerClick()
      self:OnClick()
    end
    
    function self.touchEvent.onPointerDoubleClick()
      self:OnClick()
    end
  end
end

function ZoneLockObject:Destroy()
  self.data = nil
  self.gameObject = nil
  self.transform = nil
  self.rootTf = nil
  self.stageTf = nil
  self.zombieTf = nil
  if self.zombieList then
    for _, v in ipairs(self.zombieList) do
      if v ~= nil then
        v:Destroy()
      end
    end
  end
  self.zombieList = {}
  self.stageBubbleTf = nil
  if self.stageBubbleTip ~= nil then
    self.stageBubbleTip:OnDestroy()
    self.stageBubbleTip = nil
  end
  if self.touchEvent then
    self.touchEvent.onPointerClick = nil
    self.touchEvent.onPointerDoubleClick = nil
    self.touchEvent = nil
  end
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
end

function ZoneLockObject:Refresh()
  if IsNull(self.gameObject) then
    return
  end
  self:CreateStageBubble()
end

function ZoneLockObject:CreateZombie()
  if not self:CanShowZombie() then
    return
  end
  for i = 1, 5 do
    local parent_tf = self.zombieTf:Find(tostring(i))
    local req = Resource:InstantiateAsync(zombie_char_path)
    req:completed("+", function()
      local zombie_tf = req.gameObject.transform
      zombie_tf:SetParent(parent_tf)
      zombie_tf.localPosition = VecZero
      zombie_tf:Set_eulerAngles(parent_tf:Get_eulerAngles())
    end)
    table.insert(self.zombieList, req)
  end
end

function ZoneLockObject:CreateStageBubble()
  if not self:CanShowBubble() then
    return
  end
end

function ZoneLockObject:GetBubbleParam()
  local group = LocalController:instance():getLine(TableName.LW_StageGroup, DataCenter.StageManager.stageGroupMetaId)
  local stage = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), DataCenter.StageManager.stageId)
  local param = {}
  param.buildBubbleType = BuildBubbleType.ZoneSpreadingBattle
  param.model = UIAssets.BuildStateIcon7
  param.bgName = string.format(LoadPath.UIBuildBubble, stage.stage_icon)
  param.callBack = self.OnClickCallBack
  param.uuid = DataCenter.StageManager.stageId
  param.progress = Localization:GetString(group.name) .. "  (" .. DataCenter.StageManager:StageProgress() .. ")"
  return param
end

function ZoneLockObject:GetStageBubbleIndex()
  local index = DataCenter.StageManager.stageId % 1000 % 6
  return math.max(1, index)
end

function ZoneLockObject:PlayFinishAnim(callback)
  if IsNull(self.gameObject) then
    if callback() then
      callback()
    end
    return
  end
  if callback then
    callback()
  end
end

function ZoneLockObject:HideBubbleTf()
  if self.stageBubbleTf then
    self.stageBubbleTf.gameObject:SetActive(false)
  else
    self.stageActive = false
  end
end

function ZoneLockObject:CanShowZombie()
  return false
end

function ZoneLockObject:CanShowBubble()
  if self.data.id < 5 then
    return false
  end
  local data = DataCenter.LandLockManager:GetLandLockDataById(self.data.id)
  if data == nil or data.state == LandLockState.Hide or data.state == LandLockState.Finished then
    return false
  end
  for _, priorId in ipairs(data.priorList) do
    local priorData = DataCenter.LandLockManager:GetLandLockDataById(priorId)
    if priorData.state ~= LandLockState.Finished then
      return false
    end
  end
  return true
end

function ZoneLockObject.OnClickCallBack(param)
  PveUtil.TryEnterBattle(DataCenter.StageManager.stageGroupMetaId, DataCenter.StageManager.stageId)
end

function ZoneLockObject:OnClick()
  DataCenter.LandLockManager:ClickLandLockById(self.data.id)
end

function ZoneLockObject:GetBubbleCenterPos()
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
  if IsNull(self.stageTf) then
    return buildDataList[1]:GetCenterVec()
  end
  local bubbleTf = self.stageTf:Find(tostring(self:GetStageBubbleIndex()))
  if IsNull(bubbleTf) then
    return buildDataList[1]:GetCenterVec()
  end
  return bubbleTf.position
end

return ZoneLockObject
