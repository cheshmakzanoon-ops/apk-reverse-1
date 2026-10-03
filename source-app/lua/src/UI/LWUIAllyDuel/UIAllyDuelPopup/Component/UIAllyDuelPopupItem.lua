local UIAllyDuelPopupItem = BaseClass("UIAllyDuelPopupItem", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization

function UIAllyDuelPopupItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAllyDuelPopupItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelPopupItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, "icon")
  self.name = self:AddComponent(UIText, "name")
  self.new = self:AddComponent(UIBaseComponent, "new")
end

function UIAllyDuelPopupItem:ComponentDestroy()
  self.mission = nil
end

function UIAllyDuelPopupItem:SetData(mission)
  self.mission = mission
  if IsNotNull(self.gameObject) then
    self:UpdateData()
  end
end

function UIAllyDuelPopupItem:UpdateData()
  local mission = self.mission
  if mission then
    self.icon:LoadSprite(mission.icon)
    self.name:SetLocalText(mission.name)
    self.new:SetActive(mission.new == 2)
  end
end

return UIAllyDuelPopupItem
