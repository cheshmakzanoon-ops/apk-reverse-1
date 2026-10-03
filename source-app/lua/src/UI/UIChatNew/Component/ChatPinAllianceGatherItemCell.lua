local ChatPinAllianceGatherItemCell = BaseClass("ChatPinAllianceGatherItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_path = "Title"
local icon_path = "Consume/UICommonResItem"
local consume_area_path = "Consume"
local consume_txt_path = "Consume/ConsumeTxt"
local consume_val_txt_path = "Consume/ConsumeValTxt"
local no_consume_txt_path = "NoConsumeTxt"
local btn_path = "Btn"

function ChatPinAllianceGatherItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ChatPinAllianceGatherItemCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ChatPinAllianceGatherItemCell:OnEnable()
  base.OnEnable(self)
end

function ChatPinAllianceGatherItemCell:OnDisable()
  base.OnDisable(self)
end

function ChatPinAllianceGatherItemCell:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.icon = self:AddComponent(UICommonResItem, icon_path)
  self.consume_txt = self:AddComponent(UIText, consume_txt_path)
  self.consume_val_txt = self:AddComponent(UIText, consume_val_txt_path)
  self.no_consume_txt = self:AddComponent(UIText, no_consume_txt_path)
  self.no_consume_txt:SetLocalText(130126)
  self.consume_area = self:AddComponent(UIBaseContainer, consume_area_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.consume_txt:SetLocalText(393102)
  self.consume_val_txt:SetText("x1")
end

function ChatPinAllianceGatherItemCell:ComponentDestroy()
end

function ChatPinAllianceGatherItemCell:DataDefine()
end

function ChatPinAllianceGatherItemCell:DataDestroy()
end

function ChatPinAllianceGatherItemCell:ReInit(data)
  self.data = data
  if data.type == ChatPinMessageType.AllianceGatherMember then
    self.title:SetLocalText(393101, data.content.leaderName)
    local param = {}
    param.rewardType = RewardType.GOODS
    param.itemId = 200008
    self.icon:ReInit(param)
    local recommendType = DataCenter.AllianceRallyPointDataManager:GetRecommendType()
    local free = LuaEntry.Player:CanFreeAllianceMove(recommendType)
    self.consume_area:SetActive(not free)
    self.no_consume_txt:SetActive(free)
  end
end

function ChatPinAllianceGatherItemCell:OnBtnClick(data)
  if self.data.type == ChatPinMessageType.AllianceGatherMember then
    if not DataCenter.AllianceRallyPointDataManager:CanAllianceMoveCity() then
      UIUtil.ShowTipsId("alliance_AssemblyPoint_tips_06")
      return
    end
    local recommendType = DataCenter.AllianceRallyPointDataManager:GetRecommendType()
    local free = LuaEntry.Player:CanFreeAllianceMove(recommendType)
    if free then
      UIUtil.ShowMessage(Localization:GetString("310191"), 2, "393106", "393107", function()
        MoveCityUtil.AllianceMoveCityToRecommendRallyPoint(5, false, self.data.uuid)
        DataCenter.LWChatPinManager:RemovePinData(self.data.uuid)
      end, function()
        DataCenter.LWChatPinManager:RecordRejectAllianceGatherMember(self.data.uuid)
        DataCenter.LWChatPinManager:RemovePinData(self.data.uuid)
      end)
    else
      local curNum = DataCenter.ItemData:GetItemCount(200008)
      if 0 < curNum then
        UIUtil.ShowMessage(Localization:GetString("393100", curNum), 2, "393106", "393107", function()
          MoveCityUtil.AllianceMoveCityToRecommendRallyPoint(4, false, self.data.uuid)
          DataCenter.LWChatPinManager:RemovePinData(self.data.uuid)
        end, function()
          DataCenter.LWChatPinManager:RecordRejectAllianceGatherMember(self.data.uuid)
          DataCenter.LWChatPinManager:RemovePinData(self.data.uuid)
        end)
      else
        LWResourceLackUtil:GotoGoodsItemLack(200008, 1)
      end
    end
  end
end

return ChatPinAllianceGatherItemCell
