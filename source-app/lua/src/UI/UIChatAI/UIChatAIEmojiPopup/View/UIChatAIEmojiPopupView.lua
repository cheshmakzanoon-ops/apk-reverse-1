local base = UIBaseView
local UIChatAIEmojiPopupView = BaseClass("UIChatAIEmojiPopupView", UIBaseView)
local UnityImage = typeof(CS.UnityEngine.UI.Image)

function UIChatAIEmojiPopupView:OnCreate()
  base.OnCreate(self)
  self.close_btn = self:AddComponent(UIButton, "Panel")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.emojiPopupPanel = self:AddComponent(UIBaseContainer, "Popup")
  self.emojiPopupContainer = self:AddComponent(UIBaseContainer, "Popup/Viewport/Content")
  self.emojiPopupCellBtn = self:AddComponent(UIButton, "PopupCell")
  self.emojiCellCache = self.emojiPopupCellBtn.gameObject
  self.emojiCellCache:GameObjectCreatePool()
end

function UIChatAIEmojiPopupView:Init()
  local param = self:GetUserData()
  local alignObject = param.alignObject
  local emoji_array = param.emoji_array
  self._param = param
  self.emojiPopupContainer:RemoveComponents(UIButton)
  self.emojiCellCache:GameObjectRecycleAll()
  for index, v in ipairs(emoji_array) do
    local nameStr = "Item" .. index
    local item = self.emojiCellCache:GameObjectSpawn(self.emojiPopupContainer.transform)
    item.name = nameStr
    item:SetActive(true)
    local theEmojiCellImage = item:GetComponent(UnityImage)
    if theEmojiCellImage ~= nil then
      theEmojiCellImage:LoadSprite(v.path)
    end
    local theEmojiCellBtn = self.emojiPopupContainer:AddComponent(UIButton, nameStr)
    theEmojiCellBtn:SetOnClick(function()
      print("EmojiCell:OnClick => " .. v.path)
      if param.callback then
        param.callback(v.id)
      end
      self.ctrl:CloseSelf()
    end)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.emojiPopupContainer.rectTransform)
  self:CheckAlign(self.emojiPopupPanel, alignObject)
end

function UIChatAIEmojiPopupView:OnEnable()
  self:Init()
end

function UIChatAIEmojiPopupView:CheckAlign(rootObject, alignObject)
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local scale = ScreenWidth / DefaultScreenWidth
  local _rect = rootObject.rectTransform.rect
  local align_pos = alignObject.transform.position
  local BgHeight = _rect.height * scale
  local _screenPos = PosConverse.UIWorldToScreenPos(align_pos)
  local pivot = Vector2.New(0, 0)
  local offset_x = 17 * scale
  local offset_y = 0
  if _screenPos.y - BgHeight < 100 then
    pivot.y = 0
    offset_y = -17 * scale
  else
    pivot.y = 1
    offset_y = 17 * scale
  end
  rootObject.rectTransform.pivot = pivot
  rootObject:SetPositionXYZ(align_pos.x + offset_x, align_pos.y + offset_y, align_pos.z)
end

function UIChatAIEmojiPopupView:OnDestroy()
  self.emojiPopupContainer:RemoveComponents(UIButton)
  for _, v in ipairs(self.emojiPopupContainer.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.close_btn = nil
  self.emojiPopupPanel = nil
  self.emojiPopupContainer = nil
  self.emojiPopupCellBtn = nil
  self.emojiCellCache = nil
  base.OnDestroy(self)
end

return UIChatAIEmojiPopupView
