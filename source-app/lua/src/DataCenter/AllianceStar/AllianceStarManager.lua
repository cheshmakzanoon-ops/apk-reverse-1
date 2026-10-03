local AllianceStarManager = BaseClass("AllianceStarManager", CEventable)
local Scene = require("Scene.AllianceStarCeremony.AllianceStarCeremonyScene")
local CeremonyTemplate = require("DataCenter.AllianceStar.AllianceStarCeremonyTemplate")
local PlayScriptTemplate = require("DataCenter.AllianceStar.AllianceStarPlayScriptTemplate")
local AlStarTemplate = require("DataCenter.AllianceStar.AllianceStarTemplate")
local AllianceStarCeremonyInfo = require("DataCenter.AllianceStar.AllianceStarCeremonyInfo")
local AllianceStarAllyInfo = require("DataCenter.AllianceStar.AllianceStarAllyInfo")
local AllianceStarCeremonyThumbInfo = require("DataCenter.AllianceStar.AllianceStarCeremonyThumbInfo")
local Localization = CS.GameEntry.Localization

function AllianceStarManager:__init()
  self.ceremonyTemplateGroupDict = nil
  self.alStarTemplateDict = nil
  self.playScriptTemplateDict = nil
  self.planTimeStamp = nil
  self.rewards = nil
  self.ceremonyInfo = nil
  self.historyInfoList = nil
  self.interactionInfoDict = nil
  self.allyInfoDict = nil
  self.planTimeStamp = 0
  self.isCeremonyEnd = nil
  self.showMainBubbleTip = nil
  self.ceremonyFullData = nil
  self.emojiSetting = nil
  self.ceremonyThumbs = nil
  self.obsoleteReturn = true
  self.endTime = nil
  self.mvpCfgIndex = nil
  self.thumbsUpJumpIndex = nil
end

function AllianceStarManager:__delete()
  self:ClearData()
end

function AllianceStarManager:ClearData()
  self.ceremonyTemplateGroupDict = nil
  self.alStarTemplateDict = nil
  self.playScriptTemplateDict = nil
  self.planTimeStamp = nil
  self.ceremonyEdition = nil
  self.hasCeremony = nil
  self.hasHistory = nil
  self.rewards = nil
  self.ceremonyInfo = nil
  self.historyInfoList = nil
  self.interactionInfoDict = nil
  if self.ceremonyScene then
    self.ceremonyScene:Delete()
    self.ceremonyScene = nil
  end
  if self.allyInfoDict then
    for k, v in pairs(self.allyInfoDict) do
      v:Delete()
    end
    self.allyInfoDict = nil
  end
  self.planTimeStamp = nil
  self.giveLikeMsgTimeDict = nil
  self.isCeremonyEnd = nil
  self.thumbsUpInfoDict = nil
  self.bgmCfgId = nil
  self.canPopAllyIndexDict = nil
  self.showMainBubbleTip = nil
  self.mailId = nil
  self.ceremonyFullData = nil
  self.emojiSetting = nil
  self.ceremonyThumbs = nil
  self.rewardSetting = nil
  self.endTime = nil
  self.mvpCfgIndex = nil
  self.thumbsUpJumpIndex = nil
  self:StopEndTimer()
end

function AllianceStarManager:RequestActivityInfo()
  SFSNetwork.SendMessage(MsgDefines.AllianceStarGainActivityInfoNew)
end

function AllianceStarManager:InitData(t)
  self.showMainBubbleTip = t.allianceStarNotify
  self:SetEndTime(t.allianceStarEndTime)
end

function AllianceStarManager:GetCeremonyTemplateGroupDict()
  if self.ceremonyTemplateGroupDict == nil then
    self.ceremonyTemplateGroupDict = {}
    LocalController:instance():visitTable(TableName.ALLIANCE_STAR_CEREMONY, function(id, lineData)
      local template = CeremonyTemplate.New()
      template:ParseData(lineData)
      if self.ceremonyTemplateGroupDict[template.stateId] == nil then
        self.ceremonyTemplateGroupDict[template.stateId] = {}
      end
      table.insert(self.ceremonyTemplateGroupDict[template.stateId], template)
    end)
    for k, v in pairs(self.ceremonyTemplateGroupDict) do
      table.sort(v, function(a, b)
        return a.id < b.id
      end)
    end
  end
  return self.ceremonyTemplateGroupDict
