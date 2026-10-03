local LWUIMasterySkillDetailCell = BaseClass("LWUIMasterySkillDetailCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local descImg_path = "descImg"
local desc_path = "desc"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.descImg = self:AddComponent(UIRawImage, descImg_path)
  self.desc = self:AddComponent(UIText, desc_path)
end

local function ComponentDestroy(self)
  self.descImg = nil
  self.desc = nil
end

local function DataDefine(self)
  self.showData = nil
end

local function DataDestroy(self)
  self.showData = nil
end

local function SetData(self, showData)
  self.showData = showData
  self:Refresh()
end

local function Refresh(self)
  if self.showData == nil then
    return
  end
  local path = string.format(LoadPath.LWMasteryTexturePath, self.showData.img)
  self.descImg:LoadSpriteAsync(path)
  self.desc:SetLocalText(self.showData.txt)
end

LWUIMasterySkillDetailCell.OnCreate = OnCreate
LWUIMasterySkillDetailCell.OnDestroy = OnDestroy
LWUIMasterySkillDetailCell.ComponentDefine = ComponentDefine
LWUIMasterySkillDetailCell.ComponentDestroy = ComponentDestroy
LWUIMasterySkillDetailCell.DataDefine = DataDefine
LWUIMasterySkillDetailCell.DataDestroy = DataDestroy
LWUIMasterySkillDetailCell.SetData = SetData
LWUIMasterySkillDetailCell.Refresh = Refresh
return LWUIMasterySkillDetailCell
