local UILWAllianceMemberRankAwardItem = BaseClass("UILWAllianceMemberRankAwardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local player_btn_path = "PlayerBtn/UIPlayerHead"
local player_icon_path = "PlayerBtn/UIPlayerHead"
local gender_icon_path = "GenderIcon"
local name_txt_path = "NameText"
local power_txt_path = "PowerText"
local lv_text_path = "LvText"
local online_txt_path = "OnLineText"
local click_btn_path = "UseBtn"
local click_btn_text_path = "UseBtn/UseText"
local in_active_icon_path = "InActiveIcon"
local reward_btn_path = "rewardBtn"
local reward_icon_path = "rewardBtn/rewardIcon"
local already_get_path = "alreadyGet"
local farmer_icon_path = "farmerIcon"
local USE_BTN_TXT = "season_reward_ui_011"
local MALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nan.png"
local FEMALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nv.png"
local bg_path = "bg"
local first_img_path = "firstImg"
local second_img_path = "secondImg"
local third_img_path = "thirdImg"
local num_txt_path = "numTxt"
local num_txt2_path = "numTxt2"

function UILWAllianceMemberRankAwardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAllianceMemberRankAwardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAllianceMemberRankAwardItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.first_img = self:AddComponent(UIImage, first_img_path)
  self.second_img = self:AddComponent(UIImage, second_img_path)
  self.third_img = self:AddComponent(UIImage, third_img_path)
  self.num_txt = self:AddComponent(UITextMeshProUGUIEx, num_txt_path)
  self.num_txt2 = self:AddComponent(UITextMeshProUGUIEx, num_txt2_path)
  self.playerIcon = self:AddComponent(UICommonHead, player_icon_path)
  self.genderIcon = self:AddComponent(UIImage, gender_icon_path)
  self.nameText = self:AddComponent(UIText, name_txt_path)
  self.powerText = self:AddComponent(UIText, power_txt_path)
  self.lv_text = self:AddComponent(UIText, lv_text_path)
  self.onLineText = self:AddComponent(UIText, online_txt_path)
  self.in_active_icon = self:AddComponent(UIBaseContainer, in_active_icon_path)
  self.already_get = self:AddComponent(UIText, already_get_path)
  self.already_get:SetActive(false)
  self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
  self.farmer_icon = self:AddComponent(UIImage, farmer_icon_path)
  self.reward_btn:SetOnClick(function()
    self:OnClick()
  end)
  self.reward_icon = self:AddComponent(UIImage, reward_icon_path)
  self.clickTextBtn = self:AddComponent(UIText, click_btn_text_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.playerBtn = self:AddComponent(UIButton, player_btn_path)
  self.playerBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.data.uid)
  end)
  self.clickTextBtn:SetLocalText(USE_BTN_TXT)
  self.farmer_icon:SetActive(false)
end

function UILWAllianceMemberRankAwardItem:ComponentDestroy()
  self.bg = nil
  self.first_img = nil
  self.second_img = nil
  self.third_img = nil
  self.num_txt = nil
  self.num_txt2 = nil
  self.farmer_icon = nil
  self.playerIcon = nil
  self.genderIcon = nil
  self.nameText = nil
  self.powerText = nil
  self.lv_text = nil
  self.onLineText = nil
  self.clickTextBtn = nil
  self.clickBtn = nil
  self.reward_btn = nil
  self.reward_icon = nil
  self.already_get = nil
end

function UILWAllianceMemberRankAwardItem:DataDefine()
  self.data = {}
end

function UILWAllianceMemberRankAwardItem:DataDestroy()
  self.data = nil
end

function UILWAllianceMemberRankAwardItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKickAllianceMember, self.OnMemberKicked)
  self:AddUIListener(EventId.LWSeasonAllianceRewardMemberDetailInfo, self.RefreshMemberDetailInfo)
  self:AddUIListener(EventId.LWSeasonAllianceSettlementMemberRewardInfo, self.RefreshMemberDetailInfo)
end

function UILWAllianceMemberRankAwardItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnKickAllianceMember, self.OnMemberKicked)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardMemberDetailInfo, self.RefreshMemberDetailInfo)
  self:RemoveUIListener(EventId.LWSeasonAllianceSettlementMemberRewardInfo, self.RefreshMemberDetailInfo)
end

function UILWAllianceMemberRankAwardItem:OnMemberKicked(playerId)
  if self.data and self.data.uid and self.data.uid == playerId then
    self.gameObject:SetActive(false)
  end
end

