local base = UIBaseContainer
local UIFireworkGiftGotShowItemRender = BaseClass("UIFireworkGiftGotShowItemRender", base)
local playerHead_path = "UIPlayerHead"
local commonResItem_path = "UICommonResItem"
local numTxt_path = "NumTxt"
local mvpGo_path = "MVP"
local favorBtn_path = "FavorBtnContent/FavorBtn"
local favorBtnRoot_path = "FavorBtnContent"
local mvpEffect_path = "mvpEffect"
local favorEffect_path = "favorEffect"
local autoLikeProgressIcon_path = "FavorBtnContent/FavorBtn/AutoLikeProgress/AutoProgressIcon"
local autoLikeProgress_path = "FavorBtnContent/FavorBtn/AutoLikeProgress"

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
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.commonResItem = self:AddComponent(UIBaseContainer, commonResItem_path)
  self.numTxt = self:AddComponent(UIText, numTxt_path)
  self.mvpGo = self:AddComponent(UIBaseContainer, mvpGo_path)
  self.favorBtn = self:AddComponent(UIButton, favorBtn_path)
  self.favorBtnRoot = self:AddComponent(UIBaseContainer, favorBtnRoot_path)
  self.mvpEffect = self:AddComponent(UIBaseContainer, mvpEffect_path)
  self.favorEffect = self:AddComponent(UIBaseContainer, favorEffect_path)
  self.autoLikeProgressIcon = self:AddComponent(UIImage, autoLikeProgressIcon_path)
  self.autoLikeProgress = self:AddComponent(UIBaseContainer, autoLikeProgress_path)
  self.playerHead = self:AddComponent(UICommonHead, playerHead_path)
  self.commonResItem = self:AddComponent(UICommonResItem, commonResItem_path)
  self.favorBtn:SetOnClick(BindCallback(self, self.OnClickFavorBtn))
  self.mvpEffect:SetActive(false)
  self.favorEffect:SetActive(false)
end

function UIFireworkGiftGotShowItemRender:OnClickFavorBtn()
  if self.data then
    self.favorEffect:SetActive(false)
    local type = GetTableData(TableName.Firework, self.data.configId, "type", 0)
    local subType = type == 0 and InteractiveUtil.ThumbsUpType.FireworkBox or InteractiveUtil.ThumbsUpType.S0AllianceBossFirework
    InteractiveUtil.TryThumbsUp(self.player.uid, subType, nil, function()
      if self.favorEffect then
        self.favorEffect:SetActive(true)
      end
    end)
  end
end

local function ComponentDestroy(self)
  self.mvpEffect:SetActive(false)
  self.favorEffect:SetActive(false)
  self.playerHead = nil
  self.commonResItem = nil
  self.numTxt = nil
  self.mvpGo = nil
  self.favorBtn = nil
  self.favorBtnRoot = nil
  self.mvpEffect = nil
  self.favorEffect = nil
  self.autoLikeProgressIcon = nil
  self.autoLikeProgress = nil
  self.playerHead = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self:ClearFavorSequence()
end

local AUTO_FAVOR_PRE_TIME = 1
local AUTO_FAVOR_SCALE_UP_TIME = 0.5
local AUTO_FAVOR_SCALE_DOWN_TIME = 0.5

function UIFireworkGiftGotShowItemRender:SetData(data)
  if data == self.data then
    return
  end
  self.data = data
  self.player = data.sendGiftPlayerInfo
  self:ClearFavorSequence()
  local anchoredPosition = self:GetAnchoredPosition()
  self:SetAnchoredPositionXY(200, anchoredPosition.y)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Join(self.transform:DOAnchorPosX(0, 0.5)):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  self.playerHead:SetHeadAndFrame(self.player.uid, self.player.pic, self.player.picVer, nil, self.player.headSkinId, self.player.headSkinET)
  local iconPath
  if data.reward then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(data.reward)
    if rewardList and 0 < #rewardList then
      iconPath = DataCenter.RewardManager:GetPicByType(rewardList[1].rewardType, rewardList[1].itemId)
      self.commonResItem:ReInit(rewardList[1])
    end
  end
  self.numTxt:SetText(string.format("\195\151%s", data.isDouble and 2 or 1))
  self.mvpGo:SetActive(data.isDouble)
  self.mvpEffect:SetActive(data.isDouble)
  local autoLike = GetTableData(TableName.Firework, self.data.configId, "auto_like", "") == "1"
  self.favorBtnRoot:SetActive(self.player.uid ~= LuaEntry.Player:GetUid() and autoLike)
  self.autoLikeProgress:SetActive(autoLike and self.player.uid ~= LuaEntry.Player:GetUid())
  if autoLike and self.player.uid ~= LuaEntry.Player:GetUid() then
    self.autoLikeProgressIcon:SetFillAmount(0)
    self.favorBtn.transform:Set_localScale(0.5, 0.5, 0.5)
    self.favorSequence = DOTween.Sequence()
    self.favorSequence:Append(CS.DG.Tweening.DOTween.To(function()
      return 0
    end, function(fillAmount)
      self.autoLikeProgressIcon:SetFillAmount(fillAmount)
    end, 1, AUTO_FAVOR_PRE_TIME):SetEase(CS.DG.Tweening.Ease.InExpo))
    self.favorSequence:Insert(0, self.favorBtn.transform:DOScale(Vector3.New(1.5, 1.5, 1), AUTO_FAVOR_SCALE_UP_TIME))
    self.favorSequence:Insert(AUTO_FAVOR_SCALE_UP_TIME, self.favorBtn.transform:DOScale(Vector3.New(1, 1, 1), AUTO_FAVOR_SCALE_DOWN_TIME))
    self.favorSequence:OnComplete(function()
      self:OnClickFavorBtn()
    end)
  end
end

function UIFireworkGiftGotShowItemRender:ClearFavorSequence()
  if self.favorSequence then
    self.favorSequence:Kill()
    self.favorSequence = nil
  end
end

UIFireworkGiftGotShowItemRender.OnCreate = OnCreate
UIFireworkGiftGotShowItemRender.OnDestroy = OnDestroy
UIFireworkGiftGotShowItemRender.OnEnable = OnEnable
UIFireworkGiftGotShowItemRender.OnDisable = OnDisable
UIFireworkGiftGotShowItemRender.ComponentDefine = ComponentDefine
UIFireworkGiftGotShowItemRender.ComponentDestroy = ComponentDestroy
UIFireworkGiftGotShowItemRender.DataDefine = DataDefine
UIFireworkGiftGotShowItemRender.DataDestroy = DataDestroy
return UIFireworkGiftGotShowItemRender
