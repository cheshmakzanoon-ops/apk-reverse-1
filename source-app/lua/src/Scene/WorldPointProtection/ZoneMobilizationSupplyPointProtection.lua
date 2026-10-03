local ZoneMobilizationSupplyPointProtection = BaseClass("ZoneMobilizationSupplyPointProtection")
local ResourceManager = CS.GameEntry.Resource
local ModelName = "Assets/Main/Prefabs/UI/Build/WorldMonsterProtection.prefab"

local function __init(self)
  self.uuid = nil
  self.showEndTime = 0
  self.parent = nil
  self.request = nil
  self.gameObject = nil
  self.timeText = nil
  self.protectionTime = nil
end

local function __delete(self)
  if self.request then
    self.request:Destroy()
  end
  self.request = nil
  self.gameObject = nil
  self.timeText = nil
  self.uuid = nil
  self.createTime = nil
  self.showEndTime = nil
  self.parent = nil
  self.protectionTime = nil
end

local function Refresh(self, pointInfo, transform, cfgTime)
  self.parent = transform
  self.protectionTime = cfgTime or 0
  self.uuid = pointInfo.uuid
  self:RefreshInfo(pointInfo)
end

local function RefreshInfo(self, pointInfo)
  if pointInfo then
    local configId = pointInfo.configId
    if not string.IsNullOrEmpty(configId) then
      local config = LocalController:instance():getLine(TableName.LWIceSupplies, configId)
      if config and (config.type == WorldSuppliesType.ZoneMobilizationType or config.type == WorldSuppliesType.ZoneMobilizationSmallType) then
        local createTime = pointInfo.createTime
        if createTime and 0 < createTime then
          local protectionEndTime = 0
          if self.protectionTime and 0 < self.protectionTime then
            protectionEndTime = createTime + self.protectionTime * 1000
          end
          local allianceUid = pointInfo.discovererAllianceId
          local needShow = false
          if string.IsNullOrEmpty(allianceUid) then
            needShow = pointInfo.discovererUid ~= LuaEntry.Player.uid
          else
            needShow = allianceUid ~= LuaEntry.Player.allianceId
          end
          if needShow then
            self.showEndTime = protectionEndTime
          else
            self.showEndTime = 0
          end
          if self.showEndTime and self.showEndTime > UITimeManager:GetInstance():GetServerTime() then
            self:RefreshObject()
            return
          end
        end
      end
    end
  end
  DataCenter.WorldPointProtectionManager:RemoveProtection(self.uuid)
end

local function RefreshObject(self)
  if self.request == nil then
    local request = ResourceManager:InstantiateAsync(ModelName)
    self.request = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      if self.parent then
        request.gameObject.transform.position = self.parent.position + Vector3.New(0.3, 0.6, 0)
      end
      self.gameObject = request.gameObject
      self.gameObject.name = "WorldPointProtection_" .. self.uuid
      self.gameObject:SetActive(true)
      self.timeText = self.gameObject.transform:Find("PosGo/Bg/TimeText"):GetComponent(typeof(CS.TextMeshProEx))
      self:OnUpdateSec()
    end)
  end
end

local function OnUpdateSec(self)
  if self.showEndTime and self.showEndTime > 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local diff = self.showEndTime - now
    if 0 < diff then
      if self.timeText then
        self.timeText.text = UITimeManager:GetInstance():SecondToFmtString(diff / 1000)
      end
    else
      DataCenter.WorldPointProtectionManager:RemoveProtection(self.uuid)
    end
  end
end

ZoneMobilizationSupplyPointProtection.__init = __init
ZoneMobilizationSupplyPointProtection.__delete = __delete
ZoneMobilizationSupplyPointProtection.Refresh = Refresh
ZoneMobilizationSupplyPointProtection.RefreshInfo = RefreshInfo
ZoneMobilizationSupplyPointProtection.RefreshObject = RefreshObject
ZoneMobilizationSupplyPointProtection.OnUpdateSec = OnUpdateSec
return ZoneMobilizationSupplyPointProtection
