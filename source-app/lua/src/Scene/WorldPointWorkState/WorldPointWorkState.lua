local WorldPointWorkState = BaseClass("WorldPointWorkState")
local ResourceManager = CS.GameEntry.Resource
local WorkState = {
  Idle = 0,
  Working = 1,
  Finish = 2
}
local __StateInfo = {
  [WorkState.Idle] = {
    name = "Default",
    fxPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/Eff_ljw_s4_zhaocaimao_meidian.prefab"
  },
  [WorkState.Working] = {
    name = "Work",
    fxPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/Eff_ljw_s4_zhaocaimao_chongdianzhong.prefab"
  },
  [WorkState.Finish] = {
    name = "Finish",
    fxPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/Eff_ljw_s4_zhaocaimao_mandian.prefab"
  }
}

local function __init(self)
  self.request = nil
  self.gameObject = nil
  self.uuid = nil
  self.parent = nil
  self.animator = nil
  self.workState = nil
end

local function __delete(self)
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self.gameObject = nil
  self.uuid = nil
  self.parent = nil
  self.animator = nil
  self.workState = nil
end

local function Refresh(self, pointInfo, transform)
  self.parent = transform
  self.uuid = pointInfo.uuid
  self:RefreshInfo(pointInfo)
end

local function RefreshInfo(self, pointInfo)
  if pointInfo then
    local configId = pointInfo.configId
    if not string.IsNullOrEmpty(configId) then
      local config = LocalController:instance():getLine(TableName.LWIceSupplies, configId)
      if config and (config.type == WorldSuppliesType.DarknessSeasonType or config.type == WorldSuppliesType.DarknessSeasonSmallType) then
        cast(pointInfo, typeof(CS.WorldSuppliesPoint))
        if pointInfo then
          local scale = config.type == WorldSuppliesType.DarknessSeasonSmallType and 0.5 or 1
          self:RefreshState(pointInfo.workState, scale)
          return
        end
      end
    end
  end
  DataCenter.WorldPointWorkStateManager:Remove(self.uuid)
end

local function RefreshState(self, state, scale)
  if self.workState == state then
    return
  end
  self.workState = state
  local stateInfo = __StateInfo[self.workState]
  if not stateInfo then
    return
  end
  if not self.animator and self.parent then
    self.animator = self.parent.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
  end
  if self.animator then
    self.animator:Play(stateInfo.name)
  end
  self:RefreshFx(stateInfo, scale)
end

local function RefreshFx(self, stateInfo, scale)
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  local request = ResourceManager:InstantiateAsync(stateInfo.fxPath)
  self.request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    if not self.parent or not self.parent.gameObject then
      DataCenter.WorldPointWorkStateManager:Remove(self.uuid)
      return
    end
    local modelParent = self.parent:Find("ModelGo")
    request.gameObject.transform:SetParent(modelParent)
    request.gameObject.transform:Set_localScale(scale, scale, scale)
    request.gameObject.transform:Set_localPosition(0, 0, 0)
    self.gameObject = request.gameObject
    self.gameObject:SetActive(true)
  end)
end

WorldPointWorkState.__init = __init
WorldPointWorkState.__delete = __delete
WorldPointWorkState.Refresh = Refresh
WorldPointWorkState.RefreshInfo = RefreshInfo
WorldPointWorkState.RefreshFx = RefreshFx
WorldPointWorkState.RefreshState = RefreshState
return WorldPointWorkState
