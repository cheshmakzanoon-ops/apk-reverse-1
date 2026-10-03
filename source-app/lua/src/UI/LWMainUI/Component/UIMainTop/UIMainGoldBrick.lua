local UIMainGoldBrick = BaseClass("UIMainGoldBrick", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local FlyGoodsDefaultSize = 80

function UIMainGoldBrick:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIMainGoldBrick:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainGoldBrick:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.bg_root = self:AddComponent(UIBaseContainer, "Bg")
  self.icon_root = self:AddComponent(UIBaseContainer, "Bg/Icon")
  self.text = self:AddComponent(UIText, "Bg/Text")
  self.plus_btn = self:AddComponent(UIButton, "Bg/Text/plus")
  self.plus_btn:SetOnClick(function()
    self:OnClickPlus()
  end)
  self.tip_root = self:AddComponent(UICanvasGroup, "Bg/Icon/TipRoot")
  self.tip_text = self:AddComponent(UIText, "Bg/Icon/TipRoot/TipBox/DescText")
  self.tip_box = self:AddComponent(UIButton, "Bg/Icon/TipRoot/TipBox")
  self.tip_box:SetOnClick(function()
    self:CloseTips()
  end)
end

function UIMainGoldBrick:OnAddListener()
  base.OnAddListener(self)
  if not self._onPlayerInfoUpdated then
    function self._onPlayerInfoUpdated()
      self:Refresh()
    end
  end
  self:AddUIListener(EventId.PlayerInfoUpdated, self._onPlayerInfoUpdated)
  self.addListener = true
end

function UIMainGoldBrick:OnRemoveListener()
  if self.addListener then
    self:RemoveUIListener(EventId.PlayerInfoUpdated, self._onPlayerInfoUpdated)
  end
  base.OnRemoveListener(self)
end

function UIMainGoldBrick:ComponentDestroy()
  self.btn = nil
  self.bg_root = nil
  self.icon_root = nil
  self.text = nil
  self.plus_btn = nil
  self.tip_root = nil
  self.tip_text = nil
  self.tip_box = nil
  self._onPlayerInfoUpdated = nil
end

function UIMainGoldBrick:DataDefine()
  self._onPlayerInfoUpdated = nil
  self.addListener = false
end

function UIMainGoldBrick:DataDestroy()
end

function UIMainGoldBrick:ReInit()
  self:Refresh()
end

function UIMainGoldBrick:Refresh()
  local showPlus = false
  if Config.IsPC() then
    showPlus = true
  elseif WelfareController.CanOpenGoldBrickStore() then
    showPlus = true
  end
  self.plus_btn:SetActive(showPlus)
  local goldBrickCount = DataCenter.GoldBrickDataManager:GetGoldBrickCount() or 0
  if Config.IsPC() then
    self:SetActive(true)
    self.text:SetText(string.GetFormattedStr2(0 <= goldBrickCount and goldBrickCount or goldBrickCount))
    self.text:SetColorRGBA(0 <= goldBrickCount and 1 or 1, 0 <= goldBrickCount and 1 or 0, 0 <= goldBrickCount and 1 or 0, 1)
    return
  end
  local hasHistory = LuaEntry.Player:GetAlreadyBuyGoldBrick()
  local canOpen = WelfareController.CanOpenGoldBrickStore()
  if 0 < goldBrickCount or goldBrickCount < 0 or hasHistory or canOpen then
    self:SetActive(true)
    self.text:SetText(string.GetFormattedStr2(goldBrickCount))
    self.text:SetColorRGBA(0 <= goldBrickCount and 1 or 1, 0 <= goldBrickCount and 1 or 0, 0 <= goldBrickCount and 1 or 0, 1)
  else
    self:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function UIMainGoldBrick:ShouldShow()
  if Config.IsPC() then
    return true
  end
  local goldBrickCount = DataCenter.GoldBrickDataManager:GetGoldBrickCount() or 0
  local hasHistory = LuaEntry.Player:GetAlreadyBuyGoldBrick()
  local canOpen = WelfareController.CanOpenGoldBrickStore()
  if goldBrickCount ~= 0 or hasHistory or canOpen then
    return true
  end
  return false
end

function UIMainGoldBrick:OnEnable()
  base.OnEnable(self)
  self:CloseTips()
end

function UIMainGoldBrick:OnDisable()
  self:CloseTips()
  base.OnDisable(self)
end

function UIMainGoldBrick:OnBtnClick()
  local goldBrickCount = DataCenter.GoldBrickDataManager:GetGoldBrickCount() or 0
  if goldBrickCount < 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWRefundPunish)
  elseif DataCenter.PlayerInfoDataManager:CanShowGoldBrickDetail() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGoldBrickDetail)
  else
    self:ShowTips()
  end
end

function UIMainGoldBrick:OnClickPlus()
  Logger.Log("UIMainGoldBrick:OnClickPlus() - \229\176\157\232\175\149\229\148\164\232\181\183\233\135\145\231\160\150\229\149\134\229\159\142")
  local goldBrickCount = DataCenter.GoldBrickDataManager:GetGoldBrickCount() or 0
  if goldBrickCount < 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWRefundPunish)
    PostEventLog.Track(PostEventLog.Defines.ClickGoldBrickWhenBrickLessZero)
  else
    local canOpen = WelfareController.CanOpenGoldBrickStore()
    if canOpen then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.GoldBrickStore)
    else
      if Config.IsPC() then
        DataCenter.PayManager:PayPCByGoldBrickWeb2()
      else
      end
    end
  end
end

function UIMainGoldBrick:ShowTips()
  local goldBrickCount = DataCenter.GoldBrickDataManager:GetGoldBrickCount()
  local tipText = Localization:GetString(400406, string.GetFormattedSeparatorNum(goldBrickCount))
  UIUtil.ShowDetail(tipText)
end

function UIMainGoldBrick:CloseTips()
  if self.sequenceResTip ~= nil then
    self.sequenceResTip:Pause()
    self.sequenceResTip:Kill()
    self.sequenceResTip = nil
  end
  self.tip_root:SetAlpha(0)
  self.tip_root:SetLocalScaleXYZ(1, 0, 1)
end

function UIMainGoldBrick:GetTargetPos()
  if self.icon_root then
    local iconPos = self.icon_root:GetPosition()
    if self.bg_root then
      local _, bgHeight = self.bg_root:GetSizeDeltaXY()
      local offsetY = (FlyGoodsDefaultSize - bgHeight) * 0.5
      return iconPos + Vector3.New(0, -offsetY, 0)
    end
    return iconPos
  end
  return self.btn:GetPosition()
end

return UIMainGoldBrick
