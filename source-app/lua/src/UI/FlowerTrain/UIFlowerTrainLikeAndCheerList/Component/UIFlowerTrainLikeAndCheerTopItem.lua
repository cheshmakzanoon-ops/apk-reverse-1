local base = UIBaseContainer
local UIFlowerTrainLikeAndCheerTopItem = BaseClass("UIFlowerTrainLikeAndCheerTopItem", base)
local playerHead_path = "UIPlayerHead"
local likeBtn_path = "LikeBtn"
local descTxt_path = "DescTxt"
local likeGo_path = "LikeBtn/Like"
local likedGo_path = "LikeBtn/Liked"
local nameTxt_path = "NameTxt"
UIFlowerTrainLikeAndCheerTopItem.TopPlayerInfo = {
  {
    type = 1,
    desc = "treasure_world_record_seat1"
  },
  {
    type = 2,
    desc = "treasure_world_record_seat3"
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.RefreshUserInfo)
end

local function OnDestroy(self)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.RefreshUserInfo)
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
  self.likeBtn = self:AddComponent(UIButton, likeBtn_path)
  self.descTxt = self:AddComponent(UIText, descTxt_path)
  self.likeGo = self:AddComponent(UIBaseContainer, likeGo_path)
  self.likedGo = self:AddComponent(UIBaseContainer, likedGo_path)
  self.nameTxt = self:AddComponent(UIText, nameTxt_path)
  self.head = self:AddComponent(UICommonHead, playerHead_path)
  self.likeBtn:SetOnClick(function()
    self:OnLikeBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.playerHead = nil
  self.likeBtn = nil
  self.descTxt = nil
  self.likeGo = nil
  self.likedGo = nil
  self.nameTxt = nil
  self.head = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIFlowerTrainLikeAndCheerTopItem:ReInit(data, index)
  self.data = data
  self:SetLikeState(data.reply == 1)
  local info = self.TopPlayerInfo[index] or {}
  self.descTxt:SetLocalText(info.desc or "")
  self:RefreshUserInfo(data.otherUid)
end

function UIFlowerTrainLikeAndCheerTopItem:OnLikeBtnClick()
  if self.data.reply == 1 then
    return
  end
  self:SetLikeState(true)
  self.data.reply = 1
  UIUtil.ShowTipsId("activity_sports_uitips_021")
  local thumbsUpType
  if self.data.type == 1 then
    thumbsUpType = InteractiveUtil.ThumbsUpType.ThanksFlowerTrainLike
  else
    thumbsUpType = InteractiveUtil.ThumbsUpType.ThanksFlowerTrainCheer
  end
  InteractiveUtil.TryThumbsUp(self.data.otherUid, thumbsUpType, self.data.uuid, function()
    SFSNetwork.SendMessage(MsgDefines.FlowerTrainReplyPraise, {
      self.data.uuid
    })
  end)
  self:ReInit(self.data)
end

function UIFlowerTrainLikeAndCheerTopItem:SetLikeState(state)
  self.likedGo:SetActive(state)
  self.likeGo:SetActive(not state)
end

function UIFlowerTrainLikeAndCheerTopItem:RefreshUserInfo(uid)
  if self.data == nil then
    return
  end
  if uid ~= self.data.otherUid then
    return
  end
  local user = UIUtil.GetPlayerInfoShowByUid(uid)
  if user == nil then
    return
  end
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(user.uid, user.name)
  user.frameBg = user.headBg
  self.head:ParseHeadInfo(user)
  self.head:SetEnableClickShowInfo(true, true)
  self.nameTxt:SetText(UIUtil.FormatAllianceAndName(user.abbr, showName))
end

UIFlowerTrainLikeAndCheerTopItem.OnCreate = OnCreate
UIFlowerTrainLikeAndCheerTopItem.OnDestroy = OnDestroy
UIFlowerTrainLikeAndCheerTopItem.OnEnable = OnEnable
UIFlowerTrainLikeAndCheerTopItem.OnDisable = OnDisable
UIFlowerTrainLikeAndCheerTopItem.ComponentDefine = ComponentDefine
UIFlowerTrainLikeAndCheerTopItem.ComponentDestroy = ComponentDestroy
UIFlowerTrainLikeAndCheerTopItem.DataDefine = DataDefine
UIFlowerTrainLikeAndCheerTopItem.DataDestroy = DataDestroy
return UIFlowerTrainLikeAndCheerTopItem
