local HighFiveBubble = BaseClass("HighFiveBubble")
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local Localization = CS.GameEntry.Localization
local cheng_path = "bubble/cheng"
local num1_path = "bubble/Num1"
local num2_path = "bubble/Num2"
local anim_path = "bubble"
local NUMBER_PATH = {
  [0] = "Assets/Main/Sprites/UI/UIMultiKill/number_0.png",
  [1] = "Assets/Main/Sprites/UI/UIMultiKill/number_1.png",
  [2] = "Assets/Main/Sprites/UI/UIMultiKill/number_2.png",
  [3] = "Assets/Main/Sprites/UI/UIMultiKill/number_3.png",
  [4] = "Assets/Main/Sprites/UI/UIMultiKill/number_4.png",
  [5] = "Assets/Main/Sprites/UI/UIMultiKill/number_5.png",
  [6] = "Assets/Main/Sprites/UI/UIMultiKill/number_6.png",
  [7] = "Assets/Main/Sprites/UI/UIMultiKill/number_7.png",
  [8] = "Assets/Main/Sprites/UI/UIMultiKill/number_8.png",
  [9] = "Assets/Main/Sprites/UI/UIMultiKill/number_9.png"
}
local AnimConfig = {
  Show = "V_ui_WorldHighFiveBubble_in",
  Send = "V_ui_WorldHighFiveBubble_HighFives",
  ReSend = "V_ui_WorldHighFiveBubble_HighFivesAgain",
  Idle = "V_ui_WorldHighFiveBubble_idle",
  Disappear = "V_ui_WorldHighFiveBubble_out"
}

local function OnHighFiveReceive(self, data)
  self.param = DataCenter.AllianceMemberDataManager:GetHighFiveData(self.point) or self.param
  if self.param == nil then
    return
  end
  if tostring(self.param.uuid) ~= tostring(data.uuid) then
    return
  end
  if self.param.uid == LuaEntry.Player.uid then
    local player = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid, true)
    if player then
      local thumbsUpCount = player.joinAllianceThumbsUpCount - player.highFiveCount
      self:ShowPanel(thumbsUpCount)
      if 0 < thumbsUpCount then
        self:PlayAnimationReturnTime(AnimConfig.ReSend)
      else
        self:PlayAnimationReturnTime(AnimConfig.Send)
      end
    end
  end
end

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
  
  function self.bindFunc(data)
    OnHighFiveReceive(self, data)
  end
  
  function self.lodBinFunc(lod)
    self:OnLodChange(lod)
  end
  
  function self.userBindFunc(uid)
    self:OnGetUserInfoSuccess(uid)
  end
  
  EventManager:GetInstance():AddListener(EventId.CHAT_HIGH_FIVE_RECEIVE, self.bindFunc)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.lodBinFunc)
  EventManager:GetInstance():AddListener(EventId.GetNewUserInfoSucc, self.userBindFunc)
end

local function OnDestroy(self)
  EventManager:GetInstance():RemoveListener(EventId.CHAT_HIGH_FIVE_RECEIVE, self.bindFunc)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.lodBinFunc)
  EventManager:GetInstance():RemoveListener(EventId.GetNewUserInfoSucc, self.userBindFunc)
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  if self.animTimer then
    self.animTimer:Stop()
    self.animTimer = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.chengIcon = self.transform:Find(cheng_path)
  self.numIcon1 = self.transform:Find(num1_path):GetComponent((typeof(SpriteRenderer)))
  self.numIcon2 = self.transform:Find(num2_path):GetComponent((typeof(SpriteRenderer)))
  self.anim = self.transform:Find(anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.boxCollider = self.transform:Find(""):GetComponent(typeof(CS.UnityEngine.BoxCollider))
  self.trigger = self.transform:Find(""):GetComponent(typeof(CS.TouchObjectEventTrigger))
  self.trigger.previewType = CS.WorldPreviewType.HighThanMultiObjects
  
  function self.trigger.onPointerClick()
    self:OnClick()
  end
end

local function ComponentDestroy(self)
  self.chengIcon = nil
  self.numIcon1 = nil
  self.numIcon2 = nil
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
  self.boxCollider = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param, bUuid)
  self.param = param.data
  self.point = param.point
  self.bUuid = bUuid
  local hasClick = self.param.self
  if hasClick then
    self.anim:Play(AnimConfig.Idle, 0, 0)
  else
    self.anim:Play(AnimConfig.Show, 0, 0)
  end
  self:ShowPanel(0)
end

