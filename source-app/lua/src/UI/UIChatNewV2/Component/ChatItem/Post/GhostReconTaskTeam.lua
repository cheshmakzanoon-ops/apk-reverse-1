local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_GhostReconTaskTeam = BaseClass("ChatItemPost_GhostReconTaskTeam", IChatItemPost)
local ChatItemGhostReconTaskTeamSpecialCell = require("UI.UIChatNew.Component.ChatItem.ChatItemGhostReconTaskTeamSpecialCell")
local UIGhostreconPlayerItem = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconPlayerItem")
local Localization = CS.GameEntry.Localization
local base = IChatItemPost
local UIGray = CS.UIGray
local rapidjson = require("rapidjson")

function ChatItemPost_GhostReconTaskTeam:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "BG")
  self.bossName = self:AddComponent(UIText, "bossName")
  self.posText = self:AddComponent(UIText, "Build/PosTxt")
  self.posBtn = self:AddComponent(UIButton, "Build/PosTxt/PosBtn")
  self.titleText = self:AddComponent(UIText, "title")
  self.btnText = self:AddComponent(UIText, "BG/btnJoin/btnTxtJoin")
  self.timeText = self:AddComponent(UIText, "time")
  self.joinBtn = self:AddComponent(UIButton, "BG/btnJoin")
  self.joinBtn:SetOnClick(function()
    self:OnJoinClick()
  end)
  self.posBtn:SetOnClick(function()
    self:OnPosClick()
  end)
  self.buildBg = self:AddComponent(UIRawImage, "Build/BuildBg")
  self.qualityImg = self:AddComponent(UIImage, "Build/QualityImg")
  self.buildImg = self:AddComponent(UIRawImage, "Build/BuildBg/BuildImg")
  self.tipText = self:AddComponent(UIText, "BG/TipTxt")
  self.players = {}
  local tempCom
  for i = 1, 4 do
    tempCom = self:AddComponent(UIGhostreconPlayerItem, "PlayerHeadHolder/PlayerHead/Player" .. i)
    tempCom:SetJoinFunc(function()
      self:OnJoinClick()
    end)
    table.insert(self.players, tempCom)
  end
  self.specialItem1 = self:AddComponent(ChatItemGhostReconTaskTeamSpecialCell, "SpecialCell1")
  self.specialItem2 = self:AddComponent(ChatItemGhostReconTaskTeamSpecialCell, "SpecialCell2")
  self.expire = false
end

function ChatItemPost_GhostReconTaskTeam:OnJoinClick()
  if self.allianceTaskInfo then
    if self._chatData:isMyChat() then
      local data = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(self.allianceTaskInfo.uuid)
      if data == nil then
        UIUtil.ShowTipsId("ghostrecon_070")
        return
      end
    else
      local data = DataCenter.ActGhostreconAllianceManager:GetAllianceTaskInfoByUUid(self.allianceTaskInfo.uuid)
      if data == nil then
        UIUtil.ShowTipsId("ghostrecon_070")
        return
      end
    end
  end
  if not self:isInUids(LuaEntry.Player.uid) then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.Ghostrecon.Type)
    local actInfo = 0 < #actList and actList[1] or nil
    if actInfo == nil or actInfo.needMainCityLevel and actInfo.needMainCityLevel > DataCenter.BuildManager.MainLv then
      UIUtil.ShowTipsId("ghostrecon_078")
    elseif self.allianceTaskInfo and not self.expire then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconFormation, {anim = true}, self.allianceTaskInfo.uuid, true)
    else
      UIUtil.ShowTipsId("ghostrecon_070")
    end
  end
end

function ChatItemPost_GhostReconTaskTeam:OnPosClick()
  if self.allianceTaskInfo then
    if self._chatData:isMyChat() then
      local data = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(self.allianceTaskInfo.uuid)
      if data == nil or data.state == 0 then
        UIUtil.ShowTipsId("ghostrecon_070")
        return
      end
    else
      local data = DataCenter.ActGhostreconAllianceManager:GetAllianceTaskInfoByUUid(self.allianceTaskInfo.uuid)
      if data == nil then
        UIUtil.ShowTipsId("ghostrecon_070")
        return
      end
    end
  end
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.Ghostrecon.Type)
  local actInfo = 0 < #actList and actList[1] or nil
  if actInfo == nil or actInfo.needMainCityLevel and actInfo.needMainCityLevel > DataCenter.BuildManager.MainLv then
    UIUtil.ShowTipsId("ghostrecon_078")
  elseif self.allianceTaskInfo and not self.expire then
    DataCenter.ActGhostreconManager:JumpToPoint(self.allianceTaskInfo.pointId, self.allianceTaskInfo.uuid, self.allianceTaskInfo.targetServer)
  else
    UIUtil.ShowTipsId("ghostrecon_070")
  end
