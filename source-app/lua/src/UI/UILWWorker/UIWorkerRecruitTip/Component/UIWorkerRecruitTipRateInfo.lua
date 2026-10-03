local UIWorkerRecruitTipRateInfo = BaseClass("UIWorkerRecruitTipRateInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ImgRarity_path = "ImgRarity"
local TextTitle_path = "TextTitle"
local TextValue_path = "TextValue"
local itemShowNum = 6

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
  for i = 1, itemShowNum do
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
  elseif rarityId == 5 then
    imgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_n.png"
  end
  return imgPath
end

local function GetRarityName(rarityId)
  local name = ""
  if rarityId == 0 then
    name = Localization:GetString("110119")
  elseif rarityId == 1 then
    name = Localization:GetString("worker_ui109")
  elseif rarityId == 2 then
    name = Localization:GetString("worker_ui110")
  elseif rarityId == 3 then
    name = Localization:GetString("worker_ui111")
  elseif rarityId == 4 then
    name = Localization:GetString("worker_ui112")
  elseif rarityId == 5 then
    name = Localization:GetString("worker_ui113")
  end
  return name
end

local function SetData(self, lotteryId)
  local dataStr = LuaEntry.DataConfig:TryGetStr("worker_recruit_1", "k10")
  local dropRateInfo = string.string2array_s(dataStr, "|", ";")
  for index, rarityData in pairs(dropRateInfo) do
    local rarityId = tonumber(rarityData[1])
    local rate = tonumber(rarityData[2])
    if index <= itemShowNum then
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
end

UIWorkerRecruitTipRateInfo.OnCreate = OnCreate
UIWorkerRecruitTipRateInfo.OnDestroy = OnDestroy
UIWorkerRecruitTipRateInfo.ComponentDefine = ComponentDefine
UIWorkerRecruitTipRateInfo.ComponentDestroy = ComponentDestroy
UIWorkerRecruitTipRateInfo.SetData = SetData
return UIWorkerRecruitTipRateInfo
