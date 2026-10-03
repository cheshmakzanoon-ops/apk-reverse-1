local UILuckyRollItem = BaseClass("UILuckyRollItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local path = ""
local choice_img = "Img_Choice"
local item_bgPath = "Item_bg"
local choice = {
  [1] = "UIluckywheel_img_itemblue_add",
  [2] = "UIluckywheel_img_itempur_add",
  [3] = "UIluckywheel_img_itemorange_add"
}
local quality = {
  [1] = "UIluckywheel_img_itemblue",
  [2] = "UIluckywheel_img_itempur",
  [3] = "UIluckywheel_img_itemorange"
}

function UILuckyRollItem:OnCreate()
  base.OnCreate(self)
  self.anim = self:AddComponent(UIAnimator, path)
  self.item = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.itemBg = self:AddComponent(UIImage, item_bgPath)
end

local function RemoveHightLight(self)
  if self.effectRequest ~= nil then
    self:GameObjectDestroy(self.effectRequest)
    self.effectRequest = nil
  end
end

local function AddHightLight(self)
  if self.effectRequest ~= nil then
    return
  end
  self.effectRequest = self:GameObjectInstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/UI/Lianhuanduobao/Eff_ui_duobao_jiangli_faguang1.prefab", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.transform)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localScale(1.4, 1.1, 1)
    go.name = "effect"
  end)
end

function UILuckyRollItem:OnDestroy()
  if self.delayTime ~= nil then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  base.OnDestroy(self)
end

function UILuckyRollItem:OnEnable()
  if self.anim then
    self.anim:Play("V_ui_luckyroll_item_default", 0, 0)
  end
  base.OnEnable(self)
end

function UILuckyRollItem:OnDisable()
  base.OnDisable(self)
end

function UILuckyRollItem:RefreshData(data, callback, activitySubViewType)
  self.data = data
  self.rewardData = data.reward
  self.callback = callback
  self.state = self.rewardData.rewardFlag
  self.index = data.position
  self.anim:Play("V_ui_luckyroll_item_default", 0, 0)
  self:RefreshBox(activitySubViewType)
  local hightLight = GetTableData("activity_roll_para", data.itemId, "high_light")
  if hightLight == 1 then
    AddHightLight(self)
  else
    RemoveHightLight(self)
  end
end

function UILuckyRollItem:RefreshBox(activitySubViewType)
  if self.data.type == 0 then
    self.item:ReInit(self.rewardData[1])
    local quality = DataCenter.RewardManager:GetRewardQuality(self.rewardData[1].rewardType, self.rewardData[1].itemId)
    if activitySubViewType == nil or activitySubViewType ~= 2 then
      self.itemBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UILuckyRoll/cfm_huodong_dazhuanpan_zhuanpan_kuang_pinzhi_%d.png", quality))
    else
      self.itemBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIChristmasCitySkin/lrb_shengdanjie_zhuanpan_pinzhi0%d.png", quality))
    end
  else
  end
end

function UILuckyRollItem:PlayOneAnim(index, sign)
  self.anim:Play("V_ui_commonresltem_zhuanpan_shanshuo", 0, 0)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Lucky_Select, false)
  local time = 0.2
  if sign and index == self.index then
    time = 2
  end
  self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
    self.anim:Play("V_ui_luckyroll_item_default", 0, 0)
  end, time)
end

function UILuckyRollItem:PlayFiveAnim(index, sign)
  self.anim:Play("V_ui_commonresltem_zhuanpan_shanshuo", 0, 0)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Lucky_Select, false)
  local time = 0.2
  if sign and index == self.index then
    time = 0.5
  end
  self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
    self.anim:Play("V_ui_luckyroll_item_default", 0, 0)
  end, time)
end

function UILuckyRollItem:OnClickReward()
  local x = self.transform.position.x
  local y = self.transform.position.y
  local offset = 50
  local width = self._reward_btnTab[index].rectTransform.rect.width
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, Localization:GetString("370101"), ActivityEventType.PERSONAL, x, y, isLeft, self.eventInfo.rewardScoreIndexArr[index], width, offset)
end

function UILuckyRollItem:GetPos()
  if self.item.transform then
    return self.item.transform.position
  else
    return Vector3.zero
  end
end

return UILuckyRollItem
