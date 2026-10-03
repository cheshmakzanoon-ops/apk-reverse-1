local SeasonPhotoOperationItem = BaseClass("SeasonPhotoOperationItem", UIBaseContainer)
local base = UIBaseContainer
local PhotoOperationBtnType = {
  [ChatOperationBtnType.Up] = 1,
  [ChatOperationBtnType.Emoji] = 2
}

function SeasonPhotoOperationItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonPhotoOperationItem:ComponentDefine()
  base.OnCreate(self)
  self.btnComponents = {}
  for i = 1, 2 do
    local pre = "Layout/Btn" .. i
    local go = self:AddComponent(UIBaseContainer, pre)
    local icon = self:AddComponent(UIImage, pre .. "/icon" .. i)
    local text = self:AddComponent(UITextMeshProUGUIEx, pre .. "/text" .. i)
    local btn = self:AddComponent(UIButton, pre .. "/btn" .. i)
    table.insert(self.btnComponents, {
      go = go,
      icon = icon,
      text = text,
      btn = btn
    })
    local index = i
    btn:SetOnClick(function()
      self:OnBtnClick(index)
    end)
  end
end

function SeasonPhotoOperationItem:OnBtnClick(index)
  self.data = self.list[index]
  if not (self.data and self._chatData) or not self._chatData.data then
    return
  end
  if self.data.type == ChatOperationBtnType.Up or self.data.type == ChatOperationBtnType.Emoji then
    local thumbsType = PhotoOperationBtnType[self.data.type]
    if not thumbsType then
      return
    end
    if self._chatData.data:HasThumbsUp(thumbsType) then
      UIUtil.ShowTipsId("season_alliance_photo_tips_33")
    else
      DataCenter.SeasonPhotoManager:SeasonPhotoThumbsUp(self._chatData.season, self._chatData.allianceId, self._chatData.data.uid, self._chatData.data.uuid, thumbsType)
    end
  end
  self.viewCtrl:CloseSelf()
end

function SeasonPhotoOperationItem:UpdateItemData(list, userData, viewCtrl)
  self.list = list
  self._chatData = userData
  for i, v in ipairs(self.btnComponents) do
    local data = self.list[i]
    v.go:SetActive(data ~= nil)
    if data then
      v.icon:LoadSprite(ChatInterface.GetChatUIPath(data.iconPath))
      if data.text then
        v.text:SetLocalText(data.text)
      end
    end
  end
  self.viewCtrl = viewCtrl
end

function SeasonPhotoOperationItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonPhotoOperationItem:DataDestroy()
  self.list = nil
  self._chatData = nil
  self.viewCtrl = nil
end

function SeasonPhotoOperationItem:ComponentDestroy()
  self.btnComponents = {}
end

return SeasonPhotoOperationItem
