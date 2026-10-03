local base = UIBaseContainer
local UIUpgradeTreasureBoxItemComponent = BaseClass("UIUpgradeTreasureBoxItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIUpgradeTreasureBoxItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIUpgradeTreasureBoxItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIUpgradeTreasureBoxItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.imgBase = self.viewSkin:AddComponent(self, UIImage, 2)
  self.simpleAnimationEmojiNode = self.viewSkin:AddComponent(self, UISimpleAnimation, 3)
end

function UIUpgradeTreasureBoxItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btn = nil
  self.imgBase = nil
  self.simpleAnimationEmojiNode = nil
end

function UIUpgradeTreasureBoxItemComponent:DataDefine()
  self.index = 0
end

function UIUpgradeTreasureBoxItemComponent:DataDestroy()
  self.index = nil
end

function UIUpgradeTreasureBoxItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIUpgradeTreasureBoxItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIUpgradeTreasureBoxItemComponent:Init(index, viewSkinConfig)
  self.curState = UpgradeTreasureBoxResult.None
  self.index = index
  if viewSkinConfig and viewSkinConfig.itemQuestionMask then
    self.imgBase:LoadSpriteAsync(viewSkinConfig.itemQuestionMask)
  end
  self:PlayEmoji(self.curState)
end

function UIUpgradeTreasureBoxItemComponent:Refresh(result)
  self.curState = result
  self:PlayEmoji(result)
end

function UIUpgradeTreasureBoxItemComponent:PlayEmoji(result)
  if result == UpgradeTreasureBoxResult.None then
    self.simpleAnimationEmojiNode:Play("unknown")
  elseif result == UpgradeTreasureBoxResult.Fail then
    self.simpleAnimationEmojiNode:Play("fail", true)
  elseif result == UpgradeTreasureBoxResult.Success then
    self.simpleAnimationEmojiNode:Play("success", true)
  end
end

function UIUpgradeTreasureBoxItemComponent:OnBtnClick()
  if self.curState == UpgradeTreasureBoxResult.None then
    EventManager:GetInstance():Broadcast(EventId.UpgradeTreasureBoxClickCell, self.index)
  end
end

function UIUpgradeTreasureBoxItemComponent:CanUpgrade()
  return self.curState == UpgradeTreasureBoxResult.None
end

return UIUpgradeTreasureBoxItemComponent
