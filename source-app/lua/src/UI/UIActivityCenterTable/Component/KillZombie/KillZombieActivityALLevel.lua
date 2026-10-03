local base = UIBaseContainer
local KillZombieActivityALLevel = BaseClass("KillZombieActivityALLevel", base)
local ALLevelItem = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityALLevelItem")
local level_list_path = "Viewport/LevelList"
local level_item_path = "LevelItem"

function KillZombieActivityALLevel:OnCreate()
  base.OnCreate(self)
  self.scroll_view = self:AddComponent(UIScrollRect, "")
  self.content = self:AddComponent(UIBaseContainer, level_list_path)
  self.OnItemClick = Bind(self, self.OnItemClickCallBack)
  self.theCellItem = self.transform:Find(level_item_path).gameObject
  self.theCellItem:GameObjectCreatePool()
  local goItem, theItem
  local itemList = {}
  local mgr = DataCenter.ActivityKillZombieManager
  local dataList = mgr:GetListByType(2)
  if dataList and dataList.data then
    for difficulty = dataList.min, dataList.max do
      local levelName = "item_" .. difficulty
      local data = dataList.data[difficulty]
      if data ~= nil then
        goItem = self.theCellItem:GameObjectSpawn(self.content.transform)
        goItem.name = levelName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(ALLevelItem, levelName)
        theItem:SetData(difficulty, data)
        theItem:SetOnClick(self.OnItemClick)
        table.insert(itemList, theItem)
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self.itemCellList = itemList
  self.select_dfficulty = 0
  self.conditionDifficulty = nil
end

function KillZombieActivityALLevel:OnEnable()
  base.OnEnable(self)
end

function KillZombieActivityALLevel:OnDisable()
  base.OnDisable(self)
end

function KillZombieActivityALLevel:SetData(data, WaitView, TaskView, RewardView, lockBtn)
  self.theData = data
  self.theWaitView = WaitView
  self.theTaskView = TaskView
  self.theRewardView = RewardView
  self.lockBtn = lockBtn
end

function KillZombieActivityALLevel:GetCurSelectDifficulty()
  return self.select_dfficulty
end

function KillZombieActivityALLevel:CalcActiveCell()
  local server_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  if server_data == nil or not LuaEntry.Player:IsInAlliance() then
    self.select_dfficulty = 0
    return
  end
  local mgr = DataCenter.ActivityKillZombieManager
  local dataList = mgr:GetListByType(2)
  local select_dfficulty = 0
  local maxUnReachProgress = 0
  local maxUnReachDifficulty = 0
  local maxSuccessDifficulty = 0
  for difficulty = dataList.min, dataList.max do
    local cfgdata = dataList.data[difficulty]
    if cfgdata then
      local serverData = server_data[tostring(difficulty)]
      local serverDataStatus = serverData and serverData.status or -1
      local canInvoke, progressPercent = mgr:CanInvokeBossZombieAndProgress(difficulty)
      if serverDataStatus ~= 2 then
        if canInvoke then
          select_dfficulty = difficulty
        elseif maxUnReachProgress < progressPercent then
          maxUnReachProgress = progressPercent
          maxUnReachDifficulty = difficulty
        end
      else
        maxSuccessDifficulty = math.max(maxSuccessDifficulty, difficulty)
      end
    end
  end
  if select_dfficulty == 0 then
    if maxSuccessDifficulty >= dataList.max then
      select_dfficulty = dataList.max
    else
      select_dfficulty = 0 < maxUnReachDifficulty and maxUnReachDifficulty or 1
    end
  end
  if select_dfficulty < 4 then
    self.scroll_view:SetHorizontalNormalizedPosition(0)
  else
    self.scroll_view:SetHorizontalNormalizedPosition(select_dfficulty / dataList.max)
  end
  self.select_dfficulty = select_dfficulty
end

function KillZombieActivityALLevel:RefreshUI()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self:CalcActiveCell()
  if self.select_dfficulty > 0 then
    self:SelectItem(self.select_dfficulty)
  end
  for i, cell in ipairs(self.itemCellList) do
    cell:UpdateData()
  end
end

function KillZombieActivityALLevel:SelectItem(difficulty)
  local server_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  for i, cell in ipairs(self.itemCellList) do
    local cellDifficulty = cell:GetCurDifficulty()
    cell:UpdateSelectStatus(difficulty == cellDifficulty)
  end
  self.select_dfficulty = difficulty
  self:InitCurConditionDifficulty()
  if server_data == nil then
    return
  end
  if LuaEntry.Player:IsInAlliance() then
    local dataStatus = server_data[tostring(difficulty)]
    if dataStatus.monster ~= nil or dataStatus.status > 0 then
      self.theWaitView:SetActive(false)
      self.theTaskView:SetActive(true)
      self.theRewardView:SetActive(true)
      self.theTaskView:ReInit(difficulty)
      self.theRewardView:ReInit(difficulty)
    else
      self.theWaitView:SetActive(true)
      self.theTaskView:SetActive(false)
      self.theRewardView:SetActive(false)
      self.theWaitView:ReInit(difficulty)
    end
  end
end

function KillZombieActivityALLevel:OnItemClickCallBack(difficulty)
  local server_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  if isInAlliance then
    if server_data == nil then
      UIUtil.ShowTipsId("E100008")
    else
      self:SelectItem(difficulty)
    end
  else
    if self.lockBtn then
      local param = {}
      param.positionType = PositionType.Screen
      param.position = self.lockBtn.transform.position + Vector3.New(50, -50, 0)
      param.isAutoClose = 3
      DataCenter.ArrowManager:ShowFingerArrow(param)
    end
    UIUtil.ShowTipsId("2010218")
  end
end

function KillZombieActivityALLevel:OnDestroy()
  self.content:RemoveComponents(ALLevelItem)
  self.theCellItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.theCellItem = nil
  self.content = nil
  self.scroll_view = nil
  self.theData = nil
  self.theWaitView = nil
  self.theTaskView = nil
  self.theRewardView = nil
  self.conditionDifficulty = nil
  base.OnDestroy(self)
end

function KillZombieActivityALLevel:UpdateData()
  if self.select_dfficulty > 0 then
    self:SelectItem(self.select_dfficulty)
  elseif LuaEntry.Player:IsInAlliance() then
    self:RefreshUI()
  end
end

function KillZombieActivityALLevel:OnAddListener()
  base.OnAddListener(self)
end

function KillZombieActivityALLevel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function KillZombieActivityALLevel:InitCurConditionDifficulty()
  local cfgData = DataCenter.ActivityKillZombieManager:GetDataWithTypeAndLevel(2, self.select_dfficulty)
  if cfgData then
    local conditionList = cfgData.conditionList
    local conditionDifficulty
    if conditionList ~= nil then
      for _, v in ipairs(conditionList) do
        if v.data.ui_type == 1 then
          conditionDifficulty = v.data.difficulty
        end
      end
    end
    self.conditionDifficulty = conditionDifficulty
  end
end

function KillZombieActivityALLevel:GetCurConditionDifficulty()
  return self.conditionDifficulty
end

return KillZombieActivityALLevel
