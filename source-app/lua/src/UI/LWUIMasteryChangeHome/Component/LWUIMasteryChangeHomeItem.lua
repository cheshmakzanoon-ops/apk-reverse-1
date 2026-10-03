local LWUIMasteryHaveChooseCompItem = BaseClass("LWUIMasteryHaveChooseCompItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.bgBtn = self:AddComponent(UIButton, "")
  self.bgBtn:SetOnClick(function()
    self:OnBtnClickFunc()
  end)
  self.bg = self:AddComponent(UIRawImage, "bg")
  self.nameTxt = self:AddComponent(UIText, "nameTxt")
  self.beselect = self:AddComponent(UIBaseContainer, "beselect")
end

local function ComponentDestroy(self)
  self.bgBtn = nil
  self.bg = nil
  self.nameTxt = nil
  self.beselect = nil
end

local function DataDefine(self)
  self.selfHomeId = 0
  self.curDataHomeId = 0
  self.selectHomeId = 0
  self.clickFunc = nil
end

local function DataDestroy(self)
  self.selfHomeId = nil
  self.curDataHomeId = nil
  self.selectHomeId = nil
  self.clickFunc = nil
end

local function SetData(self, selfHomeId, selectHomeId, clickFunc)
  self.selfHomeId = selfHomeId
  self.selectHomeId = selectHomeId
  self.clickFunc = clickFunc
  local curData = DataCenter.MasteryManager:GetData()
  self.curDataHomeId = curData.home_id
  self:Refresh()
end

local function SetSelectData(self, selectHomeId)
  self.selectHomeId = selectHomeId
  self.beselect:SetActive(self.selectHomeId == self.selfHomeId)
end

local function Refresh(self)
  self.beselect:SetActive(self.selectHomeId == self.selfHomeId)
  local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(self.selfHomeId)
  local imgName = ""
  local imgPath = ""
  if showTemp then
    self.nameTxt:SetLocalText(showTemp.name)
    imgName = showTemp.mastery_img
    imgPath = string.format(LoadPath.LWMasteryTexturePath, imgName)
    self.bg:LoadSpriteAsync(imgPath)
    local itemColor = 255
    if showTemp.lock then
      itemColor = 41
    end
    self.bg:SetColorRGBA255(itemColor, itemColor, itemColor, 255)
    self.nameTxt:SetColorRGBA255(itemColor, itemColor, itemColor, 255)
  end
end

local function OnBtnClickFunc(self)
  if self.clickFunc then
    self.clickFunc(self.selfHomeId)
  end
end

LWUIMasteryHaveChooseCompItem.OnCreate = OnCreate
LWUIMasteryHaveChooseCompItem.OnDestroy = OnDestroy
LWUIMasteryHaveChooseCompItem.ComponentDefine = ComponentDefine
LWUIMasteryHaveChooseCompItem.ComponentDestroy = ComponentDestroy
LWUIMasteryHaveChooseCompItem.DataDefine = DataDefine
LWUIMasteryHaveChooseCompItem.DataDestroy = DataDestroy
LWUIMasteryHaveChooseCompItem.SetData = SetData
LWUIMasteryHaveChooseCompItem.SetSelectData = SetSelectData
LWUIMasteryHaveChooseCompItem.Refresh = Refresh
LWUIMasteryHaveChooseCompItem.OnBtnClickFunc = OnBtnClickFunc
return LWUIMasteryHaveChooseCompItem
