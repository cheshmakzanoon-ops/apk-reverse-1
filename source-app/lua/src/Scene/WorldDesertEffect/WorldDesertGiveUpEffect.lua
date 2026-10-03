local WorldDesertGiveUpEffect = BaseClass("WorldDesertGiveUpEffect")
local Localization = CS.GameEntry.Localization

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
    self.time_text = self.transform:Find("ModelGo/Transform/name"):GetComponent(typeof(CS.SuperTextMesh))
    self.isDoAnim = false
    
    function self.timer_action()
      self:UpdateTime()
    end
    
    self:AddTimer()
  end
end

local function OnDestroy(self)
  self:RemoveTimer()
end

local function ReInit(self, uuid, pointId, endTime, ownerUid, allianceId)
  if IsNull(self.gameObject) then
    return
  end
  self.uuid = uuid
  self.pointId = pointId
  self.endTime = endTime
  self.ownerUid = ownerUid
  self.allianceId = allianceId
  local posV3 = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
  self.transform.position = posV3
  self.isDoAnim = true
  if ownerUid ~= LuaEntry.Player:GetUid() and allianceId == LuaEntry.Player.allianceId then
    self.time_text.color32 = Color32.New(111, 126, 243, 255)
  elseif ownerUid ~= "" and ownerUid ~= LuaEntry.Player:GetUid() then
    self.time_text.color32 = WorldWhiteColor32
  elseif ownerUid == LuaEntry.Player:GetUid() then
    self.time_text.color32 = Color32.New(146, 221, 76, 255)
  else
    self.time_text.color32 = WorldWhiteColor32
  end
  self:UpdateTime()
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function UpdateTime(self)
  if self.isDoAnim then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local timeLeft = self.endTime - curTime
    if 0 < timeLeft then
      if IsNull(self.time_text) == false then
        self.time_text.text = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(timeLeft)
      end
    else
      if IsNull(self.time_text) == false then
        self.time_text.text = "00:00"
      end
      self.isDoAnim = false
    end
  end
end

WorldDesertGiveUpEffect.OnCreate = OnCreate
WorldDesertGiveUpEffect.OnDestroy = OnDestroy
WorldDesertGiveUpEffect.ReInit = ReInit
WorldDesertGiveUpEffect.RemoveTimer = RemoveTimer
WorldDesertGiveUpEffect.UpdateTime = UpdateTime
WorldDesertGiveUpEffect.AddTimer = AddTimer
return WorldDesertGiveUpEffect
