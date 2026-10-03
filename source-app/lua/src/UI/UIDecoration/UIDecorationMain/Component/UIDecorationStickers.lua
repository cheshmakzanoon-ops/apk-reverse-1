local UIDecorationStickers = BaseClass("UIDecorationStickers", UIBaseContainer)
local UIDecorationStickerCell = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationStickerCell")
local base = UIBaseContainer

function UIDecorationStickers:OnCreate()
  base.OnCreate(self)
  self:InitData()
  self:ComponentDefine()
  self:ReInit()
end

function UIDecorationStickers:InitData()
  local prefs = DataCenter.DecorationDataManager:GetStickerData()
  self.stickerList = {}
  self.data = DataCenter.DecorationDataManager:GetMapStickerUIData()
  local defaultIndex = 1
  local index
  for i = 1, #prefs do
    index = prefs[i]
    self.data[i].decorationId = index
    if defaultIndex < index then
      defaultIndex = i
    end
  end
  if self.stickerList[self.selectIndex] then
    self.stickerList[self.selectIndex]:Restore()
  end
  self.selectIndex = defaultIndex
end

function UIDecorationStickers:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickers:ComponentDefine()
  local cell
  for i = 1, 6 do
    cell = self:AddComponent(UIDecorationStickerCell, "node_stickers/sticker" .. i)
    cell:SetData(self.data[i], i, self, function(index)
      self:SelectSticker(index)
    end)
    cell:UnSelect()
    table.insert(self.stickerList, cell)
  end
  self.settingsCom = self:AddComponent(UIBaseContainer, "Settings")
  self.settingBtn = self:AddComponent(UIButton, "Settings/settingBtn")
  self.backBtn = self:AddComponent(UIButton, "Settings/backBtn")
  self.backBtn:SetOnClick(function()
    if self.backCallBack then
      self.backCallBack()
    end
  end)
  self.settingBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true}, DecorationType.DecorationType_Emoji, nil, nil, true)
  end)
end

function UIDecorationStickers:ComponentDestroy()
  self.stickerList = nil
end

function UIDecorationStickers:ReInit(openType, backCallBack)
  self.openType = openType or MapStickerOpenType.Decoration
  self.backCallBack = backCallBack
  self:RefreshView()
end

function UIDecorationStickers:SetPlaneIndex(index)
  if self.selectIndex and self.stickerList[self.selectIndex] then
    self.stickerList[self.selectIndex]:Restore()
    self.stickerList[self.selectIndex]:UnSelect()
  end
  self.selectIndex = index
  if self.stickerList[index] then
    self.stickerList[index]:Restore()
    self.stickerList[index]:UnSelect(true)
    self.view:RefreshIconDecorations(DecorationType.DecorationType_Emoji)
  end
end

function UIDecorationStickers:SaveSticker()
  if self.selectIndex then
    self.stickerList[self.selectIndex]:SaveStricker()
  end
  local count = #self.stickerList
  local stickerStr = ""
  for i = 1, count do
    if i == 1 then
      stickerStr = self.stickerList[i].initDecorationId
    else
      stickerStr = stickerStr .. "," .. self.stickerList[i].initDecorationId
    end
  end
  DataCenter.DecorationDataManager:SaveStickerData(stickerStr)
end

function UIDecorationStickers:SetSticker(decorationId)
  if self.selectIndex and self.stickerList[self.selectIndex] then
    self.stickerList[self.selectIndex]:UpdateSticker(decorationId)
  end
end

function UIDecorationStickers:GetSelectStickerDecorationId()
  if self.stickerList[self.selectIndex] then
    return self.stickerList[self.selectIndex].initDecorationId
  end
end

function UIDecorationStickers:GetSelectStickerTempId()
  if self.stickerList[self.selectIndex].data.decorationId then
    return self.stickerList[self.selectIndex].data.decorationId
  else
    return self.stickerList[self.selectIndex].initDecorationId
  end
end

function UIDecorationStickers:SelectSticker(index)
  if self.openType == MapStickerOpenType.Wrold then
    if self.view and self.view.ctrl then
      if self.data[index] and self.data[index].decorationId ~= -1 then
        if self.selectIndex and self.stickerList[self.selectIndex] then
          self.stickerList[self.selectIndex]:UnSelect()
        end
        self.selectIndex = index
        local temp = DataCenter.DecorationTemplateManager:GetTemplate(self.data[index].decorationId)
        local isSend = DataCenter.LWSticker3DManager:SendMapSticker(WorldStickerType.Build, nil, tonumber(temp.customVariable))
        if not isSend then
          return
        end
      end
      self.view.ctrl:CloseSelf()
    end
    return
  end
  if self.stickerList[self.selectIndex] then
    self.stickerList[self.selectIndex]:Restore()
    self.stickerList[self.selectIndex]:UnSelect()
  end
  self.selectIndex = index
  self.view:RefreshIconDecorations(DecorationType.DecorationType_Emoji)
end

function UIDecorationStickers:RefreshView()
  self.settingsCom:SetActive(self.openType == MapStickerOpenType.Wrold)
  local cell
  for i = 1, #self.stickerList do
    cell = self.stickerList[i]
    cell:SetOpenType(self.openType)
  end
end

return UIDecorationStickers
