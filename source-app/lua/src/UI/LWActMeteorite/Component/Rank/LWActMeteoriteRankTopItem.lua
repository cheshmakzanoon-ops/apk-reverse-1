local base = UIBaseContainer
local LWActMeteoriteRankTopItem = BaseClass("LWActMeteoriteRankTopItem", base)
local flag_path = "flag"
local cup_img_path = "CupImg"
local player_head_path = "UIPlayerHead"
local abbr_text_path = "AbbrText"
local name_text_path = "NameText"
local score_text_path = "Score/ScoreText"
local like_btn_path = "LikeBtn"
local like_count_text_path = "LikeBtn/likeCountText"

function LWActMeteoriteRankTopItem:OnCreate()
  base.OnCreate(self)
  self.flag = self:AddComponent(UIImage, flag_path)
  self.cup_img = self:AddComponent(UIImage, cup_img_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.player_head:SetEnableClickShowInfo(true, true)
  self.abbr_text = self:AddComponent(UITextMeshProUGUIEx, abbr_text_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.score_text = self:AddComponent(UITextMeshProUGUIEx, score_text_path)
  self.like_btn = self:AddComponent(UIButton, like_btn_path)
  self.like_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if string.IsNullOrEmpty(self.uid) then
      return
    end
    InteractiveUtil.TryThumbsUp(self.uid, InteractiveUtil.ThumbsUpType.MeteoriteBattleRank, "MeteoriteBattleRank", function()
      local num = toInt(self.like_count_text:GetText()) + 1
      self.like_count_text:SetText(num)
    end)
  end)
  self.like_count_text = self:AddComponent(UITextMeshProUGUIEx, like_count_text_path)
end

function LWActMeteoriteRankTopItem:OnDestroy()
  self.flag = nil
  self.cup_img = nil
  self.player_head = nil
  self.abbr_text = nil
  self.name_text = nil
  self.score_text = nil
  self.like_btn = nil
  self.like_count_text = nil
  base.OnDestroy(self)
end

function LWActMeteoriteRankTopItem:SetData(info)
  if info == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.uid = info.uid
  self.player_head:SetHeadAndFrame(info.uid, info.pic, info.picVer, false, info.headSkinId, info.headSkinET)
  self.abbr_text:SetText("#" .. info.serverId .. " " .. info.abbr)
  self.name_text:SetText(UIUtil.FormatAllianceAndName(nil, info.name, info.uid))
  self.score_text:SetText(string.GetFormattedStr(info.score))
  self.like_count_text:SetText(info.praise)
end

return LWActMeteoriteRankTopItem
