local UIItemCell = BaseClass("UIItemCell", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.itemId = nil
  self.itemNum = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.imgQuality = self:AddComponent(UIImage, "imgQuality")
  self.imgIcon = self:AddComponent(UIImage, "imgIcon")
  self.nodeFaceBg = self:AddComponent(UIBaseComponent, "imgFaceBg")
  self.textExtra = self:AddComponent(UIText, "TextExtra")
  self.textNum = self:AddComponent(UIText, "TextLevel")
  local btn = self:AddComponent(UIButton, "")
  btn:SetOnClick(BindCallback(self, self.OnBtnClick))
end

local function ComponentDestroy(self)
  self.imgIcon = nil
  self.textNum = nil
end

local function SetData(self, rewardType, itemId, itemNum)
  self.itemId = itemId
  self.itemNum = itemNum
  self.imgIcon:SetActive(true)
  local iconPath = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
  self.imgIcon:LoadSprite(iconPath)
  local qualityPath = DataCenter.RewardManager:GetRewardQualityBg(rewardType, itemId)
  self.imgQuality:LoadSprite(qualityPath)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if template ~= nil then
    self:UpdateFaceValue(template)
  end
  self.textNum:SetText(itemNum)
end

local function UpdateFaceValue(self, template)
  self.textExtra:SetText("")
  self.nodeFaceBg:SetActive(false)
  if template == nil then
    return
  end
  local itemType = template.type
  if itemType == GOODS_TYPE.GOODS_TYPE_3 or itemType == GOODS_TYPE.GOODS_TYPE_91 then
    self.textExtra:SetText(template.para == "" and "" or string.GetFormattedStr(tonumber(template.para)))
  elseif template.para1 ~= nil and template.para1 ~= "" then
    local para1 = template.para1
    local temp = string.split(para1, ";")
    if temp ~= nil and 1 < #temp then
      self.textExtra:SetText(temp[1] .. temp[2])
      self.nodeFaceBg:SetActive(true)
    end
  end
end

local function SetNumDisplay(self, num)
  self.textNum:SetText(num)
end

local function OnBtnClick(self)
end

UIItemCell.OnCreate = OnCreate
UIItemCell.OnDestroy = OnDestroy
UIItemCell.ComponentDefine = ComponentDefine
UIItemCell.ComponentDestroy = ComponentDestroy
UIItemCell.SetData = SetData
UIItemCell.SetNumDisplay = SetNumDisplay
UIItemCell.UpdateFaceValue = UpdateFaceValue
UIItemCell.OnBtnClick = OnBtnClick
return UIItemCell
