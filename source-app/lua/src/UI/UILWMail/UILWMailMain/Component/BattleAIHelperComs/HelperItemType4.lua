local HelperItemType1 = BaseClass("HelperItemType1", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local BattleHelperUniversalItem = require("UI.UILWMail.UILWMailMain.Component.BattleAIHelperComs.BattleHelperUniversalItem")

function HelperItemType1:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HelperItemType1:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HelperItemType1:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "bg")
  self.desc_txt = self:AddComponent(UIText, "desc_txt")
  self.slot = self:AddComponent(BattleHelperUniversalItem, "slot")
end

function HelperItemType1:ComponentDestroy()
  self.bg = nil
  self.desc_txt = nil
  self.slot = nil
end

function HelperItemType1:SetData(data)
end

function HelperItemType1:DataDefine()
end

function HelperItemType1:DataDestroy()
  self.adviceInfo = nil
end

function HelperItemType1:OnEnable()
  base.OnEnable(self)
end

function HelperItemType1:OnDisable()
  base.OnDisable(self)
end

function HelperItemType1:OnAddListener()
  base.OnAddListener(self)
end

function HelperItemType1:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HelperItemType1:SetData(adviceInfo)
  local template = adviceInfo.template
  local extraInfo = adviceInfo.extraInfo
  if extraInfo and extraInfo.dialogPara then
    self.desc_txt:SetText(Localization:GetString(template.dialog_5, table.unpack(extraInfo.dialogPara)))
  else
    self.desc_txt:SetText(Localization:GetString(template.dialog_5))
  end
  if extraInfo.displayData and extraInfo.displayData[1] then
    self.slot:SetActive(true)
    self.slot:ReInit(extraInfo.displayData[1])
  else
    self.slot:SetActive(false)
  end
end

return HelperItemType1
