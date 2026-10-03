local LWUIQuickGiftView = BaseClass("LWUIQuickGiftView", UIBaseView)
local DirectionGiftListComponent = require("UI/LWPlayerInfo/UILWGiftSystem/QuickGift/Component/DirectionGiftListComponent")
local base = UIBaseView

function LWUIQuickGiftView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUIQuickGiftView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIQuickGiftView:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
  self:ReInit()
end

function LWUIQuickGiftView:ReInit()
  self.param = self:GetUserData()
  self:RefreshGiftList()
end

function LWUIQuickGiftView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compLeftGiftList = self.viewSkin:AddComponent(self, DirectionGiftListComponent, 2)
  self.compRightGiftList = self.viewSkin:AddComponent(self, DirectionGiftListComponent, 3)
  self.compDownGiftList = self.viewSkin:AddComponent(self, DirectionGiftListComponent, 4)
  self.compUpGiftList = self.viewSkin:AddComponent(self, DirectionGiftListComponent, 5)
  self:InitDirComDic()
end

function LWUIQuickGiftView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function LWUIQuickGiftView:InitDirComDic()
  self.dirComDic = {}
  local dirType = GiftSystemConst.GiftSendPanelDirection
  self.dirComDic[dirType.Up] = self.compUpGiftList
  self.dirComDic[dirType.Down] = self.compDownGiftList
  self.dirComDic[dirType.Left] = self.compLeftGiftList
  self.dirComDic[dirType.Right] = self.compRightGiftList
end

function LWUIQuickGiftView:OnUserInfoUpdate(uid)
  if uid ~= self.param.playerUid then
    return
  end
  self:RefreshGiftList()
end

function LWUIQuickGiftView:RefreshGiftList()
  local targetRect = self.param.target.rectTransform
  if self.param.dirType == GiftSystemConst.GiftSendPanelDirection.Right then
    local worldPos = targetRect.position
    local posX, posY = worldPos.x, worldPos.y
    local pivotX, pivotY = targetRect.pivot.x, targetRect.pivot.y
    local width, height = targetRect.rect.width, targetRect.rect.height
    posY = worldPos.y + (0.5 - pivotY) * height
    posX = worldPos.x + (0.5 - pivotX) * width
    local localPos = self.transform:InverseTransformPoint(Vector3.New(posX, posY, worldPos.z))
    local parentWidth = self.rectTransform.rect.width
    local rightSpace = parentWidth / 2 - localPos.x
    if rightSpace < 100 then
      self.param.dirType = GiftSystemConst.GiftSendPanelDirection.Left
    end
  end
  local dirType = self.param.dirType
  local openType = self.param.openType
  local playerUid = self.param.playerUid
  local curCom = self.dirComDic[dirType]
  if not curCom then
    return
  end
  for curDirType, component in pairs(self.dirComDic) do
    component:SetActive(curDirType == dirType)
  end
  local serverId = self.param.serverId
  if openType == GiftSystemConst.GiftSendPanelType.WarZone and (not serverId or serverId <= 0) then
    local userInfo = ChatInterface.getUserData(playerUid)
    if not userInfo then
      return
    end
    serverId = userInfo:getServerId()
    if serverId <= 0 then
      return
    end
  end
  local giftList = DataCenter.GiftSystemManager:GetHasGiftList(playerUid, openType, serverId)
  local giftListParam = {
    playerUid = playerUid,
    dirType = dirType,
    openType = openType,
    giftList = giftList,
    showItemAnim = self.param.showItemAnim,
    showBubbleBg = self.param.showBubbleBg,
    target = self.param.target,
    clickAnim = self.param.clickAnim
  }
  curCom:ShowGiftList(giftListParam, function(giftId, item)
    self:OnItemClick(giftId, item)
  end)
end

function LWUIQuickGiftView:OnItemClick(giftId, item)
  if self.param.clickAnim then
    local param = {
      effectInfo = {
        giftId = giftId,
        playerUid = LuaEntry.Player.uid
      },
      parent = self,
      targetTrans = item.transform
    }
    local effect = DataCenter.GiftEffectManager:AddCheerEffect(param)
    table.insert(self.resList, effect)
  end
  DataCenter.GiftSystemManager:SendReceiveGift(giftId, self.param.playerUid, self.param.openType)
end

function LWUIQuickGiftView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.compLeftGiftList = nil
  self.compRightGiftList = nil
  self.compDownGiftList = nil
  self.compUpGiftList = nil
end

function LWUIQuickGiftView:DataDefine()
  self.resList = {}
end

function LWUIQuickGiftView:DataDestroy()
  self.dirComDic = nil
  if self.resList then
    for _, v in pairs(self.resList) do
      if v ~= nil then
        v:Destroy()
      end
    end
    self.resList = nil
  end
end

function LWUIQuickGiftView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnUserInfoUpdate)
end

function LWUIQuickGiftView:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnUserInfoUpdate)
  base.OnRemoveListener(self)
end

function LWUIQuickGiftView:OnBtnGameObjectClick()
end

return LWUIQuickGiftView
