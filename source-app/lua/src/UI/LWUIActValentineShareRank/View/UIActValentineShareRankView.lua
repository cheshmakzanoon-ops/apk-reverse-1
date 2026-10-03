local UIActValentineShareRankView = BaseClass("UIActValentineShareRankView", UIBaseView)
local StarInfoItem = require("UI.UIActivityCenterTable.Component.UIActValentine.Component.ValentineStarItemComponent")
local ActivityValentineRankTemplate = require("DataCenter.ValentineDataManager.ActivityValentineRankTemplate")
local rapidjson = require("rapidjson")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local maleIconPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/cfm_lianmeng_tubiao_nan.png"
local femaleIconPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/cfm_lianmeng_tubiao_nv.png"
local SourceType = {
  SelfShare = 1,
  OtherChatClick = 2,
  ClickBagItem = 3
}
local panel_path = "panel"
local rank_icon_raw_img_path = "Root/RankIconRawImg"
local valentine_star_item_path = "Root/ValentineStarItem"
local u_i_player_head_path = "Root/HeadPoint/UIPlayerHead"
local gender_img_path = "Root/NameArea/GenderImg"
local nick_name_text_path = "Root/NameArea/NickNameText"
local power_val_text_path = "Root/PowerArea/PowerValText"
local rank_text_path = "Root/RankText"
local alliance_name_text_path = "Root/AllianceNameText"
local rank_name_info_path = "Root/RankNameInfo"
local share_btn_path = "Root/BtnArea/ShareBtn"
local ok_btn_path = "Root/BtnArea/OkBtn"
local like_btn_path = "Root/BtnArea/LikeBtn"
local b_g_path = "Root/BG"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.param = self:GetUserData()
  if self.param.sourceType == 3 then
    self:ParseDataWhenDataFromClickBag()
  end
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panelCloseBtn = self:AddComponent(UIButton, panel_path)
  self.panelCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.rankIconRawImg = self:AddComponent(UIRawImage, rank_icon_raw_img_path)
  self.starInfoItem = self:AddComponent(StarInfoItem, valentine_star_item_path)
  self.headItem = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.genderIconImg = self:AddComponent(UIImage, gender_img_path)
  self.nameText = self:AddComponent(UIText, nick_name_text_path)
  self.powerValText = self:AddComponent(UIText, power_val_text_path)
  self.rankText = self:AddComponent(UIText, rank_text_path)
  self.allianceNameText = self:AddComponent(UIText, alliance_name_text_path)
  self.rankNameText = self:AddComponent(UIText, rank_name_info_path)
  self.shareBtn = self:AddComponent(UIButton, share_btn_path)
  self.shareBtn:SetOnClick(function()
    self:ShareBtnClick()
  end)
  self.okBtn = self:AddComponent(UIButton, ok_btn_path)
  self.okBtn:SetOnClick(function()
    self:ConfirmBtnClick()
  end)
  self.likeBtn = self:AddComponent(UIButton, like_btn_path)
  self.likeBtn:SetOnClick(function()
    self:LikeBtnClick()
  end)
  self.bgRowImg = self:AddComponent(UIRawImage, b_g_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIActValentineShareRankView:ReInit()
  self:RefreshRankInfo()
  self:RefreshHeadInfo()
  self:RefreshButtonState()
  self:RefreshBGByActivityId()
end

function UIActValentineShareRankView:RefreshBGByActivityId()
  local activityId
  if self.param and self.param.activityId then
    activityId = self.param.activityId
  end
  if not activityId then
    return
  end
  local getTmp = DataCenter.ValentineDataManager:GetGetTmpDataByActivityId(toInt(activityId))
  if not getTmp or string.IsNullOrEmpty(getTmp.res_bigrank) then
    return
  end
  self.bgRowImg:LoadSpriteAsync(getTmp.res_bigrank)
end

function UIActValentineShareRankView:ParseDataWhenDataFromClickBag()
  local serverData = rapidjson.decode(self.param.otherParam)
  if not serverData then
    return
  end
  local selfPlayerData = LuaEntry.Player
  self.param.curRankId = serverData.rankId
  self.param.rank = serverData.rank
  self.param.uid = selfPlayerData.uid
  self.param.pic = selfPlayerData.pic
  self.param.picVer = selfPlayerData.picVer
  self.param.name = selfPlayerData.name
  self.param.allianceAbbrName = selfPlayerData.allianceAbbrName
  self.param.allianceName = selfPlayerData.allianceName
  self.param.power = selfPlayerData.power
  self.param.gender = selfPlayerData.gender
  self.param.activityId = serverData.aid
end

function UIActValentineShareRankView:RefreshRankInfo()
  local rankId = self.param.curRankId
  if not rankId then
    return
  end
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
  local rankStr = Localization:GetString("activity_99136_9")
  if not self.param.rank or toInt(self.param.rank) <= 0 then
    self.rankText:SetText(string.format("%s: %s", rankStr, Localization:GetString("361054")))
  else
    self.rankText:SetText(string.format("%s: %s", rankStr, self.param.rank))
  end
  self.powerValText:SetText(self.param.power)
end

function UIActValentineShareRankView:RefreshHeadInfo()
  self.headItem:SetData(self.param.uid, self.param.pic, self.param.picVer)
  self.headItem:SetEnableClickShowInfo(true)
  self.nameText:SetText(self.param.name)
  if not string.IsNullOrEmpty(self.param.allianceAbbrName) and not string.IsNullOrEmpty(self.param.allianceName) then
    self.allianceNameText:SetText("[" .. self.param.allianceAbbrName .. "]" .. self.param.allianceName)
  else
    self.allianceNameText:SetText("")
  end
  if self.param.gender then
    if self.param.gender == 2 then
      self.genderIconImg:SetActive(true)
      self.genderIconImg:LoadSprite(femaleIconPath)
    elseif self.param.gender == 1 then
      self.genderIconImg:SetActive(true)
      self.genderIconImg:LoadSprite(maleIconPath)
    else
      self.genderIconImg:SetActive(false)
    end
    self.genderIconImg:SetNativeSize()
  end
end

function UIActValentineShareRankView:ShareBtnClick()
  local stage_share_time = CommonUtil.PlayerPrefsGetLong(SettingKeys.VALENTINE_RANK_CARD_SHARE_TIME, 0)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaMinTime = 300000
  if self.param and self.param.activityId then
    local getTmp = DataCenter.ValentineDataManager:GetGetTmpDataByActivityId(toInt(self.param.activityId))
    if getTmp and getTmp.share_cd then
      deltaMinTime = getTmp.share_cd * 1000
    end
  end
  if curTime <= stage_share_time + deltaMinTime then
    UIUtil.ShowTips(Localization:GetString("390886", UITimeManager:GetInstance():MilliSecondToFmtString(stage_share_time + deltaMinTime - curTime)))
    return
  end
  local activityId = self.param.activityId
  local rData = DataCenter.ValentineDataManager:GetActivityReceiveData(activityId)
  local small_msg
  if rData then
    local getData = rData.activityGetData
    small_msg = getData.small_msg
  end
  local share_param = {}
  share_param.sid = LuaEntry.Player:GetSelfServerId()
  share_param.post = PostType.ValentineRankCard
  share_param.postType = PostType.ValentineRankCard
  local cardParam = {}
  cardParam.small_msg = small_msg
  cardParam.uid = self.param.uid
  cardParam.pic = self.param.pic
  cardParam.picVer = self.param.picVer
  cardParam.name = self.param.name
  cardParam.allianceAbbrName = self.param.allianceAbbrName
  cardParam.allianceName = self.param.allianceName
  cardParam.rank = self.param.rank
  cardParam.curRankId = self.param.curRankId
  cardParam.power = self.param.power
  cardParam.gender = self.param.gender
  cardParam.activityId = self.param.activityId
  share_param.param = cardParam
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function UIActValentineShareRankView:ConfirmBtnClick()
  self.ctrl:CloseSelf()
end

function UIActValentineShareRankView:LikeBtnClick()
  self.ctrl:CloseSelf()
  local thePlayerUid = self.param.uid
  InteractiveUtil.TryThumbsUp(thePlayerUid, InteractiveUtil.ThumbsUpType.PlayerInfo, "PlayerDetailMain", function()
  end)
end

function UIActValentineShareRankView:RefreshButtonState()
  local isSelf = false
  if self.param.uid == LuaEntry.Player.uid then
    isSelf = true
  end
  self.shareBtn:SetActive(self.param.sourceType == SourceType.SelfShare)
  self.okBtn:SetActive(self.param.sourceType == SourceType.OtherChatClick)
  self.likeBtn:SetActive(self.param.sourceType == SourceType.OtherChatClick and not isSelf)
end

UIActValentineShareRankView.OnCreate = OnCreate
UIActValentineShareRankView.OnDestroy = OnDestroy
UIActValentineShareRankView.OnEnable = OnEnable
UIActValentineShareRankView.OnDisable = OnDisable
UIActValentineShareRankView.ComponentDefine = ComponentDefine
UIActValentineShareRankView.ComponentDestroy = ComponentDestroy
UIActValentineShareRankView.DataDefine = DataDefine
UIActValentineShareRankView.DataDestroy = DataDestroy
UIActValentineShareRankView.OnAddListener = OnAddListener
UIActValentineShareRankView.OnRemoveListener = OnRemoveListener
return UIActValentineShareRankView