end

function AllianceStarManager:GetTemplateByInnerId(templateGroup, innerId)
  local template
  for i, v in ipairs(templateGroup) do
    if v.innerStateId == innerId then
      template = v
      break
    end
  end
  return template
end

function AllianceStarManager:GetAlStarTemplateInfo(templateId)
  if self.alStarTemplateDict == nil then
    self.alStarTemplateDict = {}
  end
  local templateInfo = self.alStarTemplateDict[templateId]
  if templateInfo == nil then
    local cfg = LocalController:instance():getLine(TableName.ALLIANCE_STAR, templateId)
    templateInfo = AlStarTemplate.New()
    templateInfo:ParseData(cfg)
    self.alStarTemplateDict[templateId] = templateInfo
  end
  return templateInfo
end

function AllianceStarManager:GetAlStarPlayScriptTemplateInfo(templateId)
  if templateId == nil then
    return nil
  end
  if self.playScriptTemplateDict == nil then
    self.playScriptTemplateDict = {}
  end
  local templateInfo = self.playScriptTemplateDict[templateId]
  if templateInfo == nil then
    local cfg = LocalController:instance():getLine(TableName.ALLIANCE_STAR_PLAYSCRIPT, templateId)
    templateInfo = PlayScriptTemplate.New()
    templateInfo:ParseData(cfg)
    self.playScriptTemplateDict[templateId] = templateInfo
  end
  return templateInfo
end

function AllianceStarManager:GetOpenCDTime()
  local time = 180000
  local ceremonyTemplateGroupDict = self:GetCeremonyTemplateGroupDict()
  if ceremonyTemplateGroupDict and ceremonyTemplateGroupDict[1] and #ceremonyTemplateGroupDict[1] >= 2 then
    time = 0
    for i, v in ipairs(ceremonyTemplateGroupDict[1]) do
      time = time + v.duration
    end
  end
  return time
end

function AllianceStarManager:GetChangePlanCD()
  return LuaEntry.DataConfig:TryGetNum("alliance_weeklyStar_config", "k1", 180)
end

function AllianceStarManager:GetCanPopAllyIndexDict()
  if self.canPopAllyIndexDict == nil then
    local cfg = LuaEntry.DataConfig:TryGetStr("alliance_weeklyStar_config", "k6")
    if not string.IsNullOrEmpty(cfg) then
      self.canPopAllyIndexDict = {}
      for i, v in ipairs(string.split(cfg, ";")) do
        self.canPopAllyIndexDict[tonumber(v)] = true
      end
    end
  end
  return self.canPopAllyIndexDict
end

function AllianceStarManager:GetEmojiSetting()
  if self.emojiSetting == nil then
    self.emojiSetting = {}
    local k8 = LuaEntry.DataConfig:TryGetStr("alliance_weeklyStar_config", "k8", "147;169;131;112;106;138")
    local k9 = LuaEntry.DataConfig:TryGetStr("alliance_weeklyStar_config", "k9", "1;3")
    local k10 = LuaEntry.DataConfig:TryGetStr("alliance_weeklyStar_config", "k10", "1;6")
    self.emojiSetting.emojiList = {}
    for i, v in ipairs(string.split(k8, ";")) do
      table.insert(self.emojiSetting.emojiList, tonumber(v))
    end
    self.emojiSetting.sendInterval = {}
    for i, v in ipairs(string.split(k9, ";")) do
      table.insert(self.emojiSetting.sendInterval, tonumber(v))
    end
    self.emojiSetting.numInterval = {}
    for i, v in ipairs(string.split(k10, ";")) do
      table.insert(self.emojiSetting.numInterval, tonumber(v))
    end
  end
  return self.emojiSetting
end

function AllianceStarManager:GetEmojiCount()
  local emojiSetting = self:GetEmojiSetting()
  return #emojiSetting.emojiList
end

function AllianceStarManager:GetRewardSetting()
  if self.rewardSetting == nil then
    self.rewardSetting = {}
    local k11 = LuaEntry.DataConfig:TryGetStr("alliance_weeklyStar_config", "k11", "1;104120102;1|5;104120103;2|10;104120105;3")
    local split1 = string.split(k11, "|")
    for i, v in ipairs(split1) do
      local split2 = string.split(v, ";")
      local data = {}
      data[1] = tonumber(split2[1])
      data[2] = tonumber(split2[2])
      data[3] = tonumber(split2[3])
      table.insert(self.rewardSetting, data)
    end
  end
  return self.rewardSetting
