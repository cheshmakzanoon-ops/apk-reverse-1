local NewCenterLikeItem = BaseClass("NewCenterLikeItem", UIBaseContainer)
local base = UIBaseContainer

function NewCenterLikeItem:OnCreate()
  base.OnCreate(self)
  self.head = self:AddComponent(UICommonHead, "UIPlayerHead")
  local playerInfo = ChatInterface.getUserData(LuaEntry.Player.uid)
  self.head:SetHeadAndFrame(playerInfo.uid, playerInfo.headPic, playerInfo.headPicVer, false, playerInfo.headSkinId, playerInfo.headSkinET)
end

function NewCenterLikeItem:OnDestroy()
  self.head = nil
  base.OnDestroy(self)
end

return NewCenterLikeItem
