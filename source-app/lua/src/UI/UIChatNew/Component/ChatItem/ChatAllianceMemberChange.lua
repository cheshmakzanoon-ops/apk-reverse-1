local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatAllianceMemberChange = BaseClass("ChatAllianceMemberChange", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local content_txt_path = "contentTxt"
local name_line_content_path = "contentTxt/NameLineContent"
local vip_level_badge_path = "contentTxt/NameLineContent/VipLevelBadge"
local txt_level_path = "contentTxt/NameLineContent/VipLevelBadge/imgBg/txtLevel"
local sender_lv_path = "contentTxt/NameLineContent/SenderLv"
local gender_path = "contentTxt/NameLineContent/Gender"
local man_path = "contentTxt/NameLineContent/Gender/Man"
local woman_path = "contentTxt/NameLineContent/Gender/Woman"
local oneSpaceW = 5.8335

function ChatAllianceMemberChange:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ChatAllianceMemberChange:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ChatAllianceMemberChange:ComponentDefine()
  self.content_txt = self:AddComponent(UITextMeshProUGUIEx, content_txt_path)
  self.name_line_content = self:AddComponent(UIBaseContainer, name_line_content_path)
  self.vip_level_badge = self:AddComponent(UIBaseContainer, vip_level_badge_path)
  self.txt_level = self:AddComponent(UITextMeshProUGUIEx, txt_level_path)
  self.sender_lv = self:AddComponent(UITextMeshProUGUIEx, sender_lv_path)
  self.gender = self:AddComponent(UIBaseContainer, gender_path)
  self.man = self:AddComponent(UIImage, man_path)
  self.woman = self:AddComponent(UIImage, woman_path)
  self.content_txt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
end

function ChatAllianceMemberChange:DataDefine()
  self._chatData = nil
  self.postType = 0
  self.uid = ""
  self.name = ""
  self.svipLevel = 0
  self.isVipShow = 0
  self.svipEndTime = 0
  self.serverTime = 0
  self.level = 0
  self.genderData = 0
  self.selfRank = 0
  self.rankType = 0
end

function ChatAllianceMemberChange:DataDestroy()
  self._chatData = nil
  self.postType = nil
  self.uid = nil
  self.name = nil
  self.svipLevel = nil
  self.isVipShow = nil
  self.svipEndTime = nil
  self.serverTime = nil
  self.level = nil
  self.genderData = nil
  self.selfRank = nil
  self.rankType = nil
end

function ChatAllianceMemberChange:ResetData()
  self._chatData = nil
  self.postType = 0
  self.uid = ""
  self.name = ""
  self.svipLevel = 0
  self.isVipShow = 0
  self.svipEndTime = 0
  self.serverTime = 0
  self.level = 0
  self.genderData = 0
  self.selfRank = 0
  self.rankType = 0
end

function ChatAllianceMemberChange:UpdateItem(chatData)
  self:SetData(chatData)
  self:RefreshView()
end

function ChatAllianceMemberChange:SetData(chatData)
  self:ResetData()
  self._chatData = chatData
  self.postType = chatData.post
  local attachmentIdJsonObj = self._chatData.attachmentIdJsonObj
  if attachmentIdJsonObj then
    if attachmentIdJsonObj.uid then
      self.uid = attachmentIdJsonObj.uid
    end
    if attachmentIdJsonObj.name then
      self.name = attachmentIdJsonObj.name
    end
    if attachmentIdJsonObj.svipLevel then
      self.svipLevel = attachmentIdJsonObj.svipLevel
    end
    if attachmentIdJsonObj.isVipShow then
      self.isVipShow = attachmentIdJsonObj.isVipShow
    end
    if attachmentIdJsonObj.svipEndTime then
      self.svipEndTime = attachmentIdJsonObj.svipEndTime
    end
    if attachmentIdJsonObj.level then
      self.level = attachmentIdJsonObj.level
    end
    if attachmentIdJsonObj.gender then
      self.genderData = attachmentIdJsonObj.gender
    end
    if attachmentIdJsonObj.selfRank then
      self.selfRank = attachmentIdJsonObj.selfRank
    end
    if attachmentIdJsonObj.rankType then
      self.rankType = attachmentIdJsonObj.rankType
    end
  end
  if self._chatData.serverTime then
    self.serverTime = self._chatData.serverTime
  end
end

function ChatAllianceMemberChange:RefreshView()
  local theme = ChatInterface.GetChatTheme()
  local isNormal = theme == ChatUIThemeConfig.ChatMode.Normal
  if isNormal then
    self.sender_lv:SetColorRGBA255(42, 40, 48, 255)
    self.content_txt:SetColorRGBA255(81, 81, 81, 255)
  else
    self.sender_lv:SetColorRGBA255(165, 165, 165, 255)
    self.content_txt:SetColorRGBA255(165, 165, 165, 255)
  end
  if self.postType == PostType.Text_MemberJoin then
    self:RefreshViewJoinType()
  else
    self:RefreshViewQuitType()
  end
end

function ChatAllianceMemberChange:RefreshViewJoinType()
  local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
  local theme = ChatInterface.GetChatTheme()
  local isNormal = theme == ChatUIThemeConfig.ChatMode.Normal
  local showPass = self.isVipShow > 0
  local levelPass = self.svipLevel >= 3
  local timePass = self.svipEndTime * 1000 > self.serverTime
  local isSvipShow = showPass and levelPass and timePass
  local isLevelShow = 0 < self.level
  local isGenderShow = self.genderData == 1 or self.genderData == 2
  local isLineContentShow = isSvipShow or isLevelShow or isGenderShow
  local lineContentW = 0
  local lineContentH = 0
  local spaceNum = 0
  self.name_line_content:SetActive(isLineContentShow)
  if isLineContentShow then
    self.vip_level_badge:SetActive(isSvipShow)
    if isSvipShow then
      self.txt_level:SetLocalText(2000268, self.svipLevel)
    end
    self.sender_lv:SetActive(isLevelShow)
    if isLevelShow then
      self.sender_lv:SetLocalText(300665, self.level)
    end
    self.gender:SetActive(isGenderShow)
    if isGenderShow then
      local isMan = self.genderData == 1
      self.man:SetActive(isMan)
      self.woman:SetActive(not isMan)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.name_line_content.transform)
    lineContentW, lineContentH = self.name_line_content:GetSizeDeltaXY()
  end
  if 0 < lineContentW then
    spaceNum = math.ceil(lineContentW / oneSpaceW)
  end
  local spaceStr = ""
  if 0 < spaceNum then
    spaceStr = string.rep(" ", spaceNum)
  end
  local nameColor = "249bc5"
  if not isNormal then
    nameColor = "28b0ff"
  end
  local nameStr = "<link=" .. self.uid .. "><color=#" .. nameColor .. "><u>" .. self.name .. "</u></color></link>"
  local contentStr = ""
  local isHaveRankData = 0 < self.selfRank and 0 < self.rankType
  if isHaveRankData then
    local rankColor = "f53c3d"
    if not isNormal then
      rankColor = "e64b4b"
    end
    local rankStr = "<color=#" .. rankColor .. ">" .. self.selfRank .. "</color>"
    local rankName = ""
    if self.rankType == RankingTypeServer.KILL then
      rankName = Localization:GetString("129095")
    elseif self.rankType == RankingTypeServer.POWER then
      rankName = Localization:GetString("129096")
    end
    contentStr = Localization:GetString("alliance_enter_message001", nameStr, rankName, rankStr)
  else
    contentStr = Localization:GetString("alliance_enter_message002", nameStr)
  end
  self.content_txt:SetText(spaceStr .. contentStr)
  local txtSizeX = self.content_txt:GetSizeDelta().x
  local txtPrefabSize = self.content_txt.unity_tmpro:GetPreferredValues(txtSizeX, 0)
  local txtPrefabH = txtPrefabSize.y
  self.content_txt:SetSizeDeltaXY(txtSizeX, txtPrefabH)
  self:SetSizeDeltaXY(txtSizeX, txtPrefabH + 30)
  self.content_txt.unity_tmpro:ForceMeshUpdate()
  local textInfo = self.content_txt.unity_tmpro.textInfo
  local lineCount = textInfo.lineCount
  if 1 < lineCount then
    if CommonUtil.IsArabic() then
      self.content_txt:SetAlignment(CS.TMPro.TextAlignmentOptions.MidlineRight)
    else
      self.content_txt:SetAlignment(CS.TMPro.TextAlignmentOptions.MidlineLeft)
    end
  else
    self.content_txt:SetAlignment(CS.TMPro.TextAlignmentOptions.Midline)
  end
  if 0 < spaceNum then
    self.content_txt.unity_tmpro:ForceMeshUpdate()
    local textInfo = self.content_txt.unity_tmpro.textInfo
    local isRightToLeftText = self.content_txt.unity_tmpro.isRightToLeftText
    if spaceNum <= textInfo.characterCount then
      local charInfo1 = textInfo.characterInfo[0]
      local charInfo2 = textInfo.characterInfo[spaceNum - 1]
      local position1 = charInfo1.bottomLeft
      local position2 = charInfo2.bottomRight
      self.name_line_content:SetLocalPosition((position1 + position2) / 2)
      local lineH = textInfo.lineInfo[0].lineHeight
      local aPosX = self.name_line_content:GetAnchoredPositionX()
      local aPosY = self.name_line_content:GetAnchoredPositionY()
      aPosX = CommonUtil.ArabicAutoMirrorFactor() * aPosX
      self.name_line_content:SetAnchoredPositionXY(aPosX, aPosY + lineContentH / 2)
    end
  end
