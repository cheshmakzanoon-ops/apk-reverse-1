local UIActMonopolyTipView = BaseClass("UIActMonopolyTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local bg_path = "content/InfoContent/bg"
local title_path = "content/InfoContent/title"
local reward_tip_path = "content/InfoContent/rewardContent/contentReward/rewardTip"
local beiguang_path = "content/InfoContent/beiguang"
local bg_sea_path = "content/InfoContent/bg/bgContent3/bg_sea"
local front_yellowglow_path = "content/front_yellowglow"

local function OnCreate(self)
  base.OnCreate(self)
  self.eventLine = self:GetUserData()
  self.openTime = 0
  self.openAniTime = 0
  self.closeTime = 0
  self.closeAniTime = 0
  self.closeTimer = nil
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rootAni = self:AddComponent(UIAnimator, "")
  local btnPanel = self:AddComponent(UIButton, "panel")
  btnPanel:SetOnClick(function()
    self:TryCloseView()
  end)
  self.contentTxt = self:AddComponent(UITextMeshProUGUIEx, "content/InfoContent/rewardContent/contentTxt")
  self.contentReward = self:AddComponent(UIBaseContainer, "content/InfoContent/rewardContent/contentReward")
  self.uiCommonResItem = self:AddComponent(UICommonResItem, "content/InfoContent/rewardContent/contentReward/UICommonResItem")
  self.rewardNum = self:AddComponent(UITextMeshProUGUIEx, "content/InfoContent/rewardContent/contentReward/rewardNum")
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.beiguang = self:AddComponent(UIVfx, beiguang_path)
  self.front_yellowglow = self:AddComponent(UIVfx, front_yellowglow_path)
  self.reward_tip = self:AddComponent(UITextMeshProUGUIEx, reward_tip_path)
  self.bg_sea = self:AddComponent(UIRawImage, bg_sea_path)
end

local function ComponentDestroy(self)
  self.beiguang = nil
  self.front_yellowglow = nil
  self.reward_tip = nil
  self.bg_sea = nil
end

local function RefreshView(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.openTime = curTime
  _, self.openAniTime = self.rootAni:PlayAnimationReturnTime("Eff_UIHalloweenActMonopolyTipShow")
  if self.openAniTime == nil then
    self.openAniTime = 0
  end
  local bannerPath = string.format(UIAssets.UIActMonopolyTexturePath, self.eventLine.banner)
  self.bg_sea:LoadSprite(bannerPath)
  self.title:SetLocalText(self.eventLine.name)
  if self.eventLine.event == ActMonopolyEventType.GetReward then
    self.contentTxt:SetActive(false)
    self.contentReward:SetActive(true)
    local dataArr
    if not string.IsNullOrEmpty(self.eventLine.reward_show) then
      dataArr = string.string2array_i_oneSep(self.eventLine.reward_show, ";")
    end
    if dataArr and #dataArr == 2 then
      local goodsId = dataArr[1]
      local goodsNum = dataArr[2]
      local param = {
        rewardType = RewardType.GOODS,
        itemId = goodsId
      }
      self.uiCommonResItem:ReInit(param)
      self.rewardNum:SetText("x" .. goodsNum)
    end
  elseif self.eventLine.event == ActMonopolyEventType.Sport then
    self.contentTxt:SetActive(true)
    self.contentReward:SetActive(true)
    local content = Localization:GetString(self.eventLine.desc)
    self.contentTxt:SetText(content)
    local dataArr
    if not string.IsNullOrEmpty(self.eventLine.reward_show) then
      dataArr = string.string2array_i_oneSep(self.eventLine.reward_show, ";")
    end
    if dataArr and #dataArr == 2 then
      local goodsId = dataArr[1]
      local goodsNum = dataArr[2]
      local param = {
        rewardType = RewardType.GOODS,
        itemId = goodsId
      }
      self.uiCommonResItem:ReInit(param)
      self.rewardNum:SetText("x" .. goodsNum)
    end
  else
    self.contentTxt:SetActive(true)
    self.contentReward:SetActive(false)
    local content = Localization:GetString(self.eventLine.desc)
    self.contentTxt:SetText(content)
  end
  local showPara = self.eventLine.c_para
  if not string.IsNullOrEmpty(showPara) then
    local showParaList = string.split(showPara, "|")
    local effectPath, effectPath2, txtColor
    if #showParaList == 3 then
      effectPath = showParaList[1]
      effectPath2 = showParaList[2]
      txtColor = showParaList[3]
    elseif #showParaList == 2 then
      effectPath = showParaList[1]
      txtColor = showParaList[2]
    end
    if effectPath then
      self.beiguang:Play(effectPath, {
        lifeType = UIVfxLifeType.Stay
      })
    end
    if effectPath2 then
      self.front_yellowglow:Play(effectPath2, {
        lifeType = UIVfxLifeType.Stay
      })
    end
    if txtColor then
      local txtColorArr = string.string2array_i_oneSep(txtColor, ",")
      if txtColorArr and #txtColorArr == 3 then
        self.contentTxt:SetColorRGBA255(txtColorArr[1], txtColorArr[2], txtColorArr[3], 255)
        self.title:SetColorRGBA255(txtColorArr[1], txtColorArr[2], txtColorArr[3], 255)
        self.reward_tip:SetColorRGBA255(255, 255, 255, 255)
        self.rewardNum:SetColorRGBA255(255, 255, 255, 255)
      end
    end
  end
end

local function TryCloseView(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - self.openTime < self.openAniTime then
    return
  end
  if self.closeTime == 0 then
    self.closeTime = curTime
    _, self.closeAniTime = self.rootAni:PlayAnimationReturnTime("Eff_UIHalloweenActMonopolyTipClose")
    if self.closeAniTime == nil then
      self.closeAniTime = 0.1
    end
    self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.closeTimer = nil
      self.ctrl:CloseSelf()
    end, self.closeAniTime)
  end
end

UIActMonopolyTipView.OnCreate = OnCreate
UIActMonopolyTipView.OnDestroy = OnDestroy
UIActMonopolyTipView.ComponentDefine = ComponentDefine
UIActMonopolyTipView.ComponentDestroy = ComponentDestroy
UIActMonopolyTipView.RefreshView = RefreshView
UIActMonopolyTipView.TryCloseView = TryCloseView
return UIActMonopolyTipView
