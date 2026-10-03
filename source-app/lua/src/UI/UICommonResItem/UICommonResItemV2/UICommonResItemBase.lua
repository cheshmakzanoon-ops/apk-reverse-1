local UICommonResItemBase = BaseClass("UICommonResItemBase")
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  self:ComponentDefineBase()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroyBase()
  self:DataDestroy()
  if self.metatable then
    setmetatable(self, self.metatable)
  end
  self.metatable = nil
  self.holder = nil
end

local function ComponentDefineBase(self)
end

local function ComponentDestroyBase(self)
end

local function OnEnable(self)
end

local function OnDisable(self)
end

local function DataDefine(self)
  self.theIcon = nil
  self.theName = nil
  self.theDesc = nil
  self.param = {}
  self.itemCountActive = nil
  self.tweenSeq = nil
  self.canClick = true
  self.flagText = nil
  self.flagActive = nil
  self.itemCount = nil
  self.nameText = nil
  self.seasonType = nil
end

local function DataDestroy(self)
  self.theIcon = nil
  self.theName = nil
  self.theDesc = nil
  self.param = nil
  self.itemCountActive = nil
  self.tweenSeq = nil
  self.canClick = nil
  self.flagText = nil
  self.flagActive = nil
  self.itemCount = nil
  self.nameText = nil
  self.seasonType = nil
  self:CloseTweenSeq()
end

local function ReInit(self, param)
  self.param = param
  if self.param.enableClick ~= nil then
    self.canClick = self.param.enableClick
  end
  self:SetDelete(self.param.isDelete)
  self:SetItemCountActive(self.param.count ~= nil)
  self:SetItemCount(self.param.count)
  self:SetItemCountColor(self.param.isShowArrow and EffectGreenColor or WhiteColor)
  self:SetReceflagActive(self.param.isShowReceFlag)
  self:SetImgQuailtyShow(self.param.rewardType)
  self:SetDoubleMark(self.param.isShowDoubleMark)
  self:SetMultiMarkIcon(self.param.multiple)
  self:SetRewardMarkState(self.param.trainRewardState)
  self:SetArrowState(self.param.isShowArrow)
  self:OnReInit()
end

local function OnBtnClick(self)
  if self.canClick ~= nil and self.canClick == false then
    return
  end
  if self.param.clickCallBack ~= nil then
    self.param.clickCallBack(self.param)
    return
  end
  self:OnClick()
  if self.param.clickAfterCallBack ~= nil then
    self.param.clickAfterCallBack(self.param)
  end
end

local function OnReInit(self)
  self:SetFlagActive(false)
  if self.param.itemColor then
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(self.param.itemColor))
  else
    self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(self.param.rewardType, self.param.itemId))
  end
  if self.param.iconName then
    self:SetItemIconImage(self.param.iconName)
  else
    self.theIcon = DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId, nil, true)
    self:SetItemIconImage(self.theIcon)
  end
  if self.param.itemName then
    self:SetNameText(self.param.itemName)
  else
    self.theName = DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId)
    self:SetNameText(self.theName)
  end
end

local function OnClick(self)
  local desc = ""
  local name = ""
  if string.IsNullOrEmpty(self.theName) or string.IsNullOrEmpty(self.theDesc) then
    if string.IsNullOrEmpty(self.param.itemName) then
      if self.theDesc == nil then
        self.theDesc = DataCenter.RewardManager:GetDescByType(self.param.rewardType, self.param.itemId)
      end
      if self.theName == nil then
        self.theName = DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId)
      end
    elseif self.param.isLocal then
      self.theDesc = self.param.itemDesc
      self.theName = self.param.itemName
    else
      self.theDesc = Localization:GetString(self.param.itemDesc)
      self.theName = Localization:GetString(self.param.itemName)
    end
  end
  desc = self.theDesc
  name = self.theName
  if string.IsNullOrEmpty(desc) and string.IsNullOrEmpty(name) then
    return
  end
  local param = {}
  param.itemName = name
  param.itemDesc = desc
  param.alignObject = self.item_icon
  param.isLocal = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

local function SetHolder(self, holder)
  self.holder = holder
  if not self.metatable then
    self.metatable = getmetatable(self)
  end
  local vtbl = self.metatable.__index
  setmetatable(self, {
    __index = function(t, k)
      local ret
      if type(vtbl) == "function" then
        ret = vtbl(t, k)
      elseif type(vtbl) == "table" then
        ret = vtbl[k]
      end
      if ret then
        return ret
      end
      local inner = rawget(self, "holder")
      if not inner then
        return
      end
      local v = inner[k]
      if type(v) == "function" then
        local function f(_, ...)
          return v(inner, ...)
        end
        
        return f
      else
        return v
      end
    end
  })
end

function UICommonResItemBase:SetSeasonType(seasonType)
  self.seasonType = seasonType
end

UICommonResItemBase.OnCreate = OnCreate
UICommonResItemBase.OnDestroy = OnDestroy
UICommonResItemBase.OnEnable = OnEnable
UICommonResItemBase.OnDisable = OnDisable
UICommonResItemBase.ComponentDefineBase = ComponentDefineBase
UICommonResItemBase.ComponentDestroyBase = ComponentDestroyBase
UICommonResItemBase.DataDefine = DataDefine
UICommonResItemBase.DataDestroy = DataDestroy
UICommonResItemBase.ReInit = ReInit
UICommonResItemBase.OnReInit = OnReInit
UICommonResItemBase.OnBtnClick = OnBtnClick
UICommonResItemBase.OnClick = OnClick
UICommonResItemBase.SetHolder = SetHolder
return UICommonResItemBase