end

function AllianceStarManager:OnPushAllianceStarRewardInfoMessage(msg)
  self.rewards = msg
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRewardInfoPush)
end

function AllianceStarManager:RefreshCeremonyInfo(msg)
  if self.ceremonyInfo == nil then
    self.ceremonyInfo = AllianceStarCeremonyInfo.New()
  end
  self.ceremonyInfo:ParseData(msg)
  if self.ceremonyScene and self.ceremonyScene.sceneObj then
    self.ceremonyScene:ChangeState(self.ceremonyInfo)
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyInfoPush)
end

function AllianceStarManager:CreateAllyDict(msg)
  if self.allyInfoDict then
    for k, v in pairs(self.allyInfoDict) do
      if self.ceremonyScene and self.ceremonyScene.sceneObj then
        self.ceremonyScene:RemoveAllyByInfo(v)
      end
      v:Delete()
      ObjectPool:GetInstance():Save(v)
    end
  end
  self.allyInfoDict = {}
  for k, v in pairs(msg.participants_info) do
    local allyInfo = ObjectPool:GetInstance():Load(AllianceStarAllyInfo)
    allyInfo:ParseData(v)
    self.allyInfoDict[k] = allyInfo
  end
  if self.ceremonyScene and self.ceremonyScene.sceneObj then
    for k, v in pairs(self.allyInfoDict) do
      self.ceremonyScene:AddAlly(v)
    end
  end
end

function AllianceStarManager:OnAllianceStartHistoryPreviewInfo(msg)
  self.historyInfoList = msg.data
  EventManager:GetInstance():Broadcast(EventId.AllianceStarHistoryPreviewInfoGet)
end

function AllianceStarManager:OnAllianceStarHistoryInfo(msg)
  if self.historyInfoList then
    for i, v in ipairs(self.historyInfoList) do
      if v.ceremonyEdition == msg.ceremonyEdition then
        for j = 1, #msg.ceremonyEditionInfo do
          local item = msg.ceremonyEditionInfo[j]
          if self:GetIsMvpByConfigId(item.configId) then
            table.remove(msg.ceremonyEditionInfo, j)
            table.insert(msg.ceremonyEditionInfo, 1, item)
            local roleItem = msg.roleInfo[j]
            table.remove(msg.roleInfo, j)
            table.insert(msg.roleInfo, 1, roleItem)
            break
          end
        end
        self.historyInfoList[i].detailData = msg
        EventManager:GetInstance():Broadcast(EventId.AllianceStarHistoryInfoGet, msg.ceremonyEdition)
      end
    end
  end
end

function AllianceStarManager:OnPushAllianceStarCeremonyRewardNotify(msg)
  self.showMainBubbleTip = false
  if msg then
    self.showMainBubbleTip = msg.needDisplay
    self:SetEndTime(msg.endTime)
  end
end

function AllianceStarManager:OnAllianceStarGainCeremonyInfoNew(msg)
  for i = 1, #msg.ceremonyInfo do
    local item = msg.ceremonyInfo[i]
    if self:GetIsMvpByConfigId(item.configId) then
      table.remove(msg.ceremonyInfo, i)
      table.insert(msg.ceremonyInfo, item)
      self.thumbsUpJumpIndex = #msg.ceremonyInfo
      break
    end
  end
  self.ceremonyEdition = msg.ceremonyEdition
  self.ceremonyFullData = msg
  self:CreateCeremonyThumbs(msg)
end

function AllianceStarManager:GetCeremonyFullData()
  return self.ceremonyFullData
end

function AllianceStarManager:OnAllianceStarGainActivityInfoNew(msg)
  self.ceremonyEdition = msg.ceremonyEdition
  self.hasCeremony = msg.hasCeremony
  self.hasHistory = msg.hasHistory
  EventManager:GetInstance():Broadcast(EventId.AllianceStarGainActivityInfoNewRefresh)
end

function AllianceStarManager:OnPushAllianceStarThumbsUpInfoChangeNew(msg)
  self:ChangeCeremonyThumbInfo(msg)
end

