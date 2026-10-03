local StageRewardItem = BaseClass("StageRewardItem", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local GameObject = CS.UnityEngine.GameObject
local Type_CS_Image = typeof(CS.UnityEngine.UI.Image)
local Type_CS_RectTransform = typeof(CS.UnityEngine.RectTransform)
local StageStateType = DataCenter.TacticalCardDataManager.StageStateType
local UNOPENED_BOX_ICON_PATH = "Assets/Main/Sprites/UI/UILWTCCardBook/lrb_guanjunduijue_baoxiangguan0%d.png"
local OPENED_BOX_ICON_PATH = "Assets/Main/Sprites/UI/UILWTCCardBook/cfm_renwu_baoxiang_kai_%d.png"
local ARROW_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_xuanze_duihao.png"
local EFFECT_PREFAB_PATH = "Assets/Main/Prefabs/UI/DigTreasure/effect/Eff_ui_dig_treasure_rewards.prefab"
local EFFECT_OPEN_PATH = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_reward_loop.prefab"
local box_icon_path = "box_icon"
local goal_text_path = "goal_txt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveAddOns()
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
  self.boxIcon = self:AddComponent(UIImage, box_icon_path)
  self.goalText = self:AddComponent(UIText, goal_text_path)
  self.rewardEffect = self:AddComponent(UIVfx, "effect")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if self.onClick then
      self.onClick(self, self.index)
    end
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.boxIcon = nil
  self.goalText = nil
  self.rewardEffect = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function StageRewardItem:SetOnClick(onClick)
  self.onClick = onClick
end

function StageRewardItem:SetData(index, needCnt, state, curCnt, type)
  self.index = index
  self.needCnt = needCnt
  self.state = state
  self.curCnt = curCnt
  self.type = type
end

function StageRewardItem:UpdateData()
  self.goalText:SetText(self.needCnt)
  self:RefreshClaimedState(self.state == StageStateType.received)
  self:RefreshCanClaimState(self.curCnt)
  base.UpdateData(self)
end

function StageRewardItem:RefreshClaimedState(claimed)
  local index = 1
  if self.type == TacticalCardType.Core then
    index = 4
  else
    index = 3
  end
  if claimed then
    self.boxIcon:LoadSprite(string.format(OPENED_BOX_ICON_PATH, index))
    self:SetCheckMarkState(true)
  else
    self.boxIcon:LoadSprite(string.format(UNOPENED_BOX_ICON_PATH, index))
    self:SetCheckMarkState(false)
  end
end

function StageRewardItem:RefreshCanClaimState(curCnt)
  self.curCnt = curCnt
  local isReceived = self.state == StageStateType.received
  local isCanReceive = curCnt >= self.needCnt and not isReceived or self.state == StageStateType.can_receive
  self:SetRewardEffectState(isCanReceive)
  self:SetRedPointState(isCanReceive)
end

function StageRewardItem:SetCheckMarkState(show)
  if show and not self.checkMark then
    local checkMarkObj = GameObject("CheckMark")
    checkMarkObj:AddComponent(Type_CS_Image)
    checkMarkObj.transform:SetParent(self.gameObject.transform)
    self.checkMark = self:AddComponent(UIImage, "CheckMark")
    self.checkMark:SetLocalScaleXYZ(0.6, 0.6, 0.6)
    self.checkMark:SetAnchoredPositionXY(0, 0)
    self.checkMark:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_xuanze_duihao.png")
    self.checkMark:SetNativeSize()
  end
  if self.checkMark then
    self.checkMark:SetActive(show)
  end
end

function StageRewardItem:SetRedPointState(show)
  if show and not self.redPoint then
    local redPointObj = GameObject("RedPoint")
    redPointObj:AddComponent(Type_CS_Image)
    redPointObj.transform:SetParent(self.gameObject.transform)
    self.redPoint = self:AddComponent(UIImage, "RedPoint")
    self.redPoint:SetLocalScaleXYZ(1, 1, 1)
    self.redPoint:SetSizeDeltaXY(17.92, 19.2)
    self.redPoint:SetAnchoredPositionXY(24, 20)
    self.redPoint:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_hongdian_xiao.png")
  end
  if self.redPoint then
    self.redPoint:SetActive(show)
  end
end

local EFFECT_PARAM = {duration = 1, onRemove = nil}

function StageRewardItem:SetRewardEffectState(show)
  if show then
    self.rewardEffect:PlayByStay(EFFECT_OPEN_PATH)
  else
    self.rewardEffect:Remove()
  end
end

function StageRewardItem:RemoveAddOns()
  if self.checkMark then
    local obj = self.checkMark.gameObject
    self.checkMark = nil
    if not IsNull(obj) then
      obj.transform:SetParent(nil)
      GameObject.Destroy(obj)
    end
  end
  if self.redPoint then
    local obj = self.redPoint.gameObject
    self.redPoint = nil
    if not IsNull(obj) then
      obj.transform:SetParent(nil)
      GameObject.Destroy(obj)
    end
  end
end

StageRewardItem.OnCreate = OnCreate
StageRewardItem.OnDestroy = OnDestroy
StageRewardItem.OnEnable = OnEnable
StageRewardItem.OnDisable = OnDisable
StageRewardItem.ComponentDefine = ComponentDefine
StageRewardItem.ComponentDestroy = ComponentDestroy
StageRewardItem.DataDefine = DataDefine
StageRewardItem.DataDestroy = DataDestroy
StageRewardItem.OnAddListener = OnAddListener
StageRewardItem.OnRemoveListener = OnRemoveListener
return StageRewardItem
