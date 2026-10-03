local base = UIBaseContainer
local LWMainUIPopupNotificationItemRender = BaseClass("LWMainUIPopupNotificationItemRender", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWMainUIPopupNotificationItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWMainUIPopupNotificationItemRender:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWMainUIPopupNotificationItemRender:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnLWMainUIPopupNotificationItem = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnLWMainUIPopupNotificationItem:SetOnClick(function()
    self:OnBtnLWMainUIPopupNotificationItemClick()
  end)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
end

function LWMainUIPopupNotificationItemRender:ComponentDestroy()
  self.viewSkin = nil
  self.btnLWMainUIPopupNotificationItem = nil
  self.imgIcon = nil
end

function LWMainUIPopupNotificationItemRender:DataDefine()
end

function LWMainUIPopupNotificationItemRender:DataDestroy()
  self.popupData = nil
end

function LWMainUIPopupNotificationItemRender:OnAddListener()
  base.OnAddListener(self)
end

function LWMainUIPopupNotificationItemRender:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWMainUIPopupNotificationItemRender:ReInit(popupData)
  self.popupData = popupData
  if self.popupData then
    self:SetActive(true)
    self.imgIcon:LoadSpriteAuto(self.popupData.icon)
  end
end

function LWMainUIPopupNotificationItemRender:OnBtnLWMainUIPopupNotificationItemClick()
  if self.popupData then
    if self.popupData.popupType == PopupNotificationType.SandWorm then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISandWormPopup, {anim = true}, self.popupData.popupParam)
    elseif self.popupData.popupType == PopupNotificationType.ActMeteoriteBattle then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWActMeteoriteFlyTip, {anim = true}, self.popupData.popupParam)
    elseif self.popupData.popupType == PopupNotificationType.SeasonSettleTime then
      local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
      if infoPlayer and infoPlayer:InSettleTime() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonSettleTimeTipsS5, {
          anim = false,
          UIMainAnim = UIMainAnimType.AllHide
        })
      end
    elseif self.popupData.popupType == PopupNotificationType.NineNationKingBattle then
      local weekData = self.popupData.popupParam
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if not weekData.fightEndTime or weekData.fightEndTime <= 0 or curTime > weekData.fightEndTime + 518400000 then
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UINewKing, {anim = true}, self.popupData.popupParam)
      end
    elseif self.popupData.popupType == PopupNotificationType.DawnPopup then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDawnPopup, {anim = true})
    end
    DataCenter.LWPopupManager:ClearPopupNotificationByClick(self.popupData.popupType)
  end
end

return LWMainUIPopupNotificationItemRender
