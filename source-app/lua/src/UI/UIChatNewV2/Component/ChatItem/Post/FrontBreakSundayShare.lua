local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_FrontBreakSundayShare = BaseClass("FrontBreakSundayShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local imageDoorNormal = "Assets/Main/Sprites/UI/UIActivityFrontBreakSunday/mjc_qianxiantuwei_liaotian_fenxiang_icon.png"
local imageDoorArabic = "Assets/Main/Sprites/UI/UIActivityFrontBreakSunday/mjc_qianxiantuwei_liaotian_fenxiang_icon2.png"

function ChatItemPost_FrontBreakSundayShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_FrontBreakSundayShare:ComponentDefine()
  self.btnLike = self:AddComponent(UIButton, "btnLike")
  self.btnLike:SetOnClick(function()
    self:OnClickBtnLike()
  end)
  self.btnChallenge = self:AddComponent(UIButton, "btnChallenge")
  self.btnChallenge:SetOnClick(function()
    self:OnClickBtnChallenge()
  end)
  self.textBtnChallenge = self:AddComponent(UITextMeshProUGUIEx, "btnChallenge/img/BtnText")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "textTitle")
  self.textLikeNum = self:AddComponent(UITextMeshProUGUIEx, "textLikeNum")
  self.textDes = self:AddComponent(UITextMeshProUGUIEx, "textDes")
  self.imgDoor = self:AddComponent(UIImage, "bg2")
end

function ChatItemPost_FrontBreakSundayShare:OnLoaded()
  local chatData = self:ChatData()
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self:Refresh(chatData)
end

function ChatItemPost_FrontBreakSundayShare:Refresh(chatData)
  if not chatData then
    return
  end
  self._chatData = chatData
  if self._chatData and self._chatData.attachmentIdJsonObj then
    local extraInfo = self._chatData.attachmentIdJsonObj
    local serRankNew = extraInfo.ActFrontBreakSerRankNew or 0
    local serRankOld = extraInfo.ActFrontBreakSerRankOld or 0
    local alRankNew = extraInfo.ActFrontBreakAlRankNew or 0
    local alRankOld = extraInfo.ActFrontBreakAlRankOld or 0
    local topRankNew = extraInfo.ActFrontBreakTopRankNew or 0
    local topRankOld = extraInfo.ActFrontBreakTopRankOld or 0
    local totalLeft = extraInfo.totalLeft or 0
    if 0 < topRankNew and (topRankOld == 0 or topRankNew < topRankOld) then
      self.textDes:SetLocalText("activity_breakthrough_tips_44", topRankNew)
    elseif 0 < serRankNew and serRankNew < serRankOld then
      self.textDes:SetLocalText("activity_breakthrough_tips_31", serRankNew)
    elseif 0 < alRankNew and alRankNew < alRankOld then
      local allianceAbbr = LuaEntry.Player:GetAllianceAbbr()
      self.textDes:SetLocalText("activity_breakthrough_tips_32", allianceAbbr, alRankNew)
    else
      local stageId = extraInfo.stageId or 0
      local actId = extraInfo.frontBreakSundayActId or 0
      local win = extraInfo.win or false
      local index = DataCenter.ActFrontBreakSundayDataManager:GetActData(actId):GetStageIndex(stageId) or 0
      index = win and index or math.max(index - 1, 0)
      self.textDes:SetLocalText("activity_breakthrough_tips_33", index, totalLeft)
    end
    self.textTitle:SetLocalText("activity_breakthrough_tips_1")
  end
  self.textBtnChallenge:SetLocalText("frontline_weekend_share_03")
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.imgDoor:LoadSpriteAuto(imageDoorArabic)
  else
    self.imgDoor:LoadSpriteAuto(imageDoorNormal)
  end
  self:SetLikeNum(chatData)
end

function ChatItemPost_FrontBreakSundayShare:SetLikeNum(chatData)
  if not chatData then
    return
  end
  if self._chatData.clientUpdateExtra then
    self.likeNum = tonumber(self._chatData.clientUpdateExtra)
    self.textLikeNum:SetText(self.likeNum)
  end
end

function ChatItemPost_FrontBreakSundayShare:OnRecycle()
end

function ChatItemPost_FrontBreakSundayShare:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatItemPost_FrontBreakSundayShare:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatItemPost_FrontBreakSundayShare:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    self:SetLikeNum(chatData)
  end
end

function ChatItemPost_FrontBreakSundayShare:OnClickBtnChallenge()
  if self._chatData and self._chatData.attachmentIdJsonObj then
    local extraInfo = self._chatData.attachmentIdJsonObj
    local player = LuaEntry.Player
    if not player:IsInSourceServer() or player:GetCurServerId() ~= player:GetSelfServerId() then
      UIUtil.ShowTips(Localization:GetString("activity_breakthrough_tips_36"))
    else
      local actData = DataCenter.ActivityListDataManager:GetActivityDataById(extraInfo.frontBreakSundayActId)
      local now = UITimeManager:GetInstance():GetServerTime()
      local actIsOpen = actData and now < actData.endTime or false
      if actIsOpen then
        GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, extraInfo.frontBreakSundayActId)
      else
        UIUtil.ShowTips(Localization:GetString("458822"))
      end
    end
  end
end

function ChatItemPost_FrontBreakSundayShare:OnClickBtnLike()
  if not self._chatData then
    return
  end
  local roomId = self._chatData.roomId
  local seqId = self._chatData:getSeqId()
  local extrString = string.format("%s|%s", tostring(roomId), tostring(seqId))
  local senderUid = self._chatData:getSenderUid()
  SFSNetwork.SendMessage(MsgDefines.FrontBreakSundayThumbsUp, senderUid, extrString)
end

return ChatItemPost_FrontBreakSundayShare
