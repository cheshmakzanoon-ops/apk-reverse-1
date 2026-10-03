local SingleAllyItem = BaseClass("SingleAllyItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function SingleAllyItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SingleAllyItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SingleAllyItem:ComponentDefine()
  self.allyFlagIcon = self:AddComponent(UIImage, "flagIcon1")
  self.serverText = self:AddComponent(UIText, "bg/server1")
  self.nameText = self:AddComponent(UIText, "name1")
  self.allyPointText = self:AddComponent(UIText, "count3")
  self.allyPersonNumText = self:AddComponent(UIText, "count2")
  self.allyPowerText = self:AddComponent(UIText, "count1")
end

function SingleAllyItem:ComponentDestroy()
  self.allyFlagIcon = nil
  self.serverText = nil
  self.nameText = nil
  self.allyPointText = nil
  self.allyPersonNumText = nil
  self.allyPowerText = nil
end

function SingleAllyItem:SetData(data)
  if data then
    if data.icon then
      self.allyFlagIcon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, tostring(data.icon)))
    end
    if data.name then
      self.nameText:SetText(data.name)
    end
    if data.serverId then
      self.serverText:SetText("#" .. data.serverId)
    end
    if data.allyPoint then
      self.allyPointText:SetText(string.GetFormattedSeperatorNum(data.allyPoint))
    end
    if data.allyPersonNum and data.allyPersonMaxNum then
      self.allyPersonNumText:SetText(data.allyPersonNum .. "/" .. data.allyPersonMaxNum)
    end
    if data.allyPower then
      self.allyPowerText:SetText(string.GetFormattedSeperatorNum(data.allyPower))
    end
  end
end

return SingleAllyItem
