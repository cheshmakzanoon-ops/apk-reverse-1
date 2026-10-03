local UILWDetectEventTreasureClaimPlayerItemRender = BaseClass("UILWDetectEventTreasureClaimPlayerItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local player_head_path = "PlayerHead"
local player_level_text_path = "HorLayout/PlayerLevelText"
local player_gender_icon_path = "HorLayout/PlayerLevelText/PlayerGenderIcon"
local get_lucky_btn_path = "HorLayout/PlayerLevelText/GetLuckyButton"
local player_name_text_path = "PlayerNameText"
local speed_text_path = "SpeedText"
local double_mark_path = "DoubleMark"
local speed_tips_text_path = "SpeedTipsText"

function UILWDetectEventTreasureClaimPlayerItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWDetectEventTreasureClaimPlayerItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDetectEventTreasureClaimPlayerItemRender:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.player_level_text = self:AddComponent(UITextMeshProUGUIEx, player_level_text_path)
  self.player_gender_icon = self:AddComponent(UIImage, player_gender_icon_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.speed_text = self:AddComponent(UITextMeshProUGUIEx, speed_text_path)
  self.double_mark = self:AddComponent(UIImage, double_mark_path)
  self.speed_tips_text = self:AddComponent(UITextMeshProUGUIEx, speed_tips_text_path)
  self.speed_tips_text:SetLocalText("radar_title_3")
  self.get_lucky_btn = self:AddComponent(UIButton, get_lucky_btn_path)
  self.get_lucky_btn:SetOnClick(function()
    self:OnBtnLuckyClick()
  end)
end

function UILWDetectEventTreasureClaimPlayerItemRender:ComponentDestroy()
  self.bg = nil
  self.player_head = nil
  self.player_level_text = nil
  self.player_gender_icon = nil
  self.player_name_text = nil
  self.speed_text = nil
  self.double_mark = nil
  self.speed_tips_text = nil
  self.get_lucky_btn = nil
end

function UILWDetectEventTreasureClaimPlayerItemRender:ReInit(data)
  self.data = data
  if self.data.uid == LuaEntry.Player.uid then
    self.bg:SetColorRGBA(0.6862, 1, 0.3725, 0.5019)
  else
    self.bg:SetColorRGBA(1, 1, 1, 0.5)
  end
  self.player_head:SetHeadAndFrame(self.data.uid, self.data.headPic, self.data.headPicVer, nil, self.data.headSkinId, self.data.headSkinET)
  self.player_level_text:SetText("Lv." .. self.data.level)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.uid, self.data.name)
  self.player_name_text:SetText(showName)
  if self.data.isBigReward then
    local iconName = RewardMultipleIcon[self.data.bigRewardMultiple] or "mjc_leida_wajuejilu_jinli"
    self.double_mark:LoadSpriteAuto(string.format(LoadPath.RadarCenterPath, iconName))
    self.double_mark:SetActive(true)
  else
    self.double_mark:SetActive(false)
  end
  if self.data.gender == 0 or self.data.gender == 3 then
    self.player_gender_icon:SetActive(false)
  else
    self.player_gender_icon:SetActive(true)
    local gender_img_path = "Assets/Main/Sprites/UI/UILWAlliance/"
    self.player_gender_icon:LoadSprite(gender_img_path .. (self.data.gender == 2 and "cfm_lianmeng_tubiao_nv" or "cfm_lianmeng_tubiao_nan"))
  end
  if self.data.hasLuckSiphonbuff ~= nil and self.data.hasLuckSiphonbuff then
    self.get_lucky_btn:SetActive(true)
  else
    self.get_lucky_btn:SetActive(false)
  end
  local seconds = self.data.costTime / 1000
  if 60 <= seconds then
    self.speed_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(self.data.costTime))
  else
    local str = string.format("%.3f", seconds)
    self.speed_text:SetText(Localization:GetString("130076", str))
  end
end

function UILWDetectEventTreasureClaimPlayerItemRender:OnBtnLuckyClick()
  if not self.tips_node then
    self.tips_node = self.get_lucky_btn:AddComponent(UIBaseComponent, "Content/TipsNode")
  end
  self.view:ShowLuckyBuffFromTips(self.data.luckSiphonbuffSenderInfo, self.tips_node.transform.position)
end

return UILWDetectEventTreasureClaimPlayerItemRender
