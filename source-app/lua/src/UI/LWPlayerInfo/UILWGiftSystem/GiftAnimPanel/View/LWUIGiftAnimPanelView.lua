local LWUIGiftAnimPanelView = BaseClass("LWUIGiftAnimPanelView", UIBaseView)
local base = UIBaseView
local LWUIGiftSpecialAnimSenderContent = require("UI.LWPlayerInfo.UILWGiftSystem.GiftAnim.Components.LWUIGiftSpecialAnimSenderContent")

function LWUIGiftAnimPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ResetAnim(self.data)
end

function LWUIGiftAnimPanelView:ResetAnim(info)
  self.data = info
  self.aniFinishCallback = self.data.callBack
  self.compSenderContent:SetActive(true)
  self:PlayAnimation()
end

function LWUIGiftAnimPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIGiftAnimPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compSenderContent = self.viewSkin:AddComponent(self, LWUIGiftSpecialAnimSenderContent, 1)
end

function LWUIGiftAnimPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.compSenderContent = nil
end

function LWUIGiftAnimPanelView:DataDefine()
  self.data = self:GetUserData()
end

function LWUIGiftAnimPanelView:DataDestroy()
end

function LWUIGiftAnimPanelView:PlayAnimation()
  if self.compSenderContent then
    self.compSenderContent:ReInit(self.data, function()
      local callback = self.aniFinishCallback
      if callback then
        local isPlay = callback()
        if not isPlay then
          self.ctrl:CloseSelf()
        end
      else
        self.ctrl:CloseSelf()
      end
    end)
  end
end

function LWUIGiftAnimPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GiftSystemSendGiftAnim, self.ResetAnim)
end

function LWUIGiftAnimPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.GiftSystemSendGiftAnim, self.ResetAnim)
  base.OnRemoveListener(self)
end

return LWUIGiftAnimPanelView
