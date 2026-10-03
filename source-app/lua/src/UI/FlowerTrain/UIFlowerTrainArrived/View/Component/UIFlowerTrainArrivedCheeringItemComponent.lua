local base = UIBaseContainer
local UIFlowerTrainArrivedCheeringItemComponent = BaseClass("UIFlowerTrainArrivedCheeringItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")
local UIGray = CS.UIGray
local likeIconState1Path = "Assets/Main/Sprites/UI/FlowerTrain_Sprite/FlowerTrainCommon/zyf_xitongtongzhi_dianzan.png"
local likeIconState2Path = "Assets/Main/Sprites/UI/FlowerTrain_Sprite/FlowerTrainCommon/zyf_xinwen_dianzan_anniu.png"

function UIFlowerTrainArrivedCheeringItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFlowerTrainArrivedCheeringItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainArrivedCheeringItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.btnClaim = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.imgLikeIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
end

function UIFlowerTrainArrivedCheeringItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
  self.btnClaim = nil
  self.imgLikeIcon = nil
end

function UIFlowerTrainArrivedCheeringItemComponent:DataDefine()
end

function UIFlowerTrainArrivedCheeringItemComponent:DataDestroy()
end

function UIFlowerTrainArrivedCheeringItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIFlowerTrainArrivedCheeringItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFlowerTrainArrivedCheeringItemComponent:OnBtnClaimClick()
  if not self.data then
    return
  end
  local uid = self.data.uid
  InteractiveUtil.TryThumbsUp(uid, InteractiveUtil.ThumbsUpType.ThanksFlowerTrainCheer, "ThanksFlowerTrainCheer", function()
    UIGray.SetGray(self.btnClaim.transform, false, false)
    self.imgLikeIcon:LoadSpriteAsync(likeIconState2Path)
    UIUtil.ShowTipsId("activity_breakthrough_tips_17")
  end)
end

function UIFlowerTrainArrivedCheeringItemComponent:ReInit(data)
  self.data = data
  self:RefreshView(data)
end

function UIFlowerTrainArrivedCheeringItemComponent:RefreshView(data)
  if not data then
    return
  end
  local uid = data.uid
  local pic = data.pic
  local picVer = data.picver
  local headSkinId = data.headFrame
  local headSkinET = data.chatBubbleET
  self.compUIPlayerHead:SetHead(uid, pic, picVer, nil, nil)
  UIGray.SetGray(self.btnClaim.transform, false, true)
  self.imgLikeIcon:LoadSpriteAsync(likeIconState1Path)
end

return UIFlowerTrainArrivedCheeringItemComponent
