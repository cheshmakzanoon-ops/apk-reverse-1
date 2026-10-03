local SurpriseBuildingTipManager = BaseClass("SurpriseBuildingTipManager")
local SurpriseBuildingTip = require("DataCenter.AllianceCityTip.SurpriseBuildingTip")
local ResourceManager = CS.GameEntry.Resource

local function __init(self)
  self.bloodyNightFireEffect = nil
  self.tipDict = {}
  self:AddListeners()
end

local function __delete(self)
  if self.tipDict ~= nil then
    for _, t in pairs(self.tipDict) do
      if t.tip ~= nil then
        t.tip:OnDestroy()
      end
      if t.req ~= nil then
        t.req:Destroy()
      end
    end
    self.tipDict = nil
  end
  self:RemoveListeners()
end

local function Startup(self)
end

local function RemoveAllSurpriseBuildingTip(self)
  if self.tipDict ~= nil then
    for _, t in pairs(self.tipDict) do
      if t.tip ~= nil then
        t.tip:OnDestroy()
      end
      if t.req ~= nil then
        t.req:Destroy()
      end
    end
    self.tipDict = {}
  end
end

local function ChangeAllTipToDawn(self)
  if self.tipDict ~= nil then
    for k, v in pairs(self.tipDict) do
      if v.tip ~= nil then
        v.tip:ChangeToDawn()
      end
    end
  end
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.OnSurpriseBuildingShow, self.OnSurpriseBuildingShow)
  EventManager:GetInstance():AddListener(EventId.OnSurpriseBuildingDestroy, self.OnSurpriseBuildingDestroy)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightActivityRefresh)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.OnSurpriseBuildingShow, self.OnSurpriseBuildingShow)
  EventManager:GetInstance():RemoveListener(EventId.OnSurpriseBuildingDestroy, self.OnSurpriseBuildingDestroy)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightActivityRefresh)
end

local function ChangeCameraLodSignal(lod)
  DataCenter.SurpriseBuildingTipManager:UpdateLod(lod)
end

local function OnBloodyNightActivityRefresh()
  local isDawn = DataCenter.BloodyNightDataManager:IsDawn(LuaEntry.Player:GetCurServerId())
  if isDawn then
    DataCenter.SurpriseBuildingTipManager:ChangeAllTipToDawn()
  end
end

local function OnSurpriseBuildingShow(pointIndex)
  local theWorld = CS.SceneManager.World
  local pointInfo = theWorld:GetPointInfo(pointIndex)
  DataCenter.SurpriseBuildingTipManager:ShowTip(pointIndex, pointInfo, true)
end

local function OnSurpriseBuildingDestroy(pointIndex)
  DataCenter.SurpriseBuildingTipManager:DestroyTip(pointIndex)
end

local function UpdateTipLod(self)
  for k, v in pairs(self.tipDict) do
    if v.tip ~= nil then
      v.tip:CheckLod(self.lodCache)
    end
  end
end

local function UpdateLod(self, lod)
  if self.lodCache ~= lod then
    self.lodCache = lod
    self:UpdateTipLod()
  end
end

local function ShowTip(self, pointIndex, pointInfo, isShow)
  if isShow and self.tipDict[pointIndex] == nil then
    self:CreateTip(pointIndex, pointInfo)
  elseif isShow and self.tipDict[pointIndex] ~= nil then
    if self.tipDict[pointIndex].tip ~= nil then
      self.tipDict[pointIndex].tip:CheckLod(DisplaySettings.currentLod)
    end
  elseif not isShow and self.tipDict[pointIndex] ~= nil then
    self:DestroyTip(pointIndex)
  end
end

local function CreateTip(self, pointIndex, pointInfo)
  if BattleFieldUtil.InBattleField() then
    return
  end
  local mapSurpriseData = LocalController:instance():getLine(TableName.LW_Map_Surprise, pointInfo.configId)
  if mapSurpriseData.opening_time == nil or mapSurpriseData.opening_time == "" then
    return
  end
  local request = ResourceManager:InstantiateAsync(UIAssets.SurpriseBuildingTip)
  request:completed("+", function()
    if request.isError then
      return
    end
    if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
      request:Destroy()
      return
    end
    if mapSurpriseData then
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      local autoFace = go:GetComponent(typeof(CS.AutoFaceToCamera))
      local adjustScales = go:GetComponent(typeof(CS.AutoAdjustScale))
      local adjustLod = go:GetComponent(typeof(CS.AutoAdjustLod))
      if not IsNull(autoFace) then
        autoFace.enabled = true
      end
      if not IsNull(adjustScales) then
        adjustScales.enabled = true
      end
      if not IsNull(adjustLod) then
        adjustLod.enabled = true
      end
      local tip = SurpriseBuildingTip.New()
      tip:OnCreate(request)
      tip:SetData(pointInfo, mapSurpriseData.positional_offset, mapSurpriseData.unlocked_prompt, mapSurpriseData.prompt)
      self.tipDict[pointIndex] = {tip = tip, req = request}
    end
  end)
  self.tipDict[pointIndex] = {tip = nil, req = request}
end

local function DestroyTip(self, pointIndex)
  local t = self.tipDict[pointIndex]
  if t ~= nil then
    if t.tip ~= nil then
      t.tip:OnDestroy()
    end
    if t.req ~= nil then
      t.req:Destroy()
    end
  end
  self.tipDict[pointIndex] = nil
end

SurpriseBuildingTipManager.__init = __init
SurpriseBuildingTipManager.__delete = __delete
SurpriseBuildingTipManager.Startup = Startup
SurpriseBuildingTipManager.RemoveAllSurpriseBuildingTip = RemoveAllSurpriseBuildingTip
SurpriseBuildingTipManager.AddListeners = AddListeners
SurpriseBuildingTipManager.RemoveListeners = RemoveListeners
SurpriseBuildingTipManager.OnSurpriseBuildingShow = OnSurpriseBuildingShow
SurpriseBuildingTipManager.OnSurpriseBuildingDestroy = OnSurpriseBuildingDestroy
SurpriseBuildingTipManager.ChangeCameraLodSignal = ChangeCameraLodSignal
SurpriseBuildingTipManager.OnBloodyNightActivityRefresh = OnBloodyNightActivityRefresh
SurpriseBuildingTipManager.ShowTip = ShowTip
SurpriseBuildingTipManager.CreateTip = CreateTip
SurpriseBuildingTipManager.DestroyTip = DestroyTip
SurpriseBuildingTipManager.UpdateLod = UpdateLod
SurpriseBuildingTipManager.UpdateTipLod = UpdateTipLod
SurpriseBuildingTipManager.ChangeAllTipToDawn = ChangeAllTipToDawn
return SurpriseBuildingTipManager
