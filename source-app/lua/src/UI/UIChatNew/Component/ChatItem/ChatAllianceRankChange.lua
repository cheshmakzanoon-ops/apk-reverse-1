local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatAllianceRankChange = BaseClass("ChatAllianceRankChange", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatViewController = require("UI.UIChatNew.Controller.ChatViewUtils")
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local rapidjson = require("rapidjson")
local title_path = "title"
local left_path = "Left"
local left_empty_path = "LeftEmpty"
local right_path = "Right"
local right_empty_path = "RightEmpty"
local left_empty_txt_path = "LeftEmpty/LeftEmptyText"
local right_empty_txt_path = "RightEmpty/RightEmptyText"
local left_name_txt_path = "Left/LeftName"
local right_name_txt_path = "Right/RightName"
local left_head_path = "Left/LeftHead"
local right_head_path = "Right/RightHead"
local new_text_path = "Right/NewImg/NewText"
local upBtn_path = "UpBtn"
local upBtn_text_path = "UpBtn/UpBtnText"

function ChatAllianceRankChange:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.left = self:AddComponent(UIBaseContainer, left_path)
  self.right = self:AddComponent(UIBaseContainer, right_path)
  self.leftEmpty = self:AddComponent(UIBaseContainer, left_empty_path)
  self.rightEmpty = self:AddComponent(UIBaseContainer, right_empty_path)
  self.leftEmptyTxt = self:AddComponent(UIText, left_empty_txt_path)
  self.rightEmptyTxt = self:AddComponent(UIText, right_empty_txt_path)
  self.left_name_txt = self:AddComponent(UIText, left_name_txt_path)
  self.right_name_txt = self:AddComponent(UIText, right_name_txt_path)
  self.left_head = self:AddComponent(ChatHead, left_head_path)
  self.right_head = self:AddComponent(ChatHead, right_head_path)
  self.new_text = self:AddComponent(UIText, new_text_path)
  self.up_text = self:AddComponent(UIText, upBtn_text_path)
  self.upBtn = self:AddComponent(UIButton, upBtn_path)
  self.upBtn:SetOnClick(function()
    self:OnUpBtnClick()
  end)
  self.leftEmptyTxt:SetLocalText(393097)
  self.rightEmptyTxt:SetLocalText(393097)
  self.new_text:SetLocalText(393096)
  self.left_head._headBtn:SetOnClick(function()
    if not string.IsNullOrEmpty(self.leftUid) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.leftUid)
    end
  end)
  self.right_head._headBtn:SetOnClick(function()
    if not string.IsNullOrEmpty(self.rightUid) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.rightUid)
    end
  end)
end

function ChatAllianceRankChange:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatAllianceRankChange:UpdateItem(chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  if chatData.post == PostType.Alliance_OfficialChange then
    self:RefreshForOfficial(chatData)
  else
    self:RefreshForLeader(chatData)
  end
end

function ChatAllianceRankChange:RefreshForOfficial(chatData)
  local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  if jsonObj then
    if jsonObj.official and jsonObj.official > 0 then
      local name = Localization:GetString(LWAlMemberOffcialParam[jsonObj.official].Text)
      self.title:SetLocalText(393095, name)
    else
      self.title:SetText("")
    end
    self:RefreshContent(jsonObj)
  end
  self:RefreshUp(chatData)
end

function ChatAllianceRankChange:RefreshForLeader(chatData)
  self.title:SetLocalText(393095, Localization:GetString(302336))
  local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  if jsonObj then
    self:RefreshContent(jsonObj)
  end
  self:RefreshUp(chatData)
end

function ChatAllianceRankChange:RefreshContent(jsonObj)
  if jsonObj.old then
    self.left:SetActive(true)
    self.leftEmpty:SetActive(false)
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(jsonObj.old.uid, jsonObj.old.name)
    self.left_name_txt:SetText(showName)
    if jsonObj.old.uid then
      self.left_head._headImg:SetData(jsonObj.old.uid, jsonObj.old.pic, jsonObj.old.picVer)
    else
      self.left_head._headImg:SetData("", jsonObj.old.pic, jsonObj.old.picVer)
    end
    self.leftUid = jsonObj.old.uid
  else
    self.left:SetActive(false)
    self.leftEmpty:SetActive(true)
  end
  if jsonObj.new then
    self.right:SetActive(true)
    self.rightEmpty:SetActive(false)
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(jsonObj.new.uid, jsonObj.new.name)
    self.right_name_txt:SetText(showName)
    if jsonObj.new.uid then
      self.right_head._headImg:SetData(jsonObj.new.uid, jsonObj.new.pic, jsonObj.new.picVer)
    else
      self.right_head._headImg:SetData("", jsonObj.new.pic, jsonObj.new.picVer)
    end
    self.rightUid = jsonObj.new.uid
  else
    self.right:SetActive(false)
    self.rightEmpty:SetActive(true)
  end
end

function ChatAllianceRankChange:RefreshUp(chatData)
  local upNum = chatData.interactLike or 0
  self.up_text:SetText("+" .. upNum)
end

function ChatAllianceRankChange:OnUpBtnClick()
  local deltaTime = ChatManager2:GetInstance():GetGiveLikeMsgTime(self.seqId, 1)
  local k1 = LuaEntry.DataConfig:TryGetNum("thumbs_up", "k1")
  local realLeftTime = deltaTime + k1
  if 0 < realLeftTime then
    local delta = UITimeManager:GetInstance():MilliSecondToFmtString(realLeftTime * 1000)
    UIUtil.ShowTips(Localization:GetString("121068", delta))
    return
  end
  local _roomId = self._chatData.roomId
  local msgTable = {
    roomId = _roomId,
    msgSeq = self.seqId,
    interactLike = 1
  }
  ChatManager2:GetInstance():SetGiveLikeMsgTime(self.seqId, 1)
  ChatManager2:GetInstance():SetGiveLikeAnim(self.seqId, 1)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_UP_COMMAND, msgTable)
end

return ChatAllianceRankChange
