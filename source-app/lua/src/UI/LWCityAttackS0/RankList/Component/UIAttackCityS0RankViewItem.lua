local UIAttackCityS0RankViewItem = BaseClass("UIAttackCityS0RankViewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_self_path = "bgSelf"
local bg_path = "bg"
local txt_rank_path = "txtRank"
local head_path = "head"
local txt_name_path = "txtName"
local txt_score_path = "txtScore"
local btn_head_path = "btnHead"

function UIAttackCityS0RankViewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAttackCityS0RankViewItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0RankViewItem:ComponentDefine()
  self.bg_self = self:AddComponent(UIImage, bg_self_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.txt_rank = self:AddComponent(UITextMeshProUGUIEx, txt_rank_path)
  self.head = self:AddComponent(UICommonHead, head_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.txt_score = self:AddComponent(UITextMeshProUGUIEx, txt_score_path)
  self.btn_head = self:AddComponent(UIButton, btn_head_path)
  self.btn_head:SetOnClick(function()
    if self.data and self.data.uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.uid)
    end
  end)
end

function UIAttackCityS0RankViewItem:ComponentDestroy()
  self.bg_self = nil
  self.bg = nil
  self.txt_rank = nil
  self.head = nil
  self.txt_name = nil
  self.btn_head = nil
  self.txt_score = nil
end

function UIAttackCityS0RankViewItem:Refresh(data)
  self.data = data
  self.head:SetData(data.roleInfo.uid, data.roleInfo.pic, data.roleInfo.picver)
  local name = UIUtil.FormatAllianceAndName(data.roleInfo.abbr, data.roleInfo.name, data.roleInfo.uid)
  self.txt_name:SetText(name)
  self.txt_score:SetText(data.score)
  local rank = data.rank or 0
  if 0 < rank then
    self.txt_rank:SetText(rank)
  else
    self.txt_rank:SetText(Localization:GetString("activity_breakthrough_tips_16"))
  end
end

function UIAttackCityS0RankViewItem:RefreshSelf(selfRank, selfScore, selfData)
  self.data = {}
  self.data.uid = selfData.roleInfo.uid
  self.head:SetData(selfData.roleInfo.uid, selfData.roleInfo.pic, selfData.roleInfo.picver)
  local name = UIUtil.FormatAllianceAndName(selfData.roleInfo.abbr, selfData.roleInfo.name, selfData.roleInfo.uid)
  self.txt_name:SetText(name)
  self.txt_score:SetText(selfScore)
  local rank = selfRank
  if 0 < rank then
    self.txt_rank:SetText(rank)
  else
    self.txt_rank:SetText(Localization:GetString("activity_breakthrough_tips_16"))
  end
end

return UIAttackCityS0RankViewItem
