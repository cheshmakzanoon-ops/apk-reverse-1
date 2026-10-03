local MonsterProtection = BaseClass("MonsterProtection")
local ModelName = "Assets/Main/Prefabs/UI/Build/WorldMonsterProtection.prefab"
local ResourceManager = CS.GameEntry.Resource

local function __init(self)
  self.marchInfo = nil
  self.uuid = nil
  self.allianceUid = nil
  self.allianceAbbr = nil
  self.ownerName = nil
  self.protectionEndTime = 0
  self.showEndTime = 0
  self.request = nil
  self.gameObject = nil
  self.timeText = nil
  self.inited = false
end

local function __delete(self)
  if self.request then
    self.request:Destroy()
  end
  self.request = nil
  self.gameObject = nil
  self.timeText = nil
  self.marchInfo = nil
  self.uuid = nil
  self.createTime = nil
  self.allianceUid = nil
  self.allianceAbbr = nil
  self.ownerName = nil
  self.protectionEndTime = nil
  self.showEndTime = nil
  self.inited = nil
end

local function Refresh(self, march, msg)
  self.marchInfo = march
  self.uuid = self.marchInfo.uuid
  local createTime = self.marchInfo.createTime
  local cfgTime = LuaEntry.DataConfig:TryGetNum("monster_invasion", "k12")
  if createTime and 0 < createTime and cfgTime and 0 < cfgTime then
    self.protectionEndTime = createTime + cfgTime * 1000
  end
  self:OnGetDetail(msg or self.marchInfo)
end

local function OnGetDetail(self, msg)
  self.allianceUid = msg.allianceUid
  self.allianceAbbr = msg.allianceAbbr
  self.ownerName = msg.ownerName
  self.isProtected = msg.isProtected
  local needShow = (string.IsNullOrEmpty(self.allianceUid) or self.allianceUid ~= LuaEntry.Player.allianceId) and self.marchInfo.belongUid ~= LuaEntry.Player.uid
  if self.isProtected ~= nil then
    needShow = needShow and self.isProtected
  elseif not self.inited then
    local serverId = LuaEntry.Player:GetCurServerId()
    if self.marchInfo and self.marchInfo.serverId then
      serverId = self.marchInfo.serverId
    end
    SFSNetwork.SendMessage(MsgDefines.MonsterInvasionBossDetail, serverId, self.uuid)
    self.inited = true
  end
  if needShow then
    self.showEndTime = self.protectionEndTime
  else
    self.showEndTime = 0
  end
  if self.isProtected ~= nil then
    if self.showEndTime and self.showEndTime > UITimeManager:GetInstance():GetServerTime() then
      self:RefreshObject()
    else
      DataCenter.MonsterProtectionManager:RemoveMonsterProtection(self.uuid)
    end
  end
end

local function RefreshObject(self)
  if self.request == nil then
    local request = ResourceManager:InstantiateAsync(ModelName)
    self.request = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.transform.position = self.marchInfo.position
      self.gameObject = request.gameObject
      self.gameObject.name = "MonsterProtection_" .. self.uuid
      self.gameObject:SetActive(true)
      self.timeText = self.gameObject.transform:Find("PosGo/Bg/TimeText"):GetComponent(typeof(CS.TextMeshProEx))
      self:OnUpdateSec()
    end)
  end
end

local function OnUpdateSec(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  local diff = self.showEndTime - now
  if 0 < diff then
    if self.timeText then
      self.timeText.text = UITimeManager:GetInstance():SecondToFmtString(diff / 1000)
    end
  else
    DataCenter.MonsterProtectionManager:RemoveMonsterProtection(self.uuid)
  end
end

MonsterProtection.__init = __init
MonsterProtection.__delete = __delete
MonsterProtection.Refresh = Refresh
MonsterProtection.OnGetDetail = OnGetDetail
MonsterProtection.RefreshObject = RefreshObject
MonsterProtection.OnUpdateSec = OnUpdateSec
return MonsterProtection
