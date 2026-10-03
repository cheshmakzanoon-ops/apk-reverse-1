local base = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local ChatSeasonLittleGameInviteMsg = BaseClass("ChatSeasonLittleGameInviteMsg", base)
local txt_des_path = "Content/txt_des"
local btn_path = "Content/Btn"
local cost_path = "Content/cost"
local icon_path = "Content/cost/icon"
local txt_tip_path = "Content/cost/txt_tip"
local txt_count_path = "Content/cost/txt_count"
local post_async_loading_path = "PostAsyncLoading"
local content_path = "Content"
local TYPE_CONFIG = {
  [EnumActivity.GGGo.Type] = {
    joinTips = "s6_miniGame_join_desc",
    bgPath = "Assets/Main/MiniGameRes/GGGo/Textures/ChatShared/zxl_100ceng_liaotian.png"
  }
}

function ChatSeasonLittleGameInviteMsg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatSeasonLittleGameInviteMsg:OnDestroy()
  self:ComponentDestroy()
  if self.tween ~= nil then
    self.tween:Kill()
    self.tween = nil
  end
  self.seqId = nil
  self.roomId = nil
  base.OnDestroy(self)
end

function ChatSeasonLittleGameInviteMsg:ComponentDefine()
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.cost = self:AddComponent(UIBaseContainer, cost_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.txt_tip = self:AddComponent(UITextMeshProUGUIEx, txt_tip_path)
  self.txt_count = self:AddComponent(UITextMeshProUGUIEx, txt_count_path)
  self.post_async_loading = self:AddComponent(UIImage, post_async_loading_path)
  self.content = self:AddComponent(UIRawImage, content_path)
  self.btn:SetOnClick(function()
    self:Interactive()
  end)
end

function ChatSeasonLittleGameInviteMsg:ComponentDestroy()
  self.txt_des = nil
  self.btn = nil
  self.cost = nil
  self.icon = nil
  self.txt_tip = nil
  self.txt_count = nil
  self.post_async_loading = nil
  self.content = nil
end

function ChatSeasonLittleGameInviteMsg:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  self:AddUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnDeleteMsg)
end

function ChatSeasonLittleGameInviteMsg:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  self:RemoveUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnDeleteMsg)
  base.OnRemoveListener(self)
end

function ChatSeasonLittleGameInviteMsg:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self:Refresh(chatData)
end

function ChatSeasonLittleGameInviteMsg:OnRecycle()
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
end

function ChatSeasonLittleGameInviteMsg:RefreshUI()
  if self._chatData and self._chatData.extra ~= nil and self._chatData.extra.attachmentId ~= nil then
    local hasClientUpdateExtra = not string.IsNullOrEmpty(self._chatData.clientUpdateExtra) and self._chatData.clientUpdateExtra ~= "0"
    local dataJson = hasClientUpdateExtra and self._chatData.clientUpdateExtra or self._chatData.extra.attachmentId
    local jsonObj = rapidjson.decode(dataJson)
    self.activityType = jsonObj.activityType or EnumActivity.GGGo.Type
    if jsonObj then
      local speak = jsonObj.speak
      if speak ~= nil then
        self.txt_des:SetText(speak)
      end
      local count = jsonObj.betnum
      self.cost:SetActive(count ~= nil and 0 < count)
      if count ~= nil then
        self.txt_count:SetLocalText(391038, tostring(count))
      end
      local costId = jsonObj.betid
      if costId ~= nil then
        self.icon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(toInt(costId)))
      end
      self.isgrey = jsonObj.isgrey
      if self._chatData.customDelState then
        CS.UIGray.SetGray(self.content.transform, true, true)
      elseif self.isgrey ~= nil then
        CS.UIGray.SetGray(self.content.transform, self.isgrey == 1, true)
      else
        CS.UIGray.SetGray(self.content.transform, false, true)
      end
      local config = TYPE_CONFIG[self.activityType]
      self.content:LoadSpriteAsync(config.bgPath)
    end
  end
end

function ChatSeasonLittleGameInviteMsg:OnDeleteMsg(chatData)
  if chatData and self._chatData ~= nil and chatData.seqId == self.seqId and chatData.roomid == self.roomId then
    CS.UIGray.SetGray(self.content.transform, true, true)
    self._chatData.customDelState = true
  end
end

function ChatSeasonLittleGameInviteMsg:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    self._chatData = chatData
    self:Refresh(chatData)
  end
