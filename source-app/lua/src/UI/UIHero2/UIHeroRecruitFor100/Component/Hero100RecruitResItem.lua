local Hero100RecruitResItem = BaseClass("Hero100RecruitResItem", UIBaseContainer)
local SHOW_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/UI/Chouka/Eff_ui_peijian_mubiaoshengji_cheng.prefab"
local UICommonResItemName = "UICommonResItem"
local root_path = "Root"
local u_i_common_res_item_point_path = "Root/ItemPoint"
local u_i_common_res_item_path = "Root/ItemPoint/" .. UICommonResItemName
local eff_point_path = "Root/EffPoint"
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.resItemPoint = self:AddComponent(UIBaseContainer, u_i_common_res_item_point_path)
  self.showEff = self:AddComponent(UIVfx, eff_point_path, SHOW_EFFECT_PATH, {
    lifeType = UIVfxLifeType.DestroyAfterOnce
  })
end

local function ComponentDestroy(self)
  self.commonResItemObj = nil
  self.root = nil
  if self.itemReq then
    self:GameObjectDestroy(self.itemReq)
    self.itemReq = nil
  end
end

local function DataDefine(self)
  self.emptyData = true
end

local function DataDestroy(self)
  self.emptyData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function Hero100RecruitResItem:SetData(itemData, isHeroDraw)
  local type = itemData.type
  local rewardType, id, num
  if isHeroDraw then
    rewardType = RewardType.GOODS
    id = itemData.id
    num = itemData.addNumber
    if type == 2 then
      rewardType = RewardType.GOODS
      id = itemData.GoodsId
      num = itemData.addNumber
    elseif type == 5 then
      rewardType = RewardType.RESOURCE_ITEM
      id = itemData.id
      num = itemData.num
    end
  elseif type == RewardType.GOODS then
    rewardType = RewardType.GOODS
    id = itemData.value.id
    num = itemData.value.num
  else
    Logger.LogError("Hero100RecruitResItem   \229\185\184\229\173\152\232\128\133\231\153\190\230\138\189\228\184\139\229\143\145\228\186\134\230\156\170\231\159\165\231\177\187\229\158\139\231\154\132\229\165\150\229\138\177\239\188\154" .. type)
  end
  if not IsNull(self.gameObject) then
    self:SetActive(true)
  end
  local param = UICommonResItem.Param.New()
  param.rewardType = rewardType
  param.itemId = id
  param.count = num
  self:RefreshResItem(param)
  self.emptyData = false
end

function Hero100RecruitResItem:RefreshResItem(itemParam)
  if self.itemReq and not self.itemReq.isDone then
    self:GameObjectDestroy(self.itemReq)
  end
  if self.commonResItem then
    self:OnResItemLoadFinish(itemParam)
    return
  end
  self.itemReq = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.name = UICommonResItemName
    go.transform:SetParent(self.resItemPoint.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_sizeDelta(90, 90)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_pivot(0.5, 0.5)
    self.commonResItem = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
    self:OnResItemLoadFinish(itemParam)
  end)
end

function Hero100RecruitResItem:OnResItemLoadFinish(itemParam)
  if self.commonResItem then
    self.commonResItem:ReInit(itemParam)
  end
end

function Hero100RecruitResItem:SetShowHideState(isShow, isPlayEff)
  if not self.root then
    return
  end
  self.root:SetActive(isShow)
  if isShow and isPlayEff then
    self.showEff:Replay()
  end
end

function Hero100RecruitResItem:ResetData()
  if not IsNull(self.gameObject) then
    self.root:SetActive(false)
  end
  self.emptyData = true
end

Hero100RecruitResItem.OnCreate = OnCreate
Hero100RecruitResItem.OnDestroy = OnDestroy
Hero100RecruitResItem.OnEnable = OnEnable
Hero100RecruitResItem.OnDisable = OnDisable
Hero100RecruitResItem.ComponentDefine = ComponentDefine
Hero100RecruitResItem.ComponentDestroy = ComponentDestroy
Hero100RecruitResItem.DataDefine = DataDefine
Hero100RecruitResItem.DataDestroy = DataDestroy
Hero100RecruitResItem.OnAddListener = OnAddListener
Hero100RecruitResItem.OnRemoveListener = OnRemoveListener
return Hero100RecruitResItem
