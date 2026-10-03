local base = UIBaseContainer
local HeroAwakenStarItemComponent = BaseClass("HeroAwakenStarItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function HeroAwakenStarItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroAwakenStarItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroAwakenStarItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compNotFullroot = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.imgStarFrag5 = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgStarFrag4 = self.viewSkin:AddComponent(self, UIImage, 3)
  self.imgStarFrag3 = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgStarFrag2 = self.viewSkin:AddComponent(self, UIImage, 5)
  self.imgStarFrag1 = self.viewSkin:AddComponent(self, UIImage, 6)
  self.compFullStar = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compVFXSingle = self.viewSkin:AddComponent(self, UIVfx, 8)
  self.imgStarFragList = {
    self.imgStarFrag1,
    self.imgStarFrag2,
    self.imgStarFrag3,
    self.imgStarFrag4,
    self.imgStarFrag5
  }
end

function HeroAwakenStarItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compNotFullroot = nil
  self.imgStarFrag5 = nil
  self.imgStarFrag4 = nil
  self.imgStarFrag3 = nil
  self.imgStarFrag2 = nil
  self.imgStarFrag1 = nil
  self.compFullStar = nil
  self.compVFXSingle = nil
  self.imgStarFragList = nil
end

function HeroAwakenStarItemComponent:DataDefine()
  self.starCount = nil
end

function HeroAwakenStarItemComponent:DataDestroy()
  self.starCount = nil
end

function HeroAwakenStarItemComponent:SetStarCount(count, playVfx)
  local playSingleVfx = playVfx == true and self.starCount ~= nil and count > self.starCount
  self.starCount = count
  self.compFullStar:SetActive(5 <= count)
  self.compNotFullroot:SetActive(count < 5)
  if count < 5 then
    for i, v in ipairs(self.imgStarFragList) do
      if i <= count then
        v:LoadSprite(string.format(LoadPath.CommonHeroRedStarFragImagePath, i))
      else
        v:LoadSprite(string.format(LoadPath.CommonHeroYellowStarFragImagePath, i))
      end
    end
  end
  if playSingleVfx then
    self.compVFXSingle:PlayByOnce(VfxAssets.HeroAwakenStarItemSingleEffect)
  end
end

return HeroAwakenStarItemComponent
