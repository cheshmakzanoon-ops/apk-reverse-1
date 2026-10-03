local base = UIBaseContainer
local LLMainUIBattleMarkItem = BaseClass("LLMainUIBattleMarkItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function LLMainUIBattleMarkItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainUIBattleMarkItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainUIBattleMarkItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.root = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
end

function LLMainUIBattleMarkItem:ComponentDestroy()
  self.viewSkin = nil
  self.compPlayerHead = nil
  self.textTitle = nil
  self.textDesc = nil
  self.textServer = nil
  self.btn = nil
  self.root = nil
end

function LLMainUIBattleMarkItem:DataDefine()
  self.compPlayerHead:SetEnableClickShowInfo(true, true)
end

function LLMainUIBattleMarkItem:DataDestroy()
  self:CleanAnim()
end

function LLMainUIBattleMarkItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
end

function LLMainUIBattleMarkItem:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
  base.OnRemoveListener(self)
end

function LLMainUIBattleMarkItem:OnBtnClick()
  if self.cityId then
    DataCenter.LandlordMgr:JumpToCity(self.cityId)
  end
end

function LLMainUIBattleMarkItem:ReInit(markData, template)
  self.cityId = template ~= nil and template.id or nil
  if self.cityId ~= nil then
    self.textTitle:SetLocalText(300015, template.pos.x, template.pos.y)
    self.textDesc:SetText(markData ~= nil and markData.pointInfo or "")
  end
  self.uid = markData ~= nil and markData.uid or nil
  if self.uid ~= nil then
    self:OnGetNewUserInfoSucc(self.uid)
  end
end

function LLMainUIBattleMarkItem:OnGetNewUserInfoSucc(uid)
  if uid ~= self.uid then
    return
  end
  local info = UIUtil.GetPlayerInfoShowByUid(uid)
  self.compPlayerHead:ParseHeadInfo(info)
end

function LLMainUIBattleMarkItem:CleanAnim()
  if IsNotNull(self.sequence) then
    self.sequence:Pause()
    self.sequence:Kill()
    self.sequence = nil
  end
end

function LLMainUIBattleMarkItem:PlayAnim(cb)
  self:CleanAnim()
  local allTime = 5
  local moveTime = 0.3
  local showTime = allTime - moveTime * 2
  local width = self.root:GetSizeDeltaXY()
  self.root:SetAnchoredPositionXY(width, 0)
  local sequence = DOTween.Sequence()
  sequence:Append(self.root.transform:DOLocalMoveX(-width * 0.5, moveTime):SetEase(CS.DG.Tweening.Ease.InCirc))
  sequence:AppendInterval(showTime)
  sequence:Append(self.root.transform:DOLocalMoveX(width, moveTime):SetEase(CS.DG.Tweening.Ease.OutCirc))
  sequence:OnComplete(function()
    self:CleanAnim()
    if cb then
      cb()
    end
  end)
  self.sequence = sequence
end

return LLMainUIBattleMarkItem
