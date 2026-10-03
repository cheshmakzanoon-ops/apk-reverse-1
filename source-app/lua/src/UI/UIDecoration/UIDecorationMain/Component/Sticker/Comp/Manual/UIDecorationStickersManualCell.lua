local ResourceManager = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local unity_time = CS.UnityEngine.Time
local UIDecorationStickersManualCell = BaseClass("UIDecorationStickersManualCell", UIBaseContainer)
local base = UIBaseContainer
local bgPtah = "Assets/Main/Sprites/UI/LWUIWorldStickers/ljq_daditubiaoqing_qipao_01.png"
local markBgPtah = "Assets/Main/Sprites/UI/LWUIWorldStickers/ljq_daditubiaoqing_qipao_kong_01.png"
local markPath = "Assets/Main/Sprites/UI/LWUIWorldStickers/"

function UIDecorationStickersManualCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDecorationStickersManualCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickersManualCell:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "bg")
  self.p_trans_dynamic = self:AddComponent(UIBaseContainer, "p_trans_dynamic")
  self.bgLow = self:AddComponent(UIImage, "bgLow")
  self.stickerIcon = self:AddComponent(UIImage, "icon")
  self.deleteBtn = self:AddComponent(UIButton, "deletebtn")
  self.deleteBtn:SetOnClick(BindCallback(self, self.OnDeleteBtnClick))
  self.selectCom = self:AddComponent(UIBaseContainer, "select")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
  self.canvasIcon = self:AddComponent(UICanvasGroup, "icon")
  self.canvasDynamic = self:AddComponent(UICanvasGroup, "p_trans_dynamic")
  self.stickerMatDic = {}
end

function UIDecorationStickersManualCell:ComponentDestroy()
  self:ClearDynamicSticker()
  self.bg = nil
  self.p_trans_dynamic = nil
  self.bgLow = nil
  self.stickerIcon = nil
  self.deleteBtn = nil
  self.selectCom = nil
  self.btn = nil
  self.btn = nil
end

function UIDecorationStickersManualCell:OnClick()
  if self.callback and self.index then
    self.callback(self.index)
    self:UnSelect(true)
  end
end

function UIDecorationStickersManualCell:OnDeleteBtnClick()
  self.initDecorationId = -1
  self:UpdateSticker(-1)
  self.stickersCom:SaveSticker()
  if self.IsOn then
    EventManager:GetInstance():Broadcast(EventId.DecorationStickerIconSelect, -1)
  end
end

function UIDecorationStickersManualCell:SetData(data, index, stickersCom, callback)
  self.data = data
  self.index = index
  self.stickersCom = stickersCom
  self.callback = callback
  self.initDecorationId = self.data.decorationId
  self.IsOn = false
  self:RefreshView()
end

function UIDecorationStickersManualCell:UpdateSticker(decorationId, isInit)
  self:ClearDynamicSticker()
  if decorationId ~= self.data.decorationId or isInit then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
    self.data.decorationId = decorationId
    self.data.template = template
    if template and template.customVariable and tonumber(template.customVariable) > 0 then
      local strickerTmp = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(tonumber(template.customVariable))
      self.bg:LoadSprite(bgPtah)
      self.bgLow:LoadSprite(markPath .. "ljq_daditubiaoqing_qipao_02")
      self.stickerIcon:LoadSprite(string.format(ChatStickerCoverPath, strickerTmp.name))
      self.stickerIcon:SetActive(true)
      self.stickerIcon:SetNativeSize()
      self.deleteBtn:SetActive(self.openType ~= MapStickerOpenType.Wrold)
      if self.selectCom ~= nil and self.selectCom:GetActive() then
        self:PlayDynamicSticker(strickerTmp.id)
      end
    else
      self.bg:LoadSprite(markBgPtah)
      self.bgLow:LoadSprite(markPath .. "ljq_daditubiaoqing_qipao_kong_02")
      self.stickerIcon:SetActive(false)
      self.deleteBtn:SetActive(false)
    end
  end
end

function UIDecorationStickersManualCell:SaveStricker()
  self.initDecorationId = self.data.decorationId
end

function UIDecorationStickersManualCell:Restore()
  if self.initDecorationId ~= self.data.decorationId then
    self:UpdateSticker(self.initDecorationId)
  end
end

function UIDecorationStickersManualCell:SetOpenType(openType)
  self.openType = openType
  self:UpdateSticker(self.initDecorationId, true)
end

function UIDecorationStickersManualCell:UnSelect(isOn)
  self.IsOn = isOn
  self.selectCom:SetActive(isOn)
  self:ClearDynamicSticker()
  if isOn and checknumber(self.data.decorationId) > 0 then
    self:PlayDynamicSticker(self.data.decorationId)
  end
end

function UIDecorationStickersManualCell:RefreshView()
  self:UpdateSticker(self.data.decorationId, true)
end

function UIDecorationStickersManualCell:IsEmpty()
  return self.initDecorationId == -1
end

function UIDecorationStickersManualCell:ClearDynamicSticker()
  self.canvasIcon:SetAlpha(1)
  self.canvasDynamic:SetAlpha(0)
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

function UIDecorationStickersManualCell:PlayDynamicSticker()
  local template = self.data ~= nil and self.data.template or nil
  if template and template.customVariable and tonumber(template.customVariable) > 0 then
    local stickerTemp = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(tonumber(template.customVariable))
    local stickerId = stickerTemp ~= nil and stickerTemp.id or 0
    self.canvasIcon:SetAlpha(0)
    self.canvasDynamic:SetAlpha(1)
    self.p_trans_dynamic:SetActive(true)
    local root = self.p_trans_dynamic.transform
    self.StickerKey = string.format("Sticker_ItemTipsView_%s_%s", self.index, stickerId)
    DataCenter.ChatEmojiTemplateManager:ShowStickerByCfgId(root, self.StickerKey, stickerId, 0.45)
    if stickerTemp.id == 5 then
      self.DiceTimer = TimerManager:GetInstance():GetTimer(1.33, function()
        self.stickerIcon:LoadSpriteAsync(string.format(ChatStickerDicePath, math.random(1, 6)))
        self.canvasIcon:SetAlpha(1)
        self.canvasDynamic:SetAlpha(0)
        self.DiceTimerSub = TimerManager:GetInstance():DelayInvoke(function()
          self.canvasIcon:SetAlpha(0)
          self.canvasDynamic:SetAlpha(1)
        end, 0.5)
      end, nil, false)
      self.DiceTimer:Start()
    end
  end
end

return UIDecorationStickersManualCell
