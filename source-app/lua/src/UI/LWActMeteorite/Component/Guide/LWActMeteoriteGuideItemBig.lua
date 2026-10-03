local LWActMeteoriteGuideItemBig = BaseClass("LWActMeteoriteGuideItemBig", UIBaseContainer)
local base = UIBaseContainer

function LWActMeteoriteGuideItemBig:OnCreate()
  base.OnCreate(self)
  self.layoutGroup = self.transform:GetComponent(typeof(CS.UnityEngine.UI.VerticalLayoutGroup))
  self.title = self:AddComponent(UITextMeshProUGUIEx, "TitleGroup/Title")
  self.img = self:AddComponent(UIImage, "Img")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "DescGroup/Desc")
end

function LWActMeteoriteGuideItemBig:OnDestroy()
  self.title = nil
  self.img = nil
  self.desc = nil
  base.OnDestroy(self)
end

function LWActMeteoriteGuideItemBig:SetData(data)
  self.title:SetLocalText(data.tittle)
  if not string.IsNullOrEmpty(data.pic) then
    self.img:LoadSpriteAuto(data.pic)
  end
  self.desc:SetLocalText(data.desc)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

return LWActMeteoriteGuideItemBig
