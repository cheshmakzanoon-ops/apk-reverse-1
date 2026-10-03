local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemTWSkillChip = BaseClass("UICommonResItemTWSkillChip", UICommonResItemBase)
local base = UICommonResItemBase

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
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnClick(self)
  local chipInfo
  if self.param.uuid then
    chipInfo = DataCenter.TWSkillChipManager:GetChipInfo(self.param.uuid)
  end
  if not chipInfo then
    chipInfo = TWSkillChipInfo.New()
    chipInfo:CreateFromTemplate(self.param.itemId, 1, 0)
  end
  if chipInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, chipInfo)
  end
end

UICommonResItemTWSkillChip.OnCreate = OnCreate
UICommonResItemTWSkillChip.OnDestroy = OnDestroy
UICommonResItemTWSkillChip.ComponentDefine = ComponentDefine
UICommonResItemTWSkillChip.ComponentDestroy = ComponentDestroy
UICommonResItemTWSkillChip.DataDefine = DataDefine
UICommonResItemTWSkillChip.DataDestroy = DataDestroy
UICommonResItemTWSkillChip.OnClick = OnClick
return UICommonResItemTWSkillChip
