local UIChampionDuelDetailInfoItemSmall = BaseClass("UIChampionDuelDetailInfoItemSmall", UIBaseContainer)
local base = UIBaseContainer
local PART_H = 15

function UIChampionDuelDetailInfoItemSmall:OnCreate()
  base.OnCreate(self)
  self.img = self:AddComponent(UIImage, "Img")
  self.right = self:AddComponent(UIBaseContainer, "Right")
  self.title = self:AddComponent(UIText, "Right/Title")
  self.desc = self:AddComponent(UIText, "Right/Desc")
end

function UIChampionDuelDetailInfoItemSmall:OnDestroy()
  self.img = nil
  self.right = nil
  self.title = nil
  self.desc = nil
  base.OnDestroy(self)
end

function UIChampionDuelDetailInfoItemSmall:ReInit(data)
  self.title:SetLocalText(data.tittle)
  self.img:LoadSpriteAuto(data.pic)
  self.desc:SetLocalText(data.desc)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.right.transform)
  local imgSize = self.img:GetSizeDelta()
  local rightSize = self.right:GetSizeDelta()
  local mySize = self:GetSizeDelta()
  if rightSize.y > imgSize.y then
    mySize.y = rightSize.y + PART_H * 2
    self:SetSizeDelta(mySize)
  else
    mySize.y = imgSize.y + PART_H * 2
    self:SetSizeDelta(mySize)
  end
end

return UIChampionDuelDetailInfoItemSmall
