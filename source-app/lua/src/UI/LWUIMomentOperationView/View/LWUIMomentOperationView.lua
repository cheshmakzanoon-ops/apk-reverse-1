local LWUIMomentOperationView = BaseClass("LWUIMomentOperationView", UIBaseView)
local LWUIMomentOperationLoopView = require("UI.LWUIMomentOperationView.Component.LWUIMomentOperationLoopView")
local base = UIBaseView
local operationHigth = 110
local operationBottomBlankHeight = 40
local animSpeed = 0.3
local Localization = CS.GameEntry.Localization
local DarkConfig = {
  {
    bgColor = "#FFFFFF",
    topIconPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatWindow/zyf_reaction_tiao1.png"
  },
  {
    bgColor = "#272727",
    topIconPath = "Assets/Main/Sprites/UI/LWChat_v2/NightSkin/ChatWindow/zyf_reaction_tiao_yejian.png"
  }
}

function LWUIMomentOperationView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUIMomentOperationView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMomentOperationView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.operationScrollView = self.viewSkin:AddComponent(self, LWUIMomentOperationLoopView, 2)
  self.bg = self:AddComponent(UIImage, "BG")
  self.topIcon = self:AddComponent(UIImage, "BG/topIcon")
end

function LWUIMomentOperationView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.operationScrollView = nil
end

function LWUIMomentOperationView:DataDefine()
  self.data = self:GetUserData()
end

function LWUIMomentOperationView:DataDestroy()
  if self.moveAniSeq then
    self.moveAniSeq:Kill()
  end
end

function LWUIMomentOperationView:ReInit()
  self.opList = self.ctrl:GetOpList()
  local bgx, bgy = self.bg:GetSizeDeltaXY()
  local operationsHeight = #self.opList * operationHigth
  self.bgHeight = operationBottomBlankHeight + operationsHeight
  if self.opList and #self.opList > 0 then
    self.operationScrollView:SetActive(true)
    self.operationScrollView:SetSizeDeltaXY(self.operationScrollView:GetSizeDelta().x, operationsHeight)
    self.operationScrollView:RefreshList(self.opList)
  else
    self.operationScrollView:SetActive(false)
  end
  self.bg:SetSizeDeltaXY(bgx, self.bgHeight)
  self.bg:SetAnchoredPositionXY(self.bg.rectTransform.anchoredPosition.x, -self.bgHeight)
  self.bg.rectTransform:DOKill()
  self.bg.rectTransform:DOAnchorPosY(0, animSpeed)
  self:DarkMode()
end

function LWUIMomentOperationView:DarkMode()
  self.bg:SetColorHex(DarkConfig[ChatInterface.GetChatTheme()].bgColor)
  self.topIcon:LoadSpriteAsync(DarkConfig[ChatInterface.GetChatTheme()].topIconPath)
end

function LWUIMomentOperationView:OnItemClick(data)
  if data.OptionType == MomentOperationBtnType.RangeSet then
    self.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWVisibilitySettings, {anim = true}, self.data)
  elseif data.OptionType == MomentOperationBtnType.Delete then
    self.ctrl:CloseSelf()
    UIUtil.ShowMessage(Localization:GetString("moment_delete_des"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      if self.data then
        ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatDelete, self.data.roomId, self.data.seqId)
      end
      UIUtil.ShowTipsId("moment_delete_tips")
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSingleMomentDetailView)
    end, nil)
  elseif data.OptionType == MomentOperationBtnType.Close then
    self:OnBtnCloseClick()
  end
end

function LWUIMomentOperationView:OnAddListener()
  base.OnAddListener(self)
end

function LWUIMomentOperationView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIMomentOperationView:OnBtnCloseClick()
  if self.moveAniSeq then
    self.moveAniSeq:Kill()
    self.moveAniSeq = nil
  end
  self.moveAniSeq = DOTween.Sequence()
  self.moveAniSeq:Append(self.bg.rectTransform:DOAnchorPosY(-self.bgHeight, animSpeed))
  self.moveAniSeq:OnComplete(function()
    self.ctrl:CloseSelf()
  end)
end

return LWUIMomentOperationView
