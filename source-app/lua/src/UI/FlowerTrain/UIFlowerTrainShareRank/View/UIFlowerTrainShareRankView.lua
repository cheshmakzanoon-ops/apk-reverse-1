local UIFlowerTrainShareRankView = BaseClass("UIFlowerTrainShareRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local SourceType = {
  SelfShare = 1,
  OtherChatClick = 2,
  ClickBagItem = 3
}
local panel_path = "panel"
local rank_icon_raw_img_path = "Root/RankIconRawImg"
local rank_icon_img_path = "Root/RankIcon"
local u_i_player_head_path = "Root/HeadPoint/UIPlayerHead"
local gender_male_img_path = "Root/NameArea/GenderMaleImg"
local gender_female_img_path = "Root/NameArea/GenderFemaleImg"
local nick_name_text_path = "Root/NameArea/NickNameText"
local power_val_text_path = "Root/PowerArea/PowerValText"
local rank_text_path = "Root/RankText"
local alliance_name_text_path = "Root/AllianceNameText"
local rank_name_info_path = "Root/RankNameInfo"
local share_btn_path = "Root/BtnArea/ShareBtn"
local ok_btn_path = "Root/BtnArea/OkBtn"
local like_btn_path = "Root/BtnArea/LikeBtn"
local heat_icon_path = "Root/SocialArea/Heat"
local heat_num_path = "Root/SocialArea/HeatNum"
local like_num_path = "Root/SocialArea/LikeNum"

function UIFlowerTrainShareRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIFlowerTrainShareRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainShareRankView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.panelCloseBtn = self:AddComponent(UIButton, panel_path)
  self.panelCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.rankIconRawImg = self:AddComponent(UIRawImage, rank_icon_raw_img_path)
  self.rankIconImg = self:AddComponent(UIImage, rank_icon_img_path)
  self.headItem = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.genderMaleIconImg = self:AddComponent(UIBaseComponent, gender_male_img_path)
  self.genderFemaleIconImg = self:AddComponent(UIBaseComponent, gender_female_img_path)
  self.nameText = self:AddComponent(UIText, nick_name_text_path)
  self.powerValText = self:AddComponent(UIText, power_val_text_path)
  self.rankText = self:AddComponent(UIText, rank_text_path)
  self.allianceNameText = self:AddComponent(UIText, alliance_name_text_path)
  self.rankNameText = self:AddComponent(UIText, rank_name_info_path)
  self.heat_icon = self:AddComponent(UIImage, heat_icon_path)
  self.heat_num = self:AddComponent(UITextMeshProUGUIEx, heat_num_path)
  self.like_num = self:AddComponent(UITextMeshProUGUIEx, like_num_path)
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
end

function UIFlowerTrainShareRankView:ComponentDestroy()
  self.viewSkin = nil
  self.rankIconRawImg = nil
  self.headItem = nil
  self.nameText = nil
  self.powerValText = nil
  self.rankText = nil
  self.allianceNameText = nil
  self.rankNameText = nil
  self.shareBtn = nil
  self.okBtn = nil
  self.likeBtn = nil
  self.like_num = nil
  self.heat_num = nil
  self.heat_icon = nil
  self.rankIconImg = nil
end

function UIFlowerTrainShareRankView:DataDefine()
  self.param = self:GetUserData()
  if self.param.sourceType == 3 then
    self:ParseDataWhenDataFromClickBag()
  end
end

function UIFlowerTrainShareRankView:ParseDataWhenDataFromClickBag()
  local serverData = rapidjson.decode(self.param.otherParam)
  if not serverData then
    return
  end
  local selfPlayerData = LuaEntry.Player
  self.param.aid = serverData.aid
  self.param.exp = serverData.exp
  self.param.praise = serverData.praise
  self.param.rank = serverData.rank
  self.param.trainItemId = serverData.trainItemId
  self.param.lv = serverData.lv
  self.param.uid = selfPlayerData.uid
  self.param.pic = selfPlayerData.pic
  self.param.picVer = selfPlayerData.picVer
  self.param.name = selfPlayerData.name
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  self.param.allianceAbbrName = allianceData and allianceData.abbr or ""
  self.param.allianceName = allianceData and allianceData.allianceName or ""
  self.param.power = selfPlayerData.power
  self.param.gender = selfPlayerData.gender
end

function UIFlowerTrainShareRankView:DataDestroy()
end

function UIFlowerTrainShareRankView:OnAddListener()
  base.OnAddListener(self)
end

function UIFlowerTrainShareRankView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFlowerTrainShareRankView:ReInit()
  self:RefreshRankInfo()
  self:RefreshHeadInfo()
  self:RefreshButtonState()
  self:RefreshSocialInfo()
  self:RefreshSkin()
end

