local UIMainRaceEntranceTipBtn = BaseClass("UIMainRaceEntranceTipBtn", UIButton)
local base = UIButton
local Localization = CS.GameEntry.Localization

function UIMainRaceEntranceTipBtn:OnCreate()
  base.OnCreate(self)
  self:SetOnClick(function()
    if self.actType == 0 then
      return
    end
    local bfType = BattleFieldUtil.GetBattleFieldTypeByActType(self.actType)
    if bfType ~= nil and BattleFieldUtil.GetBattleFieldCanEnterFlag(bfType) then
      BattleFieldUtil.ClearBattleFieldCanEnterFlag(bfType)
      self.tip:SetActive(false)
    end
    RaceEntranceUtil.GotoOpenView(self.actType)
  end)
  self.tip = self:AddComponent(UIBaseComponent, "Tip")
  self.tip:SetActive(false)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, "Tip/TipText")
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, "TimeText")
end

function UIMainRaceEntranceTipBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BattleFieldCanEnterPush, self.Refresh)
end

function UIMainRaceEntranceTipBtn:OnRemoveListener()
  self:RemoveUIListener(EventId.BattleFieldCanEnterPush, self.Refresh)
  base.OnRemoveListener(self)
end

function UIMainRaceEntranceTipBtn:OnDestroy()
  self:CleanDelay()
  self.tip = nil
  base.OnDestroy(self)
end

function UIMainRaceEntranceTipBtn:CleanDelay()
  if self.tipDelay then
    self.tipDelay:Stop()
    self.tipDelay = nil
  end
end

function UIMainRaceEntranceTipBtn:Refresh()
  local actType, bBig, tipStr, endSec = RaceEntranceUtil.CheckCanShowTip()
  self.actType = actType
  if self.actType <= 0 then
    self:CleanDelay()
    self.tip:SetActive(false)
    self:SetActive(false)
    return
  end
  local bSame = self.bBig == bBig and self.tipStr == tipStr
  self.bBig = bBig
  self.tipStr = tipStr
  self.endSec = endSec
  local delayTime = 3
  local bfType = BattleFieldUtil.GetBattleFieldTypeByActType(self.actType)
  if bfType ~= nil and BattleFieldUtil.GetBattleFieldCanEnterFlag(bfType) then
    tipStr = "Desert_strom_tips1095"
    delayTime = 10
    bSame = false
  end
  local itemPath = RaceEntranceUtil.GetBubbleIcon(self.actType, false)
  self:LoadSpriteAsync(itemPath)
  self:SetActive(true)
  self:Update1000MS()
  if bSame then
    if self.tipDelay == nil and self.tip:GetActive() then
      self.tip:SetActive(false)
    end
    return
  end
  self:CleanDelay()
  self.tip_text:SetLocalText(tipStr)
  self.tip:SetActive(true)
  self.tipDelay = TimerManager:GetInstance():DelayInvoke(function()
    self:CleanDelay()
    self.tip:SetActive(false)
  end, delayTime)
end

function UIMainRaceEntranceTipBtn:Update1000MS()
  if self.endSec == nil then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remindTime = self.endSec - curSec
  if 60 < remindTime then
    self.time_text:SetText(math.ceil(remindTime / 60) .. Localization:GetString(2010340))
  elseif 0 < remindTime then
    self.time_text:SetText(remindTime .. Localization:GetString(372115))
  else
    self.time_text:SetText(0 .. Localization:GetString(372115))
    self.endSec = nil
    RaceEntranceUtil.ReqActInfo(self.actType)
  end
end

return UIMainRaceEntranceTipBtn