local function ShowPanel(self, thumbsUpCount)
  local state = true
  local isSelf = self.param.uid == LuaEntry.Player.uid
  if isSelf then
    local player = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid, true)
    thumbsUpCount = math.max(player.joinAllianceThumbsUpCount - player.highFiveCount, 0)
    if player and player.joinAllianceThumbsUpCount - player.highFiveCount <= 0 then
      state = false
    end
  end
  self.boxCollider.enabled = not isSelf
  if self.point then
    local positionId = self.point.positionId
    if positionId ~= nil and positionId ~= 0 and positionId ~= "" and not self.point.IsWerewolf then
      state = false
    end
  end
  thumbsUpCount = math.max(thumbsUpCount, 0)
  thumbsUpCount = math.min(thumbsUpCount, 99)
  self.anim.gameObject:SetActive(state)
  local num1, num2 = 0, 0
  if thumbsUpCount < 10 then
    num1 = thumbsUpCount
  else
    num1 = thumbsUpCount / 10
    num2 = thumbsUpCount % 10
  end
  self.numIcon1:LoadSprite(NUMBER_PATH[math.floor(num1)])
  self.numIcon1.gameObject:SetActive(0 < num1 and isSelf)
  self.numIcon2:LoadSprite(NUMBER_PATH[math.floor(num2)])
  self.numIcon2.gameObject:SetActive(0 < num2 and isSelf)
  self.chengIcon.gameObject:SetActive((0 < num1 or 0 < num2) and isSelf)
end

local function OnLodChange(self, lod)
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(lod < 3)
  end
end

local function OnClick(self)
  if not InteractiveUtil.CanThumbsUp(InteractiveUtil.ThumbsUpType.HighFive) then
    UIUtil.ShowTipsId("alliance_clap_hands_tips_4")
    return
  end
  self.param = DataCenter.AllianceMemberDataManager:GetHighFiveData(self.point) or self.param
  if self.param == nil then
    return
  end
  local uid = self.param.uid
  local seqId = self.param.seqId
  local roomId = self.param.roomId
  local uuid = self.param.uuid
  local hasClick = self.param.self
  if hasClick then
    UIUtil.ShowTips(Localization:GetString("alliance_clap_hands_tips_2"))
    return
  end
  if uid == LuaEntry.Player.uid then
    self:OnClickSelf()
    return
  end
  self.param.self = true
  self:ShowPanel(0)
  local thumbsUpCount = self.param.thumbsUpCount
  local state, time = false, 0
  state, time = self:PlayAnimationReturnTime(AnimConfig.Send)
  if self.animTimer then
    self.animTimer:Stop()
    self.animTimer = nil
  end
  self.animTimer = TimerManager:GetInstance():DelayInvoke(function()
    local list = DataCenter.AllianceMemberDataManager:GetNewJoinMembersInfo()
    local info = list[uid]
    if info then
      info.self = true
    end
    EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubbleRefresh, self.bUuid)
  end, time)
  InteractiveUtil.TryThumbsUp(uid, InteractiveUtil.ThumbsUpType.HighFive, uuid, function()
    ChatManager2:GetInstance():SendEmojiComments(seqId, EmojiCommentsType.HighFive, roomId, uid)
  end)
  local path = "Assets/Main/Prefabs/March/WorldHighFiveTip.prefab"
  local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid, true)
  UIUtil.ShowThumbsUpBroadcastPopUI(self.point.serverId, self.point.mainIndex, info or {}, Localization:GetString("alliance_clap_hands_tips_1"), nil, path, "")
end

function HighFiveBubble:PlayAnimationReturnTime(animName)
  local duration = 0
  if self.anim then
    local clips = self.anim.runtimeAnimatorController.animationClips
    for i = 0, clips.Length - 1 do
      if string.endswith(clips[i].name, animName) then
        duration = clips[i].length
        self.anim:Play(animName, 0, 0)
        return true, duration
      end
    end
  end
  return false, duration
end

function HighFiveBubble:OnClickSelf()
  DataCenter.PlayerInfoDataManager:RequestHighFiveInfo()
end

function HighFiveBubble:OnGetUserInfoSuccess(uid)
  self:ShowPanel(0)
end

HighFiveBubble.OnCreate = OnCreate
HighFiveBubble.OnDestroy = OnDestroy
HighFiveBubble.ComponentDefine = ComponentDefine
HighFiveBubble.ComponentDestroy = ComponentDestroy
HighFiveBubble.DataDefine = DataDefine
HighFiveBubble.DataDestroy = DataDestroy
HighFiveBubble.ReInit = ReInit
HighFiveBubble.ShowPanel = ShowPanel
HighFiveBubble.OnLodChange = OnLodChange
HighFiveBubble.OnClick = OnClick
return HighFiveBubble
