local base = require("UI.Landlord.Reward.Component.LLRewardBaseItem")
local LLRewardRankItem = BaseClass("LLRewardRankItem", base)
local Localization = CS.GameEntry.Localization

function LLRewardRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRewardRankItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRewardRankItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textRankTop = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgRankBg = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 5)
end

function LLRewardRankItem:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
  self.textRank = nil
  self.textRankTop = nil
  self.imgRankBg = nil
  self.imgBg = nil
end

function LLRewardRankItem:DataDefine()
end

function LLRewardRankItem:DataDestroy()
end

function LLRewardRankItem:OnAddListener()
  base.OnAddListener(self)
end

function LLRewardRankItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRewardRankItem:SetData(data)
  local para = data.para or {}
  local rank = para[1] or 1
  local rank2 = para[2] or rank
  local bgIdx = 4
  if rank == rank2 then
    local bTopThree = 0 < rank and rank <= 3
    self.imgRankBg:SetActive(bTopThree)
    self.textRank:SetActive(not bTopThree)
    if bTopThree then
      self.textRankTop:SetText(rank)
      self.imgRankBg:LoadSpriteAuto(string.format(LoadPath.CommonApsNewPath, string.format("lyp_huodong_zqzhg_paihangbang_%s.png", rank)))
      bgIdx = rank
    else
      self.textRank:SetText(rank)
    end
  else
    self.imgRankBg:SetActive(false)
    self.textRank:SetActive(true)
    self.textRank:SetText(string.format("%d-%d", rank, rank2))
  end
  self.imgBg:LoadSpriteAuto(string.format(LoadPath.CommonApsNewPath, string.format("ljq_tongyong_paihangbang_%s.png", bgIdx)))
  self:RefreshIcons(data.reward)
end

return LLRewardRankItem