function AllianceStarManager:OnAllianceStarCeremonyQuestRewardNew(msg)
  local rewards = msg.rewardInfo
  if rewards then
    DataCenter.RewardManager:AddRewards(rewards)
    local tipText
    if self.ceremonyFullData then
      tipText = Localization:GetString("alliance_weeklyStar_reward_ex", #self.ceremonyFullData.ceremonyInfo)
    end
    DataCenter.RewardManager:ShowCommonReward({reward = rewards}, nil, nil, nil, nil, nil, nil, tipText)
  end
  if self.ceremonyFullData then
    self.ceremonyFullData.participateReceive = msg.participateReceive
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyQuestReward)
end

function AllianceStarManager:OnAllianceStarCeremonyQuestEmojiRewardNew(msg)
  local rewards = msg.rewardInfo
  if rewards then
    DataCenter.RewardManager:AddRewards(rewards)
    DataCenter.RewardManager:ShowCommonReward({reward = rewards})
  end
  if self.ceremonyFullData then
    self.ceremonyFullData.emojiThumbsRewardInfo = msg.emojiThumbsRewardInfo
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyQuestEmojiReward)
end

function AllianceStarManager:OnAllianceStarThumbsUpNew(msg)
  if self.ceremonyFullData then
    self.ceremonyFullData.emojiThumbsRewardInfo = msg.emojiThumbsRewardInfo
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyQuestEmojiReward)
end

function AllianceStarManager:EnterCeremonyScene(callback)
  if self.ceremonyScene then
    self.ceremonyScene:Delete()
    self.ceremonyScene = nil
  end
  self.ceremonyScene = Scene.New()
  self.ceremonyScene:Enter(self, callback)
end

function AllianceStarManager:ExitCeremonyScene()
  self:StopAllSounds()
  if self.ceremonyScene then
    self.ceremonyScene:Exit()
    self.ceremonyScene = nil
  end
end

function AllianceStarManager:IsInState(state, innerState)
  if self.ceremonyScene then
    return self.ceremonyScene:IsInState(state, innerState)
  end
  return false
end

function AllianceStarManager:SetApplaudRandomAnimByLevel(index)
  if self.ceremonyScene and self.ceremonyScene:IsInState(AlStarCeremonyState.Applaud, AlStarCeremonyInnerState[AlStarCeremonyState.Applaud].State1) then
    local sceneState = self.ceremonyScene.fsm.currState
    local innerState = sceneState.fsm.currState
    innerState:PlayAllyRandomAnimByLevel(index)
  end
end

function AllianceStarManager:ChangeProgressCtrlStage(isNext)
  if self.ceremonyScene then
    self.ceremonyScene:ChangeProgressCtrlStage(isNext)
  end
end

function AllianceStarManager:ChangeProgressCtrlStageById(stageId)
  if self.ceremonyScene then
    self.ceremonyScene:ChangeProgressCtrlStageById(stageId)
  end
end

function AllianceStarManager:GetProgressCtrlStageId()
  if self.ceremonyScene then
    return self.ceremonyScene:GetProgressCtrlStageId()
  end
  return -1
end

function AllianceStarManager:ChangeCurStageInnerStage(innerStageId)
  if self.ceremonyScene then
    self.ceremonyScene:ChangeCurStageInnerStage(innerStageId)
  end
end

function AllianceStarManager:SetGiveLikeMsgTime(seqId)
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if self.giveLikeMsgTimeDict == nil then
    self.giveLikeMsgTimeDict = {}
  end
  self.giveLikeMsgTimeDict[seqId] = now
end

function AllianceStarManager:GetGiveLikeMsgTime(seqId)
  local time = 0
  if self.giveLikeMsgTimeDict and self.giveLikeMsgTimeDict[seqId] then
    time = self.giveLikeMsgTimeDict[seqId]
  end
  return time
end

function AllianceStarManager:SetMailThumbsUpData(msg)
  if self.thumbsUpInfoDict == nil then
    self.thumbsUpInfoDict = {}
  end
  self.thumbsUpInfoDict[msg.edition] = msg.thumbsUpInfo
  EventManager:GetInstance():Broadcast(EventId.AllianceStarGainThumbsUpAllRefresh, msg)
end

