local base = UIBaseContainer
local UIAccountIdBindProgressBar = BaseClass("UIAccountIdBindProgressBar", UIBaseContainer)
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local Localization = CS.GameEntry.Localization
local MoveTime = 0.5

function UIAccountIdBindProgressBar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAccountIdBindProgressBar:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAccountIdBindProgressBar:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compEmptyNode1 = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compEmptyNode2 = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compEmptyNode3 = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compProgressNode = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textMail = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textVerify = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textConfirm = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
end

function UIAccountIdBindProgressBar:ComponentDestroy()
  self.compEmptyNode1 = nil
  self.compEmptyNode2 = nil
  self.compEmptyNode3 = nil
  self.compProgressNode = nil
  self.textMail = nil
  self.textVerify = nil
  self.textConfirm = nil
end

function UIAccountIdBindProgressBar:DataDefine()
  self.curProgress = nil
  self.progressNodes = {
    self.compEmptyNode1,
    self.compEmptyNode2,
    self.compEmptyNode3
  }
  self.textList = {
    self.textMail,
    self.textVerify,
    self.textConfirm
  }
  self.nodePosMap = {}
  self.timer = nil
end

function UIAccountIdBindProgressBar:DataDestroy()
  self:DisposeTimer()
  self.curProgress = nil
  self.progressNodes = nil
  self.nodePosMap = nil
end

function UIAccountIdBindProgressBar:OnAddListener()
  base.OnAddListener(self)
end

function UIAccountIdBindProgressBar:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAccountIdBindProgressBar:ReInit(stage)
  self:SetActive(true)
  local AccountIdBindStage = AccountScoreConst.AccountIdBindStage
  for _, v in pairs(AccountIdBindStage) do
    local node = self.progressNodes[v]
    if node and node.transform then
      local pos = node.transform.localPosition
      self.nodePosMap[v] = pos
    end
  end
  for _, text in pairs(self.textList) do
    text:SetAlpha(0.5)
  end
  self.textMail:SetLocalText("id_account_progress1_title")
  self.textVerify:SetLocalText("id_account_progress2_title")
  self.textConfirm:SetLocalText("id_account_progress3_title")
  stage = stage or AccountIdBindStage.Mail
  self:MoveToProgress(stage, false)
end

function UIAccountIdBindProgressBar:MoveToProgress(progress, ifPlayAnim)
  local oldProgress = self.curProgress
  self.curProgress = progress
  local targetPos = self.nodePosMap[self.curProgress]
  if ifPlayAnim then
    self.compProgressNode.transform:DOLocalMove(targetPos, MoveTime)
    self:DisposeTimer()
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      for k, v in pairs(self.textList) do
        if k == self.curProgress then
          v:SetAlpha(1, MoveTime / 2)
        else
          v:SetAlpha(0.5, MoveTime / 2)
        end
      end
      self:DisposeTimer()
    end, MoveTime / 2)
  else
    self.compProgressNode.transform.localPosition = targetPos
    for k, v in pairs(self.textList) do
      if k == self.curProgress then
        v:SetAlpha(1)
      else
        v:SetAlpha(0.5)
      end
    end
  end
end

function UIAccountIdBindProgressBar:DisposeTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

return UIAccountIdBindProgressBar
