local UIGhostreconRewardMemberItem = BaseClass("UIGhostreconRewardMemberItem", UIBaseContainer)
local base = UIBaseContainer
local playerHead_path = "UIPlayerHead"
local zanBtn_path = "ZanBtn"
local zanImg_path = "ZanBtn/ZanImg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.playerHead = self:AddComponent(UICommonHead, playerHead_path)
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.zanBtn = self:AddComponent(UIButton, zanBtn_path)
  self.zanBtn:SetOnClick(Bind(self, self.OnClickZanBtn))
  self.zanImg = self:AddComponent(UIImage, zanImg_path)
end

local function ComponentDestroy(self)
  self.playerHead = nil
  self.playerHead = nil
end

local function DataDefine(self)
  self.zan = false
end

local function DataDestroy(self)
  self.zan = nil
  self.uid = nil
  self.data = nil
  self.thumbsUpIdentifier = nil
end

local function OnAddListener(self)
  self:AddUIListener(EventId.GhostReconZanAll, self.OnGhostReconZanAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GhostReconZanAll, self.OnGhostReconZanAll)
end

local function SetData(self, uid, headInfo, data)
  self.uid = uid
  self.playerHead:ParseHeadInfo(headInfo)
  self.zanImg:LoadSprite(ChatInterface.GetChatUIPath("ChatItems/zyf_xitongtongzhi_dianzan.png"))
  self.data = data
  self.thumbsUpIdentifier = data.thumbsUpIdentifier or 0
end

local function TryThumbsUp(self)
  self.zan = true
  self.data.zan = true
  self.zanImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_xinwen_dianzan_anniu.png")
  InteractiveUtil.TryThumbsUp(self.uid, InteractiveUtil.ThumbsUpType.GHOST_RECON, "GHOST_RECON" .. self.thumbsUpIdentifier, function()
  end)
end

local function OnClickZanBtn(self)
  if self.zan then
    UIUtil.ShowTipsId("120289")
  else
    local number = InteractiveUtil.GetCanThumbsUpCount(InteractiveUtil.ThumbsUpType.GHOST_RECON)
    if number <= 0 then
      UIUtil.ShowTipsId("avatar_tips003")
    else
      UIUtil.ShowTipsId("ghostrecon_090")
      TryThumbsUp(self)
    end
  end
end

local function OnGhostReconZanAll(self, index)
  if index and index == self.thumbsUpIdentifier then
    TryThumbsUp(self)
  end
end

UIGhostreconRewardMemberItem.OnCreate = OnCreate
UIGhostreconRewardMemberItem.OnDestroy = OnDestroy
UIGhostreconRewardMemberItem.OnEnable = OnEnable
UIGhostreconRewardMemberItem.OnDisable = OnDisable
UIGhostreconRewardMemberItem.ComponentDefine = ComponentDefine
UIGhostreconRewardMemberItem.ComponentDestroy = ComponentDestroy
UIGhostreconRewardMemberItem.DataDefine = DataDefine
UIGhostreconRewardMemberItem.DataDestroy = DataDestroy
UIGhostreconRewardMemberItem.OnAddListener = OnAddListener
UIGhostreconRewardMemberItem.OnRemoveListener = OnRemoveListener
UIGhostreconRewardMemberItem.SetData = SetData
UIGhostreconRewardMemberItem.OnClickZanBtn = OnClickZanBtn
UIGhostreconRewardMemberItem.OnGhostReconZanAll = OnGhostReconZanAll
return UIGhostreconRewardMemberItem
