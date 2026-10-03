local UIActMonopolyTip2View = BaseClass("UIActMonopolyTip2View", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local bg_path = "content/bg"

local function OnCreate(self)
  base.OnCreate(self)
  self.eventLine = self:GetUserData()
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "panel")
  btnPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.contentTxt = self:AddComponent(UITextMeshProUGUIEx, "content/contentTxt")
  self.contentReward = self:AddComponent(UIBaseContainer, "content/contentReward")
  self.uiCommonResItem = self:AddComponent(UICommonResItem, "content/contentReward/UICommonResItem")
  self.rewardNum = self:AddComponent(UIText, "content/contentReward/rewardNum")
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, "content/title")
end

local function ComponentDestroy(self)
end

local function RefreshView(self)
  local bannerPath = string.format(UIAssets.UIActMonopolyTexturePath, self.eventLine.banner)
  self.bg:LoadSprite(bannerPath)
  self.contentTxt:SetAlignment(CommonUtil.IsArabicAutoMirrorOpen() and CS.TMPro.TextAlignmentOptions.Right or CS.TMPro.TextAlignmentOptions.Left)
  self.title:SetAlignment(CommonUtil.IsArabicAutoMirrorOpen() and CS.TMPro.TextAlignmentOptions.Right or CS.TMPro.TextAlignmentOptions.Left)
  if self.eventLine.event ~= ActMonopolyEventType.GetReward then
    self.contentTxt:SetActive(true)
    self.contentReward:SetActive(false)
    local content = Localization:GetString(self.eventLine.desc)
    self.contentTxt:SetText(content)
  else
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
  end
end

UIActMonopolyTip2View.OnCreate = OnCreate
UIActMonopolyTip2View.OnDestroy = OnDestroy
UIActMonopolyTip2View.ComponentDefine = ComponentDefine
UIActMonopolyTip2View.ComponentDestroy = ComponentDestroy
UIActMonopolyTip2View.RefreshView = RefreshView
return UIActMonopolyTip2View
