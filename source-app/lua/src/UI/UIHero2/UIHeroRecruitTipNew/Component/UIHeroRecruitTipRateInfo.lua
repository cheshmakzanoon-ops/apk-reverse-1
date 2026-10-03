local UIHeroRecruitTipRateInfo = BaseClass("UIHeroRecruitTipRateInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ImgRarity_path = "ImgRarity"
local TextTitle_path = "TextTitle"
local TextValue_path = "TextValue"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.attrList = {}
  for i = 1, 5 do
    local attrItem = self:AddComponent(UIBaseContainer, "NodeAttr" .. i)
    attrItem.imgRarity = attrItem:AddComponent(UIImage, ImgRarity_path)
    attrItem.textTitle = attrItem:AddComponent(UIText, TextTitle_path)
    attrItem.textValue = attrItem:AddComponent(UIText, TextValue_path)
    self.attrList[i] = attrItem
  end
end

local function ComponentDestroy(self)
  self.attrList = nil
end

local function GetRarityImg(rarityId)
  local imgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_ur.png"
  if rarityId == 0 then
    imgPath = "Assets/Main/Sprites/UI/UIHeroRecruit/cfm_yingxiong_tubiao_zhanli"
  elseif rarityId == 1 then
    imgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_ur.png"
  elseif rarityId == 2 then
    imgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_ssr.png"
  elseif rarityId == 3 then
    imgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_sr.png"
  elseif rarityId == 4 then
    imgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_r.png"
  end
  return imgPath
end

local function GetRarityName(rarityId)
  local name = ""
  if rarityId == 0 then
    name = Localization:GetString("110119")
  elseif rarityId == 1 then
    name = Localization:GetString("110122")
  elseif rarityId == 2 then
    name = Localization:GetString("110121")
  elseif rarityId == 3 then
    name = Localization:GetString("110120")
  elseif rarityId == 4 then
    name = ""
  end
  return name
end

local function SetData(self, lotteryId)
  self.lotteryId = lotteryId
  local showType = {
    1,
    2,
    3,
    4,
    0
  }
  local dropRateInfo = self.view.ctrl:GetDropRateInfo(self.lotteryId)
  for index, rarityId in pairs(showType) do
    local rate = tonumber(dropRateInfo[rarityId])
    self.attrList[index]:SetActive(rate ~= nil and rate ~= 0)
    if rate ~= nil then
      local imgPath = GetRarityImg(rarityId)
      self.attrList[index].imgRarity:LoadSprite(imgPath)
      self.attrList[index].imgRarity:SetNativeSize()
      local name = GetRarityName(rarityId)
      self.attrList[index].textTitle:SetText(name)
      self.attrList[index].textValue:SetText(rate .. "%")
    end
  end
end

UIHeroRecruitTipRateInfo.OnCreate = OnCreate
UIHeroRecruitTipRateInfo.OnDestroy = OnDestroy
UIHeroRecruitTipRateInfo.ComponentDefine = ComponentDefine
UIHeroRecruitTipRateInfo.ComponentDestroy = ComponentDestroy
UIHeroRecruitTipRateInfo.SetData = SetData
return UIHeroRecruitTipRateInfo
