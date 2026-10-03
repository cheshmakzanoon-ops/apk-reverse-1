local WorldMarchStickerUI = BaseClass("WorldMarchStickerUI")
local WorldMarchStickerCell = require("Scene.WorldMarchTileUI.WorldMarchStickerCell")

function WorldMarchStickerUI:__init()
  self.stickerList = {}
  self:GetStickerData()
  self:AddListener()
end

function WorldMarchStickerUI:GetStickerData()
  local prefs = DataCenter.DecorationDataManager:GetStickerData()
  self.data = DataCenter.DecorationDataManager:GetMapStickerUIData()
  local index
  for i = 1, #prefs do
    index = prefs[i]
    self.data[i].decorationId = index
  end
end

function WorldMarchStickerUI:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.DecorationSetMapSticker, self.RefreshView, self)
end

function WorldMarchStickerUI:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.DecorationSetMapSticker, self.RefreshView)
end

function WorldMarchStickerUI:RefreshView()
  self:GetStickerData()
  for i = 1, 6 do
    self.stickerList[i]:UpdateSticker(self.data[i].decorationId)
  end
end

function WorldMarchStickerUI:ReInit(panelView, marchUuid, callbackd)
  if not panelView or not marchUuid then
    return
  end
  self.backCallBack = callbackd
  self.panelView = panelView
  self.marchUuid = marchUuid
  self:ComponentDefine()
end

function WorldMarchStickerUI:ComponentDefine()
  local cell, obj, cellData
  for i = 1, 6 do
    cellData = self.data[i]
    cellData.marchUid = self.marchUuid
    obj = self.panelView.transform:Find("mapStickers/node_stickers/sticker" .. i)
    cell = WorldMarchStickerCell:New()
    cell:ReInit(obj.gameObject, self.data[i], i)
    table.insert(self.stickerList, cell)
  end
  self.settingsCom = self.panelView.transform:Find("mapStickers/Settings")
  self.settingBtn = self.panelView.transform:Find("mapStickers/Settings/settingBtn"):GetComponent(typeof(CS.UnityEngine.UI.Button))
  self.backBtn = self.panelView.transform:Find("mapStickers/Settings/backBtn"):GetComponent(typeof(CS.UnityEngine.UI.Button))
  self.settingsCom.gameObject:SetActive(true)
  
  function self.backOnClcik()
    if self.backCallBack then
      self.backCallBack()
    end
  end
  
  self.backBtn.onClick:AddListener(self.backOnClcik)
  
  function self.settingOnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true}, DecorationType.DecorationType_Emoji, nil, nil, true)
  end
  
  self.settingBtn.onClick:AddListener(self.settingOnClick)
end

function WorldMarchStickerUI:__delete()
  for i = 1, #self.stickerList do
    self.stickerList[i]:Delete()
  end
  self.stickerList = nil
  self.backBtn.onClick:Clear()
  self.settingBtn.onClick:Clear()
  self:RemoveListener()
end

return WorldMarchStickerUI
