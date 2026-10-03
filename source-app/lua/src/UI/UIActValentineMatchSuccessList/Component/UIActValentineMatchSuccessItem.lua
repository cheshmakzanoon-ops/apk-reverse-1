local base = UIBaseContainer
local UIActValentineMatchSuccessItem = BaseClass("UIActValentineMatchSuccessItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIPlayerHead = require("Framework.UI.Component.UIPlayerHead")

function UIActValentineMatchSuccessItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActValentineMatchSuccessItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActValentineMatchSuccessItem:OnEnable()
  base.OnEnable(self)
end

function UIActValentineMatchSuccessItem:OnDisable()
  base.OnDisable(self)
end

function UIActValentineMatchSuccessItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compHeadIcon = self.viewSkin:AddComponent(self, UIPlayerHead, 1)
  self.imgGender = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textNickName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.compMessageTips = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textMessageTipsNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
end

function UIActValentineMatchSuccessItem:ComponentDestroy()
  self.viewSkin = nil
  self.compHeadIcon = nil
  self.imgGender = nil
  self.textNickName = nil
  self.btnClick = nil
  self.compMessageTips = nil
  self.textMessageTipsNum = nil
end

function UIActValentineMatchSuccessItem:DataDefine()
end

function UIActValentineMatchSuccessItem:DataDestroy()
end

function UIActValentineMatchSuccessItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshValentineMatchSuccessRedPoint, self.RefreshMessageTips)
end

function UIActValentineMatchSuccessItem:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshValentineMatchSuccessRedPoint, self.RefreshMessageTips)
  base.OnRemoveListener(self)
end

function UIActValentineMatchSuccessItem:SetData(activityId, matchPlayerData)
  if matchPlayerData == nil then
    return
  end
  self.activityId = activityId
  self.matchPlayerData = matchPlayerData
  self.textNickName:SetText(matchPlayerData.name)
  local uid = matchPlayerData.uid
  local pic = matchPlayerData.pic
  local picVer = matchPlayerData.picVer or matchPlayerData.picver
  self.compHeadIcon:SetBigData(uid, pic or "", picVer or 0, true)
  local gender = matchPlayerData.gender
  local gender_img_path = "Assets/Main/Sprites/UI/UILWPlayerInfo/"
  if gender == 1 then
    self.imgGender:SetActive(true)
    self.imgGender:LoadSprite(gender_img_path .. "icon_pop_sex_male.png")
  elseif gender == 2 then
    self.imgGender:SetActive(true)
    self.imgGender:LoadSprite(gender_img_path .. "icon_pop_sex_female.png")
  else
    self.imgGender:SetActive(false)
  end
  self.imgGender:SetNativeSize()
  self:TryRefreshMessageTips()
end

function UIActValentineMatchSuccessItem:TryRefreshMessageTips()
  local matchRedPoint = DataCenter.ValentineDataManager:GetMatchRedPoint(self.activityId, self.matchPlayerData.uid)
  if matchRedPoint == -1 then
    self.compMessageTips:SetActive(false)
    DataCenter.ValentineDataManager:RequestMatchRedPoint(self.activityId, self.matchPlayerData.uid)
  else
    self.compMessageTips:SetActive(0 < matchRedPoint)
    if 0 < matchRedPoint then
      self.textMessageTipsNum:SetText(matchRedPoint)
    end
  end
end

function UIActValentineMatchSuccessItem:RefreshMessageTips(msg)
  local targetuuid = msg.targetuuid
  local matchRedPoint = msg.matchRedPoint
  if targetuuid ~= self.matchPlayerData.uid then
    return
  end
  if matchRedPoint == nil then
    self.compMessageTips:SetActive(false)
    return
  end
  self.compMessageTips:SetActive(0 < matchRedPoint)
  if 0 < matchRedPoint then
    self.textMessageTipsNum:SetText(matchRedPoint)
  end
end

function UIActValentineMatchSuccessItem:OnBtnClickClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, {
    uid = self.matchPlayerData.uid,
    isShowUnreadRedDot = true,
    activityId = self.activityId
  })
end

return UIActValentineMatchSuccessItem
