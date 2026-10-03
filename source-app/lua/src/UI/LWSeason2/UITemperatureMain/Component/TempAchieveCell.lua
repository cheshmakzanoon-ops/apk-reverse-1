local TempAchieveCell = BaseClass("TempAchieveCell", UIBaseContainer)
local base = UIBaseContainer
local icon_path = "icon"
local desc_path = "desc"
local share_path = "share"

function TempAchieveCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TempAchieveCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TempAchieveCell:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  local share = self:AddComponent(UIButton, share_path)
  share:SetOnClick(function()
    UIUtil.ShowTipsId(120018)
  end)
end

function TempAchieveCell:ComponentDestroy()
end

function TempAchieveCell:SetData(meta)
  self.meta = meta
  self.icon:LoadSprite(meta.icon)
  local num = DataCenter.TemperatureManager:GetAchieveNumById(self.meta.id)
  self.desc:SetLocalText(meta.desc, num)
end

function TempAchieveCell:Refresh()
  local num = DataCenter.TemperatureManager:GetAchieveNumById(self.meta.id)
  self.desc:SetLocalText(self.meta.desc, num)
end

return TempAchieveCell
