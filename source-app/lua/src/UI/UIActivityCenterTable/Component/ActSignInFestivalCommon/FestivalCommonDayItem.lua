local base = UIBaseContainer
local FestivalCommonDayItem = BaseClass("FestivalCommonDayItem", base)
local Thanksgiving2025BannerEffectPath1 = "Assets/Main/Prefabs/UI/Act2025Thanksgiving/Eff_ui_ThanksGiving2025_Day7_d_Variant.prefab"
local Thanksgiving2025BannerEffectPath2 = "Assets/Main/Prefabs/UI/Act2025Thanksgiving/Eff_ui_ThanksGiving2025_Day7_u_Variant.prefab"
local rewardItem_path = "rewardItem"
local dayNumberTxt_path = "dayNumberText"
local dayTxt_path = "dayText"
local claimed_path = "claimed"
local canClaim_path = "canclaim"
local btn_path = ""
local bgPath = "bg"
local effect_node1_path = "effectNode1"
local effect_node2_path = "effectNode2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveEffects()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rewardItem = self:AddComponent(UIBaseContainer, rewardItem_path)
  self.dayNumberTxt = self:AddComponent(UITextMeshProUGUIEx, dayNumberTxt_path)
  self.dayTxt = self:AddComponent(UITextMeshProUGUIEx, dayTxt_path)
  self.claimed = self:AddComponent(UIBaseContainer, claimed_path)
  self.canClaim = self:AddComponent(UIBaseContainer, canClaim_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetSafeClickMode(true)
  self.btn:SetOnClick(function()
    if not self.data then
      return
    end
    if self.data.state == 2 then
      if self.reward then
        self.reward.btn:Click()
      end
      return
    end
    if self.data.state == 0 and self.data.day - 1 > self.nowDay then
      if self.reward then
        self.reward.btn:Click()
      end
      return
    end
    if self.onBtnClick then
      self.onBtnClick(self.data)
    end
  end)
  self.reward = self:AddComponent(UICommonResItem, rewardItem_path)
  self.dayNumberTxt:SetText("")
  self.bg = self:AddComponent(UIImage, bgPath)
  self.effectNode1 = self:AddComponent(UIBaseContainer, effect_node1_path)
  self.effectNode2 = self:AddComponent(UIBaseContainer, effect_node2_path)
end

local function ComponentDestroy(self)
  self.rewardItem = nil
  self.dayNumberTxt = nil
  self.dayTxt = nil
  self.claimed = nil
  self.canClaim = nil
  self.btn = nil
  self.bg = nil
end

local function DataDefine(self)
  self.itemShowConfig = nil
  self.data = nil
  self.onBtnClick = nil
end

local function DataDestroy(self)
  self.itemShowConfig = nil
  self.data = nil
  self.onBtnClick = nil
end

local function OnRefresh(self, data, nowDay, isFinalDay, itemShowConfig)
  self.data = data
  self.nowDay = nowDay
  self.isFinalDay = isFinalDay
  self.itemShowConfig = itemShowConfig
  local itemColor
  if not self.isFinalDay then
    itemColor = self.itemShowConfig.itemColor
  else
    itemColor = self.itemShowConfig.itemFinalColor
  end
  local descColorArr = string.split(itemColor, ";")
  if descColorArr then
    self.dayNumberTxt:SetColorRGBA255(descColorArr[1], descColorArr[2], descColorArr[3], descColorArr[4])
  end
  if data.day < 10 then
    self.dayNumberTxt:SetLocalText("activity_5401_tips5", "0" .. data.day)
  else
    self.dayNumberTxt:SetLocalText("activity_5401_tips5", data.day)
  end
  if data.state == 2 then
    self.claimed:SetActive(true)
    self.canClaim:SetActive(false)
  elseif data.state == 1 then
    self.claimed:SetActive(false)
    self.canClaim:SetActive(true)
  else
    local canClaim = nowDay >= data.day - 1
    self.claimed:SetActive(false)
    self.canClaim:SetActive(canClaim)
  end
  if self.data.showReward and self.data.showReward[1] then
    self.reward:SetActive(true)
    self.reward:ReInit(data.showReward[1])
    self.reward:SetImgQuailtyShow(not isFinalDay)
  else
    self.reward:SetActive(false)
  end
  self:ModifyItemByConfig()
end

local function SetBtnOnClick(self, func)
  self.onBtnClick = func
end

local function ModifyItemByConfig(self)
  if table.IsNullOrEmpty(self.itemShowConfig) then
    return
  end
  local bgPath = self.itemShowConfig.itemBg
  if self.isFinalDay then
    bgPath = self.itemShowConfig.itemFinalBg
  end
  self.bg:LoadSpriteAsync(bgPath)
  self:RemoveEffects()
  local showEffect = self.itemShowConfig.showEffect
  if self.isFinalDay and showEffect then
    local effectPath = self.itemShowConfig.effectPath
    if string.IsNullOrEmpty(effectPath) then
      return
    end
    local effectPathList = string.split(effectPath, "|")
    if table.length(effectPathList) ~= 2 then
      return
    end
    self.effect1 = self:GameObjectInstantiateAsync(effectPathList[1], function(request)
      if IsNull(request.gameObject) then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.effectNode1.transform)
      go.transform:Set_anchorMin(0, 0)
      go.transform:Set_anchorMax(1, 1)
      go.transform:Set_offsetMin(0, 0)
      go.transform:Set_offsetMax(0, 0)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    end)
    self.effect2 = self:GameObjectInstantiateAsync(effectPathList[2], function(request)
      if IsNull(request.gameObject) then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.effectNode2.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end)
  end
end

local function RemoveEffects(self)
  if self.effect1 then
    self:GameObjectDestroy(self.effect1)
    self.effect1 = nil
  end
  if self.effect2 then
    self:GameObjectDestroy(self.effect2)
    self.effect2 = nil
  end
end

FestivalCommonDayItem.OnCreate = OnCreate
FestivalCommonDayItem.OnDestroy = OnDestroy
FestivalCommonDayItem.OnEnable = OnEnable
FestivalCommonDayItem.OnDisable = OnDisable
FestivalCommonDayItem.ComponentDefine = ComponentDefine
FestivalCommonDayItem.ComponentDestroy = ComponentDestroy
FestivalCommonDayItem.DataDefine = DataDefine
FestivalCommonDayItem.DataDestroy = DataDestroy
FestivalCommonDayItem.OnRefresh = OnRefresh
FestivalCommonDayItem.SetBtnOnClick = SetBtnOnClick
FestivalCommonDayItem.ModifyItemByConfig = ModifyItemByConfig
FestivalCommonDayItem.RemoveEffects = RemoveEffects
return FestivalCommonDayItem
