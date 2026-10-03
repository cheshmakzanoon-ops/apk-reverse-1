local LWUIMigrationView_PersonalContent = BaseClass("LWUIMigrationView_PersonalContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local PItem = require("UI.LWUIMigration.Score.Component.LWUIMigrationView_PersonalItem")
local PCostItem = require("UI.LWUIMigration.Score.Component.LWUIMigrationView_PersonalCostItem")
local content_path = "ScrollView/Viewport/content"
local head_path = "ScrollView/Viewport/content/Top/Di/Head"
local text_point_path = "ScrollView/Viewport/content/Top/Point/PointText"
local my_point_btn_path = "ScrollView/Viewport/content/Top/Point/MyPointBtn"
local img_rating_path = "ScrollView/Viewport/content/Top/Rating/RatingIcon"
local text_rating_path = "ScrollView/Viewport/content/Top/Rating/RatingText"
local img_cost_path = "ScrollView/Viewport/content/Top/Cost/CostIcon"
local text_cost_path = "ScrollView/Viewport/content/Top/Cost/CostText"
local bottom_path = "ScrollView/Viewport/content/Bottom"
local item_cost_path = "ScrollView/Viewport/content/Bottom/Item"
local text_desc_path = "ScrollView/Viewport/content/DescText"

function LWUIMigrationView_PersonalContent:OnCreate()
  base.OnCreate(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.head = self:AddComponent(UICommonHead, head_path)
  self.text_point = self:AddComponent(UIText, text_point_path)
  self.my_point_btn = self:AddComponent(UIButton, my_point_btn_path)
  self.my_point_btn:SetOnClick(function()
    local strTip = string.GetFormattedSeparatorNum(self.myScore)
    UIUtil.ShowBubbleTipsAuto(strTip, self.my_point_btn.transform.position, 0, -30, 0, nil, nil)
  end)
  self.img_rating = self:AddComponent(UIImage, img_rating_path)
  self.btn_rating = self:AddComponent(UIButton, img_rating_path)
  self.btn_rating:SetOnClick(BindCallback(self, self.OnBtnRatingClick))
  self.text_rating = self:AddComponent(UIText, text_rating_path)
  self.img_cost = self:AddComponent(UIImage, img_cost_path)
  local iconPath = DataCenter.ActMigrationManager:GetItemIcon()
  if iconPath then
    self.img_cost:LoadSpriteAuto(iconPath)
  end
  self.text_cost = self:AddComponent(UIText, text_cost_path)
  self.bottom = self:AddComponent(UIBaseContainer, bottom_path)
  self.item_cost = self.transform:Find(item_cost_path).gameObject
  self.item_cost:GameObjectCreatePool()
  self.text_desc = self:AddComponent(UIText, text_desc_path)
  local keyStr = DataCenter.ActMigrationManager:GetSeasonTips(1)
  if not string.IsNullOrEmpty(keyStr) then
    self.text_desc:SetLocalText(keyStr)
  end
end

function LWUIMigrationView_PersonalContent:OnDestroy()
  self:ClearList()
  self.bottom:RemoveComponents(PCostItem)
  for _, v in ipairs(self.bottom.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.item_cost:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function LWUIMigrationView_PersonalContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationScoreInfoUpdate, self.UpdateData)
end

function LWUIMigrationView_PersonalContent:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationScoreInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function LWUIMigrationView_PersonalContent:OnBtnRatingClick()
  local strTip = Localization:GetString("migration_activity_tips_20040")
  UIUtil.ShowBubbleTips(strTip, self.btn_rating.transform.position, 0, -30, 0, nil, nil)
end

function LWUIMigrationView_PersonalContent:SetData()
  self.content:SetAnchoredPositionXY(0, 0)
  self:UpdateTop()
  self:UpdateBottom()
  self.text_desc.transform:SetAsLastSibling()
end

function LWUIMigrationView_PersonalContent:ClearList()
  if self.cellReqs then
    self.content:RemoveComponents(PItem)
    for k, v in pairs(self.cellReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellReqs = {}
  self.cells = {}
end

function LWUIMigrationView_PersonalContent:UpdateData()
end

function LWUIMigrationView_PersonalContent:UpdateTop()
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  local headSkinPath = LuaEntry.Player:GetHeadBgImg()
  self.head:SetData(uid, pic, picVer, nil, headSkinPath)
  local mgr = DataCenter.ActMigrationManager
  local myInfo = mgr:GetMyInfo()
  local migrated = myInfo ~= nil and myInfo.migrated or 0
  local identity = myInfo ~= nil and myInfo.identity or 0
  local imgPath = mgr:GetPlayerTypeImg(identity)
  self.img_rating:LoadSpriteAuto(imgPath)
  local score = myInfo ~= nil and myInfo.score or 0
  self.myScore = score
  self.text_point:SetText(string.GetFormattedStr(score))
  local pInfo = mgr:GetMyPersonStandard()
  local nameKey = pInfo ~= nil and pInfo.name or ""
  self.text_rating:SetLocalText(nameKey)
  local costNum = pInfo ~= nil and pInfo.cost or 0
  if migrated == 1 then
    costNum = 0
  end
  self.text_cost:SetText("\195\151" .. costNum)
end

function LWUIMigrationView_PersonalContent:UpdateBottom()
  local actInfo = DataCenter.ActMigrationManager:GetActInfo()
  local colorList = actInfo ~= nil and actInfo.colorList or {}
  local configs = DataCenter.ActMigrationManager:GetPersonStandard()
  local cnt = #configs
  local bTF = self.bottom.transform
  for i = 1, cnt do
    local name = "item" .. i
    local item = self.bottom:GetComponent(name, PCostItem)
    local sInfo = configs[i]
    local cell = bTF:Find(name)
    item = self.bottom:GetComponent(name, PCostItem)
    if cell == nil then
      cell = self.item_cost:GameObjectSpawn(bTF)
      cell.name = name
    end
    if item == nil then
      item = self.bottom:AddComponent(PCostItem, name)
    end
    item:SetActive(true)
    item:SetData(sInfo, i, self.myScore, colorList)
  end
  bTF:SetAsLastSibling()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bottom.rectTransform)
end

return LWUIMigrationView_PersonalContent
