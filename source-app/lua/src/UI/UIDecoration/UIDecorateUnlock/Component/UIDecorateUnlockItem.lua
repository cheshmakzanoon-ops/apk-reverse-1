local UIDecorateUnlockItem = BaseClass("UIDecorateUnlockItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "UICommonResItem"
local name_path = "NameText"
local get_btn_path = "GetBtn"
local get_btn_text_path = "GetBtn/GetBtnLabel"
local use_btn_path = "UseBtn"
local use_btn_text_path = "UseBtn/UseBtnLabel"
local get_wat_image = "GetWayImage"

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

local function ComponentDefine(self)
  self.icon = self:AddComponent(UICommonResItem, icon_path)
  self.name = self:AddComponent(UIText, name_path)
  self.get_btn = self:AddComponent(UIButton, get_btn_path)
  self.get_btn_text = self:AddComponent(UIText, get_btn_text_path)
  self.get_btn_text:SetLocalText(2000476)
  self.get_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickGetBtn()
  end)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn_text = self:AddComponent(UIText, use_btn_text_path)
  self.use_btn_text:SetLocalText(110046)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickUseBtn()
  end)
  self.get_wat_image = self:AddComponent(UIImage, get_wat_image)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.data = {}
  self.decorationId = 0
end

local function DataDestroy(self)
  self.data = nil
  self.decorationId = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self, data, decorationId)
  self.data = data
  self.decorationId = decorationId
  self:RefreshView()
end

local function RefreshView(self)
  if self.data.id then
    local param = {}
    local itemCount = DataCenter.ItemData:GetItemCount(self.data.id)
    DataCenter.DecorationDataManager:SetNewItemFlag(self.data.id)
    local name_txt = DataCenter.ItemTemplateManager:GetName(tostring(self.data.id))
    self.name:SetText(name_txt)
    param.count = itemCount
    param.rewardType = RewardType.GOODS
    param.itemId = self.data.id
    self.icon:ReInit(param)
    self.use_btn:SetActive(0 < itemCount)
    self.get_btn:SetActive(itemCount <= 0)
    self.get_wat_image:SetActive(false)
    self.icon:SetActive(true)
  elseif self.data.tips and self.data.pic and self.data.btnName then
    self.icon:SetActive(false)
    self.get_wat_image:SetActive(true)
    self.get_wat_image:LoadSprite(self.data.pic)
    self.name:SetText(self.data.btnName)
    self.use_btn:SetActive(false)
    self.get_btn:SetActive(true)
  end
end

local function ClickGetBtn(self)
  if self.data.getBtnClickAction then
    self.data.getBtnClickAction()
  end
  if self.data and self.data.tips and self.decorationId then
    PostEventLog.Track(PostEventLog.Defines.DecorationViewClickGainWays, {
      decorationId = self.decorationId,
      tips = self.data.tips
    })
  end
end

local function ClickUseBtn(self)
  if self.data.type == 2 then
    local decorationId = GetTableData(TableName.DecorationDazzle, tonumber(self.data.skinId), "decoration_id")
    local wearData = DataCenter.DecorationDataManager:GetSkinDataById(decorationId)
    local now = UITimeManager:GetInstance():GetServerSeconds()
    local time = LocalController:instance():getIntValue(TableName.GoodsTab, self.data.id, "para2")
    if wearData ~= nil and wearData:GetExpireTime() > 0 and (time == 0 or (now + time) * 1000 > wearData:GetExpireTime()) then
      UIUtil.ShowSecondMessage(nil, Localization:GetString("season_s4_callback_tips_10"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        local item = DataCenter.ItemData:GetItemById(self.data.id)
        if item then
          SFSNetwork.SendMessage(MsgDefines.ItemUse, {
            uuid = item.uuid,
            num = 1
          })
        end
      end, function()
      end, nil, nil, false, nil, nil)
      return
    end
    local item = DataCenter.ItemData:GetItemById(self.data.id)
    if item then
      SFSNetwork.SendMessage(MsgDefines.ItemUse, {
        uuid = item.uuid,
        num = 1
      })
    end
    return
  end
  
  local function DoUse()
    DataCenter.DecorationDataManager:CovertSkin(self.data.skinId, self.data.index)
  end
  
  if self.data and self.data.id and UIUtil.TryConfirmUseLimitedDecorationItem(self.data.id, DoUse) then
    return
  end
  DoUse()
end

UIDecorateUnlockItem.OnCreate = OnCreate
UIDecorateUnlockItem.OnDestroy = OnDestroy
UIDecorateUnlockItem.OnEnable = OnEnable
UIDecorateUnlockItem.OnDisable = OnDisable
UIDecorateUnlockItem.ComponentDefine = ComponentDefine
UIDecorateUnlockItem.ComponentDestroy = ComponentDestroy
UIDecorateUnlockItem.DataDefine = DataDefine
UIDecorateUnlockItem.DataDestroy = DataDestroy
UIDecorateUnlockItem.ReInit = ReInit
UIDecorateUnlockItem.RefreshView = RefreshView
UIDecorateUnlockItem.ClickGetBtn = ClickGetBtn
UIDecorateUnlockItem.ClickUseBtn = ClickUseBtn
return UIDecorateUnlockItem