end

function ChatItemPost_GhostReconTaskTeam:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  self:AddUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnDelMsg)
  self:AddUIListener(ChatEventEnum.UPDATE_MSG_USERINFO, self.UpdateMember)
end

function ChatItemPost_GhostReconTaskTeam:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  self:RemoveUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnDelMsg)
  self:RemoveUIListener(ChatEventEnum.UPDATE_MSG_USERINFO, self.UpdateMember)
  base.OnRemoveListener(self)
end

function ChatItemPost_GhostReconTaskTeam:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.uids = {}
end

function ChatItemPost_GhostReconTaskTeam:OnUpdateMsg(chatData)
  if chatData then
    if self._chatData == nil or chatData.seqId ~= self._chatData.seqId or chatData.post ~= PostType.GHOST_RECON_TASK_TEAM then
      return
    end
    self:UpdateItem(chatData)
  end
end

function ChatItemPost_GhostReconTaskTeam:OnDelMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomid == self.roomId then
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(self.roomId)
    if roomData then
      local chatData = roomData:getChatDataBySeqId(self.seqId)
      if chatData and chatData.post == PostType.GHOST_RECON_TASK_TEAM then
        local clientUpdateExtra = self._chatData.clientUpdateExtra
        if clientUpdateExtra then
          if string.find(clientUpdateExtra, "notExpire") then
            clientUpdateExtra = string.gsub(clientUpdateExtra, "notExpire", "expire")
          end
        else
          clientUpdateExtra = "expire"
        end
        self._chatData.clientUpdateExtra = clientUpdateExtra
        self:UpdateItem(self._chatData)
      end
    end
  end
end

function ChatItemPost_GhostReconTaskTeam:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  if chatData.post ~= PostType.GHOST_RECON_TASK_TEAM then
    Logger.LogError("chatUpdateItem error ----------- > roomId : " .. self._chatData.roomId .. "seqId : " .. chatData.seqId)
    return
  end
  self:UpdateItem(chatData)
end

function ChatItemPost_GhostReconTaskTeam:UpdateItem(chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  if not self._chatData.extra.customJsonParam then
    Logger.LogError("UpdateItem error ----------- > roomId : " .. self._chatData.roomId .. "seqId : " .. chatData.seqId)
    return
  end
  if self._chatData:isMyChat() then
    self.bg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_right))
    self.specialItem1:SetBgColor(177, 193, 230, 255)
    self.specialItem2:SetBgColor(177, 193, 230, 255)
  else
    self.bg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_left))
    self.specialItem1:SetBgColor(244, 227, 220, 255)
    self.specialItem2:SetBgColor(244, 227, 220, 255)
  end
  self.uids = {}
  self.allianceTaskInfo = rapidjson.decode(self._chatData.extra.customJsonParam).taskInfo
  self:RefreshExtraData(chatData.clientUpdateExtra)
  self:RefreshView()
end

function ChatItemPost_GhostReconTaskTeam:RefreshExtraData(clientUpdateExtra)
  self.specialInfo = {}
  if not string.IsNullOrEmpty(clientUpdateExtra) then
    local strSplit = string.split(clientUpdateExtra, "|")
    if strSplit[1] == "expire" then
      self.expire = true
      table.remove(strSplit, 1)
    elseif strSplit[1] == "notExpire" then
      self.expire = false
      table.remove(strSplit, 1)
    else
      self.expire = false
    end
    if strSplit[1] then
      self.uids = string.split(strSplit[1], ",")
    end
    if strSplit[2] then
      local arry = string.split(strSplit[2], ",")
      local data = {}
      data.heroId = arry[1]
      data.num = arry[2]
      table.insert(self.specialInfo, data)
    end
    if strSplit[3] then
      local arry = string.split(strSplit[3], ",")
      local data = {}
      data.heroId = arry[1]
      data.num = arry[2]
      table.insert(self.specialInfo, data)
    end
  else
    self.expire = false
  end
end

function ChatItemPost_GhostReconTaskTeam:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ChatItemPost_GhostReconTaskTeam:isInUids(uid)
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

function ChatItemPost_GhostReconTaskTeam:RefreshPlayerList()
  self:RefreshState()
  local hideJoin = self:isInUids(LuaEntry.Player.uid) or self._chatData:isMyChat() or self.expire
  for i = 1, 4 do
    if not string.IsNullOrEmpty(self.uids[i]) then
      local senderInfo = ChatInterface.getUserMgr():getChatUserInfo(self.uids[i])
      if self.players[i] and not IsNull(self.players[i].gameObject) then
        self.players[i]:SetData(senderInfo)
      end
    else
      self.players[i]:SetData(nil)
      self.players[i]:SetJoinActive(not hideJoin)
    end
  end
