local BirthdayYearNumContent = BaseClass("BirthdayYearNumContent", UIBaseContainer)
local base = UIBaseContainer
local NumImgPosDict = {
  ["1"] = 0,
  ["2"] = 1,
  ["3"] = 2,
  ["4"] = 3,
  ["5"] = 4,
  ["6"] = 5,
  ["7"] = 6,
  ["8"] = 7,
  ["9"] = 8,
  ["0"] = 9
}
local NumImgSize = 10
local NumSznColor = {
  [BirthdaySzn.Spring] = {
    color = "97df52",
    outlineColor = "fcfdbd",
    shadowColor = "feda35",
    shadow2Color = "7bc13e"
  },
  [BirthdaySzn.Summer] = {
    color = "fe8c5a",
    outlineColor = "fef8ac",
    shadowColor = "feaf17",
    shadow2Color = "dc6641"
  },
  [BirthdaySzn.Fall] = {
    color = "ffb21b",
    outlineColor = "fdf298",
    shadowColor = "feb118",
    shadow2Color = "d6810d"
  },
  [BirthdaySzn.Winter] = {
    color = "8adaf4",
    outlineColor = "ffffdb",
    shadowColor = "f3bc50",
    shadow2Color = "8ea0b5"
  }
}
local shadow1_path = "ShadowContent/Shadow1"
local shadow1_img_path = "ShadowContent/Shadow1/Shadow1Img"
local shadow2_path = "ShadowContent/Shadow2"
local shadow2_img_path = "ShadowContent/Shadow2/Shadow2Img"
local shadow3_path = "ShadowContent/Shadow3"
local shadow3_img_path = "ShadowContent/Shadow3/Shadow3Img"
local shadow4_path = "ShadowContent/Shadow4"
local shadow4_img_path = "ShadowContent/Shadow4/Shadow4Img"
local out_line1_path = "OutLineContent/OutLine1"
local out_line1_img_path = "OutLineContent/OutLine1/OutLine1Img"
local out_line2_path = "OutLineContent/OutLine2"
local out_line2_img_path = "OutLineContent/OutLine2/OutLine2Img"
local out_line3_path = "OutLineContent/OutLine3"
local out_line3_img_path = "OutLineContent/OutLine3/OutLine3Img"
local out_line4_path = "OutLineContent/OutLine4"
local out_line4_img_path = "OutLineContent/OutLine4/OutLine4Img"
local num1_path = "NumContent/Num1"
local num1_img_path = "NumContent/Num1/Num1Img"
local num2_path = "NumContent/Num2"
local num2_img_path = "NumContent/Num2/Num2Img"
local num3_path = "NumContent/Num3"
local num3_img_path = "NumContent/Num3/Num3Img"
local num4_path = "NumContent/Num4"
local num4_img_path = "NumContent/Num4/Num4Img"
local shadow_b1_path = "ShadowBContent/ShadowB1"
local shadow_b1_img_path = "ShadowBContent/ShadowB1/ShadowB1Img"
local shadow_b2_path = "ShadowBContent/ShadowB2"
local shadow_b2_img_path = "ShadowBContent/ShadowB2/ShadowB2Img"
local shadow_b3_path = "ShadowBContent/ShadowB3"
local shadow_b3_img_path = "ShadowBContent/ShadowB3/ShadowB3Img"
local shadow_b4_path = "ShadowBContent/ShadowB4"
local shadow_b4_img_path = "ShadowBContent/ShadowB4/ShadowB4Img"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.shadow1 = self:AddComponent(UIBaseContainer, shadow1_path)
  self.shadow1_img = self:AddComponent(UIRawImage, shadow1_img_path)
  self.shadow2 = self:AddComponent(UIBaseContainer, shadow2_path)
  self.shadow2_img = self:AddComponent(UIRawImage, shadow2_img_path)
  self.shadow3 = self:AddComponent(UIBaseContainer, shadow3_path)
  self.shadow3_img = self:AddComponent(UIRawImage, shadow3_img_path)
  self.shadow4 = self:AddComponent(UIBaseContainer, shadow4_path)
  self.shadow4_img = self:AddComponent(UIRawImage, shadow4_img_path)
  self.out_line1 = self:AddComponent(UIBaseContainer, out_line1_path)
  self.out_line1_img = self:AddComponent(UIRawImage, out_line1_img_path)
  self.out_line2 = self:AddComponent(UIBaseContainer, out_line2_path)
  self.out_line2_img = self:AddComponent(UIRawImage, out_line2_img_path)
  self.out_line3 = self:AddComponent(UIBaseContainer, out_line3_path)
  self.out_line3_img = self:AddComponent(UIRawImage, out_line3_img_path)
  self.out_line4 = self:AddComponent(UIBaseContainer, out_line4_path)
  self.out_line4_img = self:AddComponent(UIRawImage, out_line4_img_path)
  self.num1 = self:AddComponent(UIBaseContainer, num1_path)
  self.num1_img = self:AddComponent(UIRawImage, num1_img_path)
  self.num2 = self:AddComponent(UIBaseContainer, num2_path)
  self.num2_img = self:AddComponent(UIRawImage, num2_img_path)
  self.num3 = self:AddComponent(UIBaseContainer, num3_path)
  self.num3_img = self:AddComponent(UIRawImage, num3_img_path)
  self.num4 = self:AddComponent(UIBaseContainer, num4_path)
  self.num4_img = self:AddComponent(UIRawImage, num4_img_path)
  self.shadow_b1 = self:AddComponent(UIBaseContainer, shadow_b1_path)
  self.shadow_b1_img = self:AddComponent(UIRawImage, shadow_b1_img_path)
  self.shadow_b2 = self:AddComponent(UIBaseContainer, shadow_b2_path)
  self.shadow_b2_img = self:AddComponent(UIRawImage, shadow_b2_img_path)
  self.shadow_b3 = self:AddComponent(UIBaseContainer, shadow_b3_path)
  self.shadow_b3_img = self:AddComponent(UIRawImage, shadow_b3_img_path)
  self.shadow_b4 = self:AddComponent(UIBaseContainer, shadow_b4_path)
  self.shadow_b4_img = self:AddComponent(UIRawImage, shadow_b4_img_path)
  self.numCompArr = {
    [1] = {
      shadow = self.shadow1,
      shadowImg = self.shadow1_img,
      outLine = self.out_line1,
      outLineImg = self.out_line1_img,
      num = self.num1,
      numImg = self.num1_img,
      shadowB = self.shadow_b1,
      shadowBImg = self.shadow_b1_img
    },
    [2] = {
      shadow = self.shadow2,
      shadowImg = self.shadow2_img,
      outLine = self.out_line2,
      outLineImg = self.out_line2_img,
      num = self.num2,
      numImg = self.num2_img,
      shadowB = self.shadow_b2,
      shadowBImg = self.shadow_b2_img
    },
    [3] = {
      shadow = self.shadow3,
      shadowImg = self.shadow3_img,
      outLine = self.out_line3,
      outLineImg = self.out_line3_img,
      num = self.num3,
      numImg = self.num3_img,
      shadowB = self.shadow_b3,
      shadowBImg = self.shadow_b3_img
    },
    [4] = {
      shadow = self.shadow4,
      shadowImg = self.shadow4_img,
      outLine = self.out_line4,
      outLineImg = self.out_line4_img,
      num = self.num4,
      numImg = self.num4_img,
      shadowB = self.shadow_b4,
      shadowBImg = self.shadow_b4_img
    }
  }
