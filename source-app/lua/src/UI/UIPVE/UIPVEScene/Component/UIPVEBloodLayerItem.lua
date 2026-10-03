local UIPVEBloodLayerItem = BaseClass("UIPVEBloodLayerItem", UIBaseContainer)
local base = UIBaseContainer
local blood_a_path = "bg/bloodA"
local blood_b_path = "bg/bloodB"
local enumImg = {
  "Assets/Main/Sprites/Guide/UIbattle_icon_soldiers_orange.png",
  "Assets/Main/Sprites/Guide/UIbattle_icon_soldiers_yellow.png",
  "Assets/Main/Sprites/Guide/UIbattle_icon_soldiers_green.png",
  "Assets/Main/Sprites/Guide/UIbattle_icon_soldiers_blue.png",
  "Assets/Main/Sprites/Guide/UIbattle_icon_soldiers_pur.png"
}

local function OnCreate(self)
  base.OnCreate(self)
  self.bloodA = self:AddComponent(UIImage, blood_a_path)
  self.bloodB = self:AddComponent(UIImage, blood_b_path)
  self.cacheBloodAColor = 0
  self.cacheBloodBColor = 0
  self.cacheAPercent = 0
  self.cacheBPercent = 0
  self.bloodA:SetFillAmount(self.cacheAPercent)
  self.bloodB:SetFillAmount(self.cacheBPercent)
  self.count = #enumImg
  self.animTime = 0
  self.lastPercent = 0
  self.targetPercent = 0
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function InitData(self, dataList, index, time)
  self.param = dataList[index]
  if self.param.layer <= 0 then
    self.cacheBloodAColor = 0
    self.cacheBloodBColor = 0
    self.cacheAPercent = 0
    self.cacheBPercent = 0
    self.bloodA:SetFillAmount(self.cacheAPercent)
    self.bloodB:SetFillAmount(self.cacheBPercent)
  else
    local bloodAColor = self.param.layer - 1
    local bloodBColor = self.param.layer
    if self.param.layer >= self.count then
      bloodAColor = (self.param.layer - 1) % self.count
      bloodBColor = self.param.layer % self.count
      if bloodAColor == 0 then
        bloodAColor = self.count
      end
      if bloodBColor == 0 then
        bloodBColor = self.count
      end
    end
    if bloodAColor ~= self.cacheBloodAColor then
      self.bloodA:LoadSprite(self:GetColorImgPathByIndex(bloodAColor))
      self.cacheBloodAColor = bloodAColor
    end
    if bloodBColor ~= self.cacheBloodBColor then
      self.bloodB:LoadSprite(self:GetColorImgPathByIndex(bloodBColor))
      self.cacheBloodBColor = bloodBColor
    end
    local percent = math.min(1, self.param.restNum / self.param.restLimit)
    if bloodAColor <= 0 then
      if self.cacheBPercent ~= percent then
        self.lastPercent = self.cacheBPercent
        self.targetPercent = percent
        self.cacheBPercent = percent
        self.animTime = time
        self.startTime = 0
        self.bloodB:SetFillAmount(self.cacheBPercent)
      end
      if 0 < self.cacheAPercent then
        self.cacheAPercent = 0
        self.bloodA:SetFillAmount(self.cacheAPercent)
      end
    else
      if self.cacheBPercent ~= percent then
        self.lastPercent = self.cacheBPercent
        self.targetPercent = percent
        self.cacheBPercent = percent
        self.animTime = time
        self.startTime = 0
        self.bloodB:SetFillAmount(self.cacheBPercent)
      end
      if self.cacheAPercent < 1 then
        self.cacheAPercent = 1
        self.bloodA:SetFillAmount(self.cacheAPercent)
      end
    end
  end
end

local function GetColorImgPathByIndex(self, index)
  if 0 < index then
    return enumImg[index]
  end
  return "Assets/Main/Sprites/Guide/UIbattle_icon_soldiers_orange.png"
end

UIPVEBloodLayerItem.OnCreate = OnCreate
UIPVEBloodLayerItem.OnDestroy = OnDestroy
UIPVEBloodLayerItem.OnEnable = OnEnable
UIPVEBloodLayerItem.OnDisable = OnDisable
UIPVEBloodLayerItem.InitData = InitData
UIPVEBloodLayerItem.GetColorImgPathByIndex = GetColorImgPathByIndex
return UIPVEBloodLayerItem
