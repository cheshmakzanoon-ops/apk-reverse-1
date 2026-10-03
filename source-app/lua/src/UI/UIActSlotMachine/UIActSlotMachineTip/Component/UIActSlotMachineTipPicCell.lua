local UIActSlotMachineTipPicCell = BaseClass("UIActSlotMachineTipPicCell", UIBaseContainer)
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
  local path = string.format(LoadPath.ActSlotMachineTexturePath, self.showData.img)
  self.descImg:LoadSprite(path)
  self.desc:SetLocalText(self.showData.txt)
end

UIActSlotMachineTipPicCell.OnCreate = OnCreate
UIActSlotMachineTipPicCell.OnDestroy = OnDestroy
UIActSlotMachineTipPicCell.ComponentDefine = ComponentDefine
UIActSlotMachineTipPicCell.ComponentDestroy = ComponentDestroy
UIActSlotMachineTipPicCell.DataDefine = DataDefine
UIActSlotMachineTipPicCell.DataDestroy = DataDestroy
UIActSlotMachineTipPicCell.SetData = SetData
UIActSlotMachineTipPicCell.Refresh = Refresh
return UIActSlotMachineTipPicCell
