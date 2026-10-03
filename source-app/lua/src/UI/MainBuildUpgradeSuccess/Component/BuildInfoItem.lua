local BuildInfoItem = BaseClass("BuildInfoItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function BuildInfoItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function BuildInfoItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BuildInfoItem:DataDefine()
end

function BuildInfoItem:ComponentDefine()
  self.unLockBuildIcon = self:AddComponent(UIImage, "buildIcon")
  self.buildNameText = self:AddComponent(UIText, "buildName")
end

function BuildInfoItem:ReInit(itemId)
  itemId = tonumber(itemId)
  local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(itemId, 1)
  if not template then
    Logger.LogError("BuildInfoItem:ReInit template is nil", itemId)
    return
  end
  self.unLockBuildIcon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(itemId, 1))
  self.buildNameText:SetLocalText(template.name)
end

function BuildInfoItem:DataDestroy()
end

function BuildInfoItem:ComponentDestroy()
  self.unLockBuildIcon = nil
  self.buildNameText = nil
end

return BuildInfoItem
