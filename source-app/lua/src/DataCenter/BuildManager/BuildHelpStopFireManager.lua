local BuildHelpStopFireManager = BaseClass("BuildHelpStopFireManager")
local BuildHelpStopFireEffect = require("DataCenter.BuildManager.BuildHelpStopFireEffect")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.helpStopCityFireTimes = 0
  self.allEffect = {}
  self.bindOnBuildOutView = BindCallback(self, self.OnBuildOutView)
  self.bindOnLodChange = BindCallback(self, self.OnLodChange)
  self.bindClearAllEffect = BindCallback(self, self.ClearAllEffect)
  self:AddListener()
end

local function __delete(self)
  self.helpStopCityFireTimes = 0
  self:ClearAllEffect()
  self.allEffect = nil
  self:RemoveListener()
  self.bindOnBuildOutView = nil
  self.bindOnLodChange = nil
  self.bindClearAllEffect = nil
  self.allanceDialogIds = nil
  self.defaultDialogId = nil
end

local function ClearAllEffect(self)
  if self.allEffect then
    for k, v in pairs(self.allEffect) do
      v:OnDestroy()
    end
  end
  ObjectPool:GetInstance():Clear(BuildHelpStopFireEffect)
end

local function InitData(self, msg)
  if msg.help_stop_city_fire_times then
    self.helpStopCityFireTimes = msg.help_stop_city_fire_times
  end
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_OUT_VIEW, self.bindOnBuildOutView)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.bindOnLodChange)
  EventManager:GetInstance():AddListener(EventId.OnEnterCrossServer, self.bindClearAllEffect)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.bindClearAllEffect)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_OUT_VIEW, self.bindOnBuildOutView)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.bindOnLodChange)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCrossServer, self.bindClearAllEffect)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.bindClearAllEffect)
end

local function HelpStopCityFireHandler(self, msg)
  if msg.help_stop_city_fire_times then
    self.helpStopCityFireTimes = msg.help_stop_city_fire_times
  end
  if msg.remainGold ~= nil then
    LuaEntry.Player.gold = msg.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

local function PushHelpStopCityFireTimesHandler(self, msg)
  if msg.help_stop_city_fire_times then
    self.helpStopCityFireTimes = msg.help_stop_city_fire_times
  end
end

local function PushHelpStopCityFireNotifyHandler(self, msg)
  if CS.SceneManager.World == nil then
    return
  end
  if msg.helper and msg.helper.uid and msg.targetUid then
    if (LuaEntry.Player.uid == msg.helper.uid or LuaEntry.Player.uid == msg.helper.targetUid) and msg.pointId then
      local info = CS.SceneManager.World:GetPointInfo(msg.pointId)
      if info then
        cast(info, typeof(CS.BuildPointInfo))
        if info.destroyStartTime > 0 then
          self:RemoveOneEffect(info.uuid)
        else
          self:ShowEffect(info, msg.pointId)
        end
      end
    end
    UIUtil.ShowThumbsUpBroadcastPopUI(msg.serverId, msg.pointId, msg.helper, Localization:GetString("outfire_tips_02", msg.helper.name), "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_dianzan.png")
  end
end

local function IsFree(self)
  return self.helpStopCityFireTimes < LuaEntry.DataConfig:TryGetNum("city_wall", "k10", 0)
end

local function IsOpen(self)
  return LuaEntry.DataConfig:CheckSwitch("outfire_help")
end

local function OnBuildOutView(self, uuid)
  self:RemoveOneEffect(tonumber(uuid))
end

local function OnLodChange(self, lod)
  if lod ~= nil and CS.CommonUtils.IsDebug() then
    Logger.Log("LOD-" .. lod)
  end
  for k, v in pairs(self.allEffect) do
    v:OnLodChange(lod)
  end
end

local function RemoveOneEffect(self, bUuid)
  if self.allEffect and self.allEffect[bUuid] then
    local effect = self.allEffect[bUuid]
    effect:OnDestroy()
    self.allEffect[bUuid] = nil
    ObjectPool:GetInstance():Save(effect)
  end
end

local function ShowEffect(self, bUuid, pointId)
  local param = {}
  param.buid = bUuid
  param.posIndex = pointId
  if self.allEffect[bUuid] == nil then
    self.allEffect[bUuid] = ObjectPool:GetInstance():Load(BuildHelpStopFireEffect)
    self.allEffect[bUuid]:OnCreate()
  end
  self.allEffect[bUuid]:ReInit(param)
end

local function ShowEffectByRebuild(self, Index, pointVector3)
  local param = {}
  param.buid = Index
  param.posIndex = pointVector3
  if self.allEffect[Index] == nil then
    self.allEffect[Index] = ObjectPool:GetInstance():Load(BuildHelpStopFireEffect)
    self.allEffect[Index]:OnCreate()
  end
  self.allEffect[Index]:ReInitRebuild(param)
end

local function HelpStopFireChatInteractive(self, seqId, senderUid, roomId, targetUid, thumbsUpType, name, func, tips_)
  local index = 1
  if senderUid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  local deltaTime = ChatManager2:GetInstance():GetGiveLikeMsgTime(seqId, index)
  local k1 = LuaEntry.DataConfig:TryGetNum("thumbs_up", "k1")
  local realLeftTime = deltaTime + k1
  if 0 < realLeftTime then
    local delta = UITimeManager:GetInstance():MilliSecondToFmtString(realLeftTime * 1000)
    UIUtil.ShowTips(Localization:GetString("121068", delta))
    return
  end
  InteractiveUtil.TryThumbsUp(targetUid, thumbsUpType, seqId, function()
    UIUtil.ShowTips(Localization:GetString(tips_ or "outfire_tips_like_1", name))
    ChatManager2:GetInstance():SetGiveLikeMsgTime(seqId, index)
    if func then
      func()
    end
  end, string.format("%s|%s", roomId, seqId))
end

BuildHelpStopFireManager.__init = __init
BuildHelpStopFireManager.__delete = __delete
BuildHelpStopFireManager.AddListener = AddListener
BuildHelpStopFireManager.RemoveListener = RemoveListener
BuildHelpStopFireManager.InitData = InitData
BuildHelpStopFireManager.HelpStopCityFireHandler = HelpStopCityFireHandler
BuildHelpStopFireManager.PushHelpStopCityFireTimesHandler = PushHelpStopCityFireTimesHandler
BuildHelpStopFireManager.PushHelpStopCityFireNotifyHandler = PushHelpStopCityFireNotifyHandler
BuildHelpStopFireManager.IsFree = IsFree
BuildHelpStopFireManager.IsOpen = IsOpen
BuildHelpStopFireManager.ClearAllEffect = ClearAllEffect
BuildHelpStopFireManager.OnBuildOutView = OnBuildOutView
BuildHelpStopFireManager.OnLodChange = OnLodChange
BuildHelpStopFireManager.RemoveOneEffect = RemoveOneEffect
BuildHelpStopFireManager.ShowEffect = ShowEffect
BuildHelpStopFireManager.HelpStopFireChatInteractive = HelpStopFireChatInteractive
BuildHelpStopFireManager.ShowEffectByRebuild = ShowEffectByRebuild
return BuildHelpStopFireManager