function AllianceStarManager:GetMailThumbsUpDataItem(edition, mailUid)
  local item
  if self.thumbsUpInfoDict and self.thumbsUpInfoDict[edition] then
    for k, v in pairs(self.thumbsUpInfoDict[edition]) do
      if v.mailUid == mailUid then
        item = v
        break
      end
    end
  end
  return item
end

function AllianceStarManager:RefreshMailThumbsUpDataItem(msg)
  if self.thumbsUpInfoDict and self.thumbsUpInfoDict[msg.edition] then
    for k, v in pairs(self.thumbsUpInfoDict[msg.edition]) do
      if v.mailUid == msg.mailUid then
        v.mailCount = msg.mailCount
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceStarGainThumbsUpOneRefresh, msg)
end

function AllianceStarManager:GetEmojiThumbsRewardInfo()
  if self.ceremonyFullData and self.ceremonyFullData.emojiThumbsRewardInfo then
    return self.ceremonyFullData.emojiThumbsRewardInfo
  end
  return nil
end

function AllianceStarManager:GetCanClaimNormalRewardList()
  local rewardInfo
  if self.rewards and self.rewards.unReceivedRewardInfo then
    rewardInfo = self.rewards.unReceivedRewardInfo
  end
  return rewardInfo
end

function AllianceStarManager:GetHistoryTotalRewardData()
  local rewardInfo
  if self.rewards and self.rewards.receivedRewardInfo then
    rewardInfo = self.rewards.receivedRewardInfo
  end
  return rewardInfo
end

function AllianceStarManager:RequestClaimStoredReward()
  SFSNetwork.SendMessage(MsgDefines.AllianceStarCeremonyQuestReward)
end

function AllianceStarManager:PlayBgm(id)
  if self.bgmCfgId ~= id then
    self.bgmCfgId = id
    self.bgmId = DataCenter.LWSoundManager:PlaySound(id, true)
  end
end

function AllianceStarManager:StopBgm()
  if self.bgmId then
    DataCenter.LWSoundManager:StopSound(self.bgmId, true)
    self.bgmId = nil
  end
  self.bgmCfgId = nil
end

function AllianceStarManager:StopAllSounds()
  self:StopBgm()
  self:StopLoopEffect()
  DataCenter.LWSoundManager:StopAllSounds()
  CommonUtil.PlayGameBgMusic()
end

function AllianceStarManager:PlaySfx(id)
  DataCenter.LWSoundManager:PlaySound(id, false)
end

function AllianceStarManager:PlayLoopEffect(id)
  self.loopEffectId = DataCenter.LWSoundManager:PlaySound(id, true)
end

function AllianceStarManager:StopLoopEffect()
  if self.loopEffectId then
    DataCenter.LWSoundManager:StopSound(self.loopEffectId)
    self.loopEffectId = nil
  end
end

function AllianceStarManager:CreateCeremonyThumbs(msg)
  self.ceremonyThumbs = {}
  for i, v in ipairs(msg.ceremonyInfo) do
    local thumbUidInfos = {}
    for _, ceremonyInfo in ipairs(v.ceremonyInfoList) do
      local starThumbInfo = AllianceStarCeremonyThumbInfo.New()
      starThumbInfo:ParseData(v.configId, ceremonyInfo.uid, ceremonyInfo.thumbsInfo, ceremonyInfo.selfThumbs, ceremonyInfo.isStar)
      thumbUidInfos[ceremonyInfo.uid] = starThumbInfo
    end
    self.ceremonyThumbs[v.configId] = thumbUidInfos
  end
end

function AllianceStarManager:GetCeremonyThumbs()
  return self.ceremonyThumbs
end

function AllianceStarManager:ChangeCeremonyThumbInfo(msg)
  if self.ceremonyThumbs then
    local thumbUidInfos = self.ceremonyThumbs[msg.configId]
    local thumbsChangeInfo = msg.thumbsChangeInfo
    if thumbUidInfos then
      local thumbInfo = thumbUidInfos[thumbsChangeInfo.uid]
      if thumbInfo then
        thumbInfo:ParseChangeData(thumbsChangeInfo.thumbsInfo, thumbsChangeInfo.selfThumbs)
        EventManager:GetInstance():Broadcast(EventId.AllianceStarRefreshThumb, thumbInfo)
      end
    end
  end
end

