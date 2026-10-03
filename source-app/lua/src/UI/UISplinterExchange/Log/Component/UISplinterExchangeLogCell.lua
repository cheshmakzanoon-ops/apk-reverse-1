local base = UIBaseContainer
local UISplinterExchangeLogCell = BaseClass("UISplinterExchangeLogCell", base)
local NameText_path = "NameText"
local DialogText_path = "DialogText"
local UpBtn_path = "UpBtn"
local UpImg_path = "UpBtn/UpImg"
local TimeText_path = "TimeText"
local PlayerHead_Path = "Head/UIPlayerHead"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.NameText = self:AddComponent(UITextMeshProUGUIEx, NameText_path)
  self.DialogText = self:AddComponent(UITextMeshProUGUIEx, DialogText_path)
  self.UpBtn = self:AddComponent(UIButton, UpBtn_path)
  self.UpImg = self:AddComponent(UIImage, UpImg_path)
  self.TimeText = self:AddComponent(UITextMeshProUGUIEx, TimeText_path)
  self.PlayerHead = self:AddComponent(UICommonHead, PlayerHead_Path)
  self.PlayerHead:SetEnableClickShowInfo(true, true)
  self.UpBtn:SetOnClick(function()
    if self.data.like == 1 then
      UIUtil.ShowTipsId("Treasure_map_43")
      return
    end
    self.view.ctrl:SendLikeMsg(self.data)
  end)
  self.UpBtn:SetActive(false)
end

local function ComponentDestroy(self)
  self.NameText = nil
  self.DialogText = nil
  self.UpBtn = nil
  self.UpImg = nil
  self.TimeText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
  self.type = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SplinterRefreshLogCell, self.Refresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.SplinterRefreshLogCell, self.Refresh)
  base.OnAddListener(self)
end

local function SetData(self, type, data)
  self.type = type
  self.data = data
  self.NameText:SetLocalText("Treasure_map_28", data.name)
  self.UpImg:SetActive(self.data.like == 1)
  self.TimeText:SetText(UITimeManager:GetInstance():TimeStampToMDHSForLocalMinute(data.time))
  local framePath
  if self.data.headSkinId then
    framePath = DataCenter.DecorationDataManager:GetHeadFrame(self.data.headSkinId, self.data.headSkinET, false)
  end
  self.PlayerHead:SetData(self.data.uid, self.data.headPic, self.data.headPicVer, nil, framePath)
  self.DialogText:SetLocalText("Treasure_map_27", DataCenter.ItemTemplateManager:GetName(data.costFragment), DataCenter.ItemTemplateManager:GetName(data.getFragment))
end

local function Refresh(self, uuid)
  if uuid == self.data.uuid then
    local data = DataCenter.SplinterExchangeManager:GetRecordDataByUuid(self.type, uuid)
    self:SetData(self.type, data)
  end
end

UISplinterExchangeLogCell.OnCreate = OnCreate
UISplinterExchangeLogCell.OnDestroy = OnDestroy
UISplinterExchangeLogCell.OnEnable = OnEnable
UISplinterExchangeLogCell.OnDisable = OnDisable
UISplinterExchangeLogCell.ComponentDefine = ComponentDefine
UISplinterExchangeLogCell.ComponentDestroy = ComponentDestroy
UISplinterExchangeLogCell.DataDefine = DataDefine
UISplinterExchangeLogCell.DataDestroy = DataDestroy
UISplinterExchangeLogCell.SetData = SetData
UISplinterExchangeLogCell.OnAddListener = OnAddListener
UISplinterExchangeLogCell.OnRemoveListener = OnRemoveListener
UISplinterExchangeLogCell.Refresh = Refresh
return UISplinterExchangeLogCell
