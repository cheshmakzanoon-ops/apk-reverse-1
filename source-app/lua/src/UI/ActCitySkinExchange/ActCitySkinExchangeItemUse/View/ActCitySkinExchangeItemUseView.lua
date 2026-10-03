local ActCitySkinExchangeItemUseView = BaseClass("ActCitySkinExchangeItemUseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ActCitySkinExchangeItemUseItem = require("UI.ActCitySkinExchange.ActCitySkinExchangeItemUse.Component.ActCitySkinExchangeItemUseItem")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local panel_path = "panel"
local title_text_path = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local content_path = "Root/Scroll/Viewport/Content"
local l_w_act_monopoly_item_use_item_path = "Root/LWActCitySkinExchangeItemUseItem"
local tip_txt_path = "Root/tipTxt"
local icon_path = "Root/ResourceInfo/icon"
local cur_num_path = "Root/ResourceInfo/curNum"

function ActCitySkinExchangeItemUseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function ActCitySkinExchangeItemUseView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActCitySkinExchangeItemUseView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.l_w_act_monopoly_item_use_item = self:AddComponent(UIBaseContainer, l_w_act_monopoly_item_use_item_path)
  self.tip_txt = self:AddComponent(UITextMeshProUGUIEx, tip_txt_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.itemList = {}
  self.l_w_act_monopoly_item_use_item:SetActive(false)
  self.l_w_act_monopoly_item_use_item.gameObject:GameObjectCreatePool()
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.cur_num = self:AddComponent(UITextMeshProUGUIEx, cur_num_path)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "CommonActivityPopUpBgPart")
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function ActCitySkinExchangeItemUseView:ComponentDestroy()
  self:ClearList()
  self.panel = nil
  self.content = nil
  self.l_w_act_monopoly_item_use_item = nil
  self.tip_txt = nil
  self.cur_num = nil
end

function ActCitySkinExchangeItemUseView:OnEnable()
  base.OnEnable(self)
end

function ActCitySkinExchangeItemUseView:OnDisable()
  base.OnDisable(self)
end

function ActCitySkinExchangeItemUseView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.UseItemSuccessHandle)
end

function ActCitySkinExchangeItemUseView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.UseItemSuccessHandle)
  base.OnRemoveListener(self)
end

function ActCitySkinExchangeItemUseView:ReInit()
  self:InitData()
  self:RefreshTopContent()
  self:RefreshItemContent(true)
end

function ActCitySkinExchangeItemUseView:InitData()
  self.activityId = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId)
  self.paraTemp = self.activityInfo:GetShowConfigTemp()
  self.usebox_list = self.paraTemp.usebox_list
  if self.paraTemp and #self.paraTemp.usebox_desc == 2 then
    local textPara = self.paraTemp.usebox_desc
    self.commonActivityPopUpBgPart:SetTitle(textPara[1])
    self.tip_txt:SetLocalText(textPara[2])
  end
end

function ActCitySkinExchangeItemUseView:RefreshTopContent()
  if self.paraTemp == nil then
    return
  end
  local targetItemId = self.paraTemp.usebox_item
  local imgPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, targetItemId)
  self.icon:LoadSprite(imgPath)
  local curNum = DataCenter.ItemData:GetItemCount(targetItemId)
  self.cur_num:SetText(curNum)
end

function ActCitySkinExchangeItemUseView:RefreshItemContent(isFirst)
  local dataNum = #self.usebox_list
  local itemNum = #self.itemList
  if dataNum ~= itemNum then
    self:ClearList()
    for i = 1, dataNum do
      local index = i
      local item = self.l_w_act_monopoly_item_use_item.gameObject:GameObjectSpawn(self.content.transform)
      item.name = index
      local obj = self.content:AddComponent(ActCitySkinExchangeItemUseItem, item.name)
      obj:SetActive(true)
      self.itemList[index] = obj
    end
  end
  for i = 1, dataNum do
    self.itemList[i]:SetData(self.activityId, self.usebox_list[i], isFirst)
  end
end

function ActCitySkinExchangeItemUseView:ClearList()
  self.content:RemoveComponents(ActCitySkinExchangeItemUseItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.l_w_act_monopoly_item_use_item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

function ActCitySkinExchangeItemUseView:UseItemSuccessHandle()
  self:RefreshTopContent()
  self:RefreshItemContent()
end

return ActCitySkinExchangeItemUseView
