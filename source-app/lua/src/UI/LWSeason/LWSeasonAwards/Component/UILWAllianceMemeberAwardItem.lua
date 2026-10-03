local UILWAllianceMemeberAwardItem = BaseClass("UILWAllianceMemeberAwardItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
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

function UILWAllianceMemeberAwardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAllianceMemeberAwardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAllianceMemeberAwardItem:ComponentDefine()
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

function UILWAllianceMemeberAwardItem:ComponentDestroy()
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

function UILWAllianceMemeberAwardItem:DataDefine()
  self.data = {}
end

function UILWAllianceMemeberAwardItem:DataDestroy()
  self.data = nil
end

function UILWAllianceMemeberAwardItem:OnEnable()
  base.OnEnable(self)
end

function UILWAllianceMemeberAwardItem:OnDisable()
  base.OnDisable(self)
end

function UILWAllianceMemeberAwardItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKickAllianceMember, self.OnMemberKicked)
  self:AddUIListener(EventId.LWSeasonAllianceRewardMemberDetailInfo, self.RefreshMemberDetailInfo)
  self:AddUIListener(EventId.LWSeasonAllianceSettlementMemberRewardInfo, self.RefreshMemberDetailInfo)
end

function UILWAllianceMemeberAwardItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnKickAllianceMember, self.OnMemberKicked)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardMemberDetailInfo, self.RefreshMemberDetailInfo)
  self:RemoveUIListener(EventId.LWSeasonAllianceSettlementMemberRewardInfo, self.RefreshMemberDetailInfo)
end

function UILWAllianceMemeberAwardItem:OnMemberKicked(playerId)
  if self.data and self.data.uid and self.data.uid == playerId then
    self.gameObject:SetActive(false)
  end
end

function UILWAllianceMemeberAwardItem:RefreshMemberRewardInfo()
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

function UILWAllianceMemeberAwardItem:RefreshMemberDetailInfo(playerId)
  if self.data and self.data.uid and self.data.uid == playerId then
    self:RefreshMemberRewardInfo()
  end
end

function UILWAllianceMemeberAwardItem:SetData(data)
  self.data = data
  local userId = data.uid
  local userPic = data.pic
  local userPicVer = data.picVer
  self.playerIcon:SetData(userId, userPic, userPicVer, true, data.headBg)
  self.nameText:SetText(self.data.name)
  if self.data.uid == LuaEntry.Player.uid then
    self.nameText:SetColor(BlueColor)
  else
    self.nameText:SetColor(description1_color)
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
  self:RefreshMemberRewardInfo()
end

function UILWAllianceMemeberAwardItem:SetRewardIcon(rewardIndex)
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

function UILWAllianceMemeberAwardItem:OnClick()
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

return UILWAllianceMemeberAwardItem