function AllianceStarManager:GetThumbInfo(ceremonyId, uid)
  if self.ceremonyThumbs and self.ceremonyThumbs[ceremonyId] and self.ceremonyThumbs[ceremonyId][uid] then
    return self.ceremonyThumbs[ceremonyId][uid]
  end
  return nil
end

function AllianceStarManager:GetCeremonyStarThumbInfo(ceremonyId)
  if self.ceremonyThumbs and self.ceremonyThumbs[ceremonyId] then
    for k, v in pairs(self.ceremonyThumbs[ceremonyId]) do
      if v.isStar then
        return v
      end
    end
  end
  return nil
end

function AllianceStarManager:GetCeremonyStarOwnInNominate(ceremonyId)
  if self.ceremonyThumbs and self.ceremonyThumbs[ceremonyId] then
    for k, v in pairs(self.ceremonyThumbs[ceremonyId]) do
      if v.uid == LuaEntry.Player.uid then
        return true
      end
    end
  end
  return false
end

function AllianceStarManager:IsShowAlStarTipBar()
  local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("alliance_star")
  if isSwitchOn and self.hasCeremony and self.endTime and UITimeManager:GetInstance():GetServerTime() < self.endTime then
    return true
  end
  return false
end

function AllianceStarManager:GetCeremonyEdition()
  return self.ceremonyEdition or 1
end

function AllianceStarManager:ShowAlStarLogItem()
  local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("alliance_star")
  return isSwitchOn and self.hasHistory
end

function AllianceStarManager:GetUIScreenSizeXY()
  local scale = 1
  return 810 * scale, 1800 * scale
end

function AllianceStarManager:OnLeaveAlliance()
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIAllianceStarMain) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceStarMain)
  end
  self:ClearData()
end

function AllianceStarManager:ShowReward()
  local showReward = true
  return showReward
end

function AllianceStarManager:IsShowMainBubbleTip()
  local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("alliance_star")
  if isSwitchOn and self.showMainBubbleTip and self.endTime and UITimeManager:GetInstance():GetServerTime() < self.endTime then
    return true
  end
  return false
end

function AllianceStarManager:GetMailId()
  return self.mailId
end

function AllianceStarManager:GetShowEmojiFinger()
  local show = true
  if self.ceremonyEdition then
    show = CommonUtil.PlayerPrefsGetInt(SettingKeys.AL_STAR_EMOJI_GUIDE_EDITION, 0) < self.ceremonyEdition
  end
  return show
end

function AllianceStarManager:SaveShowEmojiFinger()
  if self.ceremonyEdition then
    CommonUtil.PlayerPrefsSetInt(SettingKeys.AL_STAR_EMOJI_GUIDE_EDITION, self.ceremonyEdition)
  end
end

function AllianceStarManager:SetEndTime(endTime)
  if self.endTime ~= endTime then
    self.endTime = endTime
    if self.endTime == nil or UITimeManager:GetInstance():GetServerTime() >= self.endTime then
      self:StopEndTimer()
    else
      local secs = math.ceil((self.endTime - UITimeManager:GetInstance():GetServerTime()) / 1000)
      self:StarEndTimer(secs)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceStarRefreshMainBubbleTip)
  EventManager:GetInstance():Broadcast(EventId.AllianceStarGainActivityInfoNewRefresh)
end

function AllianceStarManager:StopEndTimer()
  if self.endTimer then
    self.endTimer:Stop()
    self.endTimer = nil
  end
end

function AllianceStarManager:StarEndTimer(delayS)
  self:StopEndTimer()
  self.endTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
    EventManager:GetInstance():Broadcast(EventId.AllianceStarRefreshMainBubbleTip)
    EventManager:GetInstance():Broadcast(EventId.AllianceStarGainActivityInfoNewRefresh)
  end, delayS)
end

function AllianceStarManager:GetIsMvpByConfigId(configId)
  if self.mvpCfgIndex == nil then
    self.mvpCfgIndex = LuaEntry.DataConfig:TryGetNum("alliance_weeklyStar_config", "k12")
  end
  local cfg = self:GetAlStarTemplateInfo(configId)
  if cfg and self.mvpCfgIndex == cfg.indexId then
    return true
  end
  return false
end

function AllianceStarManager:LogInfo(str)
  if CommonUtil.IsDebug() then
    Logger.LogInfo(str)
  end
end

