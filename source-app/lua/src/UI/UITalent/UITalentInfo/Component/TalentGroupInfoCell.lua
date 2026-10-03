local TalentGroupInfoCell = BaseClass("TalentGroupInfoCell", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.talentName = self:AddComponent(UIText, "talentName")
  self.talentDes = self:AddComponent(UIText, "talentDes")
  self.line = self:AddComponent(UIText, "line")
  self.line_gray = self:AddComponent(UIText, "line_gray")
end

local function ComponentDestroy(self)
end

local function SetData(self, data)
  self.talentName:SetText(data.name)
  self.talentDes:SetText(data.des)
  self.line:SetActive(not data.gray)
  self.line_gray:SetActive(data.gray)
  if not data.gray then
    self.talentName:SetColorRGBA(0.7176470588235294, 0.4, 0.18823529411764706, 1)
    self.talentDes:SetColorRGBA(0.7176470588235294, 0.4, 0.18823529411764706, 1)
  else
    self.talentName:SetColorRGBA(0.5647058823529412, 0.5647058823529412, 0.5647058823529412, 1)
    self.talentDes:SetColorRGBA(0.5647058823529412, 0.5647058823529412, 0.5647058823529412, 1)
  end
end

TalentGroupInfoCell.OnCreate = OnCreate
TalentGroupInfoCell.OnDestroy = OnDestroy
TalentGroupInfoCell.ComponentDefine = ComponentDefine
TalentGroupInfoCell.ComponentDestroy = ComponentDestroy
TalentGroupInfoCell.SetData = SetData
return TalentGroupInfoCell
