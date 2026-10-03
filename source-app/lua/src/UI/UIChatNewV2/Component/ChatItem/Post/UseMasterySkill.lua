local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_UseMasterySkill = BaseClass("UseMasterySkill", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local skill_icon_path = "SkillIcon"
local name_text_path = "NameText"
local des_text_path = "DesText"
local return_skill_btn_path = "ReturnSkillBtn"

function ChatItemPost_UseMasterySkill:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_UseMasterySkill:ComponentDefine()
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.skill_icon = self:AddComponent(UIImage, skill_icon_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
  self.return_skill_btn = self:AddComponent(UIButton, return_skill_btn_path)
  self.return_skill_btn:SetOnClick(function()
    self:Interactive()
  end)
  self.return_skill_btn_img = self:AddComponent(UIImage, return_skill_btn_path)
end

function ChatItemPost_UseMasterySkill:OnLoaded()
  local chatData = self:ChatData()
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self:Refresh(chatData)
end

function ChatItemPost_UseMasterySkill:Refresh(chatData)
  self._chatData = chatData
  local isMyChat = self._chatData:isMyChat()
  if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
    local skillId = tonumber(self._chatData.extra.customJsonParam.skillId) or 0
    if 0 < skillId then
      local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(skillId)
      if skillTemp then
        self.name_text:SetLocalText(skillTemp.name)
        self.des_text:SetLocalText("skill_use_msg_des")
        self.skill_icon:LoadSpriteAsync(skillTemp:GetIconFullPath())
      end
    end
  end
  local scaleX = isMyChat and -1 or 1
  self.bg:SetLocalScaleXYZ(scaleX, 1, 1)
  self.return_skill_btn:SetActive(not isMyChat)
  if isMyChat then
    self.skill_icon:SetAnchoredPositionXY(197.4, 0)
    self.name_text:SetAnchoredPositionXY(-74.904, 40.61)
    self.des_text:SetAnchoredPositionXY(-230.36, 15)
    self.name_text:SetSizeDeltaXY(310.9196, 50.77018)
    self.des_text:SetSizeDeltaXY(310.9196, 76.67824)
  else
    self.skill_icon:SetAnchoredPositionXY(-197.4, 0)
    self.name_text:SetAnchoredPositionXY(25.268, 40.61)
    self.des_text:SetAnchoredPositionXY(-120.64, 15)
    self.name_text:SetSizeDeltaXY(291.3354, 50.77018)
    self.des_text:SetSizeDeltaXY(291.3354, 76.67824)
  end
  local imgColor = 1
  local theme = ChatInterface.GetChatTheme()
  if theme ~= ChatUIThemeConfig.ChatMode.Normal then
    imgColor = 0.8
  end
  self.skill_icon:SetColorRGBA(imgColor, imgColor, imgColor, 1)
  self.bg:SetColorRGBA(imgColor, imgColor, imgColor, 1)
  self.return_skill_btn_img:SetColorRGBA(imgColor, imgColor, imgColor, 1)
end

function ChatItemPost_UseMasterySkill:OnRecycle()
end

function ChatItemPost_UseMasterySkill:OnAddListener()
  base.OnAddListener(self)
end

function ChatItemPost_UseMasterySkill:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ChatItemPost_UseMasterySkill:OnUpdateMsg(chatData)
end

function ChatItemPost_UseMasterySkill:Interactive()
  if self._chatData == nil then
    return
  end
  local isOpen = DataCenter.MasteryManager:IsShowWorldMasteryBtn()
  if not isOpen then
    UIUtil.ShowTipsId("skill_use_tips")
    return
  end
  local allShowData = DataCenter.MasteryManager:GetMasterySkillUseShowDataInChatView()
  if allShowData == nil or #allShowData == 0 then
    UIUtil.ShowTipsId("skill_use_tips")
    return
  end
  local targetUid = self._chatData.senderUid
  if not string.IsNullOrEmpty(targetUid) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISkillUseInChat, {anim = true}, targetUid)
  end
end

return ChatItemPost_UseMasterySkill