function AllianceStarManager:LogError(str)
  if CommonUtil.IsDebug() then
    Logger.LogError(str)
  end
end

function AllianceStarManager:UploadServerLog(str)
  Logger.LogInfo(str)
end

function AllianceStarManager:TestAddInteractionNumber(uid, type, num)
  local msg = {}
  msg.type = type
  msg.uid = uid
  msg.interactionNumber = num
  self:OnPushAllianceStarCeremonyInteractionInfo(msg)
end

function AllianceStarManager:PrintSceneState()
  if self.ceremonyScene then
    local sceneState = self.ceremonyScene.fsm.currState
    if sceneState then
      local innerState = sceneState.fsm.currState
      self:LogInfo(string.format("State:%s InnerState:%s ElapsedTime:%s", sceneState.stateId, innerState.stateId, innerState.elapsedTime))
    else
      self:LogInfo("\230\156\170\232\174\190\231\189\174\229\144\140\231\155\159\228\185\139\230\152\159\229\156\186\230\153\175\231\138\182\230\128\129")
    end
  else
    self:LogInfo("\230\156\170\232\191\155\229\133\165\229\144\140\231\155\159\228\185\139\230\152\159\229\156\186\230\153\175")
  end
end

function AllianceStarManager:DebugGetAllianceStartHistoryPreviewInfo()
  local t = {}
  local now = UITimeManager:GetInstance():GetServerTime()
  t.data = {}
  for i = 1, 10 do
    local data = {}
    data.ceremonyEdition = i
    data.startTimeStamp = now - (10 - i) * 86400 * 1000
    t.data[i] = data
  end
  t.curCeremonyEdition = 10
  self:OnAllianceStartHistoryPreviewInfo(t)
end

function AllianceStarManager:DebugGetAllianceStarHistoryInfo()
  local t = {}
  t.ceremonyEdition = 10
  t.ceremonyEditionInfoMap = {}
  for i = 1, 10 do
    t.ceremonyEditionInfoMap[i] = {}
    t.ceremonyEditionInfoMap[i].configId = 10000
    t.ceremonyEditionInfoMap[i].ceremonyInfoList = {}
    t.ceremonyEditionInfoMap[i].ceremonyInfoList[1] = {}
    t.ceremonyEditionInfoMap[i].ceremonyInfoList[1].uid = "1"
    t.ceremonyEditionInfoMap[i].ceremonyInfoList[1].score = 100
    t.ceremonyEditionInfoMap[i].ceremonyInfoList[1].extendInfo = "8"
  end
  t.roleInfoMap = {}
  t.roleInfoMap["1"] = {}
  self:OnAllianceStarHistoryInfo(t)
end

function AllianceStarManager:DebugGetAllianceStarGainCeremonyInfoNew()
  local msg = {}
  msg.ceremonyEdition = 1
  msg.ceremonyInfo = {}
  for i = 1, 7 do
    local info = {}
    info.configId = 10000
    info.ceremonyInfoList = {}
    local innerInfo = {}
    innerInfo.uid = LuaEntry.Player.uid
    innerInfo.score = 151
    innerInfo.isStar = true
    table.insert(info.ceremonyInfoList, innerInfo)
    table.insert(msg.ceremonyInfo, info)
  end
  msg.roleInfoMap = {}
  msg.roleInfoMap[LuaEntry.Player.uid] = LuaEntry.Player
  DataCenter.AllianceStarManager:OnAllianceStarGainCeremonyInfoNew(msg)
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIAllianceStarMain) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceStarMain, {anim = true})
  end
end

function AllianceStarManager:OnPushAllianceStarCeremonyPlanInfoMessage(msg)
  self:LogObsolete()
  if self.obsoleteReturn then
    return
  end
  self.isCeremonyEnd = msg.isCeremonyEnd
  self.planTimeStamp = msg.planTimeStamp or 0
  self.planChangedTimeStamp = msg.changedTimeStamp or 0
  self.ceremonyEdition = msg.ceremonyEdition or 0
  self.hasCeremony = msg.hasCeremony
  EventManager:GetInstance():Broadcast(EventId.AlStarChangePlanTimeStamp)
end

function AllianceStarManager:OnPushAllianceStarCeremonyInfoMessage(msg)
  self:LogObsolete()
  if self.obsoleteReturn then
    return
  end
  self:RefreshCeremonyInfo(msg)