function UILWAllianceMemberRankAwardItem:RefreshMemberRewardInfo()
  local rewardIndex = DataCenter.SeasonRewardDataManager:GetAllianceReweardMemberAssignedRewardIndex(self.data.uid)
  local alreadyGet = DataCenter.SeasonRewardDataManager:CheckMemberAlreadyGetReward(self.data.uid)
  local hasReward = rewardIndex and rewardIndex ~= 0
  self.clickBtn:SetActive(not hasReward)
  self.reward_icon:SetActive(hasReward and rewardIndex ~= 4)
  self.already_get:SetActive(hasReward and rewardIndex == 4 and alreadyGet)
  if hasReward and not rewardIndex ~= 4 then
    self:SetRewardIcon(rewardIndex)
  end
end

function UILWAllianceMemberRankAwardItem:RefreshMemberDetailInfo(playerId)
  if self.data and self.data.uid and self.data.uid == playerId then
    self:RefreshMemberRewardInfo()
  end
end

function UILWAllianceMemberRankAwardItem:SetData(event_rank, data)
  self.data = data
  local userId = data.uid
  local userPic = data.pic
  local userPicVer = data.picVer
  self.playerIcon:SetData(userId, userPic, userPicVer, true, data.headBg)
  self.nameText:SetText(self.data.name)
  if self.data.uid == LuaEntry.Player.uid then
    self.nameText:SetColor(BlueColor)
  else
    self.nameText:SetColorHex("#2a2830")
  end
  self.genderIcon:SetActive(false)
  if self.data.gender and self.data.gender > 0 then
    if self.data.gender == 1 then
      self.genderIcon:SetActive(true)
      self.genderIcon:LoadSprite(MALE_ICON_PATH)
    elseif self.data.gender == 2 then
      self.genderIcon:LoadSprite(FEMALE_ICON_PATH)
    end
  end
  self.powerText:SetText(Localization:GetString("100253") .. string.GetFormattedSpecial(self.data.power))
  self.lv_text:SetLocalText(320439, self.data.mainCityLv)
  self.in_active_icon:SetActive(self.data.isInactive)
  if self.data.seasonRole == 1 then
    self.farmer_icon:SetActive(true)
    self.in_active_icon:SetActive(false)
  else
    self.farmer_icon:SetActive(false)
  end
  if self.data.isSelfAlliance then
    self.onLineText:SetActive(true)
    self.onLineText:SetText(self.data.online_time)
    if self.data.isOnline then
      self.onLineText:SetColor(Color.New(0.3607843137254902, 0.8156862745098039, 0.6509803921568628, 1))
    else
      self.onLineText:SetColor(Color.New(0.49, 0.49, 0.49, 1))
    end
  else
    self.onLineText:SetActive(false)
  end
  self.clickBtn:SetActive(false)
  if event_rank == 1 or event_rank == 2 or event_rank == 3 then
    self.bg:SetActive(true)
    self.first_img:SetActive(event_rank == 1)
    self.second_img:SetActive(event_rank == 2)
    self.third_img:SetActive(event_rank == 3)
    self.num_txt:SetActive(true)
    self.num_txt2:SetActive(false)
    self.num_txt:SetText(tostring(event_rank))
    if event_rank == 1 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_1.png")
    elseif event_rank == 2 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_2.png")
    elseif event_rank == 3 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_3.png")
    end
  else
    self.bg:SetActive(true)
    self.first_img:SetActive(false)
    self.second_img:SetActive(false)
    self.third_img:SetActive(false)
    self.num_txt:SetActive(false)
    self.num_txt2:SetActive(true)
    self.num_txt2:SetText(tostring(event_rank))
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_4.png")
  end
  self:RefreshMemberRewardInfo()
end

function UILWAllianceMemberRankAwardItem:SetRewardIcon(rewardIndex)
  local index = 1
  if rewardIndex == 1 then
    index = 3
  elseif rewardIndex == 3 then
    index = 1
  elseif rewardIndex == 5 then
    index = 4
  else
    index = 2
  end
  local iconPath = string.format(LoadPath.SeasonReward, "Mjc_saijijiangli_fajiang_box" .. index)
  self.reward_icon:LoadSprite(iconPath)
end

function UILWAllianceMemberRankAwardItem:OnClick()
  if DataCenter.SeasonRewardDataManager:CheckDistributeAuthority() then
    if DataCenter.SeasonRewardDataManager:SeasonRewardAllPublished() then
      UIUtil.ShowTipsId("season_extra_tips_11")
      return
    end
    if self.data.seasonRole == 1 then
      UIUtil.ShowTipsId("season_builders_alliance_tips_13")
      return
    end
    local alreadyGet = DataCenter.SeasonRewardDataManager:CheckMemberAlreadyGetReward(self.data.uid)
    if not alreadyGet then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonDistributeAward, {anim = false}, self.data)
    else
      UIUtil.ShowTipsId("361027")
    end
  else
    UIUtil.ShowTipsId("season_extra_tips_13")
  end
end

return UILWAllianceMemberRankAwardItem
