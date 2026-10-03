local base = UIBaseContainer
local UIS0AllianceLastClearResult = BaseClass("UIS0AllianceLastClearResult", UIBaseContainer)
local RESULT_ICON_PATH = {
  [AllianceBossS0ClearResult.Easy] = "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_TMJY_jiandan.png",
  [AllianceBossS0ClearResult.Normal] = "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_TMJY_shizhong.png",
  [AllianceBossS0ClearResult.Hard] = "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_TMJY_kunnan.png",
  [AllianceBossS0ClearResult.Failed] = "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_TMJY_shibai.png"
}
local RESULT_CONTEXT_ID = {
  [AllianceBossS0ClearResult.Easy] = "s0_alliance_boss_easy",
  [AllianceBossS0ClearResult.Normal] = "s0_alliance_boss_even",
  [AllianceBossS0ClearResult.Hard] = "s0_alliance_boss_barely",
  [AllianceBossS0ClearResult.Failed] = "s0_alliance_boss_failed"
}
local RESULT_CONTEXT_COLOR = {
  [AllianceBossS0ClearResult.Easy] = "#5FEF87",
  [AllianceBossS0ClearResult.Normal] = "#FFD66B",
  [AllianceBossS0ClearResult.Hard] = "#F97077",
  [AllianceBossS0ClearResult.Failed] = "#CCC8C6"
}

function UIS0AllianceLastClearResult:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIS0AllianceLastClearResult:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceLastClearResult:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtClearProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgEmoji = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textLock = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function UIS0AllianceLastClearResult:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtClearProgress = nil
  self.imgEmoji = nil
  self.textLock = nil
end

function UIS0AllianceLastClearResult:DataDefine()
  self.result = nil
end

function UIS0AllianceLastClearResult:DataDestroy()
  self.result = nil
end

function UIS0AllianceLastClearResult:Refresh(result)
  if result == nil or result == AllianceBossS0ClearResult.None then
    Logger.LogError("S0AllianceBoss -- clear result error, result = " .. result)
    return
  end
  if result ~= self.result and result ~= 0 then
    if result >= AllianceBossS0ClearResult.NoRecord then
      local dialogId
      if result == AllianceBossS0ClearResult.Lock then
        dialogId = "s0_alliance_boss_go_lock_tips"
      elseif result == AllianceBossS0ClearResult.LockMember then
        dialogId = "s0_alliance_boss_go_lock_tips_1"
      elseif result == AllianceBossS0ClearResult.NoRecord then
        dialogId = "s0_alliance_boss_unlock_tips"
      elseif result == AllianceBossS0ClearResult.InCombat then
        dialogId = "s0_alliance_boss_battle_tips"
      end
      if dialogId then
        self.textLock:SetActive(true)
        self.textLock:SetLocalText(dialogId)
        self.textTxtClearProgress:SetActive(false)
      end
    else
      self.textTxtClearProgress:SetActive(true)
      self.textLock:SetActive(false)
      self.textTxtClearProgress:SetActive(true)
      self.textLock:SetActive(false)
      self.imgEmoji:LoadSpriteAuto(RESULT_ICON_PATH[result])
      self.textTxtClearProgress:SetLocalText(RESULT_CONTEXT_ID[result])
      self.textTxtClearProgress:SetColorHex(RESULT_CONTEXT_COLOR[result])
    end
  end
end

return UIS0AllianceLastClearResult
