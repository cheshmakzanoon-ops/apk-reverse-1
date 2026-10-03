local UILWMailListItemCommon = BaseClass("UILWMailListItemCommon", UIBaseContainer)
local base = UIBaseContainer
local rapidjson = require("rapidjson")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local read_img_path = "BgRead"
local icon_img_path = "Icon"
local name_txt_path = "rect_text/TitleTxt"
local des_txt_path = "rect_text/SubTitleTxt"
local time_txt_path = "rect_text/TimeText"
local gift_img_path = "Gift"
local red_point_path = "RedPoint"
local btn_path = "ClickButton"
local rect_text_path = "rect_text"

function UILWMailListItemCommon:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailListItemCommon:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailListItemCommon:ComponentDefine()
  self.readBg = self:AddComponent(UIBaseContainer, read_img_path)
  self.icon = self:AddComponent(UIImage, icon_img_path)
  self.nameText = self:AddComponent(UIText, name_txt_path)
  self.desText = self:AddComponent(UITextMeshProUGUIEx, des_txt_path)
  self.desTextLayout = self:AddComponent(UILayoutElement, des_txt_path)
  self.timeText = self:AddComponent(UIText, time_txt_path)
  self.giftIcon = self:AddComponent(UIBaseContainer, gift_img_path)
  self.redPoint = self:AddComponent(UIBaseContainer, red_point_path)
  self.rect_text = self:AddComponent(UIBaseContainer, rect_text_path)
  self.clickBtn = self:AddComponent(UIButton, btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnMailClick()
  end)
end

function UILWMailListItemCommon:ComponentDestroy()
  self.readBg = nil
  self.icon = nil
  self.nameText = nil
  self.desText = nil
  self.desTextLayout = nil
  self.timeText = nil
  self.giftIcon = nil
  self.redPoint = nil
  self.clickBtn = nil
  self.rect_text = nil
end

function UILWMailListItemCommon:DataDefine()
  self.mailData = {}
  self.mailUid = nil
end

function UILWMailListItemCommon:DataDestroy()
  self.mailData = nil
  self.mailUid = nil
end

function UILWMailListItemCommon:OnEnable()
  base.OnEnable(self)
end

function UILWMailListItemCommon:OnDisable()
  base.OnDisable(self)
end

function UILWMailListItemCommon:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailListItemCommon:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailListItemCommon:SetData(params)
  self.mailData = params.mail_data
  if not self.mailData then
    return
  end
  self.mailUid = self.mailData.uid
  if not self.mailUid then
    return
  end
  local mainTitle = MailShowHelper.GetMainTitle(self.mailData)
  mainTitle = string.gsub(mainTitle, "\n", "")
  mainTitle = ChatInterface.CheckMessage(mainTitle)
  mainTitle = MailShowHelper.GetTextWithHighlight(mainTitle, params.filter or "")
  mainTitle = string.trim(mainTitle)
  if self.mailData.type == MailType.MAIL_PRESIDENT_SEND or self.mailData.type == MailType.MAIL_PRESIDENT_SEND_EIGHT then
    self.nameText:SetText(Localization:GetString("457072") .. mainTitle)
  else
    self.nameText:SetText(mainTitle)
  end
  local subTitle = MailShowHelper.GetMailSubTitle(self.mailData)
  subTitle = MailShowHelper.GetTextWithHighlight(subTitle, params.filter or "")
  if not string.IsNullOrEmpty(subTitle) then
    self.desTextLayout:SetSizeDeltaY(200)
    self.desText:SetActive(true)
    self.desText:SetText(string.trim(subTitle))
    self.desText.unity_tmpro:ForceMeshUpdate()
    local textInfo = self.desText.unity_tmpro.textInfo
    local lineCount = textInfo.lineCount
    local textContentShowH = 0
    local lineMaxNum = 2
    for i = 0, lineCount - 1 do
      local lineInfo = textInfo.lineInfo[i]
      local height = lineInfo.lineHeight
      if i < lineMaxNum then
        textContentShowH = textContentShowH + height
      else
        break
      end
    end
    self.desTextLayout:SetPreferredHeight(textContentShowH)
    self.desTextLayout:SetMinHeight(textContentShowH)
  else
    self.desText:SetActive(false)
  end
  local createTime = MailShowHelper.GetRelativeCreateTime(self.mailData)
  self.timeText:SetText(createTime)
  self:RefreshRedPoint()
end

