local OtherBuildBubbleManager = BaseClass("OtherBuildBubbleManager")
local OtherBuildBubbleTip = require("UI.BuildBubbleTip.View.OtherBuildBubbleTip")
local ResourceManager = CS.GameEntry.Resource
local TileBgScale1 = Vector3.New(0.7, 0.7, 0.7)
local TileBgScale2 = Vector3.New(1, 1, 1)
local TileBgScale3 = Vector3.New(0.6, 0.6, 0.6)

local function __init(self)
  self.buildBubbleDic = {}
  self.loadingBubbleDic = {}
  self:AddListener()
end

local function __delete(self)
  for k, v in pairs(self.buildBubbleDic) do
    self.buildBubbleDic[k]:OnDestroy()
    self.buildBubbleDic[k].request:Destroy()
  end
  self.loadingBubbleDic = nil
  self.buildBubbleDic = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.StorageShopDataChange, self.OnOtherBuildComeInView)
  EventManager:GetInstance():AddListener(EventId.ShowIsOnFire, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.OnEnterPveLevel)
  EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.OnExitPveLevel)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.StorageShopDataChange, self.OnOtherBuildComeInView)
  EventManager:GetInstance():RemoveListener(EventId.ShowIsOnFire, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.OnEnterPveLevel)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.OnExitPveLevel)
end

local function Startup()
end

local function BuildInViewSignal(data)
  local uuid = tonumber(data)
  local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(uuid)
  if pointInfo ~= nil then
    cast(pointInfo, typeof(CS.BuildPointInfo))
    if pointInfo ~= nil then
      if pointInfo.ownerUid == LuaEntry.Player.uid then
        return
      end
      if pointInfo.destroyStartTime > 0 then
        DataCenter.OtherBuildBubbleManager:TryDelOneBubble(pointInfo.pointIndex)
      end
    end
  end
end

local function OnOtherBuildComeInView(pId)
  local pointId = tonumber(pId)
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if pointInfo then
    cast(pointInfo, typeof(CS.BuildPointInfo))
    if pointInfo.ownerUid == LuaEntry.Player.uid then
      return
    end
    if pointInfo ~= nil then
      DataCenter.OtherBuildBubbleManager:TryRefreshOneBubble(pointInfo)
    end
  else
    DataCenter.OtherBuildBubbleManager:TryDelOneBubble(pId)
  end
end

local function OnOtherBuildComeOutView(pId)
  DataCenter.OtherBuildBubbleManager:TryDelOneBubble(pId)
end

local function TryRefreshOneBubble(self, buildInfo)
  local showState = buildInfo:GetShowState()
  if not self:CheckIfNeedBubble(showState, buildInfo) then
    self:TryDelOneBubble(buildInfo.pointIndex)
    return
  end
  local buildId = buildInfo.itemId
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local param = {
    pointId = buildInfo.pointIndex,
    ownerUid = buildInfo.ownerUid,
    uuid = buildInfo.uuid,
    modelHeight = CS.SceneManager.World:GetBuildingHeight(buildInfo.pointIndex),
    tileX = buildTemplate.tileX,
    tileY = buildTemplate.tileY,
    bgScale = self:GetBgScale(buildTemplate.tileX, buildTemplate.tileY),
    iconScale = self:GetIconScale(),
    otherBubbleType = OtherBuildBubbleType.StorageShop,
    model = UIAssets.BuildStateIcon,
    iconName = string.format(LoadPath.UIBuildBubble, OtherBuildBubbleIcon.StorageShop),
    bgName = string.format(LoadPath.UIBuildBubble, OtherBuildBubbleIcon.CommonBg),
    callback = nil
  }
  if showState == CS.QueueState.STORAGE_SHOP then
    param.model = UIAssets.BuildStateIcon
    param.iconName = string.format(LoadPath.UIBuildBubble, OtherBuildBubbleIcon.StorageShop)
    param.bgName = string.format(LoadPath.UIBuildBubble, OtherBuildBubbleIcon.CommonBg)
    
    function param:callback()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, self.ownerUid)
    end
  end
  if self.buildBubbleDic[buildInfo.pointIndex] then
    self.buildBubbleDic[buildInfo.pointIndex]:ReInit(param)
  else
    self:CreateOneBubble(param)
  end
end

local function CreateOneBubble(self, param)
  local request = ResourceManager:InstantiateAsync(param.model)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.BuildBubbleNode)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.name = "OtherBubble" .. param.uuid
    local otherBubbleTip
    if param.model == UIAssets.BuildStateIcon then
      otherBubbleTip = OtherBuildBubbleTip.New()
    end
    otherBubbleTip:OnCreate(request)
    otherBubbleTip:ReInit(param)
    self.buildBubbleDic[param.pointId] = otherBubbleTip
  end)
end

local function TryDelOneBubble(self, pointId)
  if self.buildBubbleDic[pointId] then
    self:DelOneBubble(pointId)
  end
end

local function DelOneBubble(self, pointId)
  local bubble = self.buildBubbleDic[pointId]
  if bubble then
    bubble:OnDestroy()
    bubble.request:Destroy()
    bubble = nil
    self.buildBubbleDic[pointId] = nil
  end
end

local function GetBgScale(self, tileX, tileY)
  if tileX == BuildTilesSize.One or tileY == BuildTilesSize.One then
    return TileBgScale1
  else
    return TileBgScale2
  end
  return TileBgScale2
end

local function GetIconScale(self)
  return ResetScale
end

local function CheckIfNeedBubble(self, showState, buildInfo)
  if buildInfo ~= nil and showState == CS.QueueState.STORAGE_SHOP and buildInfo.destroyStartTime <= 0 then
    local needBubble = DataCenter.StorageShopManager:CheckIfHasGoodsOnSell(buildInfo.ownerUid)
    return needBubble
  end
end

local function OnEnterPveLevel()
  local self = DataCenter.OtherBuildBubbleManager
  self:ClearModels()
end

local function OnExitPveLevel()
end

local function ClearModels(self)
  self.loadingBubbleDic = {}
  self.buildBubbleDic = {}
end

OtherBuildBubbleManager.__init = __init
OtherBuildBubbleManager.__delete = __delete
OtherBuildBubbleManager.AddListener = AddListener
OtherBuildBubbleManager.RemoveListener = RemoveListener
OtherBuildBubbleManager.Startup = Startup
OtherBuildBubbleManager.OnOtherBuildComeInView = OnOtherBuildComeInView
OtherBuildBubbleManager.OnOtherBuildComeOutView = OnOtherBuildComeOutView
OtherBuildBubbleManager.TryRefreshOneBubble = TryRefreshOneBubble
OtherBuildBubbleManager.CreateOneBubble = CreateOneBubble
OtherBuildBubbleManager.TryDelOneBubble = TryDelOneBubble
OtherBuildBubbleManager.DelOneBubble = DelOneBubble
OtherBuildBubbleManager.CheckIfNeedBubble = CheckIfNeedBubble
OtherBuildBubbleManager.GetBgScale = GetBgScale
OtherBuildBubbleManager.GetIconScale = GetIconScale
OtherBuildBubbleManager.BuildInViewSignal = BuildInViewSignal
OtherBuildBubbleManager.OnEnterPveLevel = OnEnterPveLevel
OtherBuildBubbleManager.OnExitPveLevel = OnExitPveLevel
OtherBuildBubbleManager.ClearModels = ClearModels
return OtherBuildBubbleManager
