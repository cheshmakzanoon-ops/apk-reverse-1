local UIChampionDuelDetailInfoItemBig = BaseClass("UIChampionDuelDetailInfoItemBig", UIBaseContainer)
local base = UIBaseContainer

function UIChampionDuelDetailInfoItemBig:OnCreate()
  base.OnCreate(self)
  self.layoutGroup = self.transform:GetComponent(typeof(CS.UnityEngine.UI.VerticalLayoutGroup))
  self.title = self:AddComponent(UIText, "TitleGroup/Title")
  self.img = self:AddComponent(UIRawImage, "Img")
  self.desc = self:AddComponent(UIText, "DescGroup/Desc")
end

function UIChampionDuelDetailInfoItemBig:OnDestroy()
  self.title = nil
  self.img = nil
  self.desc = nil
  base.OnDestroy(self)
end

function UIChampionDuelDetailInfoItemBig:ReInit(data)
  self.title:SetLocalText(data.tittle)
  self.img:LoadSpriteAuto(data.pic)
  self.desc:SetLocalText(data.desc)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

return UIChampionDuelDetailInfoItemBig
