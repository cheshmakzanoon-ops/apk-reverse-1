local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_AllianceWar = BaseClass("AllianceWar", IChatItemPost)
local base = IChatItemPost
local UIGray = CS.UIGray
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization

function ChatItemPost_AllianceWar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_AllianceWar:ComponentDefine()
  self.bossName = self:AddComponent(UITextMeshProUGUIEx, "bossName")
  self.posText = self:AddComponent(UITextMeshProUGUIEx, "posText")
  self.initiatorText = self:AddComponent(UITextMeshProUGUIEx, "initiatorText")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.timeText = self:AddComponent(UITextMeshProUGUIEx, "time")
  self.btnText = self:AddComponent(UIText, "btnJump/btnTxtJump")
  self.bossIcon = self:AddComponent(UIImage, "bossIcon")
  self.joinBtn = self:AddComponent(UIButton, "btnJump")
  self.joinImg = self:AddComponent(UIImage, "joinImg")
  self.joinBtn:SetOnClick(function()
    self:OnJoinClick()
  end)
  self.posText:OnPointerClick(function(eventData)
    self:Goto()
  end)
  self.players = {}
  local tempCom
  for i = 1, 4 do
    tempCom = self:AddComponent(UIButton, "playerBG/players/player" .. i)
    tempCom:SetOnClick(function()
      self:OnJoinClick()
    end)
    self["player" .. i] = self:AddComponent(UICommonHead, "playerBG/players/player" .. i .. "/UIPlayerHead" .. i)
    table.insert(self.players, self["player" .. i])
  end
end

function ChatItemPost_AllianceWar:OnJoinClick()
  if not self.warData or not self.warData.leaderMarch then
    return
  end
  if DataCenter.AllianceWarDataManager:CheckJoinAllianceWar(self.data.targetUid) then
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
    if not SeasonUtil.CanJoinWar(self.warData.fixedSoldierType, true) then
      return
    end
    MarchUtil.OnClickStartMarch(MarchTargetType.JOIN_RALLY, self.warData.leaderMarch.startId, self.data.targetUid, -1, 1, MarchTargetType.RALLY_FOR_BOSS, self.warData.server, self.warData.worldId)
  else
    UIUtil.ShowTipsId(120226)
  end
end

function ChatItemPost_AllianceWar:OnUpdateMsg(chatData)
  if chatData then
    if chatData.seqId ~= self._chatData.seqId or chatData.post ~= PostType.Alliance_War then
      return
    end
    if self.isNew then
      local uidstr = string.split(chatData.clientUpdateExtra, "|")
      if uidstr[2] then
        self.uids = string.split(uidstr[2], ",")
      end
    elseif not string.IsNullOrEmpty(chatData.clientUpdateExtra) then
      self.uids = string.split(chatData.clientUpdateExtra, "|")
    end
    self:RefreshPlayerList()
  end
end

function ChatItemPost_AllianceWar:Goto()
  if not CrossServerUtil:IsInOtherServer() then
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
    local rightPos = SceneUtils.TileIndexToWorld(tonumber(self.data.targetPointId), ForceChangeScene.World)
    GoToUtil.GotoWorldPos(rightPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, self.data.server, self.data.worldId)
  end
end

function ChatItemPost_AllianceWar:isTimestamp(num)
  return type(num) == "number" and 0 < num and num < 2.147483648E9
end

function ChatItemPost_AllianceWar:IsOverdue()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return curTime > self.data.endTime
end

function ChatItemPost_AllianceWar:OnLoaded()
  self:Overdue()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  if chatData.post ~= PostType.Alliance_War then
    Logger.LogError("chatUpdateItem error ----------- > roomId : " .. self._chatData.roomId .. "seqId : " .. chatData.seqId)
    return
  end
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self.data = chatData:getMessageParam()
  self.isNew = false
  self.uids = {}
  self.warData = nil
  if not self.data or not self.data.monsterPic then
    if not self._chatData.extra.customJsonParam then
      Logger.LogError("UpdateItem error ----------- > roomId : " .. self._chatData.roomId .. "seqId : " .. chatData.seqId)
      return
    end
    self.isNew = true
    self.data = rapidjson.decode(self._chatData.extra.customJsonParam)
    if not self.data.targetUid then
      return
    end
    if not string.IsNullOrEmpty(chatData.clientUpdateExtra) then
      local uidstr = string.split(chatData.clientUpdateExtra, "|")
      if uidstr[2] then
        self.uids = string.split(uidstr[2], ",")
      end
    end
    self.data.monsterId = self.data.targetUid
    self.data.targetUid = tonumber(self.data.teamUuid)
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(self.data.monsterId)
    self.data.monsterPic = monster.pic
    self.data.monsterLevel = monster.level
    self.data.monsterName = monster.name
    self.warData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.data.targetUid)
    if self.warData then
    end
    self:RefreshView(self.isNew)
    return
  end
  self.uids = ChatInterface.GetIsNewChatItem(chatData)
  self.warData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.data.targetUid)
  self:RefreshView(self.isNew)
end

function ChatItemPost_AllianceWar:OnRecycle()
  self:StopTimer()
end

function ChatItemPost_AllianceWar:GetEndTime()
  if self.isNew then
    return self.data.endTime
  else
    return self.warData.marchTime
  end
end

function ChatItemPost_AllianceWar:RefreshTime()
  if not self.timeText or not self.warData then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self:GetEndTime() - curTime
  if time <= 0 then
    self.timeText:SetActive(false)
    self:StopTimer()
    self:RefreshState()
  else
    self.timeText:SetText(self.langTime .. UITimeManager:GetInstance():MilliSecondToFmtString(time))
  end
end

