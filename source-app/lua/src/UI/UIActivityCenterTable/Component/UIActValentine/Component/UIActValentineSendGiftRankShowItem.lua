local UIActValentineSendGiftRankShowItem = BaseClass("UIActValentineSendGiftRankShowItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_player_head_path = "HeadPoint/UIPlayerHead"
local like_btn_path = "LikeBtn"
local like_effect_path = "LikeEffect"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.like_btn = self:AddComponent(UIButton, like_btn_path)
  self.like_btn:SetOnClick(function()
    self:OnLikeBtnClick()
  end)
  self.like_effect = self:AddComponent(UIBaseContainer, like_effect_path)
end

local function ComponentDestroy(self)
  self.u_i_player_head = nil
  self.like_btn = nil
  self.like_effect = nil
end

local function SetData(self, data)
  self.data = data
  local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET)
  self.u_i_player_head:SetData(data.uid, data.pic, data.picVer, nil, headFrame)
  self.u_i_player_head:SetEnableClickShowInfo(true)
  self.like_effect:SetActive(false)
end

local function OnLikeBtnClick(self)
  local thePlayerUid = self.data.uid
  InteractiveUtil.TryThumbsUp(thePlayerUid, InteractiveUtil.ThumbsUpType.PlayerInfo, "PlayerDetailMain", function()
  end)
  self.like_effect:SetActive(false)
  self.like_effect:SetActive(true)
end

UIActValentineSendGiftRankShowItem.OnCreate = OnCreate
UIActValentineSendGiftRankShowItem.OnDestroy = OnDestroy
UIActValentineSendGiftRankShowItem.ComponentDefine = ComponentDefine
UIActValentineSendGiftRankShowItem.ComponentDestroy = ComponentDestroy
UIActValentineSendGiftRankShowItem.SetData = SetData
UIActValentineSendGiftRankShowItem.OnLikeBtnClick = OnLikeBtnClick
return UIActValentineSendGiftRankShowItem
