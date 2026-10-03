local UIMultipleParkourRankWinner = BaseClass("UIMultipleParkourRankWinner", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local vfx_glow_path = "imgBadge/vfxGlow"
local txt_rank_path = "imgBadge/txtRank"
local txt_last_rank_path = "imgBadge/txtLastRank"
local img_head_path = "imgHead"
local txt_abbr_path = "txtAbbr"
local txt_name_path = "txtName"
local btn_head_path = "btnHead"
local like_path = "like"
local like_count_text_path = "like/likeCountText"
local dian_zan_effect_path = "DianZanEffect"
local hand_path = "DianZanEffect/Hand"
local diamond_path = "DianZanEffect/Diamond"
local txt_level_path = "txtLevel"

function UIMultipleParkourRankWinner:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMultipleParkourRankWinner:OnDestroy()
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self:ComponentDestroy()
  self.data = nil
  base.OnDestroy(self)
end

function UIMultipleParkourRankWinner:ComponentDefine()
  self.vfx_glow = self:AddComponent(UIBaseContainer, vfx_glow_path)
  self.txt_rank = self:AddComponent(UITextMeshProUGUIEx, txt_rank_path)
  self.txt_last_rank = self:AddComponent(UITextMeshProUGUIEx, txt_last_rank_path)
  self.img_head = self:AddComponent(UIBaseContainer, img_head_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.btn_head = self:AddComponent(UIButton, btn_head_path)
  self.like = self:AddComponent(UIButton, like_path)
  self.like_count_text = self:AddComponent(UITextMeshProUGUIEx, like_count_text_path)
  self.dian_zan_effect = self:AddComponent(UIBaseContainer, dian_zan_effect_path)
  self.hand = self:AddComponent(UIImage, hand_path)
  self.diamond = self:AddComponent(UIBaseContainer, diamond_path)
  self.txt_level = self:AddComponent(UITextMeshProUGUIEx, txt_level_path)
  self.compPlayerHead = self.img_head.gameObject:GetComponent(typeof(CS.UIPlayerHead))
  self.like:SetOnClick(function()
    if self.data and self.data.uid then
      InteractiveUtil.TryThumbsUp(self.data.uid, InteractiveUtil.ThumbsUpType.MultipleParkour, "MultipleParkourThumbsUp", function()
      end)
    end
  end)
  self.dian_zan_effect:SetActive(false)
  self.btn_head:SetOnClick(function()
    if self.data and self.data.uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.uid)
    end
  end)
end

function UIMultipleParkourRankWinner:ComponentDestroy()
  self.data = nil
  self.vfx_glow = nil
  self.txt_rank = nil
  self.txt_last_rank = nil
  self.img_head = nil
  self.txt_name = nil
  self.btn_head = nil
  self.like = nil
  self.like_count_text = nil
  self.dian_zan_effect = nil
  self.hand = nil
  self.diamond = nil
  self.txt_level = nil
end

function UIMultipleParkourRankWinner:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MultipleParkourRankPraise, self.OnMultipleParkourRankPraise)
end

function UIMultipleParkourRankWinner:OnRemoveListener()
  self:RemoveUIListener(EventId.MultipleParkourRankPraise, self.OnMultipleParkourRankPraise)
  base.OnRemoveListener(self)
end

function UIMultipleParkourRankWinner:OnMultipleParkourRankPraise(message)
  if not message then
    return
  end
  if not self.data or self.data.uid == nil then
    return
  end
  if message.targetUid == nil or message.praise == nil then
    return
  end
  if self.data.uid ~= message.targetUid then
    return
  end
  self.data.praise = message.praise or 0
  self.like_count_text:SetText(self.data.praise)
  UIUtil.ShowTips(Localization:GetString("multiply_door_tips_012"))
end

function UIMultipleParkourRankWinner:Refresh(data, tab)
  self.data = data
  self.compPlayerHead:SetData(data.uid, data.playerInfo.pic, data.playerInfo.picver)
  local name = data.playerInfo.name
  if tab == 2 then
    name = UIUtil.FormatAllianceAndName(data.playerInfo.abbr, data.playerInfo.name, data.uid)
  end
  self.txt_name:SetText(name)
  self.txt_rank:SetText(data.rank)
  self.txt_last_rank:SetActive(false)
  self.like_count_text:SetText(data.praise)
  local key = Localization:GetString("multiply_door_tips_001")
  local level = data.level or 1
  self.txt_level:SetText(key .. " " .. level)
end

return UIMultipleParkourRankWinner
