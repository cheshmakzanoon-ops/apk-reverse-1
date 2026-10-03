local base = UIBaseContainer
local UIFishEatFishCell = BaseClass("UIFishEatFishCell", UIBaseContainer)

function UIFishEatFishCell:ComponentDefine()
  local icon_path = "icon"
  local title_text_path = "titleText"
  local name_text_path = "nameText"
  local select_img_path = "selectImg"
  local click_btn_path = "clickBtn"
  self.icon = self:AddComponent(UIImage, icon_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.select_img = self:AddComponent(UIImage, select_img_path)
  self.click_btn = self:AddComponent(UIButton, click_btn_path)
  self.click_btn:SetOnClick(BindCallback(self, self.OnClick))
end

function UIFishEatFishCell:ComponentDestroy()
  self.icon = nil
  self.title_text = nil
  self.name_text = nil
  self.select_img = nil
  self.click_btn = nil
end

function UIFishEatFishCell:DataDefine()
end

function UIFishEatFishCell:DataDestroy()
end

function UIFishEatFishCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFishEatFishCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFishEatFishCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FishEatClickFish, self.OnClickEvt)
  self:AddUIListener(EventId.RefreshMyFishList, self.OnRefresh)
end

function UIFishEatFishCell:OnRemoveListener()
  self:RemoveUIListener(EventId.FishEatClickFish, self.OnClickEvt)
  self:RemoveUIListener(EventId.RefreshMyFishList, self.OnRefresh)
  base.OnRemoveListener(self)
end

function UIFishEatFishCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function UIFishEatFishCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UIFishEatFishCell:InitUi()
  self.title_text:SetLocalText(self.Data.Fish.name)
  self.icon:LoadSpriteAsync(self.Data.Fish.use_png)
  self.select_img:SetActive(false)
  self:UpdateCount()
end

function UIFishEatFishCell:UpdateCount()
  self.Count = DataCenter.FishingDataManager:GetMyFishNum(self.Data.Fish.id)
  self.name_text:SetLocalText("s6_use_fish_remaining_title", self.Count)
end

function UIFishEatFishCell:UpdateData()
end

function UIFishEatFishCell:UpdateUi()
end

function UIFishEatFishCell:OnClick()
  if self.Data ~= nil and self.Data.Fish ~= nil then
    EventManager:GetInstance():Broadcast(EventId.FishEatClickFish, self.Data.Fish)
  end
end

function UIFishEatFishCell:OnClickEvt(evt)
  if self.Data ~= nil and self.Data.Fish ~= nil and evt ~= nil then
    self.select_img:SetActive(checknumber(evt.id) == checknumber(self.Data.Fish.id))
  end
end

function UIFishEatFishCell:OnRefresh(evt)
  self:UpdateCount()
end

return UIFishEatFishCell
