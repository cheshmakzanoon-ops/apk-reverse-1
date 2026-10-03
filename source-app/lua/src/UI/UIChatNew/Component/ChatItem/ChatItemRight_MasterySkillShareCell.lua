local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemRight_MasterySkillShareCell = BaseClass("ChatItemRight_MasterySkillShareCell", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local LWUIMasterySkillCell = require("UI.LWUIMastery.Component.LWUIMasterySkillCell")
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local skill_cell_path = "ChatAnchor/ChatShareNode/LWUIMasterySkillCell"
local skill_name_path = "ChatAnchor/ChatShareNode/skillName"
local mastery_icon_path = "ChatAnchor/ChatShareNode/masteryIcon"
local mastery_name_path = "ChatAnchor/ChatShareNode/masteryName"
local click_btn_path = "ChatAnchor/ChatShareNode/clickBtn"
local _cp_chatShareTitle = "ChatAnchor/ChatShareNode/Image/ShareTitle"
local skill_lv_path = "ChatAnchor/ChatShareNode/skilLv"

function ChatItemRight_MasterySkillShareCell:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  self._chatUserName = self:AddComponent(ChatUserName, "ChatNameLayout")
  self.masterySkillCell = self:AddComponent(LWUIMasterySkillCell, skill_cell_path)
  self.skill_name = self:AddComponent(UITextMeshProUGUIEx, skill_name_path)
  self.mastery_icon = self:AddComponent(UIImage, mastery_icon_path)
  self.mastery_name = self:AddComponent(UITextMeshProUGUIEx, mastery_name_path)
  self.click_btn = self:AddComponent(UIButton, click_btn_path)
  self._chatShareTitle = self:AddComponent(UIText, _cp_chatShareTitle)
  self.skillLv = self:AddComponent(UITextMeshProUGUIEx, skill_lv_path)
  self.click_btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.click_btn:SetSafeClickMode(true)
  self._chatShareTitle:SetLocalText(110073)
end

function ChatItemRight_MasterySkillShareCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemRight_MasterySkillShareCell:OnAddListener()
  base.OnAddListener(self)
end

function ChatItemRight_MasterySkillShareCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ChatItemRight_MasterySkillShareCell:UpdateItem(chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self:RefreshView(chatData)
end

function ChatItemRight_MasterySkillShareCell:RefreshView(chatData)
  self._chatHead:UpdateHead(self._userInfo, self._chatData)
  self._chatUserName:UpdateName(self._userInfo, self._chatData)
  self.masteryId = nil
  self.showLv = nil
  if self._chatData.attachmentId then
    local attachJson = rapidjson.decode(self._chatData.attachmentId)
    if attachJson then
      local masteryId = attachJson.configId
      local lvOneTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(masteryId)
      local lv = attachJson.lv
      if lvOneTemp then
        if 0 < lv then
          self.skillLv:SetText(Localization:GetString("season_mastery_tips_23", lv))
        else
          self.skillLv:SetText("")
        end
        local homeId = lvOneTemp.home
        self.showLv = attachJson.lv
        local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(homeId)
        if showTemp then
          local imgPath = showTemp:GetIconFullPath()
          self.mastery_icon:LoadSprite(imgPath)
          self.mastery_name:SetLocalText(showTemp.name)
          self.mastery_icon:SetActive(true)
          self.mastery_name:SetActive(true)
        else
          self.mastery_icon:SetActive(false)
          self.mastery_name:SetActive(false)
        end
        self.masteryId = masteryId
        self.masterySkillCell:SetData(masteryId)
        self.skill_name:SetLocalText(lvOneTemp.name)
        self.masterySkillCell:SetActive(true)
        self.skill_name:SetActive(true)
      else
        self.masterySkillCell:SetActive(false)
        self.skill_name:SetActive(false)
        self.mastery_icon:SetActive(false)
        self.mastery_name:SetActive(false)
      end
    else
      self.masterySkillCell:SetActive(false)
      self.skill_name:SetActive(false)
      self.mastery_icon:SetActive(false)
      self.mastery_name:SetActive(false)
    end
  else
    self.masterySkillCell:SetActive(false)
    self.skill_name:SetActive(false)
    self.mastery_icon:SetActive(false)
    self.mastery_name:SetActive(false)
  end
end

function ChatItemRight_MasterySkillShareCell:OnShowClick()
  if self.masteryId and self.showLv then
    local param = {}
    param.masteryId = self.masteryId
    param.isShowMaxLvl = false
    param.showSkillInfo = false
    param.showShareBtn = false
    param.showLv = self.showLv
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryGetSkill, {anim = true}, param)
  end
end

return ChatItemRight_MasterySkillShareCell
