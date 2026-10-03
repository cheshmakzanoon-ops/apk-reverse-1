local T11UnlockNewSkillView = BaseClass("T11UnlockNewSkillView", UIBaseView)
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local t11_soldier_skill_item_path = "T11SoldierSkillItem"

function T11UnlockNewSkillView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function T11UnlockNewSkillView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11UnlockNewSkillView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textSkillName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textSkillDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnBG = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnBG:SetOnClick(function()
    self:OnBtnBGClick()
  end)
  self.unlockSkillItem = self:AddComponent(T11SoldierSkillItemComponent, t11_soldier_skill_item_path)
end

function T11UnlockNewSkillView:ComponentDestroy()
  self.viewSkin = nil
  self.textSkillName = nil
  self.textSkillDesc = nil
  self.btnBG = nil
end

function T11UnlockNewSkillView:DataDefine()
end

function T11UnlockNewSkillView:DataDestroy()
end

function T11UnlockNewSkillView:OnAddListener()
  base.OnAddListener(self)
end

function T11UnlockNewSkillView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11UnlockNewSkillView:RefreshView()
  self.unlockSkillData = self.ctrl:GetUnlockSkillData()
  if not self.unlockSkillData then
    return
  end
  self.unlockSkillItem:Init(self.unlockSkillData)
  self.textSkillName:SetLocalText(self.unlockSkillData.name)
  self.textSkillDesc:SetLocalText(self.unlockSkillData.desc)
end

function T11UnlockNewSkillView:OnBtnBGClick()
  self.ctrl:CloseSelf()
end

return T11UnlockNewSkillView
