local UIRewardPlayerItem = BaseClass("UIRewardPlayerItem", UIBaseContainer)
local base = UIBaseContainer
local nameConst = "[%s]%s"

function UIRewardPlayerItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIRewardPlayerItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRewardPlayerItem:ComponentDefine()
  self.player_head = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.playerName_text = self:AddComponent(UIText, "name")
end

function UIRewardPlayerItem:ComponentDestroy()
end

function UIRewardPlayerItem:ReInit(data)
  self.player_head:SetHeadAndFrame(data.playerInfo.uid, data.playerInfo.pic, data.playerInfo.picver, false, data.playerInfo.headFrame)
  local name = ""
  if string.IsNullOrEmpty(data.playerInfo.abbr) then
    name = data.playerInfo.name
  else
    name = string.format(nameConst, data.playerInfo.abbr, data.playerInfo.name)
  end
  self.playerName_text:SetText(name)
end

return UIRewardPlayerItem
