local FormationBuffCell = BaseClass("FormationBuffCell", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray

function FormationBuffCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function FormationBuffCell:ComponentDefine()
  self.infoIcon = self:AddComponent(UIImage, "iconBG/infoIcon")
  self.iconBG = self:AddComponent(UIImage, "iconBG")
  self.partitionIcon = self:AddComponent(UIImage, "BG/Image")
  self.bg = self:AddComponent(UIImage, "")
  self.layoutBg = self:AddComponent(UIBaseContainer, "BG")
  self.infoText = self:AddComponent(UIText, "BG/infoText")
  self.additionText = self:AddComponent(UIText, "BG/additionText")
  self.tempComponents = {
    self.infoIcon,
    self.iconBG,
    self.partitionIcon,
    self.bg
  }
end

function FormationBuffCell:ReInit(data)
  self.data = data
  self.infoText:SetLocalText(self.data.des)
  self.additionText:SetLocalText(self.data.effect_desc, self.data.effect_para * 100 .. "%")
  local path = string.format(LoadPath.HeroCommonPath, self.data.icon)
  self.infoIcon:LoadSprite(path)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.additionText.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutBg.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg.transform)
  self:RefreshIsGray(self.data)
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if self and self.view and self.view.RefreshBuffViewContent then
      self.view:RefreshBuffViewContent()
    end
  end, 1)
end

function FormationBuffCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FormationBuffCell:ComponentDestroy()
  self.infoIcon = nil
  self.iconBG = nil
  self.partitionIcon = nil
  self.bg = nil
  self.infoText = nil
  self.additionText = nil
  self.components = nil
end

function FormationBuffCell:RefreshIsGray(data)
  self:RefreshGray(not data.isShow)
end

function FormationBuffCell:RefreshGray(isGray)
  if not self.tempComponents then
    return
  end
  for i, com in pairs(self.tempComponents) do
    UIGray.SetGray(com.transform, isGray)
  end
end

return FormationBuffCell