function UIFlowerTrainShareRankView:RefreshRankInfo()
  self.showData = FlowerTrainUtils.GetFlowerTrainDisplayMetaByGoodsId(self.param.trainItemId, self.param.lv)
  self.rankIconRawImg:LoadSpriteAsync(self.showData.pic4, function()
    self.rankIconRawImg:SetNativeSize()
  end)
  self.rankIconImg:LoadSprite(self.showData.level_icon)
  local name = "2025halloween_memorialplaque_name"
  local trainItemId = self.param.trainItemId
  if trainItemId then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(trainItemId)
    if itemTemplate then
      name = itemTemplate.name
    end
  end
  self.rankNameText:SetLocalText(name)
  if not self.param.rank or toInt(self.param.rank) <= 0 then
    self.rankText:SetText(Localization:GetString("2025halloween_memorialplaque_tips1", Localization:GetString("361054")))
  else
    self.rankText:SetText(Localization:GetString("2025halloween_memorialplaque_tips1", self.param.rank))
  end
  self.powerValText:SetText(self.param.power)
end

function UIFlowerTrainShareRankView:RefreshHeadInfo()
  self.headItem:SetData(self.param.uid, self.param.pic, self.param.picVer)
  self.headItem:SetEnableClickShowInfo(true)
  self.nameText:SetText(self.param.name)
  if not string.IsNullOrEmpty(self.param.allianceAbbrName) and not string.IsNullOrEmpty(self.param.allianceName) then
    self.allianceNameText:SetText("[" .. self.param.allianceAbbrName .. "]" .. self.param.allianceName)
  else
    self.allianceNameText:SetText("")
  end
  if self.param.gender then
    self.genderMaleIconImg:SetActive(self.param.gender == 1)
    self.genderFemaleIconImg:SetActive(self.param.gender == 2)
  end
end

function UIFlowerTrainShareRankView:RefreshSocialInfo()
  local path = FlowerTrainUtils.GetFlowerTrainFireImgPathByGoodsId(self.param.trainItemId, self.param.exp)
  self.heat_icon:LoadSprite(path)
  self.like_num:SetText(self.param.praise or 0)
  self.heat_num:SetText(self.param.exp or 0)
end

function UIFlowerTrainShareRankView:ShareBtnClick()
  local stage_share_time = CommonUtil.PlayerPrefsGetLong(SettingKeys.FLOWER_TRAIN_RANK_CARD_SHARE_TIME, 0)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaMinTime = 300000
  if curTime <= stage_share_time + deltaMinTime then
    UIUtil.ShowTips(Localization:GetString("breakthough_tips_03"))
    return
  end
  local share_param = {}
  share_param.sid = LuaEntry.Player:GetSelfServerId()
  share_param.post = PostType.FLOWER_TRAIN_SHARE
  share_param.postType = PostType.FLOWER_TRAIN_SHARE
  local cardParam = {}
  cardParam.uid = self.param.uid
  cardParam.pic = self.param.pic
  cardParam.picVer = self.param.picVer
  cardParam.name = self.param.name
  cardParam.allianceAbbrName = self.param.allianceAbbrName
  cardParam.allianceName = self.param.allianceName
  cardParam.aid = self.param.aid
  cardParam.exp = self.param.exp
  cardParam.praise = self.param.praise
  cardParam.lv = self.param.lv
  cardParam.trainItemId = self.param.trainItemId
  cardParam.rank = self.param.rank
  cardParam.power = self.param.power
  cardParam.gender = self.param.gender
  share_param.param = cardParam
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function UIFlowerTrainShareRankView:ConfirmBtnClick()
  self.ctrl:CloseSelf()
end

function UIFlowerTrainShareRankView:LikeBtnClick()
  self.ctrl:CloseSelf()
  local thePlayerUid = self.param.uid
  InteractiveUtil.TryThumbsUp(thePlayerUid, InteractiveUtil.ThumbsUpType.PlayerInfo, "PlayerDetailMain", function()
  end)
end

function UIFlowerTrainShareRankView:RefreshButtonState()
  local isSelf = false
  if self.param.uid == LuaEntry.Player.uid then
    isSelf = true
  end
  self.shareBtn:SetActive(self.param.sourceType == SourceType.SelfShare)
  self.okBtn:SetActive(self.param.sourceType == SourceType.OtherChatClick)
  self.likeBtn:SetActive(self.param.sourceType == SourceType.OtherChatClick and not isSelf)
end

function UIFlowerTrainShareRankView:RefreshSkin()
  if not self.param.trainItemId then
    return
  end
  local paraMeta = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(self.param.trainItemId)
  if not paraMeta or string.IsNullOrEmpty(paraMeta.share_rank_panel_cfg) then
    return
  end
  FlowerTrainUtils.GeneratePanelDeco(self, paraMeta.share_rank_panel_cfg)
end

return UIFlowerTrainShareRankView
