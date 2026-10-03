local base = UIBaseContainer
local UILWDominatorMainTrainInfoItemComponent = BaseClass("UILWDominatorMainTrainInfoItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorMainTrainInfoItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainTrainInfoItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainTrainInfoItemComponent:ComponentDefine()
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.textLevel = self:AddComponent(UIText, "LevelText")
end

function UILWDominatorMainTrainInfoItemComponent:ComponentDestroy()
  self.imgIcon = nil
  self.textLevel = nil
end

function UILWDominatorMainTrainInfoItemComponent:DataDefine()
end

function UILWDominatorMainTrainInfoItemComponent:DataDestroy()
end

function UILWDominatorMainTrainInfoItemComponent:ReInit(info)
  if info == nil then
    return
  end
  local groupTemplate = info:GetGroupTemplate()
  if groupTemplate then
    local icon = groupTemplate:GetBasicPageIconPath()
    if not string.IsNullOrEmpty(icon) then
      self.imgIcon:LoadSprite(icon)
    end
  end
  self.textLevel:SetText("Lv." .. tostring(info:GetCurLevel()))
end

function UILWDominatorMainTrainInfoItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorMainTrainInfoItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWDominatorMainTrainInfoItemComponent
