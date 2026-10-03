local base = UIBaseContainer
local LWUIActEasterAnonymousAvatarNode = BaseClass("LWUIActEasterAnonymousAvatarNode", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local M = LWUIActEasterAnonymousAvatarNode

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.imgCurAvatar = self:AddComponent(UIImage, "CurAvatarImage")
  self.btnSelect = self:AddComponent(UIButton, "SelectBtn")
  self.btnSelect:SetOnClick(function()
    self:OnBtnSelectClick()
  end)
  self.compCurSelect = self:AddComponent(UIBaseContainer, "CurSelect")
end

function M:ComponentDestroy()
  self.imgCurAvatar = nil
  self.btnSelect = nil
  self.compCurSelect = nil
end

function M:DataDefine()
  self.headId = 0
  self.index = 0
end

function M:DataDestroy()
  self.headId = nil
  self.index = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggGetActivitySelectAnonymousAvatar, self.OnRecChangeIndex)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EasterEggGetActivitySelectAnonymousAvatar, self.OnRecChangeIndex)
end

function M:OnBtnSelectClick()
  self.ctrl:SetCurSelectHeadIndex(self.index)
  EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivitySelectAnonymousAvatar, self.index)
end

function M:SetHeadImage(index, headId, selectHeadIndex, ctrl)
  self.ctrl = ctrl
  self.compCurSelect:SetActive(index == selectHeadIndex)
  self.index = index
  self.headId = headId
  local iconPath = HeroUtils.GetHeroIconPath(headId)
  self.imgCurAvatar:LoadSpriteAuto(iconPath)
end

function M:OnRecChangeIndex()
  self.compCurSelect:SetActive(self.index == self.ctrl:GetCurSelectHeadIndex())
end

return LWUIActEasterAnonymousAvatarNode
