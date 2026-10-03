local WorldBankScoutTipManager = BaseClass("WorldBankScoutTipManager", Singleton)
local WorldBankScoutTip = require("DataCenter.SeasonManager.Bank.Tip.WorldBankScoutTip")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.marchHeadTopUIList = {}
  self.isOnCreateList = {}
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self.marchHeadTopUIList = nil
  self.isOnCreateList = nil
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.HideTroopHead, self.HideTroopHead)
  EventManager:GetInstance():AddListener(EventId.SingleMarchStateUpdate, self.MarchStateUpdate)
  EventManager:GetInstance():AddListener(EventId.WorldTroopGameObjectCreateFinish, self.MarchStateUpdate)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.HideTroopHead, self.HideTroopHead)
  EventManager:GetInstance():RemoveListener(EventId.SingleMarchStateUpdate, self.MarchStateUpdate)
  EventManager:GetInstance():RemoveListener(EventId.WorldTroopGameObjectCreateFinish, self.MarchStateUpdate)
end

local function MarchStateUpdate(data)
  local marchUuid = tonumber(data)
  local marchInfo = CS.SceneManager.World:GetMarch(marchUuid)
  if not marchInfo or marchInfo:GetMarchTargetType() ~= MarchTargetType.CROSS_BANK_DEPOSIT then
    WorldBankScoutTipManager:GetInstance():HideHeadUI(marchUuid)
    return
  end
  local marchType = marchInfo:GetMarchType()
  if marchType ~= NewMarchType.CROSS_SCOUT and marchType ~= NewMarchType.SCOUT then
    WorldBankScoutTipManager:GetInstance():HideHeadUI(marchUuid)
    return
  end
  WorldBankScoutTipManager:GetInstance():ShowHeadUI(marchUuid, marchInfo)
end

local function ChangeCameraLodSignal(lod)
end

local function HideTroopHead(uuid)
  WorldBankScoutTipManager:GetInstance():HideHeadUI(uuid)
end

local function UpdateLod(self, lod)
end

local function HideHeadUI(self, marchUuid)
  if self.marchHeadTopUIList[marchUuid] ~= nil or self.isOnCreateList[marchUuid] ~= nil then
    local headUI = self.marchHeadTopUIList[marchUuid]
    if headUI ~= nil then
      local request = headUI.request
      headUI:OnDestroy()
      if request ~= nil then
        request:Destroy()
      end
      self.marchHeadTopUIList[marchUuid] = nil
    end
    local temp = self.isOnCreateList[marchUuid]
    if temp ~= nil then
      temp:Destroy()
      self.isOnCreateList[marchUuid] = nil
    end
  end
end

local function ShowHeadUI(self, marchUuid, marchInfo_)
  local troop = CS.SceneManager.World:GetTroop(marchUuid)
  if troop ~= nil then
    self:ShowBankTip(troop, marchUuid, marchInfo_)
  end
end

local function ShowBankTip(self, troop, marchUuid, info)
  local transform = troop:GetTransform()
  info = info or CS.SceneManager.World:GetMarch(marchUuid)
  if info ~= nil then
    if self.marchHeadTopUIList[marchUuid] == nil and self.isOnCreateList[marchUuid] == nil then
      local request = ResourceManager:InstantiateAsync(UIAssets.WorldBankScoutTip)
      self.isOnCreateList[marchUuid] = request
      request:completed("+", function()
        self.isOnCreateList[marchUuid] = nil
        if request.isError then
          return
        end
        request.gameObject:SetActive(true)
        if transform == nil then
          request:Destroy()
        end
        request.gameObject.transform:SetParent(transform)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        local tileUI = WorldBankScoutTip.New()
        tileUI:OnCreate(request)
        self.marchHeadTopUIList[marchUuid] = tileUI
        self.marchHeadTopUIList[marchUuid]:ShowMarchInfo(info)
      end)
    elseif self.marchHeadTopUIList[marchUuid] ~= nil then
      self.marchHeadTopUIList[marchUuid]:ShowMarchInfo(info)
    end
  end
end

WorldBankScoutTipManager.__init = __init
WorldBankScoutTipManager.__delete = __delete
WorldBankScoutTipManager.AddListener = AddListener
WorldBankScoutTipManager.RemoveListener = RemoveListener
WorldBankScoutTipManager.ChangeCameraLodSignal = ChangeCameraLodSignal
WorldBankScoutTipManager.MarchStateUpdate = MarchStateUpdate
WorldBankScoutTipManager.HideTroopHead = HideTroopHead
WorldBankScoutTipManager.ShowHeadUI = ShowHeadUI
WorldBankScoutTipManager.HideHeadUI = HideHeadUI
WorldBankScoutTipManager.UpdateLod = UpdateLod
WorldBankScoutTipManager.ShowBankTip = ShowBankTip
return WorldBankScoutTipManager
