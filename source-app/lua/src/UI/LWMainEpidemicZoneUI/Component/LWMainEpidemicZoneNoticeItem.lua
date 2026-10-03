local LWMainEpidemicZoneNoticeItem = BaseClass("LWMainEpidemicZoneNoticeItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "Bg"
local text_tip_path = "Bg/TipText"
local left_tip_path = "Bg/LeftTip"

function LWMainEpidemicZoneNoticeItem:OnCreate()
  base.OnCreate(self)
  self.basePos = Vector3.zero
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.baseW = self.bg:GetSizeDelta().x
  self.text_tip = self:AddComponent(UIText, text_tip_path)
  if self.text_tip.unity_tmpro then
    self.text_tip.unity_tmpro.richText = true
  end
  self.left_tip = self:AddComponent(UIImage, left_tip_path)
  self.fly_time = 0.5
  self:AddUIListener(EventId.DragonNoticeShow, self.SetShow)
end

function LWMainEpidemicZoneNoticeItem:OnDestroy()
  self:RemoveUIListener(EventId.DragonNoticeShow, self.SetShow)
  self:CleanSeq()
  self.bg = nil
  self.text_tip = nil
  self.left_tip = nil
  base.OnDestroy(self)
end

function LWMainEpidemicZoneNoticeItem:CleanSeq()
  if self.seqOpen ~= nil then
    self.seqOpen:Pause()
    self.seqOpen:Kill()
    self.seqOpen = nil
  end
  if self.bg ~= nil then
    self.bg:SetActive(false)
  end
end

function LWMainEpidemicZoneNoticeItem:SetShow(data)
  local config = data ~= nil and data.config or nil
  if config == nil then
    return
  end
  if self.bg == nil or config == nil or self.curIdx == config.id then
    return
  end
  self.curIdx = config.id
  self:CleanSeq()
  self.bg:SetActive(true)
  self.bg.transform:Set_localPosition(self.basePos.x - self.baseW, self.basePos.y, self.basePos.z)
  if not string.IsNullOrEmpty(config.icon) then
    self.left_tip:SetActive(true)
    local flag = self.left_tip:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldEpidemicDetailPath, config.icon), function()
      if self.left_tip then
        self.left_tip:SetNativeSize()
      end
    end)
    if not flag then
      self.left_tip:SetNativeSize()
    end
  else
    self.left_tip:SetActive(false)
  end
  self.text_tip:SetLocalText(config.alert_tips)
  
  local function cb()
    self.seqOpen = nil
    self.bg:SetActive(false)
    self.curIdx = nil
  end
  
  self.seqOpen = self:DoAction(self.bg.transform, data.actTime or 2, cb)
end

function LWMainEpidemicZoneNoticeItem:DoAction(transform, actTime, cb)
  local delayTime = actTime - self.fly_time
  local seq = CS.DG.Tweening.DOTween.Sequence()
  seq:Append(transform:DOLocalMoveX(self.basePos.x, self.fly_time))
  seq:AppendInterval(delayTime)
  seq.onComplete = cb
  return seq
end

return LWMainEpidemicZoneNoticeItem
