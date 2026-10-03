local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemAllianceCongratulation = BaseClass("ChatItemAllianceCongratulation", base)
local rapidjson = require("rapidjson")
local ui_player_head_path = "item/Content/UIPlayerHead"
local player_name_text_path = "item/Content/PlayerNameText"
local des_text_path = "item/Content/DesText"
local btn_path = "item/Content/ZanBtn"
local count_text_path = "item/Content/CountText"
local active_anim_path = "item/Content/ZanBtn/ActiveAnim"

function ChatItemAllianceCongratulation:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemAllianceCongratulation:OnDestroy()
  self:ComponentDestroy()
  self._chatData = nil
  self.playerInfo = nil
  self.localLikeTime = nil
  self.seqId = nil
  base.OnDestroy(self)
end

function ChatItemAllianceCongratulation:ComponentDefine()
  self.ui_player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
  self.bg = self:AddComponent(UIRawImage, "item/Content")
  self.countText = self:AddComponent(UIText, count_text_path)
  self.heart_effect = self:AddComponent(UIBaseContainer, active_anim_path)
  self.heart_effect:SetActive(false)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:Interactive()
  end)
end

function ChatItemAllianceCongratulation:ComponentDestroy()
  self.ui_player_head = nil
  self.player_name_text = nil
  self.des_text = nil
  self.bg = nil
  self.countText = nil
  self.heart_effect = nil
  self.btn = nil
end

function ChatItemAllianceCongratulation:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceCongratulationThumbsUpChange, self.OnUpdateMsg)
  self:AddUIListener(EventId.AllianceCongratulationThumbsUpCount, self.Refresh)
end

function ChatItemAllianceCongratulation:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceCongratulationThumbsUpChange, self.OnUpdateMsg)
  self:RemoveUIListener(EventId.AllianceCongratulationThumbsUpCount, self.Refresh)
  base.OnRemoveListener(self)
end

function ChatItemAllianceCongratulation:UpdateItem(_chat_data, _index)
  self.seqId = _chat_data:getSeqId()
  self:RefreshData(_chat_data)
  self:OnUpdateMsg()
end

function ChatItemAllianceCongratulation:RefreshData(_chat_data)
  self._chatData = _chat_data
  if _chat_data and _chat_data.extra and _chat_data.extra.customJsonParam then
    local jsonObj = rapidjson.decode(_chat_data.extra.customJsonParam)
    if jsonObj then
      self.targetUid = jsonObj.uid
      self.configId = jsonObj.configId
      self.playerInfo = jsonObj.roleInfo
      if self.playerInfo then
        local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.playerInfo.uid, self.playerInfo.name)
        self.player_name_text:SetText(showName)
        self.ui_player_head:ParseHeadInfo(self.playerInfo)
        self.ui_player_head:SetEnableClickShowInfo(true, true)
      end
      if self.configId then
        local lineData = LocalController:instance():getLine(TableName.LW_Alliance_Congratulation, self.configId)
        if lineData then
          self.des_text:SetLocalText(lineData.ac_msg_key, lineData.para1)
        end
      end
    end
  end
end

function ChatItemAllianceCongratulation:OnUpdateMsg()
  if self.targetUid and self.configId then
    self.thumbsInfo = DataCenter.AllianceCongratulationDataManager:GetThumbsUpInfo(self.targetUid, self.configId)
    if self.thumbsInfo == nil then
      DataCenter.AllianceCongratulationDataManager:GetAllianceCongratulationGainThumbsUpCount(self.targetUid, self.configId)
    elseif self.thumbsInfo and self.thumbsInfo.needRefresh then
      DataCenter.AllianceCongratulationDataManager:GetAllianceCongratulationGainThumbsUpCount(self.targetUid, self.configId)
    else
      self:Refresh()
    end
  end
end

function ChatItemAllianceCongratulation:Refresh()
  self.thumbsInfo = DataCenter.AllianceCongratulationDataManager:GetThumbsUpInfo(self.targetUid, self.configId)
  local count = 0
  if self.thumbsInfo and self.thumbsInfo.count then
    count = self.thumbsInfo.count
  end
  if self.thumbsInfo and self.thumbsInfo.selfThumb then
    local colorStr = "<color=#099b4a><b>%s</b></color>"
    local countStr = string.format(colorStr, count)
    self.countText:SetText(countStr)
  else
    self.countText:SetText(count)
  end
end

function ChatItemAllianceCongratulation:Interactive()
  if self.targetUid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  DataCenter.AllianceCongratulationDataManager:SetFlyCenter(self.btn.gameObject.transform.position)
  if self.thumbsInfo and not self.thumbsInfo.selfThumb then
    DataCenter.AllianceCongratulationDataManager:SendAllianceCongratulationThumbsUp(self.targetUid, self.configId)
  elseif self.thumbsInfo and self.thumbsInfo.selfThumb then
    UIUtil.ShowTipsId("801142")
  end
end

return ChatItemAllianceCongratulation