function UILWMailListItemCommon:RefreshRedPoint()
  local un_read = self.mailData.status ~= 1
  local has_reward = self.mailData.rewardStatus == 0
  self.readBg:SetActive(not un_read)
  self.giftIcon:SetActive(has_reward)
  if has_reward then
    self.redPoint:SetActive(false)
  else
    self.redPoint:SetActive(un_read)
  end
  local mailType = self.mailData.type
  local icon_path = "Assets/Main/Sprites/UI/UILWMail/"
  if MailShowHelper.IsSeasonBattleMail(mailType) then
    local data = self.mailData:GetMailExt()
    local player = data.player
    if player and 1 < #player then
      local thePlayer = player[2]
      if thePlayer.armyType == MailTargetType.SeasonDesert and thePlayer.meta and thePlayer.pic then
        self.icon:LoadSprite(thePlayer.pic)
        return
      elseif thePlayer.armyType == MailTargetType.SeasonBuilding and thePlayer.meta and thePlayer.pic then
        self.icon:LoadSprite(thePlayer.pic)
        return
      elseif thePlayer.armyType == MailTargetType.SeasonCenter and thePlayer.meta and thePlayer.pic then
        self.icon:LoadSprite(thePlayer.pic)
        return
      end
    end
  end
  if mailType == MailType.LW_ALLIANCE_GROUP_MAIL then
    local isR5 = false
    if self.mailData then
      local extra = self.mailData:GetMailMessageExtra()
      if tostring(extra) == "5" then
        isR5 = true
      end
    end
    if isR5 then
      self.icon:LoadSprite(icon_path .. (un_read and "od_mails_r5icon01.png" or "od_mails_r5icon02.png"))
    else
      self.icon:LoadSprite(icon_path .. (un_read and "zyf_youjianxitongyouhua_R4_icon2.png" or "zyf_youjianxitongyouhua_R4_icon1.png"))
    end
  elseif mailType == MailType.LW_Notice_Vote then
    self.icon:LoadSprite(ChatInterface.GetChatUIPath("ChatNotice/zyf_tongmenggonggao_gonggaokuang_icon.png"))
  elseif mailType == MailType.MAIL_ALLIANCE_MARK_ADD then
    local contentData = rapidjson.decode(self.mailData.contents)
    local data = contentData.obj
    local markType = data.markType
    local markIcon = DataCenter.WorldFavoDataManager:GetBookMapMarkIconName(markType)
    self.icon:LoadSprite(string.format(LoadPath.AllianceMark, markIcon))
  else
    self.icon:LoadSprite(icon_path .. (un_read and "lt_youjian_xin_guan.png" or "lt_youjian_xin_kai.png"))
  end
end

function UILWMailListItemCommon:OnMailClick()
  if GMUtils and GMUtils.GetBool(GMConst.DebugClickLogWarning, false) and self.mailData then
    local sb = StringBuilder.New()
    sb:Append("<color=#FFFF00>-----Mail Debug----</color>\n")
    sb:AppendFormatLine("uid: %s", tostring(self.mailData.uid))
    sb:AppendFormatLine("type: %s", tostring(self.mailData.type))
    sb:AppendFormatLine("groupId: %s", tostring(self.mailData.groupId))
    sb:AppendFormatLine("title: %s", tostring(self.mailData.title))
    sb:AppendFormatLine("subTitle: %s", tostring(self.mailData.subTitle))
    sb:AppendFormatLine("fromName: %s", tostring(self.mailData.fromName))
    sb:AppendFormatLine("status: %s", tostring(self.mailData.status))
    sb:AppendFormatLine("rewardStatus: %s", tostring(self.mailData.rewardStatus))
    sb:AppendFormatLine("saveFlag: %s", tostring(self.mailData.saveFlag))
    sb:AppendFormatLine("createTime: %s", tostring(self.mailData.createTime))
    Logger.LogWarning(sb:ToString())
  end
  if self.mailData.type == MailType.LW_Notice_Vote then
    local rapidjson = require("rapidjson")
    local json = rapidjson.decode(self.mailData.contents)
    local extra = json and json.b.extra
    local uuid = ""
    if type(extra) == "table" then
      uuid = extra.voteInfo.uuid
    elseif type(extra) == "string" then
      local extraData = rapidjson.decode(extra)
      uuid = extraData.voteInfo.uuid
    end
    local data = DataCenter.AllianceNoticeManager:GetNoticeDataById(uuid)
    self.view.ctrl:ReadOneMail(self.mailUid)
    if data then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIAllianceNoticeDetail, {anim = true}, {data = data, isTemp = true})
    else
      UIUtil.ShowTipsId("poll_notice_deleted")
    end
    return
  end
  if self.mailData.type == MailType.LW_SEASON_ALLIANCE_REWARD_MAIL then
    self.view.ctrl:SetCurrentMail(self.mailUid)
    UIManager.Instance:OpenWindow(UIWindowNames.UILWMailSeasonRewardView, {anim = true}, self.mailData.uid)
  else
    self.view.ctrl:SetCurrentView(3)
    self.view.ctrl:SetCurrentMail(self.mailUid)
    self.view.ctrl:ReadCurrentMail()
    self.view:ContentTrans()
  end
end

return UILWMailListItemCommon
