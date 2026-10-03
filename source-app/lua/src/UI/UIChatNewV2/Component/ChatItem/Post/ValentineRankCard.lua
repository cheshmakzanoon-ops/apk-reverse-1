local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_ValentineRankCard = BaseClass("ChatItemPost_ValentineRankCard", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local StarItem = require("UI.UIActivityCenterTable.Component.UIActValentine.Component.ValentineStarItemComponent")
local ActivityValentineRankTemplate = require("DataCenter.ValentineDataManager.ActivityValentineRankTemplate")
local player_name_text_path = "Content/PlayerNameText"
local u_i_player_head_path = "Content/PlayHeadPoint/UIPlayerHead"
local rank_text_path = "Content/RankText"
local rank_icon_path = "Content/RankIcon"
local valentine_star_item_path = "Content/ValentineStarItem"
local click_btn_path = "Content/ClickBtn"
local bg_path = "Content/Bg"
local night_mask_path = "NightMask"

function ChatItemPost_ValentineRankCard:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_ValentineRankCard:OnDestroy()
  base.OnDestroy(self)
end

function ChatItemPost_ValentineRankCard:ComponentDefine()
  self.playerNameText = self:AddComponent(UIText, player_name_text_path)
  self.headItem = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.headItem:SetEnableClickShowInfo(true)
  self.rankNameText = self:AddComponent(UIText, rank_text_path)
  self.rankIconRawImg = self:AddComponent(UIRawImage, rank_icon_path)
  self.starInfoItem = self:AddComponent(StarItem, valentine_star_item_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OpenShareRankView()
  end)
  self.bgRowImg = self:AddComponent(UIRawImage, bg_path)
  self.nightMask = self:AddComponent(UIImage, night_mask_path)
end

function ChatItemPost_ValentineRankCard:ComponentDestroy()
  self.playerNameText = nil
  self.playerHead = nil
  self.rankText = nil
  self.rankIcon = nil
  self.starItem = nil
  self.nightMask = nil
end

function ChatItemPost_ValentineRankCard:OnLoaded()
  local chatData = self:ChatData()
  if not chatData then
    return
  end
  if not chatData.attachmentId then
    return
  end
  local attachJson = rapidjson.decode(chatData.attachmentId)
  if not attachJson or table.count(attachJson) <= 0 then
    return
  end
  if not attachJson.uid then
    return
  end
  self.param = {}
  self.param.uid = attachJson.uid
  self.param.pic = attachJson.pic
  self.param.picVer = attachJson.picVer
  self.param.name = attachJson.name
  self.param.allianceAbbrName = attachJson.allianceAbbrName
  self.param.allianceName = attachJson.allianceName
  self.param.rank = attachJson.rank
  self.param.curRankId = attachJson.curRankId
  self.param.power = attachJson.power
  self.param.gender = attachJson.gender
  self.param.activityId = attachJson.activityId
  self:RefreshUI()
end

function ChatItemPost_ValentineRankCard:RefreshUI()
  self:RefreshRankInfo()
  self:RefreshPlayerInfo()
  self:RefreshBGImgByActivityId()
end

function ChatItemPost_ValentineRankCard:RefreshRankInfo()
  local rankId = self.param.curRankId
  local lineData = LocalController:instance():getLine(TableName.ValentineRank, rankId)
  if not lineData then
    return
  end
  local rankData = ActivityValentineRankTemplate.New()
  rankData:UpdateData(lineData)
  local path = string.format(rankData.icon)
  self.rankIconRawImg:LoadSprite(path)
  self.rankIconRawImg:SetNativeSize()
  self.rankNameText:SetLocalText(rankData.key_big)
  self.starInfoItem:RefreshByRankData(rankData)
end

function ChatItemPost_ValentineRankCard:RefreshPlayerInfo()
  self.headItem:SetData(self.param.uid, self.param.pic, self.param.picVer)
  local showName = UIUtil.FormatAllianceAndName(self.param.allianceAbbrName, self.param.name)
  self.playerNameText:SetText(showName)
end

function ChatItemPost_ValentineRankCard:OnRecycle()
  self.data = nil
end

function ChatItemPost_ValentineRankCard:OpenShareRankView()
  if not self.param then
    return
  end
  local param = {}
  param.sourceType = 2
  param.uid = self.param.uid
  param.pic = self.param.pic
  param.picVer = self.param.picVer
  param.name = self.param.name
  param.allianceAbbrName = self.param.allianceAbbrName
  param.allianceName = self.param.allianceName
  param.rank = self.param.rank
  param.curRankId = self.param.curRankId
  param.power = self.param.power
  param.gender = self.param.gender
  param.activityId = self.param.activityId
  UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineShareRank, {anim = true}, param)
end

function ChatItemPost_ValentineRankCard:RefreshBGImgByActivityId()
  if not self.param or not self.param.activityId then
    return
  end
  local getTmp = DataCenter.ValentineDataManager:GetGetTmpDataByActivityId(toInt(self.param.activityId))
  if not getTmp then
    return
  end
  if string.IsNullOrEmpty(getTmp.res_message) then
    return
  end
  self.bgRowImg:LoadSpriteAsyncWithCallback(getTmp.res_message, function()
    self.bgRowImg:SetNativeSize()
  end)
  local isNight = ChatInterface.GetChatTheme() == ChatUIThemeConfig.ChatMode.Night
  self.nightMask:SetActive(isNight)
end

return ChatItemPost_ValentineRankCard
