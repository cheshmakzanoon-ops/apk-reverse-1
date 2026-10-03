local base = UIBaseContainer
local UILWCommonDominatorHeadComponent = BaseClass("UILWCommonDominatorHeadComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWCommonDominatorHeadComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWCommonDominatorHeadComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWCommonDominatorHeadComponent:ComponentDefine()
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.imgRankIcon = self:AddComponent(UIImage, "RankIcon")
end

function UILWCommonDominatorHeadComponent:ComponentDestroy()
  self.imgIcon = nil
  self.imgRankIcon = nil
end

function UILWCommonDominatorHeadComponent:DataDefine()
  self.info = nil
  self.rankShowTemplate = nil
end

function UILWCommonDominatorHeadComponent:DataDestroy()
  self.info = nil
  self.rankShowTemplate = nil
end

function UILWCommonDominatorHeadComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWCommonDominatorHeadComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWCommonDominatorHeadComponent:SetDominatorInfo(info)
  self.info = info
  self.rankShowTemplate = nil
  if self.info == nil then
    return
  end
  self.rankShowTemplate = self.info:GetCurRankShowTemplate()
  if self.rankShowTemplate == nil then
    return
  end
  self:Refresh()
end

function UILWCommonDominatorHeadComponent:SetDominatorRankShowTemplate(template)
  self.info = nil
  self.rankShowTemplate = template
  if self.rankShowTemplate == nil then
    return
  end
  self:Refresh()
end

function UILWCommonDominatorHeadComponent:Refresh()
  if self.rankShowTemplate == nil then
    return
  end
  self.imgRankIcon:LoadSprite(self.rankShowTemplate:GetRankIconPathSmall())
  local headIconPath = self.rankShowTemplate:GetHeadIconPath()
  if not string.IsNullOrEmpty(headIconPath) then
    self.imgIcon:LoadSprite(headIconPath)
  end
end

return UILWCommonDominatorHeadComponent
