local SkinSimulationClickManager = BaseClass("SkinSimulationClickManager")

local function __init(self)
  self.updateSecTimer = nil
  self.curSkinId = -1
  self.randomAniEnable = false
  self.minTime = -1
  self.maxTime = -1
  self.randomAniTimer = -1
  self.randomAniStart = false
  self:AddListener()
end

local function __delete(self)
  self.curSkinId = -1
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
  self:RemoveListener()
end

function SkinSimulationClickManager:OnEnterGame()
  self:PlayerChangeSkin()
end

function SkinSimulationClickManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.BaseSkinIdChange, self.SetBaseSkinId, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.UserSkinUpdate, self.PlayerChangeSkin, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.LuaEntryEffectRefreshStatus, self.ChangeState, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.GF_enter_city, self.EnterCity, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.StatusDataInit, self.InitState, self)
end

function SkinSimulationClickManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.BaseSkinIdChange, self.SetBaseSkinId)
  EventManager:GetInstance():RemoveListener2(EventId.UserSkinUpdate, self.PlayerChangeSkin)
  EventManager:GetInstance():RemoveListener2(EventId.LuaEntryEffectRefreshStatus, self.ChangeState)
  EventManager:GetInstance():RemoveListener2(EventId.GF_enter_city, self.EnterCity)
  EventManager:GetInstance():RemoveListener2(EventId.StatusDataInit, self.InitState)
end

local function Startup(self)
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function SkinSimulationClickManager:OnUpdateSec()
  if self.randomAniEnable and self.randomAniStart then
    if BattleFieldUtil.InBattleField() then
      self:StopTimer()
      return
    end
    local now = UITimeManager:GetInstance():GetServerSeconds()
    if now <= self.randomAniTimer then
      return
    end
    local serverId = LuaEntry.Player:GetCrossServerId()
    local worldId = LuaEntry.Player:GetCurWorldId()
    SFSNetwork.SendMessage(MsgDefines.ClickWorldSkinAction, LuaEntry.Player.uid, 3, serverId, worldId)
    self:StopTimer()
  end
end

function SkinSimulationClickManager:SkinChange(check)
  if self.curSkinId > 0 then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(self.curSkinId)
    if template and template.act_mod_open == 1 and 0 < template.randMin and 0 < template.randMax and template.randMax > template.randMin then
      self.randomAniEnable = true
      self.randomAniStart = false
      self.minTime = template.randMin
      self.maxTime = template.randMax
      if check then
        self:CheckRandomLogicTimer()
      end
    else
      self.randomAniEnable = false
      self.randomAniStart = false
      self:StopTimer()
    end
  else
    self.randomAniEnable = false
    self.randomAniStart = false
    self:StopTimer()
  end
end

function SkinSimulationClickManager:CheckRandomLogicTimer()
  if self.randomAniEnable then
    local list = LuaEntry.Effect:GetStatusMap()
    local flag = true
    for k, v in pairs(list) do
      local intKey = toInt(k)
      local numValue = tonumber(v)
      local meta = LocalController:instance():getLine(TableName.StatusTab, tostring(intKey))
      if meta and toInt(meta.type2) == StatusType2.SkinAnimationType then
        flag = false
        break
      end
    end
    self:StopTimer()
    if flag then
      local second = math.random(self.minTime, self.maxTime)
      local now = UITimeManager:GetInstance():GetServerSeconds()
      self.randomAniTimer = second + now
      self.randomAniStart = true
      self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
      self.updateSecTimer:Start()
    end
  end
end

function SkinSimulationClickManager:StopTimer()
  self.randomAniStart = false
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function SkinSimulationClickManager:SetBaseSkinId(skinId)
  self.curSkinId = skinId
  self:SkinChange()
end

function SkinSimulationClickManager:PlayerChangeSkin()
  local skin = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_City)
  self.curSkinId = skin and skin or -1
  self:SkinChange(true)
end

function SkinSimulationClickManager:ChangeState(stateId)
  if stateId then
    local meta = LocalController:instance():getLine(TableName.StatusTab, tostring(stateId))
    if meta and toInt(meta.type2) == StatusType2.SkinAnimationType then
      self:CheckRandomLogicTimer()
    end
  end
end

function SkinSimulationClickManager:EnterCity()
  if self.randomAniEnable and self.updateSecTimer == nil then
    self:CheckRandomLogicTimer()
  end
end

function SkinSimulationClickManager:InitState()
  if self.randomAniEnable and self.updateSecTimer == nil then
    self:CheckRandomLogicTimer()
  end
end

SkinSimulationClickManager.__init = __init
SkinSimulationClickManager.__delete = __delete
SkinSimulationClickManager.Startup = Startup
return SkinSimulationClickManager
