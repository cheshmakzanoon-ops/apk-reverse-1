local WorldDesertProtectEffect = BaseClass("WorldDesertProtectEffect")
local Localization = CS.GameEntry.Localization

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
    self.isDoAnim = false
    local timeTxtNode = self.transform:Find("ModelGo/Transform/name")
    if timeTxtNode ~= nil then
      self.time_text = timeTxtNode:GetComponent(typeof(CS.SuperTextMesh))
    end
    
    function self.timer_action()
      self:UpdateTime()
    end
    
    self:AddTimer()
  end
end

local function OnDestroy(self)
  self:RemoveTimer()
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

local function ReInit(self, uuid, pointId, endTime)
  if IsNull(self.gameObject) then
    return
  end
  self.uuid = uuid
  self.pointId = pointId
  self.endTime = endTime
  local posV3 = SceneUtils.TileIndexToWorld(self.pointId)
  self.transform.position = posV3
  self.isDoAnim = true
  self:UpdateTime()
  local info = CS.SceneManager.World:GetDesertInfoByUuid(self.uuid)
  if info ~= nil then
    local desertId = info.desertId
    if desertId ~= nil and desertId ~= 0 then
      local FirstOccupyRoot = self.transform:Find("ModelGo/FirstOccupy")
      if FirstOccupyRoot then
        local needAnim = false
        local protect_time = GetTableData(TableName.Desert, desertId, "protect_time")
        if protect_time then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          local timeLeft = endTime - curTime
          if protect_time * 1000 - timeLeft < 3000 then
            needAnim = true
          end
        end
        FirstOccupyRoot.gameObject:SetActive(needAnim)
      end
    end
  end
end

local function UpdateTime(self)
  if self.isDoAnim then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local timeLeft = self.endTime - curTime
    if timeLeft <= 0 then
      self.isDoAnim = false
      if IsNull(self.time_text) == false then
        self.time_text.text = "00:00"
      end
      WorldDesertEffectManager:GetInstance():RemoveProtectEffect(self.uuid)
    elseif IsNull(self.time_text) == false then
      self.time_text.text = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(timeLeft)
    end
  end
end

WorldDesertProtectEffect.OnCreate = OnCreate
WorldDesertProtectEffect.OnDestroy = OnDestroy
WorldDesertProtectEffect.ReInit = ReInit
WorldDesertProtectEffect.UpdateTime = UpdateTime
WorldDesertProtectEffect.RemoveTimer = RemoveTimer
WorldDesertProtectEffect.AddTimer = AddTimer
return WorldDesertProtectEffect
