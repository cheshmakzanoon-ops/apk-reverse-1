local NextGarbagePointManager = BaseClass("NextGarbagePointManager")
local ResourceManager = CS.GameEntry.Resource
local PositionDelta = Vector3.New(0, 2, 0)

local function __init(self)
  self.request = nil
  self.garbageList = {}
  self.index = -1
  self.vecPos = nil
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self:RemoveUI()
  self.garbageList = nil
  self.index = nil
  self.vecPos = nil
end

local function Startup()
end

local function RemoveUI(self)
  if self.request ~= nil then
    self.request:Destroy()
    self.request = nil
  end
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.Guide_video_Play, self.UILoadingExitSignal)
  EventManager:GetInstance():AddListener(EventId.CityGarbageResult, self.CityGarbageResultSignal)
  EventManager:GetInstance():AddListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.Guide_video_Play, self.UILoadingExitSignal)
  EventManager:GetInstance():RemoveListener(EventId.CityGarbageResult, self.CityGarbageResultSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
end

local function ShowUI(self)
  if self.request == nil then
    self.request = ResourceManager:InstantiateAsync(UIAssets.NextGarbagePoint)
    self.request:completed("+", function()
      if self.request.isError then
        return
      end
      self.request.gameObject:SetActive(true)
      self.request.gameObject.transform:SetParent(CS.SceneManager.World.BuildBubbleNode)
      self.request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.request.gameObject.transform.position = self.vecPos + PositionDelta
    end)
  elseif self.request.gameObject ~= nil then
    self.request.gameObject.transform.position = self.vecPos + PositionDelta
  end
end

local function InitPoint(self)
  local str = LuaEntry.DataConfig:TryGetStr("prologue_tag_order", "k1")
  if str ~= nil and str ~= "" then
    self.garbageList = string.split(str, ";")
  end
end

local function RefreshIndex(self)
  self.vecPos = nil
  self.index = -1
  if DataCenter.BuildManager.MainLv == 0 and self.garbageList ~= nil then
    local vecZ = Vector3.New(0, 0, 0)
    for k, v in ipairs(self.garbageList) do
      local point = DataCenter.CityPointDataManager:GetPointDataByItemId(tostring(v))
      local vec = point and point:GetCenterWorldPos() or VecZero
      if vec.x ~= vecZ.x or vec.y ~= vecZ.y or vec.z ~= vecZ.z then
        self.vecPos = vec
        self.index = k
      end
    end
  end
  if self.index > 0 then
    self:ShowUI()
  else
    self:RemoveUI()
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateFakeBuildingPos, self:GetCurPosIndex())
end

local function UILoadingExitSignal()
  DataCenter.NextGarbagePointManager:RefreshIndex()
end

local function GetCurPos(self)
  return self.vecPos
end

local function GetCurPosIndex(self)
  if self.vecPos ~= nil then
    return SceneUtils.WorldToTileIndex(self.vecPos)
  end
end

local function CityGarbageResultSignal(self)
  DataCenter.NextGarbagePointManager:RefreshIndex()
end

local function BuildMainZeroUpgradeSuccessSignal(self)
  DataCenter.NextGarbagePointManager:RefreshIndex()
end

NextGarbagePointManager.__init = __init
NextGarbagePointManager.__delete = __delete
NextGarbagePointManager.Startup = Startup
NextGarbagePointManager.ShowUI = ShowUI
NextGarbagePointManager.RemoveUI = RemoveUI
NextGarbagePointManager.InitPoint = InitPoint
NextGarbagePointManager.RefreshIndex = RefreshIndex
NextGarbagePointManager.AddListener = AddListener
NextGarbagePointManager.RemoveListener = RemoveListener
NextGarbagePointManager.UILoadingExitSignal = UILoadingExitSignal
NextGarbagePointManager.GetCurPos = GetCurPos
NextGarbagePointManager.GetCurPosIndex = GetCurPosIndex
NextGarbagePointManager.CityGarbageResultSignal = CityGarbageResultSignal
NextGarbagePointManager.BuildMainZeroUpgradeSuccessSignal = BuildMainZeroUpgradeSuccessSignal
return NextGarbagePointManager
