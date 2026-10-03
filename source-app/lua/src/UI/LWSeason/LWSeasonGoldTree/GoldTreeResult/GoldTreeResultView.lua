local base = UIBaseView
local GoldTreeResult = BaseClass("GoldTreeResult", base)
local Localization = CS.GameEntry.Localization
local btn_path = "Bgs/Bg"
local back_path = "Root/PrizeItem/Back"
local tips_path = "Root/PrizeItem/Back/Tips"
local front_path = "Root/PrizeItem/Front"
local txtName_path = "Root/PrizeItem/Front/Name"
local icon_path = "Root/PrizeItem/Front/Icon"
local iconCount_path = "Root/PrizeItem/Front/IconCount"
local txtCount2_path = "Root/PrizeItem/Front/TxtCount2"
local animator_path = ""
local effect_path = "Root/PrizeItem/Front/IconCount/Eff_ui_GoldenTree_flower/icon10"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
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
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.data then
    EventManager:GetInstance():Broadcast(EventId.GoldTreeOpenCard, self.data)
  end
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.back = self:AddComponent(UIBaseContainer, back_path)
  self.tips = self:AddComponent(UIText, tips_path)
  self.front = self:AddComponent(UIBaseContainer, front_path)
  self.txtName = self:AddComponent(UIText, txtName_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.iconCount = self:AddComponent(UIImage, iconCount_path)
  self.txtCount2 = self:AddComponent(UIText, txtCount2_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
  self.effect = self.effect.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystemRenderer))
end

local function ComponentDestroy(self)
  if self.matReq ~= nil then
    self.matReq:Release()
    self.matReq = nil
  end
  self.btn = nil
  self.back = nil
  self.tips = nil
  self.front = nil
  self.txtName = nil
  self.icon = nil
  self.iconCount = nil
  self.txtCount2 = nil
  self.animator = nil
  self.effect = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreeResult:RefreshView()
  local data = self:GetUserData()
  if not data then
    return
  end
  self.data = data
  self.state = 0
  self.tips:SetActive(true)
  local prayData = DataCenter.SeasonGoldTreeManager:GetPrayCardInfo(data.day)
  if not prayData then
    return
  end
  local prayConf = DataCenter.SeasonGoldTreeTemplateManager:GetCardTemp(prayData.cardId)
  local multiplierConf = DataCenter.SeasonGoldTreeTemplateManager:GetCardMultiplierTemp(prayData.multiplierId)
  self.txtName:SetLocalText(prayConf.name)
  self.icon:LoadSprite(prayConf.icon)
  self.txtCount2:SetText(string.format("\195\151%s", multiplierConf.multiplier))
  self.resultTips = Localization:GetString("season_s4_golden_tree_UI_70", Localization:GetString(multiplierConf.name), multiplierConf.multiplier)
  if self.matReq ~= nil then
    self.matReq:Release()
    self.matReq = nil
  end
  if not string.IsNullOrEmpty(multiplierConf.material) then
    self.matReq = CS.GameEntry.Resource:LoadAssetAsync(multiplierConf.material, typeof(CS.UnityEngine.Material))
    if self.matReq then
      function self.matReq.completed(asset)
        if asset == nil then
          return
        end
        local mat = CS.UnityEngine.Material.Instantiate(asset.asset)
        self.effect.material = mat
      end
    end
  end
end

function GoldTreeResult:OnClick()
  if self.state == 0 then
    self.state = 1
    self.tips:SetActive(false)
    local cardReward = self.data.cardReward
    local flag, time = self.animator:PlayAnimationReturnTime("V_ui_GoldTreeResult_fanpai")
    if not flag or not cardReward then
      self.state = 2
      return
    end
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self.state = 2
      DataCenter.RewardManager:ShowCommonReward({reward = cardReward}, nil, nil, nil, nil, nil, nil, self.resultTips)
    end, time)
    return
  end
  if self.state == 2 then
    self.state = 3
    local flag, time = self.animator:PlayAnimationReturnTime("V_ui_GoldTreeResult_out")
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self.state = 4
      self.ctrl:CloseSelf()
    end, time)
  end
  if self.state > 3 then
    self.ctrl:CloseSelf()
  end
end

GoldTreeResult.OnCreate = OnCreate
GoldTreeResult.OnDestroy = OnDestroy
GoldTreeResult.OnEnable = OnEnable
GoldTreeResult.OnDisable = OnDisable
GoldTreeResult.ComponentDefine = ComponentDefine
GoldTreeResult.ComponentDestroy = ComponentDestroy
GoldTreeResult.DataDefine = DataDefine
GoldTreeResult.DataDestroy = DataDestroy
return GoldTreeResult
