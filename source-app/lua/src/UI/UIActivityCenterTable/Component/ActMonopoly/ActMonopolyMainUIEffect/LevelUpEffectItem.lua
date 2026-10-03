local LevelUpEffectItem = BaseClass("LevelUpEffectItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local eff_ui_levelup_txt_path = ""
local txt_add_path = "txt_add"
local txt_path = "txt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.eff_ui_levelup_txt = self:AddComponent(UIAnimator, eff_ui_levelup_txt_path)
  self.txt_add = self:AddComponent(UITextMeshProUGUIEx, txt_add_path)
  self.txt = self:AddComponent(UITextMeshProUGUIEx, txt_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, lvNum)
  self.recordLv = lvNum
  self.eff_ui_levelup_txt:SetActive(false)
  self.eff_ui_levelup_txt:SetActive(true)
  self.txt_add:SetLocalText(GameDialogDefine.LEVEL_NUMBER, self.recordLv)
  self.txt:SetLocalText(GameDialogDefine.LEVEL_NUMBER, self.recordLv)
end

LevelUpEffectItem.OnCreate = OnCreate
LevelUpEffectItem.OnDestroy = OnDestroy
LevelUpEffectItem.ComponentDefine = ComponentDefine
LevelUpEffectItem.ComponentDestroy = ComponentDestroy
LevelUpEffectItem.DataDefine = DataDefine
LevelUpEffectItem.DataDestroy = DataDestroy
LevelUpEffectItem.SetData = SetData
return LevelUpEffectItem
