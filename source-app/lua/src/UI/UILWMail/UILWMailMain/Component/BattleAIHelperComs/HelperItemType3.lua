local HelperItemType3 = BaseClass("HelperItemType3", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function HelperItemType3:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HelperItemType3:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HelperItemType3:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "bg")
  self.desc_txt = self:AddComponent(UIText, "desc_txt")
  self.detail_btn = self:AddComponent(UIButton, "detail_btn")
  self.detail_btn:SetOnClick(function()
    if self.adviceInfo then
      UIUtil.ShowIntro(Localization:GetString("2901005"), nil, Localization:GetString(self.adviceInfo.template.dialog_4))
    end
  end)
end

function HelperItemType3:ComponentDestroy()
  self.bg = nil
  self.desc_txt = nil
  self.detail_btn = nil
end

function HelperItemType3:SetData(data)
end

function HelperItemType3:DataDefine()
end

function HelperItemType3:DataDestroy()
  self.adviceInfo = nil
end

function HelperItemType3:OnEnable()
  base.OnEnable(self)
end

function HelperItemType3:OnDisable()
  base.OnDisable(self)
end

function HelperItemType3:OnAddListener()
  base.OnAddListener(self)
end

function HelperItemType3:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HelperItemType3:SetData(adviceInfo)
  local template = adviceInfo.template
  local dialogPara = adviceInfo.extraInfo ~= nil and adviceInfo.extraInfo.dialogPara or {}
  self.desc_txt:SetText(Localization:GetString(template.dialog_3, table.unpack(dialogPara)))
  local dialog4 = template.dialog_4
  self.detail_btn:SetActive(not string.IsNullOrEmpty(dialog4))
  self.adviceInfo = adviceInfo
end

return HelperItemType3