end

function ChatAllianceMemberChange:RefreshViewQuitType()
  local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
  local theme = ChatInterface.GetChatTheme()
  local isNormal = theme == ChatUIThemeConfig.ChatMode.Normal
  self.name_line_content:SetActive(false)
  local nameColor = "f97077"
  if not isNormal then
    nameColor = "e64b4b"
  end
  local nameStr = "<link=" .. self.uid .. "><color=#" .. nameColor .. "><u>" .. self.name .. "</u></color></link>"
  local contentStr = Localization:GetString("alliance_quit_message001", nameStr)
  self.content_txt:SetText(contentStr)
  local txtSizeX = self.content_txt:GetSizeDelta().x
  local txtPrefabSize = self.content_txt.unity_tmpro:GetPreferredValues(txtSizeX, 0)
  local txtPrefabH = txtPrefabSize.y
  self.content_txt:SetSizeDeltaXY(txtSizeX, txtPrefabH)
  self:SetSizeDeltaXY(txtSizeX, txtPrefabH + 30)
  self.content_txt.unity_tmpro:ForceMeshUpdate()
  local textInfo = self.content_txt.unity_tmpro.textInfo
  local lineCount = textInfo.lineCount
  if 1 < lineCount then
    self.content_txt:SetAlignment(CS.TMPro.TextAlignmentOptions.MidlineLeft)
  else
    self.content_txt:SetAlignment(CS.TMPro.TextAlignmentOptions.Midline)
  end
end

function ChatAllianceMemberChange:OnPointerClick(clickPos)
  if self.uid == nil then
    return
  end
  local linkId = self.content_txt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.uid)
end

return ChatAllianceMemberChange
