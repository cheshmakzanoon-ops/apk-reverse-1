local base = UICommonResItem
local UICommonResItemFirstPayExpComponent = BaseClass("UICommonResItemFirstPayExpComponent", UICommonResItem)
local Localization = CS.GameEntry.Localization
local pig_mark_path = "PigMark"

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.pigMarkImg = self:AddComponent(UIBaseContainer, pig_mark_path)
end

local function ReInit(self, param)
  base.ReInit(self, param)
  if self.pigMarkImg then
    self.pigMarkImg:SetActive(param and param.isShowPigMark)
  end
end

UICommonResItemFirstPayExpComponent.ReInit = ReInit
UICommonResItemFirstPayExpComponent.ComponentDefine = ComponentDefine
return UICommonResItemFirstPayExpComponent
