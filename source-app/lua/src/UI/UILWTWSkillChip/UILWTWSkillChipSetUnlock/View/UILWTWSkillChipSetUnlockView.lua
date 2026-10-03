local base = UIBaseView
local UILWTWSkillChipSetUnlockView = BaseClass("UILWTWSkillChipSetUnlockView", base)
local spine_container_path = "Common_bg_orange/Common_bg_orange2/Root/spineContainer"
local content_title_txt_path = "Common_bg_orange/Common_bg_orange2/Root/title_txt"
local content_desc_txt_path = "Common_bg_orange/Common_bg_orange2/Root/desc_txt"
local buy_btn_path = "Common_bg_orange/Common_bg_orange2/Root/buy_btn"
local buy_btn_txt_path = "Common_bg_orange/Common_bg_orange2/Root/buy_btn/buyName"
local buy_cost_img_path = "Common_bg_orange/Common_bg_orange2/Root/buy_btn/price_layout/Image"
local buy_cost_txt_path = "Common_bg_orange/Common_bg_orange2/Root/buy_btn/price_layout/price"
local window_title_txt_path = "Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "Common_bg_orange/CloseBtn"
local closeMask_btn_path = "panel"
local DISPLAY_SPINE_HERO_ID = 40020

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local titleTxt, tipTitleTxt, tipDescTxt, costDiamond, confirmCallback = self:GetUserData()
  self.costDiamond = costDiamond
  self.confirmCallback = confirmCallback
  self.window_title_txt:SetText(titleTxt)
  self.content_title_txt:SetText(tipTitleTxt)
  self.content_desc_txt:SetText(tipDescTxt)
  self.buy_cost_img:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOLD, RewardType.GOLD))
  self.formattedCostStr = string.GetFormattedGoldNum(costDiamond)
  self:RefreshCost()
  self:LoadHeroSpine()
end

local function OnDestroy(self)
  self:DestroyHeroSpine()
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
  self.spine_container = self:AddComponent(UIBaseContainer, spine_container_path)
  self.content_title_txt = self:AddComponent(UIText, content_title_txt_path)
  self.content_desc_txt = self:AddComponent(UIText, content_desc_txt_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn_txt = self:AddComponent(UIText, buy_btn_txt_path)
  self.buy_cost_img = self:AddComponent(UIImage, buy_cost_img_path)
  self.buy_cost_txt = self:AddComponent(UIText, buy_cost_txt_path)
  self.window_title_txt = self:AddComponent(UIText, window_title_txt_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.closeMask_btn = self:AddComponent(UIButton, closeMask_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeMask_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.buy_btn:SetOnClick(function()
    if self.confirmCallback then
      self.confirmCallback()
      self.ctrl:CloseSelf()
    end
  end)
end

local function ComponentDestroy(self)
  self.spine_container = nil
  self.content_title_txt = nil
  self.content_desc_txt = nil
  self.buy_btn = nil
  self.buy_btn_txt = nil
  self.buy_cost_img = nil
  self.buy_cost_txt = nil
  self.window_title_txt = nil
  self.close_btn = nil
  self.closeMask_btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function LoadHeroSpine(self)
  if self.spineLoadRequest then
    return
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(DISPLAY_SPINE_HERO_ID)
  if not heroTemplate then
    return
  end
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), heroTemplate.appearance, "show_model_path")
  local spinePath_B = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), heroTemplate.appearance, "show_model_path_B")
  if not string.IsNullOrEmpty(spinePath_B) and CommonUtil.IsJapanABTest() then
    spinePath = spinePath_B
  end
  self.spineLoadRequest = self:GameObjectInstantiateAsync(spinePath, function(request)
    if IsNull(request.gameObject) then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.spine_container.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end)
end

local function DestroyHeroSpine(self)
  if self.spineLoadRequest then
    self.spineLoadRequest:Destroy()
    self.spineLoadRequest = nil
  end
end

local function RefreshCost(self)
  local cost = self.costDiamond
  local haveDiamond = LuaEntry.Player.gold
  if cost > haveDiamond then
    self.buy_cost_txt:SetText(string.format("<color=#F97077>%s</color>", self.formattedCostStr))
  else
    self.buy_cost_txt:SetText(self.formattedCostStr)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGold, RefreshCost)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGold, RefreshCost)
end

UILWTWSkillChipSetUnlockView.OnCreate = OnCreate
UILWTWSkillChipSetUnlockView.OnDestroy = OnDestroy
UILWTWSkillChipSetUnlockView.OnEnable = OnEnable
UILWTWSkillChipSetUnlockView.OnDisable = OnDisable
UILWTWSkillChipSetUnlockView.ComponentDefine = ComponentDefine
UILWTWSkillChipSetUnlockView.ComponentDestroy = ComponentDestroy
UILWTWSkillChipSetUnlockView.DataDefine = DataDefine
UILWTWSkillChipSetUnlockView.DataDestroy = DataDestroy
UILWTWSkillChipSetUnlockView.LoadHeroSpine = LoadHeroSpine
UILWTWSkillChipSetUnlockView.DestroyHeroSpine = DestroyHeroSpine
UILWTWSkillChipSetUnlockView.RefreshCost = RefreshCost
UILWTWSkillChipSetUnlockView.OnAddListener = OnAddListener
UILWTWSkillChipSetUnlockView.OnRemoveListener = OnRemoveListener
UILWTWSkillChipSetUnlockView.RefreshCost = RefreshCost
return UILWTWSkillChipSetUnlockView
