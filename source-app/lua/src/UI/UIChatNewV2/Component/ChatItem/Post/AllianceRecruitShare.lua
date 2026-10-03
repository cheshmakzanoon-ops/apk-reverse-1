local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_AllianceRecruitShare = BaseClass("AllianceRecruitShare", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local chatShareNode_path = ""
local shareTitle_path = "Image/ShareTitle"
local countryFlag_path = "ShareIconNode/countryFlag"
local allianceFlag_path = "ShareIconNode/AllianceFlag"
local recruitTip_path = "ShareIconNode/recruitTip"
local peopleNum_path = "ShareIconNode/people/peopleNum"
local detailBtn_path = "ShareIconNode/detailBtn"
local detailBtnTxt_path = "ShareIconNode/detailBtn/detailBtnTxt"
local joinBtn_path = "ShareIconNode/joinBtn"
local joinBtnTxt_path = "ShareIconNode/joinBtn/joinBtnTxt"

function ChatItemPost_AllianceRecruitShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_AllianceRecruitShare:ComponentDefine()
  self.chatShareNodeN = self:AddComponent(UIBaseContainer, chatShareNode_path)
  self.shareTitleN = self:AddComponent(UIText, shareTitle_path)
  self.countryFlagN = self:AddComponent(UIImage, countryFlag_path)
  self.allianceFlagN = self:AddComponent(AllianceFlagItem, allianceFlag_path)
  self.recruitTipN = self:AddComponent(UIText, recruitTip_path)
  self.peopleNumN = self:AddComponent(UIText, peopleNum_path)
  self.detailBtnN = self:AddComponent(UIButton, detailBtn_path)
  self.detailBtnN:SetOnClick(function()
    self:OnClickDetailBtn()
  end)
  self.detailBtnTxtN = self:AddComponent(UIText, detailBtnTxt_path)
  self.detailBtnTxtN:SetLocalText(100092)
  self.joinBtnN = self:AddComponent(UIButton, joinBtn_path)
  self.joinBtnN:SetOnClick(function()
    self:OnClickJoinBtn()
  end)
  self.joinBtnTxtN = self:AddComponent(UIText, joinBtnTxt_path)
  self.joinBtnTxtN:SetLocalText(110037)
end

function ChatItemPost_AllianceRecruitShare:OnClickBg()
  if self.attachInfo ~= nil then
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
    local tempIndex = DataCenter.AllianceTaskManager:GetTaskIndex(self.attachInfo.taskId)
    if tempIndex then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceTask, {anim = true, hideTop = true}, tempIndex, false)
    else
      tempIndex = DataCenter.AllianceSeasonTaskManager:GetTaskIndex(self.attachInfo.taskId)
      if tempIndex then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceTask, {anim = true, hideTop = true}, tempIndex, true)
      end
    end
  end
end

function ChatItemPost_AllianceRecruitShare:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  self.attachInfo = chatdata:getMessageParam(false)
  self.shareTitleN:SetText("[" .. self.attachInfo.abbr .. "]" .. self.attachInfo.name)
  if not LuaEntry.GlobalData:IsChina() then
    self.countryFlagN:SetActive(true)
    local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(self.attachInfo.country)
    self.countryFlagN:LoadSprite(nationTemplate:GetNationFlagPath())
  else
    self.countryFlagN:SetActive(false)
  end
  self.allianceFlagN:SetData(self.attachInfo.allianceFlag)
  self.recruitTipN:SetText(self.attachInfo.recruitTip)
  self.peopleNumN:SetText(self.attachInfo.memberNum)
  if self.attachInfo.needApply == 1 then
    self.joinBtnTxtN:SetLocalText(110090)
  else
    self.joinBtnTxtN:SetLocalText(110037)
  end
  local senderUid = chatdata.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self.chatNameLayoutN then
    self.chatNameLayoutN:UpdateName(_userInfo, chatdata)
  end
  self:UpdateTopOffset()
end

function ChatItemPost_AllianceRecruitShare:OnClickDetailBtn()
  if CS.SceneManager:IsInCity() then
    return UIUtil.ShowTipsId(121373)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = true}, self.attachInfo.name, self.attachInfo.uid)
end

function ChatItemPost_AllianceRecruitShare:OnClickJoinBtn()
  if CS.SceneManager:IsInCity() then
    return UIUtil.ShowTipsId(121373)
  end
  if LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTips(Localization:GetString("E100056"))
  else
    local joinType = self.attachInfo.needApply and 1 or 0
    SFSNetwork.SendMessage(MsgDefines.AlApply, self.attachInfo.uid, joinType, self.attachInfo.language)
  end
end

function ChatItemPost_AllianceRecruitShare:GetTopOffset()
  if self.chatNameLayoutN and type(self.chatNameLayoutN.GetTopOffset) == "function" then
    return self.chatNameLayoutN:GetTopOffset()
  else
    return 0
  end
end

function ChatItemPost_AllianceRecruitShare:UpdateTopOffset()
  local initOffset = 40
  local topOffset = self:GetTopOffset()
  local sizeX, sizeY = self.rectTransform:Get_sizeDelta()
  self.rectTransform:Set_sizeDelta(sizeX, sizeY + topOffset)
  self:SetTransPosY(self.chatShareNodeN.rectTransform, -(initOffset + topOffset))
end

function ChatItemPost_AllianceRecruitShare:OnRecycle()
end

return ChatItemPost_AllianceRecruitShare
