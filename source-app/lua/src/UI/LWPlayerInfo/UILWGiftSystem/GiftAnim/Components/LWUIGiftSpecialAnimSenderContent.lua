local base = UIBaseContainer
local LWUIGiftSpecialAnimSenderContent = BaseClass("LWUIGiftSpecialAnimSenderContent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function LWUIGiftSpecialAnimSenderContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIGiftSpecialAnimSenderContent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIGiftSpecialAnimSenderContent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compSender = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.compPurple = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compGold = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.textSenderName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compTarget = self.viewSkin:AddComponent(self, UICommonHead, 5)
  self.textTargetName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compPurpleEff = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compGoldEff = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.compGiftExtraItemNum = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textGiftScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.imgSendPlayer = self.viewSkin:AddComponent(self, UIImage, 11)
  self.imgTargetPlayer = self.viewSkin:AddComponent(self, UIImage, 12)
  self.animatorSenderContent = self.viewSkin:AddComponent(self, UIAnimator, 13)
  self.compSender:SetEnableClickShowInfo(true, true)
  self.compTarget:SetEnableClickShowInfo(true, true)
end

function LWUIGiftSpecialAnimSenderContent:ComponentDestroy()
  self.viewSkin = nil
  self.compSender = nil
  self.compPurple = nil
  self.compGold = nil
  self.textSenderName = nil
  self.compTarget = nil
  self.textTargetName = nil
  self.compPurpleEff = nil
  self.compGoldEff = nil
  self.compGiftExtraItemNum = nil
  self.textGiftScore = nil
  self.imgSendPlayer = nil
  self.imgTargetPlayer = nil
  self.animatorSenderContent = nil
end

function LWUIGiftSpecialAnimSenderContent:DataDefine()
  self.isPlayedMoveOutAnim = false
end

function LWUIGiftSpecialAnimSenderContent:DataDestroy()
  self.isPlayedMoveOutAnim = nil
  self:ClearCloseTimer()
end

function LWUIGiftSpecialAnimSenderContent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIGiftSpecialAnimSenderContent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIGiftSpecialAnimSenderContent:ReInit(data, closeCallBack)
  self.data = data
  self.isPlayedMoveOutAnim = false
  self.closeCallBack = closeCallBack
  self:RefreshSenderInfo()
end

local SENDER_ANIM = {
  MoveIn = "SenderContent_movein",
  MoveOut = "SenderContent_moveout",
  MoveIn_Arabic = "SenderContent_movein_flip",
  MoveOut_Arabic = "SenderContent_moveout_flip"
}
local GOLD_COLOR_BG_PATH = "Assets/Main/Sprites/UI/LWUIGiftSystem/wxy_songli_zhanshi_di.png"
local PURPLE_COLOR_BG_PATH = "Assets/Main/Sprites/UI/LWUIGiftSystem/wxy_songli_zhanshi_zidi.png"

function LWUIGiftSpecialAnimSenderContent:RefreshSenderInfo()
  local senderInfo = self.data.senderInfo
  local targetInfo = self.data.targetInfo
  self.animatorSenderContent:SetActive(senderInfo ~= nil and targetInfo ~= nil)
  self:ClearCloseTimer()
  if senderInfo and targetInfo then
    local quality = 5
    if self.data.giftId then
      local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.giftId)
      quality = template and template.color or 5
    end
    self.imgSendPlayer:LoadSpriteAsync(quality == 5 and GOLD_COLOR_BG_PATH or PURPLE_COLOR_BG_PATH)
    self.imgTargetPlayer:LoadSpriteAsync(quality == 5 and GOLD_COLOR_BG_PATH or PURPLE_COLOR_BG_PATH)
    self.compPurple:SetActive(quality == 4)
    self.compPurpleEff:SetActive(quality == 4)
    self.compGold:SetActive(quality == 5)
    self.compGoldEff:SetActive(quality == 5)
    self:PlayAnim(true)
    local extraNum = tonumber(self.data.giftExtraItemNum) or 0
    self.compGiftExtraItemNum:SetActive(0 < extraNum)
    if 0 < extraNum then
      self.textGiftScore:SetText("\195\151" .. extraNum)
    end
    self.compSender:SetEnableClickShowInfo(not senderInfo.isActiveAnonymity, true)
    self.compSender:ParseHeadInfo(senderInfo)
    self.compTarget:ParseHeadInfo(targetInfo)
    if senderInfo.isActiveAnonymity then
      self.textSenderName:SetText(Localization:GetString("390810"))
    else
      self.textSenderName:SetText(UIUtil.FormatAllianceAndName(senderInfo.abbr, senderInfo.name))
    end
    self.textTargetName:SetText(UIUtil.FormatAllianceAndName(targetInfo.abbr, targetInfo.name))
    local closeTime = LuaEntry.DataConfig:TryGetNum("player_send_gift", "k1", 2000)
    self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self then
        self:ClearCloseTimer()
        local time = self:PlayAnim(false)
        self.closeAnim = TimerManager:GetInstance():DelayInvoke(function()
          if self then
            if self.closeAnim then
              self.closeAnim:Stop()
              self.closeAnim = nil
            end
            if self.closeCallBack then
              self.closeCallBack()
            end
          end
        end, time)
      end
    end, closeTime / 1000)
  end
end

function LWUIGiftSpecialAnimSenderContent:PlayAnim(isMoveIn)
  if self.animatorSenderContent then
    if not isMoveIn then
      self.isPlayedMoveOutAnim = true
    end
    local state, time
    if CommonUtil.IsArabicAutoMirrorOpen() then
      state, time = self.animatorSenderContent:PlayAnimationReturnTime(isMoveIn and SENDER_ANIM.MoveIn_Arabic or SENDER_ANIM.MoveOut_Arabic)
    else
      state, time = self.animatorSenderContent:PlayAnimationReturnTime(isMoveIn and SENDER_ANIM.MoveIn or SENDER_ANIM.MoveOut)
    end
    if state then
      return time
    end
  end
end

function LWUIGiftSpecialAnimSenderContent:ClearCloseTimer()
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  if self.closeAnim then
    self.closeAnim:Stop()
    self.closeAnim = nil
  end
end

function LWUIGiftSpecialAnimSenderContent:TryPlayMoveOutAnim()
  if self.isPlayedMoveOutAnim then
    return
  end
  self:ClearCloseTimer()
  return self:PlayAnim(false)
end

return LWUIGiftSpecialAnimSenderContent
