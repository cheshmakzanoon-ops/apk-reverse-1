local UIProductLevelState = BaseClass("UIProductLevelState", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local pic_path = "icon"
local pics = {
  "Common_product_level_3",
  "Common_product_level_2",
  "Common_product_level_1"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:OnDataDefine()
  self:OnComponentDefine()
end

local function OnDestroy(self)
  self:OnDataDestroy()
  self:OnComponentDestroy()
  base.OnDestroy(self)
end

local function OnDataDefine(self)
  self.currentIndex = -1
end

local function OnComponentDefine(self)
  self.btn = self:AddComponent(UIButton, this_path)
  self.pic = self:AddComponent(UIImage, pic_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClick()
  end)
end

local function OnDataDestroy(self)
  self.currentIndex = nil
end

local function OnComponentDestroy(self)
  self.btn = nil
  self.pic = nil
end

local function ReInit(self, levels, callBack)
  self.levels = levels
  self.callBack = callBack
  self.totalPics = math.max(1, math.min(table.count(self.levels), table.count(pics)))
  local num = table.count(self.levels)
  if 0 < num then
    self:SetCurrentIndex(num)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnClick(self)
  if self.currentIndex <= 0 then
    return
  end
  self:SetCurrentIndex(self.currentIndex + 1)
end

local function SetCurrentIndex(self, index)
  self.currentIndex = index
  if self.currentIndex > table.count(self.levels) then
    self.currentIndex = 1
  end
  self:RefreshView()
  if self.callBack ~= nil then
    self.callBack(self.currentIndex, self.levels[self.currentIndex])
  end
end

local function RefreshView(self)
  local picIndex = math.max(math.min(self.currentIndex, self.totalPics), 1)
  local picPath = string.format(LoadPath.CommonNewPath, pics[picIndex])
  self.pic:LoadSprite(picPath)
end

UIProductLevelState.OnDestroy = OnDestroy
UIProductLevelState.OnCreate = OnCreate
UIProductLevelState.OnEnable = OnEnable
UIProductLevelState.OnDisable = OnDisable
UIProductLevelState.ReInit = ReInit
UIProductLevelState.OnDataDefine = OnDataDefine
UIProductLevelState.OnComponentDefine = OnComponentDefine
UIProductLevelState.OnDataDestroy = OnDataDestroy
UIProductLevelState.OnComponentDestroy = OnComponentDestroy
UIProductLevelState.OnClick = OnClick
UIProductLevelState.SetCurrentIndex = SetCurrentIndex
UIProductLevelState.RefreshView = RefreshView
return UIProductLevelState
