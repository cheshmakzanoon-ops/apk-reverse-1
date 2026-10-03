local base = UIBaseContainer
local UIFlowerTrainRankListRankPlayerView = BaseClass("UIFlowerTrainRankListRankPlayerView", base)
local flowerTrainImg_path = "FlowerTrain"
local playerHead_path = "NormalContent/UIPlayerHead"
local allianceNameTxt_path = "NormalContent/allianceName"
local playerNameTxt_path = "NormalContent/PlayerName"
local heatIconImg_path = "NormalContent/HeatIcon"
local heatNumTxt_path = "NormalContent/HeatIcon/HeatNum"
local likeBtn_path = "NormalContent/LikeBtn"
local likeCountTxt_path = "NormalContent/LikeBtn/likeCountText"
local emptyContent_path = "EmptyContent"
local normalContent_path = "NormalContent"
local effect_path = "NormalContent/DianZanEffect"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddUIListener(EventId.UIFlowerTrain_RankPraise, self.OnRankPraise)
end

local function OnDestroy(self)
  self:RemoveUIListener(EventId.UIFlowerTrain_RankPraise, self.OnRankPraise)
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
  self.flowerTrainImg = self:AddComponent(UIRawImage, flowerTrainImg_path)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.allianceNameTxt = self:AddComponent(UIText, allianceNameTxt_path)
  self.playerNameTxt = self:AddComponent(UIText, playerNameTxt_path)
  self.heatIconImg = self:AddComponent(UIImage, heatIconImg_path)
  self.heatNumTxt = self:AddComponent(UIText, heatNumTxt_path)
  self.likeBtn = self:AddComponent(UIButton, likeBtn_path)
  self.likeCountTxt = self:AddComponent(UIText, likeCountTxt_path)
  self.emptyContent = self:AddComponent(UIBaseContainer, emptyContent_path)
  self.normalContent = self:AddComponent(UIBaseContainer, normalContent_path)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
  self.effect:SetActive(false)
  self.playerHeadComponent = self:AddComponent(UICommonHead, playerHead_path)
  self.likeBtn:SetOnClick(function()
    self:OnBtnLikeClick()
  end)
end

local function ComponentDestroy(self)
  self.flowerTrainImg = nil
  self.playerHead = nil
  self.allianceNameTxt = nil
  self.playerNameTxt = nil
  self.heatIconImg = nil
  self.heatNumTxt = nil
  self.likeBtn = nil
  self.likeCountTxt = nil
  self.emptyContent = nil
  self.normalContent = nil
  self.effect = nil
  self.playerHeadComponent = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIFlowerTrainRankListRankPlayerView:ReInit(data, itemId, rankActivityId)
  self.data = data
  self.rankActivityId = rankActivityId
  self:SetState(next(data) == nil)
  if next(data) then
    local displayMeta = FlowerTrainUtils.GetFlowerTrainDisplayMetaByGoodsId(itemId, data.trainLv)
    self.flowerTrainImg:LoadSprite(displayMeta.rank_pic)
    self.flowerTrainImg:SetNativeSize()
    self.playerHeadComponent:ParseHeadInfo(data)
    local abbrStr = "#" .. data.serverId
    if not string.IsNullOrEmpty(data.abbr) then
      abbrStr = abbrStr .. " [" .. data.abbr .. "]"
    end
    self.allianceNameTxt:SetText(abbrStr)
    self.playerNameTxt:SetText(data.name)
    local paraMeta = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(itemId)
    local expFireConfigList = FlowerTrainUtils.ParesExpFireImgPath(paraMeta.id)
    local path = FlowerTrainUtils.GetExpFireImgPath(expFireConfigList, tonumber(data.score))
    self.heatIconImg:LoadSprite(path)
    self.heatNumTxt:SetText(data.score)
    self.likeCountTxt:SetText(data.praise)
  end
end

function UIFlowerTrainRankListRankPlayerView:ShowDianZanEffect()
  self.effect:SetActive(false)
  self.effect:SetActive(true)
end

function UIFlowerTrainRankListRankPlayerView:SetState(isEmpty)
  self.emptyContent:SetActive(isEmpty)
  self.normalContent:SetActive(not isEmpty)
  self.flowerTrainImg:SetActive(not isEmpty)
end

function UIFlowerTrainRankListRankPlayerView:OnBtnLikeClick()
  if self.rankActivityId == nil then
    return
  end
  if self.data.uid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainRankPraise, {
    activityId = self.rankActivityId,
    otherUid = self.data.uid
  })
end

function UIFlowerTrainRankListRankPlayerView:OnRankPraise(data)
  if not self.data then
    return
  end
  if self.data.uid ~= data.otherUid then
    return
  end
  self:ShowDianZanEffect()
  self.data.praise = self.data.praise + 1
  self.likeCountTxt:SetText(self.data.praise)
end

UIFlowerTrainRankListRankPlayerView.OnCreate = OnCreate
UIFlowerTrainRankListRankPlayerView.OnDestroy = OnDestroy
UIFlowerTrainRankListRankPlayerView.OnEnable = OnEnable
UIFlowerTrainRankListRankPlayerView.OnDisable = OnDisable
UIFlowerTrainRankListRankPlayerView.ComponentDefine = ComponentDefine
UIFlowerTrainRankListRankPlayerView.ComponentDestroy = ComponentDestroy
UIFlowerTrainRankListRankPlayerView.DataDefine = DataDefine
UIFlowerTrainRankListRankPlayerView.DataDestroy = DataDestroy
return UIFlowerTrainRankListRankPlayerView