end

function ChatItemPost_GhostReconTaskTeam:RefreshState()
  self.joinBtn:SetActive(true)
  if self._chatData:isMyChat() then
    self.joinBtn:SetActive(false)
    self.tipText:SetActive(false)
  elseif self.expire then
    UIGray.SetGray(self.joinBtn.transform, true, false)
    self.btnText:SetLocalText("ghostrecon_070")
    self.tipText:SetActive(false)
  elseif self:isInUids(LuaEntry.Player.uid) then
    self.joinBtn:SetActive(false)
    self.tipText:SetActive(true)
    self.tipText:SetLocalText("ghostrecon_068")
  elseif #self.uids >= 4 then
    UIGray.SetGray(self.joinBtn.transform, true, false)
    self.btnText:SetLocalText("ghostrecon_069")
    self.tipText:SetActive(false)
  else
    UIGray.SetGray(self.joinBtn.transform, false, true)
    self.joinBtn:SetActive(true)
    self.btnText:SetLocalText("ghostrecon_btn05")
    self.tipText:SetActive(false)
  end
end

function ChatItemPost_GhostReconTaskTeam:RefreshView()
  if self.allianceTaskInfo == nil then
    return
  end
  self.joinBtn:SetActive(not self._chatData:isMyChat())
  local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(self.allianceTaskInfo.cfgId)
  self.titleText:SetText(Localization:GetString(140205, cfg.level, Localization:GetString("ghostrecon_022")))
  local pos = SceneUtils.IndexToTilePos(self.allianceTaskInfo.pointId, ForceChangeScene.World)
  self.posText:SetText(string.format("#%s X:%s Y:%s", self.allianceTaskInfo.targetServer, pos.x, pos.y))
  self.posText:SetActive(true)
  local leaderMemberInfo
  for index, value in ipairs(self.allianceTaskInfo.memberList) do
    if value.uid == self.allianceTaskInfo.ownerId then
      leaderMemberInfo = value
      break
    end
  end
  if leaderMemberInfo and leaderMemberInfo.memberInfo and leaderMemberInfo.memberInfo.name then
    self.bossName:SetText(leaderMemberInfo.memberInfo.name)
  end
  self.buildBg:LoadSprite(UIAssets.GhostreconTexturePath .. cfg.imgSet.ChatBuildBg)
  self.qualityImg:LoadSprite(cfg.imgSet.QualityImg)
  self.qualityImg:SetNativeSize()
  self.buildImg:LoadSprite(UIAssets.GhostreconTexturePath .. cfg.imgSet.BuildImg)
  self.specialItem1:SetActive(false)
  self.specialItem2:SetActive(false)
  if cfg.superCondions and #cfg.superCondions > 0 then
    for i = 1, 2 do
      local condition = cfg.superCondions[i]
      if condition then
        local num = 0
        for _, specialInfo in ipairs(self.specialInfo) do
          if tonumber(specialInfo.heroId) == condition.heroId then
            num = specialInfo.num
            break
          end
        end
        local specialItem = self["specialItem" .. i]
        specialItem:SetActive(true)
        specialItem:SetData(num, condition)
      end
    end
    if self._chatData:isMyChat() then
      self.bg:SetSizeDelta(Vector2.New(self:GetSizeDelta().x, 265))
    else
      self.bg:SetSizeDelta(Vector2.New(self:GetSizeDelta().x, 335))
    end
  else
    self.specialItem1:SetActive(false)
    self.specialItem2:SetActive(false)
    self.bg:SetSizeDelta(Vector2.New(self:GetSizeDelta().x, 265))
  end
  self:RefreshPlayerList()
  self.frame:RefreshItemSize()
end

function ChatItemPost_GhostReconTaskTeam:ComponentDestroy()
  self.bossName = nil
  self.posText = nil
  self.titleText = nil
  self.timeText = nil
  self.btnText = nil
  self.joinBtn = nil
  self.players = nil
  for i = 1, 4 do
    self["player" .. i] = nil
  end
end

function ChatItemPost_GhostReconTaskTeam:DataDestroy()
  self._chatData = nil
  self.expire = nil
  self.seqId = nil
  self.roomId = nil
end

function ChatItemPost_GhostReconTaskTeam:OnRecycle()
end

function ChatItemPost_GhostReconTaskTeam:HandleClick()
  return true
end

function ChatItemPost_GhostReconTaskTeam:UpdateMember()
  if self.players and #self.players > 0 then
    for index, value in ipairs(self.players) do
      value:RefreshHead()
    end
  end
end

return ChatItemPost_GhostReconTaskTeam