end

function ChatSeasonLittleGameInviteMsg:Interactive()
  if not DataCenter.LWGGGoDataManager:GetResourceLoaded() then
    return
  end
  if self.isgrey ~= nil and self.isgrey == 1 or self._chatData.customDelState then
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc10")
    return
  end
  local room = DataCenter.LWGGGoDataManager:GetRoom()
  if room:GetState() == LittleGameRoomState.FightIng then
    DataCenter.LWGGGoManager:ReConnectPvp()
    return
  elseif room:GetState() == LittleGameRoomState.FightEnd or room:GetState() == LittleGameRoomState.FightDescribe then
    UIUtil.ShowTipsId("season_s6_minigame_erro_tips_2")
    return
  end
  if self._chatData and self._chatData.extra ~= nil and self._chatData.extra.attachmentId ~= nil then
    local jsonObj = rapidjson.decode(self._chatData.extra.attachmentId)
    local uid = jsonObj.uid
    if uid == nil then
      return
    end
    if uid == LuaEntry.Player.uid then
      UIUtil.ShowTipsId("season_s5_activity_1200045_desc50")
      return
    end
    local sid = toInt(jsonObj.sid)
    local inSameSeasonGroup
    local serverGroupList = SeasonUtil.GetServerGroup()
    for k, v in pairs(serverGroupList) do
      if k == sid then
        inSameSeasonGroup = true
        break
      end
    end
    local betNum = toInt(jsonObj.betnum)
    if not inSameSeasonGroup and 0 < betNum then
      UIUtil.ShowTipsId("season_s6_minigame_pvp_limit9")
      return
    end
    local betCount = room:GetBetCount()
    if betCount < 0 then
      UIUtil.ShowTipsId("operate_notice_10004")
      return
    end
    local betData = DataCenter.LWGGGoDataManager:GetBetData()
    local hasCount = DataCenter.ItemData:GetItemCount(betData.id)
    if 0 < betNum and inSameSeasonGroup then
      if 0 >= room:GetBetMaxCount() - room:GetBetCount() then
        UIUtil.ShowTipsId("season_s6_minigame_pvp_limit8")
        return
      end
      if betNum > hasCount then
        UIUtil.ShowTipsId("120021")
        return
      end
    end
    local uuid = toInt(jsonObj.uuid)
    if 0 < betNum then
      local config = TYPE_CONFIG[EnumActivity.GGGo.Type]
      UIUtil.ShowSecondMessage("", Localization:GetString(config.joinTips, tostring(betNum), tostring(hasCount)), 2, "110006", "110106", function()
        SFSNetwork.SendMessage(MsgDefines.ActivityLittleGamePvpJoin, uuid, sid, DataCenter.LWGGGoDataManager:GetVersion(), self.activityType)
      end, nil, nil, nil, nil, nil, nil, nil, nil, false, nil, nil)
    else
      SFSNetwork.SendMessage(MsgDefines.ActivityLittleGamePvpJoin, uuid, sid, DataCenter.LWGGGoDataManager:GetVersion(), self.activityType)
    end
  end
end

function ChatSeasonLittleGameInviteMsg:Refresh(chatData)
  self._chatData = chatData
  self:RefreshUI()
  self:CheckDowning()
end

function ChatSeasonLittleGameInviteMsg:CheckDowning()
  local download = DataCenter.LWGGGoDataManager:GetResourceLoaded()
  self.post_async_loading:SetActive(not download)
  if not download then
    self.txt_des:SetLocalText(100231)
    self.tween = self.post_async_loading.transform:DOLocalRotate(Vector3(0, 0, -360), 1, CS.DG.Tweening.RotateMode.LocalAxisAdd):SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
    self:Downing()
  end
end

function ChatSeasonLittleGameInviteMsg:Downing()
  if not DataCenter.LWGGGoDataManager:GetResourceLoaded() then
    DataCenter.LWGGGoDataManager:ToLoadRes(function()
      if self.tween ~= nil then
        self.tween:Kill()
        self.tween = nil
      end
      self:DownFinish()
    end)
  end
end

function ChatSeasonLittleGameInviteMsg:DownFinish()
  if self.post_async_loading ~= nil then
    self.post_async_loading:SetActive(false)
    self:RefreshUI()
  end
end

return ChatSeasonLittleGameInviteMsg
