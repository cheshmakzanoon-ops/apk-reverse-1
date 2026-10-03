local p_img_sticker_empty_path = "content/p_img_sticker_empty"
local p_img_sticker_base_path = "content/p_img_sticker_base"
local p_img_sticker_path = "content/p_img_sticker_base/p_img_sticker"
local p_trans_sticker_root_path = "content/p_img_sticker_base/p_trans_sticker_root"
local p_text_sticker_desc_path = "content/p_text_sticker_desc"
local p_btn_sticker_path = "content/p_btn_sticker"
local p_btn_delete_path = "content/p_img_sticker_base/p_btn_delete"
local base = UIBaseContainer
local UIDecorationStickersAutoStickerCell = BaseClass("UIDecorationStickersAutoStickerCell", UIBaseContainer)

function UIDecorationStickersAutoStickerCell:ComponentDefine()
  self.p_img_sticker_empty = self:AddComponent(UIImage, p_img_sticker_empty_path)
  self.p_img_sticker_base = self:AddComponent(UIImage, p_img_sticker_base_path)
  self.p_img_sticker = self:AddComponent(UIImage, p_img_sticker_path)
  self.p_trans_sticker_root = self:AddComponent(UIBaseContainer, p_trans_sticker_root_path)
  self.p_text_sticker_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_sticker_desc_path)
  self.p_btn_sticker = self:AddComponent(UIButton, p_btn_sticker_path)
  self.p_btn_sticker:SetOnClick(BindCallback(self, self.OnClicked))
  self.p_btn_delete = self:AddComponent(UIButton, p_btn_delete_path)
  self.p_btn_delete:SetOnClick(BindCallback(self, self.OnDeleteClicked))
end

function UIDecorationStickersAutoStickerCell:ComponentDestroy()
  self:ClearDynamicSticker()
  self.p_img_sticker_empty = nil
  self.p_img_sticker_base = nil
  self.p_img_sticker = nil
  self.p_trans_sticker_root = nil
  self.p_text_sticker_desc = nil
  self.p_btn_sticker = nil
  self.p_btn_delete = nil
end

function UIDecorationStickersAutoStickerCell:DataDefine()
end

function UIDecorationStickersAutoStickerCell:DataDestroy()
end

function UIDecorationStickersAutoStickerCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationStickersAutoStickerCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickersAutoStickerCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationStickerAutoStickerUpdate, self.OnAutoStickerUpdated)
  self:AddUIListener(EventId.DecorationStickerAutoStickerSet, self.OnAutoStickerUpdated)
end

function UIDecorationStickersAutoStickerCell:OnRemoveListener()
  self:RemoveUIListener(EventId.DecorationStickerAutoStickerUpdate, self.OnAutoStickerUpdated)
  self:RemoveUIListener(EventId.DecorationStickerAutoStickerSet, self.OnAutoStickerUpdated)
  base.OnRemoveListener(self)
end

function UIDecorationStickersAutoStickerCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function UIDecorationStickersAutoStickerCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UIDecorationStickersAutoStickerCell:InitUi()
  self.p_text_sticker_desc:SetLocalText(self.Data.Cell.short_desc)
end

function UIDecorationStickersAutoStickerCell:UpdateData()
  local stickerId = self.Data ~= nil and DataCenter.LWSticker3DManager:GetAutoStickerId(self.Data.Cell.auto_send_param) or 0
  self.StickerCell = LocalController:instance():tryGetLine(TableName.LW_Sticker, stickerId)
  self.HasSticker = self.StickerCell ~= nil
  return true
end

function UIDecorationStickersAutoStickerCell:UpdateUi()
  self.p_img_sticker_empty:SetActive(not self.HasSticker)
  self.p_img_sticker_base:SetActive(self.HasSticker)
  self.p_trans_sticker_root:SetActive(self.HasSticker)
  self.p_btn_delete:SetActive(self.HasSticker)
  self.p_img_sticker:SetActive(not self.Data.IsDetail)
  self.p_trans_sticker_root:SetActive(self.Data.IsDetail)
  if self.StickerCell ~= nil then
    if self.Data.IsDetail then
      self:ClearDynamicSticker()
      self.StickerKey = string.format("Sticker_AutoSticker_%s_%s", checkstring(self.Data.IsDetail), self.StickerCell.id)
      DataCenter.ChatEmojiTemplateManager:ShowStickerByCfgId(self.p_trans_sticker_root.transform, self.StickerKey, self.StickerCell.id, 0.44)
      if self.StickerCell.id == 5 then
        self.DiceTimer = TimerManager:GetInstance():GetTimer(1.33, function()
          self.p_img_sticker:LoadSpriteAsync(string.format(ChatStickerDicePath, math.random(1, 6)))
          self.p_img_sticker:SetActive(true)
          self.p_trans_sticker_root:SetActive(false)
          self.DiceTimerSub = TimerManager:GetInstance():DelayInvoke(function()
            self.p_img_sticker:SetActive(false)
            self.p_trans_sticker_root:SetActive(true)
          end, 0.5)
        end, nil, false)
        self.DiceTimer:Start()
      end
    else
      self.p_img_sticker:LoadSpriteAsync(string.format(ChatStickerCoverPath, self.StickerCell.name))
    end
  else
    self:ClearDynamicSticker()
  end
end

function UIDecorationStickersAutoStickerCell:ClearDynamicSticker()
  if self.StickerKey then
    DataCenter.ChatEmojiTemplateManager:KillStickerByKey(self.StickerKey)
    self.StickerKey = nil
  end
  if self.DiceTimerSub then
    self.DiceTimerSub:Stop()
    self.DiceTimerSub = nil
  end
  if self.DiceTimer then
    self.DiceTimer:Stop()
    self.DiceTimer = nil
  end
end

function UIDecorationStickersAutoStickerCell:OnAutoStickerUpdated(evt)
  local oldStickerId = self.StickerCell ~= nil and self.StickerCell.id or 0
  self:UpdateData()
  local newStickerId = self.StickerCell ~= nil and self.StickerCell.id or 0
  if oldStickerId ~= newStickerId then
    self:UpdateUi()
  end
end

function UIDecorationStickersAutoStickerCell:OnClicked()
  if self.Data == nil or self.Data.IsDetail then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.DecorationStickerAutoStickerClick, self.Data)
end

function UIDecorationStickersAutoStickerCell:OnDeleteClicked()
  EventManager:GetInstance():Broadcast(EventId.DecorationStickerIconSelect, -1)
  DataCenter.LWSticker3DManager:SetAutoStickerId(self.Data.Cell.auto_send_param, 0, true)
end

return UIDecorationStickersAutoStickerCell