function ChatItemPost_AllianceWar:StartTimer()
  function self.TimerAction()
    self:RefreshTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemPost_AllianceWar:StopTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatItemPost_AllianceWar:isInUids(uid)
  if not self.uids then
    return false
  end
  for _, v in ipairs(self.uids) do
    if v == uid then
      return true
    end
  end
  return false
end

function ChatItemPost_AllianceWar:RefreshPlayerList()
  local dataList = {}
  local str = ""
  local isLoacal = false
  if not self.warData then
    if self.uids then
      dataList = self.uids
      isLoacal = true
    else
      return
    end
  elseif self.isNew then
    dataList = self.uids
  else
    for i, v in pairs(self.warData.memberList) do
      if not string.IsNullOrEmpty(v.ownerUid) then
        str = string.IsNullOrEmpty(str) and v.ownerUid or str .. "|" .. v.ownerUid
      end
      dataList[#dataList + 1] = v.ownerUid
    end
  end
  for i = 1, 4 do
    if not string.IsNullOrEmpty(dataList[i]) then
      local senderInfo = ChatInterface.getUserMgr():getChatUserInfo(dataList[i])
      if self.players[i] and not IsNull(self.players[i].gameObject) then
        self.players[i]:SetHeadAndFrame(senderInfo.uid, senderInfo.headPic, senderInfo.headPicVer, false, senderInfo.headSkinId, senderInfo.headSkinET)
        self.players[i]:SetActive(true)
      end
    elseif self.players[i] and not IsNull(self.players[i].gameObject) then
      self.players[i]:SetActive(false)
    end
  end
  if not self.isNew then
    local isPlayerUpdate = false
    if not isLoacal then
      if #self.uids > 0 and #self.warData.memberList == 0 then
        str = ""
        isPlayerUpdate = true
      end
      for i, v in pairs(self.warData.memberList) do
        if not self:isInUids(v.ownerUid) then
          isPlayerUpdate = true
        end
      end
      self.uids = string.split(str, "|")
    end
    if isPlayerUpdate then
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatUpdate, self._chatData.roomId, self._chatData.seqId, str)
    end
  end
  self:RefreshState()
end

function ChatItemPost_AllianceWar:GetIsinWar()
  if not self.warData then
    return self:isInUids(LuaEntry.Player.uid)
  end
  for i, v in pairs(self.warData.memberList) do
    if v.ownerUid == LuaEntry.Player.uid then
      return true
    end
  end
  if self.data.ownerUid == LuaEntry.Player.uid then
    return true
  end
end

function ChatItemPost_AllianceWar:RefreshState()
  if not IsNull(self.joinImg.gameObject) and not IsNull(self.joinBtn.gameObject) then
    self.joinImg:SetActive(false)
    self.joinBtn:SetActive(true)
  end
  if DataCenter.AllianceWarDataManager:CheckJoinAllianceWar(self.data.targetUid) then
    self.btnText:SetLocalText(110037)
    if self.joinBtn:GetActive() then
      UIGray.SetGray(self.joinBtn.transform, false, true)
    end
  elseif #self.uids >= 4 then
    self.btnText:SetLocalText(128013)
    if self.joinBtn:GetActive() then
      UIGray.SetGray(self.joinBtn.transform, true, false)
    end
  elseif self:GetIsinWar() then
    self.joinImg:SetActive(true)
    self.joinBtn:SetActive(false)
  end
  if not self.warData then
    self:Overdue()
  end
end

function ChatItemPost_AllianceWar:Overdue()
  self.joinImg:SetActive(false)
  self.joinBtn:SetActive(true)
  self.btnText:SetLocalText(390843)
  UIGray.SetGray(self.joinBtn.transform, true, false)
end

function ChatItemPost_AllianceWar:RefreshView()
  if not self.data.monsterPic then
    return
  end
  self.joinImg:SetActive(false)
  self.joinBtn:SetActive(true)
  self:RefreshPlayerList()
  self.titleText:SetLocalText("rally_share_title")
  if self.data.ownerUid then
    local senderInfo = ChatInterface.getUserMgr():getChatUserInfo(self.data.ownerUid)
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.ownerUid, senderInfo.userName)
    self.initiatorText:SetText(Localization:GetString("rally_share_owner") .. ": " .. showName)
  else
    self.initiatorText:SetText(Localization:GetString("rally_share_owner"))
  end
  self.langTime = Localization:GetString("match_assemble_status02")
  self.bossName:SetText(Localization:GetString("300665", self.data.monsterLevel) .. " " .. Localization:GetString(self.data.monsterName))
  self.bossIcon:LoadSpriteAsyncWithCallback(UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, self.data.monsterPic), function(texture)
    if self and self.bossIcon then
      self.bossIcon:SetNativeSize()
    end
  end)
  local enemyPos = SceneUtils.IndexToTilePos(tonumber(self.data.targetPointId), ForceChangeScene.World)
  local distance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)))
  self.posText:SetLocalText(455097, distance)
  self.timeText:SetActive(false)
  self:RefreshPlayerList()
  self:RefreshState()
  if not self.warData or not self.data.monsterPic then
    return
  end
  self.timeText:SetActive(true)
  self:RefreshTime()
  self:StartTimer()
end

function ChatItemPost_AllianceWar:ComponentDestroy()
  self:StopTimer()
  self.bossName = nil
  self.posText = nil
  self.initiatorText = nil
  self.titleText = nil
  self.timeText = nil
  self.completeImg = nil
  self.bossIcon = nil
  self.btnText = nil
  self.joinBtn = nil
  self.players = nil
  for i = 1, 4 do
    self["player" .. i] = nil
  end
end

function ChatItemPost_AllianceWar:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatItemPost_AllianceWar:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

return ChatItemPost_AllianceWar
