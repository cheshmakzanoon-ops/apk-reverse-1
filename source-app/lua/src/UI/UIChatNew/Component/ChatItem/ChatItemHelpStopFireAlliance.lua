local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemHelpStopFireAlliance = BaseClass("ChatItemHelpStopFireAlliance", base)
local rapidjson = require("rapidjson")
local ui_player_head_path = "Content/UIPlayerHead"
local player_name_text_path = "Content/PlayerNameText"
local des_text_path = "Content/DesText"
local btn_path = "Content/ZanBtn"
local count_text_path = "Content/CountText"
local active_anim_path = "Content/ZanBtn/ActiveAnim"

function ChatItemHelpStopFireAlliance:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemHelpStopFireAlliance:OnDestroy()
  self:ClearTimer()
  self:ComponentDestroy()
  self._chatData = nil
  self.playerInfo = nil
  self.localLikeTime = nil
  self.seqId = nil
  base.OnDestroy(self)
end

function ChatItemHelpStopFireAlliance:ComponentDefine()
  self.ui_player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
  self.bg = self:AddComponent(UIRawImage, "Content")
  self.countText = self:AddComponent(UIText, count_text_path)
  self.heart_effect = self:AddComponent(UIBaseContainer, active_anim_path)
  self.heart_effect:SetActive(false)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:Interactive()
  end)
end

function ChatItemHelpStopFireAlliance:ComponentDestroy()
  self.ui_player_head = nil
  self.player_name_text = nil
  self.des_text = nil
  self.bg = nil
  self.countText = nil
  self.heart_effect = nil
  self.btn = nil
  self.event_icon = nil
end

function ChatItemHelpStopFireAlliance:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatItemHelpStopFireAlliance:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatItemHelpStopFireAlliance:UpdateItem(_chat_data, _index)
  self.seqId = _chat_data:getSeqId()
  self:Refresh(_chat_data)
end

function ChatItemHelpStopFireAlliance:OnUpdateMsg(_chat_data)
  if _chat_data and _chat_data.seqId == self.seqId and _chat_data.roomid == self.roomId then
    self:Refresh(_chat_data)
  end
end

function ChatItemHelpStopFireAlliance:Refresh(_chat_data)
  self._chatData = _chat_data
  if _chat_data and _chat_data.extra and _chat_data.extra.customJsonParam then
    local jsonObj = rapidjson.decode(_chat_data.extra.customJsonParam)
    if jsonObj then
      self.playerInfo = jsonObj.playerInfo
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.playerInfo.uid, self.playerInfo.name)
      self.player_name_text:SetText(showName)
      self.ui_player_head:ParseHeadInfo(self.playerInfo)
      self.ui_player_head:SetEnableClickShowInfo(true, true)
      self.des_text:SetLocalText(jsonObj.dialogId, jsonObj.count)
    end
  end
  local count = 0
  if _chat_data and _chat_data.clientUpdateExtra then
    count = _chat_data.clientUpdateExtra
  end
  self.countText:SetText(count)
end

function ChatItemHelpStopFireAlliance:Interactive()
  if self._chatData then
    local seqId = self.seqId
    local senderUid = self._chatData.senderUid
    local roomId = self._chatData.roomId
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.playerInfo.uid, self.playerInfo.name)
    self.clickInteractive = true
    DataCenter.BuildHelpStopFireManager:HelpStopFireChatInteractive(seqId, senderUid, roomId, self.playerInfo.uid, InteractiveUtil.ThumbsUpType.HelpStopFireAlliance, showName, function()
      if self and self.heart_effect then
        self.heart_effect:SetActive(true)
        self:ClearTimer()
        self.timer = TimerManager:GetInstance():DelayInvoke(function()
          if self and self.heart_effect then
            self.heart_effect:SetActive(false)
            self.timer = nil
          end
        end)
      end
    end)
  end
end

function ChatItemHelpStopFireAlliance:ClearTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

return ChatItemHelpStopFireAlliance
