local ChatItemPlayersTriggerPushMsg = require("UI.UIChatNew.Component.ChatItem.ChatItemPlayersTriggerPushMsg")
local ChatItemS0AllianceBossPushMsg = BaseClass("ChatItemS0AllianceBossPushMsg", ChatItemPlayersTriggerPushMsg)
local base = ChatItemPlayersTriggerPushMsg

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function SetConfigData(self, data)
  if self._chatData == nil then
    return
  end
  local post = self._chatData.post
  if post == PostType.S0_ALLIANCE_BOSS_GIFT_REWARD then
    if data.DescDialogId then
      self.des_text:SetLocalText(data.DescDialogId)
    end
    if self.data and self.data.configId then
      self.fireworkLineData = LocalController:instance():getLine(TableName.Firework, self.data.configId)
      if self.fireworkLineData then
        self.event_icon:LoadSpriteAuto(self.fireworkLineData.reward_icon)
      end
    end
    if data.BgPath then
      self.bg:LoadSpriteAuto(data.BgPath)
    end
  end
end

local function BtnClick(self)
  if not LuaEntry.Player:IsInSelfServer() then
    UIUtil.ShowTipsId("server_tips_002")
    return
  end
  if not self:GetIsOverdue() then
    local data = {
      uuid = self.data.uuid,
      ownerUid = self.data.ownerUid
    }
    SFSNetwork.SendMessage(MsgDefines.FindFireworksGiftWorldPoint, data)
  else
    UIUtil.ShowTipsId("alliance_duel_gacha_tips_1018")
  end
end

local function GetIsOverdue(self)
  if not self.data.expiredTime or self.data.expiredTime <= 0 then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.expiredTime = tonumber(self.data.expiredTime) or 0
  local time = self.expiredTime - curTime
  if time <= 0 then
    return true
  end
end

ChatItemS0AllianceBossPushMsg.OnCreate = OnCreate
ChatItemS0AllianceBossPushMsg.OnDestroy = OnDestroy
ChatItemS0AllianceBossPushMsg.SetConfigData = SetConfigData
ChatItemS0AllianceBossPushMsg.BtnClick = BtnClick
ChatItemS0AllianceBossPushMsg.GetIsOverdue = GetIsOverdue
return ChatItemS0AllianceBossPushMsg