end

local function ComponentDestroy(self)
  self.shadow1 = nil
  self.shadow1_img = nil
  self.shadow2 = nil
  self.shadow2_img = nil
  self.shadow3 = nil
  self.shadow3_img = nil
  self.shadow4 = nil
  self.shadow4_img = nil
  self.out_line1 = nil
  self.out_line1_img = nil
  self.out_line2 = nil
  self.out_line2_img = nil
  self.out_line3 = nil
  self.out_line3_img = nil
  self.out_line4 = nil
  self.out_line4_img = nil
  self.num1 = nil
  self.num1_img = nil
  self.num2 = nil
  self.num2_img = nil
  self.num3 = nil
  self.num3_img = nil
  self.num4 = nil
  self.num4_img = nil
  self.shadow_b1 = nil
  self.shadow_b1_img = nil
  self.shadow_b2 = nil
  self.shadow_b2_img = nil
  self.shadow_b3 = nil
  self.shadow_b3_img = nil
  self.shadow_b4 = nil
  self.shadow_b4_img = nil
  self.numCompArr = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, year, sznType)
  local yearStr = year and tostring(year) or ""
  local numLenMax = 4
  for i = 1, numLenMax do
    local compIndex = i
    if i <= #yearStr then
      self.numCompArr[compIndex].shadow:SetActive(true)
      self.numCompArr[compIndex].outLine:SetActive(true)
      self.numCompArr[compIndex].num:SetActive(true)
      self.numCompArr[compIndex].shadowB:SetActive(true)
      local imgPos = 0
      local num = string.SubStr(yearStr, i, i)
      if NumImgPosDict[num] then
        imgPos = NumImgPosDict[num]
      end
      local uvWidth = 1 / NumImgSize
      local uvHeight = 1
      local uvX = imgPos * uvWidth
      local uvY = 0
      self.numCompArr[compIndex].shadowImg:SetUVRectPositionAndSize(uvX, uvY, uvWidth, uvHeight)
      self.numCompArr[compIndex].outLineImg:SetUVRectPositionAndSize(uvX, uvY, uvWidth, uvHeight)
      self.numCompArr[compIndex].numImg:SetUVRectPositionAndSize(uvX, uvY, uvWidth, uvHeight)
      self.numCompArr[compIndex].shadowBImg:SetUVRectPositionAndSize(uvX, uvY, uvWidth, uvHeight)
      self.numCompArr[compIndex].numImg:SetColorHex(NumSznColor[sznType].color)
      self.numCompArr[compIndex].outLineImg:SetColorHex(NumSznColor[sznType].outlineColor)
      self.numCompArr[compIndex].shadowImg:SetColorHex(NumSznColor[sznType].shadowColor)
      self.numCompArr[compIndex].shadowBImg:SetColorHex(NumSznColor[sznType].shadow2Color)
    else
      self.numCompArr[compIndex].shadow:SetActive(false)
      self.numCompArr[compIndex].outLine:SetActive(false)
      self.numCompArr[compIndex].num:SetActive(false)
      self.numCompArr[compIndex].shadowB:SetActive(false)
    end
  end
end

BirthdayYearNumContent.OnCreate = OnCreate
BirthdayYearNumContent.OnDestroy = OnDestroy
BirthdayYearNumContent.ComponentDefine = ComponentDefine
BirthdayYearNumContent.ComponentDestroy = ComponentDestroy
BirthdayYearNumContent.DataDefine = DataDefine
BirthdayYearNumContent.DataDestroy = DataDestroy
BirthdayYearNumContent.SetData = SetData
return BirthdayYearNumContent
