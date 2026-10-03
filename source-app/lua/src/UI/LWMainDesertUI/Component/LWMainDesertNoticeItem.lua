local LWMainDesertNoticeItem = BaseClass("LWMainDesertNoticeItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "Bg"
local text_tip_path = "Bg/TipText"
local left_tip_path = "Bg/LeftTip"
local bg2_path = "Bg2"
local text_end_path = "Bg2/EndText"

function LWMainDesertNoticeItem:OnCreate()
  base.OnCreate(self)
  self.basePos = Vector3.zero
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  local baseX, baseY, baseZ = self.bg.transform:Get_localPosition()
  self.baseW = self.bg:GetSizeDelta().x
  self.text_tip = self:AddComponent(UIText, text_tip_path)
  if self.text_tip.unity_tmpro then
    self.text_tip.unity_tmpro.richText = true
  end
  self.left_tip = self:AddComponent(UIImage, left_tip_path)
  self.bg2 = self:AddComponent(UIBaseContainer, bg2_path)
  baseX, baseY, baseZ = self.bg2.transform:Get_localPosition()
  self.baseW2 = self.bg2:GetSizeDelta().x
  self.text_end = self:AddComponent(UIText, text_end_path)
  if self.text_end.unity_tmpro then
    self.text_end.unity_tmpro.richText = true
  end
  self.fly_time = 0.5
  self:AddUIListener(EventId.DragonNoticeShow, self.SetShow)
end

function LWMainDesertNoticeItem:OnDestroy()
  self:RemoveUIListener(EventId.DragonNoticeShow, self.SetShow)
  self:CleanSeq()
  self.bg = nil
  self.text_tip = nil
  self.left_tip = nil
  self.bg2 = nil
  self.text_end = nil
  base.OnDestroy(self)
end

function LWMainDesertNoticeItem:CleanSeq()
  self:CleanSeqOpen()
  self:CleanSeqEnd()
end

function LWMainDesertNoticeItem:CleanSeqEnd()
  if self.seqEnd ~= nil then
    self.seqEnd:Pause()
    self.seqEnd:Kill()
    self.seqEnd = nil
  end
  if self.bg2 ~= nil then
    self.bg2:SetActive(false)
  end
end

function LWMainDesertNoticeItem:CleanSeqOpen()
  if self.seqOpen ~= nil then
    self.seqOpen:Pause()
    self.seqOpen:Kill()
    self.seqOpen = nil
  end
  if self.bg ~= nil then
    self.bg:SetActive(false)
  end
end

function LWMainDesertNoticeItem:SetShow(data)
  local config = data ~= nil and data.config or nil
  if config == nil then
    return
  end
  if config.type == 5 then
    self:ShowEnd(config, data.actTime or 2, data.time or 0)
  else
    self:ShowOpen(config, data.actTime or 2)
  end
end

function LWMainDesertNoticeItem:ShowOpen(config, actTime)
  if self.bg == nil or config == nil or self.curIdx == config.id then
    return
  end
  self.curIdx = config.id
  self:CleanSeqOpen()
  self.bg:SetActive(true)
  self.bg.transform:Set_localPosition(self.basePos.x - self.baseW, self.basePos.y, self.basePos.z)
  if not string.IsNullOrEmpty(config.icon) then
    self.left_tip:SetActive(true)
    self.left_tip:LoadSpriteAsyncWithCallback(config.icon, function()
      if self.left_tip then
        self.left_tip:SetNativeSize()
      end
    end)
  else
    self.left_tip:SetActive(false)
  end
  self.text_tip:SetLocalText(config.alert_tips)
  
  local function cb()
    self.seqOpen = nil
    self.bg:SetActive(false)
    self.curIdx = nil
  end
  
  self.seqOpen = self:DoAction(self.bg.transform, actTime, cb)
end

function LWMainDesertNoticeItem:ShowEnd(config, actTime, time)
  if self.bg2 == nil or config == nil or self.curIdx2 == config.id or time <= 0 then
    return
  end
  self.curIdx2 = config.id
  self:CleanSeqEnd()
  self.bg2:SetActive(true)
  self.bg2.transform:Set_localPosition(self.basePos.x - self.baseW2, self.basePos.y, self.basePos.z)
  self.text_end:SetLocalText(config.alert_tips, time)
  
  local function cb()
    self.seqEnd = nil
    self.bg2:SetActive(false)
    self.curIdx2 = nil
  end
  
  self.seqEnd = self:DoAction(self.bg2.transform, actTime, cb)
end

function LWMainDesertNoticeItem:DoAction(transform, actTime, cb)
  local delayTime = actTime - self.fly_time
  local seq = CS.DG.Tweening.DOTween.Sequence()
  seq:Append(transform:DOLocalMoveX(self.basePos.x, self.fly_time))
  seq:AppendInterval(delayTime)
  seq.onComplete = cb
  return seq
end

return LWMainDesertNoticeItem
