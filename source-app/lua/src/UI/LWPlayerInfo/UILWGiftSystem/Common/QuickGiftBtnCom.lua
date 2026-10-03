local base = UIBaseContainer
local QuickGiftBtnCom = BaseClass("QuickGiftBtnCom", base)
local giftEffectPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWGiftSendBtn.prefab"

function QuickGiftBtnCom:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function QuickGiftBtnCom:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function QuickGiftBtnCom:OnEnable()
  base.OnEnable(self)
end

function QuickGiftBtnCom:OnDisable()
  base.OnDisable(self)
end

function QuickGiftBtnCom:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "btn")
  self.btn:SetOnClick(function()
    self:OnGiftListClick()
  end)
end

function QuickGiftBtnCom:ReInit(uid, panelType, dirType)
  self.uid = uid
  self.panelType = panelType
  self.dirType = dirType
  ChatInterface.getUserData(self.uid)
  local isCanShowGift = DataCenter.GiftSystemManager:IsCanShowQuickBtn(self.panelType)
  self:SetActive(isCanShowGift)
  if isCanShowGift then
    if self.giftEffect then
      self:GameObjectDestroy(self.giftEffect)
      self.giftEffect = nil
    end
    self.giftEffect = self:GameObjectInstantiateAsync(giftEffectPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.btn.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
    end)
  end
end

function QuickGiftBtnCom:OnGiftListClick()
  if not self.uid or not self.panelType then
    return
  end
  local userInfo = ChatInterface.getUserData(tostring(self.uid))
  local param = {
    playerUid = self.uid,
    dirType = self.dirType or GiftSystemConst.GiftSendPanelDirection.Right,
    openType = self.panelType,
    target = self,
    giftItemAnim = false,
    giftItemBubbleBg = true,
    clickAnim = false,
    showBubbleBg = true,
    serverId = userInfo:getServerId()
  }
  DataCenter.GiftSystemManager:ShowQuick(param)
end

function QuickGiftBtnCom:ComponentDestroy()
  if self.giftEffect then
    self:GameObjectDestroy(self.giftEffect)
    self.giftEffect = nil
  end
  self.btn = nil
end

function QuickGiftBtnCom:DataDefine()
end

function QuickGiftBtnCom:DataDestroy()
end

return QuickGiftBtnCom
