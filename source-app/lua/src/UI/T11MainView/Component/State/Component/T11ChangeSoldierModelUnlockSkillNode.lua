local base = UIBaseContainer
local T11ChangeSoldierModelUnlockSkillNode = BaseClass("T11ChangeSoldierModelUnlockSkillNode", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")

function T11ChangeSoldierModelUnlockSkillNode:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11ChangeSoldierModelUnlockSkillNode:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11ChangeSoldierModelUnlockSkillNode:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compT11SoldierSkillItemChangeArea = self.viewSkin:AddComponent(self, T11SoldierSkillItemComponent, 1)
end

function T11ChangeSoldierModelUnlockSkillNode:ComponentDestroy()
  self.compT11SoldierSkillItemChangeArea = nil
end

function T11ChangeSoldierModelUnlockSkillNode:DataDefine()
end

function T11ChangeSoldierModelUnlockSkillNode:DataDestroy()
end

function T11ChangeSoldierModelUnlockSkillNode:ReInit(skillInfo)
  if not skillInfo then
    Logger.LogError("T11ChangeSoldierModelUnlockSkillNode:ReInit called with nil skillInfo")
    return
  end
  self.compT11SoldierSkillItemChangeArea:Init(skillInfo, true)
end

return T11ChangeSoldierModelUnlockSkillNode
