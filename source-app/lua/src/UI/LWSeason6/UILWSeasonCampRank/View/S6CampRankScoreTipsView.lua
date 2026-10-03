local root_vertical_path = "Root/ImgBg/root_vertical"
local p_text_title_path = "Root/ImgBg/root_vertical/p_text_title"
local p_text_occupy_score_path = "Root/ImgBg/root_vertical/content_occupy/p_text_occupy_score"
local p_text_destroy_score_path = "Root/ImgBg/root_vertical/content_destroy/p_text_destroy_score"
local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local S6CampRankScoreTipsView = BaseClass("S6CampRankScoreTipsView", base)

function S6CampRankScoreTipsView:ComponentDefine()
  base.ComponentDefine(self)
  self.root_vertical = self:AddComponent(UIBaseContainer, root_vertical_path)
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_text_occupy_score = self:AddComponent(UITextMeshProUGUIEx, p_text_occupy_score_path)
  self.p_text_destroy_score = self:AddComponent(UITextMeshProUGUIEx, p_text_destroy_score_path)
end

function S6CampRankScoreTipsView:ComponentDestroy()
  base.ComponentDestroy(self)
  self.root_vertical = nil
  self.p_text_title = nil
  self.p_text_occupy_score = nil
  self.p_text_destroy_score = nil
end

function S6CampRankScoreTipsView:DataDestroy()
  self.Data = nil
end

function S6CampRankScoreTipsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6CampRankScoreTipsView:RefreshShow()
  self:Init()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root_vertical.transform)
end

function S6CampRankScoreTipsView:Init()
  self.p_text_title:SetLocalText("season_s6_rank_reward_11", self.param.score)
  self.p_text_occupy_score:SetLocalText("season_s6_rank_reward_12", self.param.buildingScore)
  self.p_text_destroy_score:SetLocalText("season_s6_rank_reward_13", self.param.destroyScore)
end

return S6CampRankScoreTipsView
