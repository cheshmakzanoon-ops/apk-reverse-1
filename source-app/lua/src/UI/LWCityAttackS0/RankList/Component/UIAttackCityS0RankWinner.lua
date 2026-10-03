local UIAttackCityS0RankWinner = BaseClass("UIAttackCityS0RankWinner", UIBaseContainer)
local base = UIBaseContainer
local RewardUtil = require("Util.RewardUtil")
local Localization = CS.GameEntry.Localization
local img_head_path = "imgHead"
local txt_name_path = "txtName"
local txt_score_path = "txtScore"
local btn_head_path = "btnHead"
local like_path = "like"
local like_count_text_path = "like/likeCountText"
local dian_zan_effect_path = "DianZanEffect"
local hand_path = "DianZanEffect/Hand"
local diamond_path = "DianZanEffect/Diamond"
local score_span = 1000000

function UIAttackCityS0RankWinner:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAttackCityS0RankWinner:OnDestroy()
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self:ComponentDestroy()
  self.data = nil
  base.OnDestroy(self)
end

function UIAttackCityS0RankWinner:ComponentDefine()
  self.img_head = self:AddComponent(UIBaseContainer, img_head_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.txt_score = self:AddComponent(UITextMeshProUGUIEx, txt_score_path)
  self.btn_head = self:AddComponent(UIButton, btn_head_path)
  self.like = self:AddComponent(UIButton, like_path)
  self.like_count_text = self:AddComponent(UITextMeshProUGUIEx, like_count_text_path)
  self.dian_zan_effect = self:AddComponent(UIBaseContainer, dian_zan_effect_path)
  self.hand = self:AddComponent(UIImage, hand_path)
  self.diamond = self:AddComponent(UIBaseContainer, diamond_path)
  self.rewardIcon = self:AddComponent(UIImage, "Reward/Icon")
  self.rewardNum = self:AddComponent(UITextMeshProUGUIEx, "Reward/Num")
  self.compPlayerHead = self.transform:Find(img_head_path):GetComponent(typeof(CS.UIPlayerHead))
  self.like:SetOnClick(function()
    if self.data and self.data.roleInfo.uid then
      self:OnLikClick()
    end
  end)
  self.dian_zan_effect:SetActive(false)
  self.btn_head:SetOnClick(function()
    if self.data and self.data.roleInfo.uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.roleInfo.uid)
    end
  end)
end

function UIAttackCityS0RankWinner:ComponentDestroy()
  self.data = nil
  self.rewardIcon = nil
  self.rewardNum = nil
  self.img_head = nil
  self.txt_name = nil
  self.btn_head = nil
  self.like = nil
  self.txt_score = nil
  self.like_count_text = nil
  self.dian_zan_effect = nil
  self.hand = nil
  self.diamond = nil
  self.compPlayerHead = nil
end

function UIAttackCityS0RankWinner:OnAddListener()
  base.OnAddListener(self)
end

function UIAttackCityS0RankWinner:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAttackCityS0RankWinner:Refresh(data, cityId)
  if data then
    self.gameObject:SetActive(true)
    self.data = data
    self.compPlayerHead:SetData(data.roleInfo.uid, data.roleInfo.pic, data.roleInfo.picver)
    local name = data.name
    name = UIUtil.FormatAllianceAndName(data.roleInfo.abbr, data.roleInfo.name, data.roleInfo.uid)
    self.txt_name:SetText(name)
    self.txt_score:SetText(data.score)
    self.like_count_text:SetText(data.thumbsUpCount)
    self.cityId = cityId
    local dataConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
    local level = dataConfig.level
    local meta = DataCenter.AttackCityS0ConfigManager:GetAttackCityThumbsUpReward(level)
    if not meta then
      Logger.LogError("\230\159\165\230\137\190\228\184\141\229\136\176\229\175\185\229\186\148\231\173\137\231\186\167\229\159\142\229\184\130\229\165\150\229\138\177=" .. (cityId or "") .. "Level:" .. level)
      return
    end
    local groups = DataCenter.ChampionDuelManager:GetRewardsById(meta)
    if groups ~= nil and 1 <= #groups then
      self.rewardIcon:LoadSprite(RewardUtil.GetPic(groups[1].rewardType, groups[1].itemId))
      local count = tonumber(groups[1].count)
      self.rewardNum:SetText(string.GetFormattedStr(count))
    end
  else
    self.gameObject:SetActive(false)
  end
end

function UIAttackCityS0RankWinner:OnLikClick()
  if self.data.isThumbsUp then
    UIUtil.ShowTipsId("new_city_activity_battle_tips1064")
  else
    DataCenter.AttackCityS0DataManager:SendThumpsUpRewardMsg(self.cityId, self.data.roleInfo.uid)
  end
end

return UIAttackCityS0RankWinner
