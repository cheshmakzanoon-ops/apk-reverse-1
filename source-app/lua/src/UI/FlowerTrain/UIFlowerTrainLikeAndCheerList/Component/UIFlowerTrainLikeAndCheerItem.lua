local base = UIBaseContainer
local UIFlowerTrainLikeAndCheerItem = BaseClass("UIFlowerTrainLikeAndCheerItem", base)
local Localization = CS.GameEntry.Localization
local playerHead_path = "UIPlayerHead"
local descTxt_path = "Txt_Des"
local timeTxt_path = "Txt_Time"
local titleTxt_path = "Txt_Title"
local likeBtn_path = "LikeBtn"
local likedGo_path = "LikeBtn/Liked"
local likeGo_path = "LikeBtn/Like"

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
  self.descTxt = self:AddComponent(UIText, descTxt_path)
  self.timeTxt = self:AddComponent(UIText, timeTxt_path)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.likeBtn = self:AddComponent(UIButton, likeBtn_path)
  self.likedGo = self:AddComponent(UIBaseContainer, likedGo_path)
  self.likeGo = self:AddComponent(UIBaseContainer, likeGo_path)
  self.head = self:AddComponent(UICommonHead, playerHead_path)
  self.likeBtn:SetOnClick(function()
    self:OnLikeBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.playerHead = nil
  self.descTxt = nil
  self.timeTxt = nil
  self.titleTxt = nil
  self.likeBtn = nil
  self.likedGo = nil
  self.likeGo = nil
  self.head = nil
end

local function DataDefine(self)
  local data = self.view:GetUserData()
  self.paraMeta = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(data.itemId)
end

local function DataDestroy(self)
end

function UIFlowerTrainLikeAndCheerItem:ReInit(data)
  self.data = data
  self:SetLikeState(data.reply == 1)
  self:RefreshUserInfo(data.otherUid)
  self.timeTxt:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.createTime, false))
  local desc = ""
  if data.type == 1 then
    desc = Localization:GetString("treasure_world_record_desc1", self.paraMeta.para6)
  elseif data.type == 2 then
    desc = Localization:GetString("treasure_world_record_desc2", self.paraMeta.para7)
  end
  self.descTxt:SetText(desc)
end

function UIFlowerTrainLikeAndCheerItem:OnLikeBtnClick()
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

function UIFlowerTrainLikeAndCheerItem:SetLikeState(state)
  self.likedGo:SetActive(state)
  self.likeGo:SetActive(not state)
end

function UIFlowerTrainLikeAndCheerItem:RefreshUserInfo(uid)
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
  self.titleTxt:SetText(UIUtil.FormatServerAllianceName(user.serverId, user.alAbbr, showName, user.uid))
end

UIFlowerTrainLikeAndCheerItem.OnCreate = OnCreate
UIFlowerTrainLikeAndCheerItem.OnDestroy = OnDestroy
UIFlowerTrainLikeAndCheerItem.OnEnable = OnEnable
UIFlowerTrainLikeAndCheerItem.OnDisable = OnDisable
UIFlowerTrainLikeAndCheerItem.ComponentDefine = ComponentDefine
UIFlowerTrainLikeAndCheerItem.ComponentDestroy = ComponentDestroy
UIFlowerTrainLikeAndCheerItem.DataDefine = DataDefine
UIFlowerTrainLikeAndCheerItem.DataDestroy = DataDestroy
return UIFlowerTrainLikeAndCheerItem