end

function AllianceStarManager:OnPushAllianceStarCeremonyInteractionInfo(msg)
  self:LogObsolete()
  if self.obsoleteReturn then
    return
  end
  if self.interactionInfoDict == nil then
    self.interactionInfoDict = {}
  end
  if self.ceremonyScene and self.ceremonyInfo then
    local oldLevel
    local template = self.ceremonyInfo:GetTemplateInfo()
    if template then
      if self.interactionInfoDict[msg.type] then
        oldLevel = template:GetLevelByInteractionNum(self.interactionInfoDict[msg.type].interactionNumber)
      end
      local newLevel = template:GetLevelByInteractionNum(msg.interactionNumber)
      if oldLevel ~= newLevel and self.ceremonyScene then
        if newLevel == #template.rewardInfoList + 1 then
          self:SetApplaudRandomAnimByLevel(2)
        else
          self:SetApplaudRandomAnimByLevel(1)
        end
      end
    end
  end
  self.interactionInfoDict[msg.type] = msg
  if self.ceremonyScene and self.ceremonyScene.sceneObj and msg.interactionNumber > 0 then
    self.ceremonyScene:PlayInteractionAnim(msg)
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyInteractionInfoPush, msg)
end

function AllianceStarManager:OnPushAllianceStarCeremonyParticipantsInfos(msg)
  self:LogObsolete()
  if self.obsoleteReturn then
    return
  end
  self:CreateAllyDict(msg)
end

function AllianceStarManager:OnPushAllianceStartCeremonyParticipantsInfoChange(msg)
  self:LogObsolete()
  if self.obsoleteReturn then
    return
  end
  if self.allyInfoDict == nil then
    self.allyInfoDict = {}
  end
  if msg.operateType == 0 then
    local freeCount = 0
    for k, v in pairs(msg.participants_info) do
      local allyInfo = self.allyInfoDict[k]
      if allyInfo then
        if self.ceremonyScene and self.ceremonyScene.sceneObj then
          self.ceremonyScene:RemoveAllyByInfo(allyInfo)
        end
        allyInfo:Delete()
        ObjectPool:GetInstance():Save(allyInfo)
        self.allyInfoDict[k] = nil
        freeCount = freeCount + 1
      end
    end
    if self.ceremonyScene and self.ceremonyScene.sceneObj and 0 < freeCount then
      for k, v in pairs(self.allyInfoDict) do
        if v:GetAlly() == nil then
          self.ceremonyScene:AddAlly(v)
          freeCount = freeCount - 1
          if freeCount <= 0 then
            break
          end
        end
      end
    end
  else
    for k, v in pairs(msg.participants_info) do
      local allyInfo = self.allyInfoDict[k]
      if allyInfo == nil then
        allyInfo = ObjectPool:GetInstance():Load(AllianceStarAllyInfo)
        self.allyInfoDict[k] = allyInfo
      end
      allyInfo:ParseData(v)
      if self.ceremonyScene and self.ceremonyScene.sceneObj then
        local ally = allyInfo:GetAlly()
        if ally then
          ally:RefreshAllyInfo(allyInfo)
        else
          self.ceremonyScene:AddAlly(self.allyInfoDict[k])
        end
      end
    end
  end
end

function AllianceStarManager:OnPushAllianceStartCeremonyMailId(msg)
  self:LogObsolete()
  if self.obsoleteReturn then
    return
  end
  self.mailId = msg.mailId
end

function AllianceStarManager:IsCeremonyEnd()
  self:LogObsolete()
  if self.obsoleteReturn then
    return
  end
  return self.isCeremonyEnd
end

function AllianceStarManager:GetCeremonyInteractionInfo(type)
  self:LogObsolete()
  if self.obsoleteReturn then
    return
  end
  local data
  if self.interactionInfoDict and self.interactionInfoDict[type] then
    data = self.interactionInfoDict[type]
  end
  return data
end

function AllianceStarManager:ClearInteractionInfo()
  self:LogObsolete()
  if self.obsoleteReturn then
    return
  end
  if self.interactionInfoDict then
    for k, v in pairs(self.interactionInfoDict) do
      v.interactionNumber = 0
    end
  end
end

function AllianceStarManager:LogObsolete()
  self:LogError("AllianceStar Obsolete")
end

return AllianceStarManager
