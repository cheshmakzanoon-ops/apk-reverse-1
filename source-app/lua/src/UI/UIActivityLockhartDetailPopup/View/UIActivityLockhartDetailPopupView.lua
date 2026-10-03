local UIActivityLockhartDetailPopupView = BaseClass("UIActivityLockhartDetailPopupView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local sub_title1_path = "PopUpTitle/Common_bg_orange2/Content/SubTitle1"
local sub_desc1_path = "PopUpTitle/Common_bg_orange2/Content/SubDesc1"
local content1_path = "PopUpTitle/Common_bg_orange2/Content/List1/Scroll View/Viewport/Content1"
local sub_title2_path = "PopUpTitle/Common_bg_orange2/Content/SubTitle2"
local sub_desc2_path = "PopUpTitle/Common_bg_orange2/Content/SubDesc2"
local content2_path = "PopUpTitle/Common_bg_orange2/Content/List2/Scroll View/Viewport/Content2"

function UIActivityLockhartDetailPopupView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function UIActivityLockhartDetailPopupView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActivityLockhartDetailPopupView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, panel_path)
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.titleText:SetLocalText(self.param.title or 2000047)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.sub_title1 = self:AddComponent(UIText, sub_title1_path)
  self.sub_desc1 = self:AddComponent(UITextMeshProUGUIEx, sub_desc1_path)
  self.sub_title2 = self:AddComponent(UIText, sub_title2_path)
  self.sub_desc2 = self:AddComponent(UIText, sub_desc2_path)
  self.content1 = self:AddComponent(UIBaseContainer, content1_path)
  self.content2 = self:AddComponent(UIBaseContainer, content2_path)
  self.theCellItem = self.transform:Find("ItemCell").gameObject
  self.theCellItem:GameObjectCreatePool()
  self.sub_title1:SetLocalText("2010106")
  self.sub_desc1:SetLocalText("activity_luoha_tips_01")
  self.sub_title2:SetLocalText("2010107")
  local mgr = DataCenter.ActivityListDataManager
  local kill_boss_count = mgr:GetExtraData(KILL_LOCK_HART_BOSS, 0)
  local countLimit = LuaEntry.DataConfig:TryGetNum("assembly_monster_toplimit", "k4") or 20
  if CommonUtil.IsArabic() then
    self.sub_desc2:SetLocalText("2010108", "<color=#f53c3d>" .. kill_boss_count .. "/" .. countLimit .. "</color>")
  else
    self.sub_desc2:SetLocalText("2010108", "<color=#f53c3d>" .. kill_boss_count .. "</color>/" .. countLimit)
  end
  if self.param ~= nil then
    local activityData = self.param.activityData
    if activityData ~= nil then
      self:parseGift(self.content1, activityData.extra1)
      self:parseGift(self.content2, activityData.extra2)
    end
  end
end

function UIActivityLockhartDetailPopupView:ComponentDestroy()
  self.content1:RemoveComponents(UICommonResItem)
  self.content2:RemoveComponents(UICommonResItem)
  self.theCellItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content1.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  for _, v in ipairs(self.content2.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.btnPanel = nil
  self.titleText = nil
  self.closeBtn = nil
end

function UIActivityLockhartDetailPopupView:parseGift(content, extra)
  local goItem, theItem
  local extra_items = extra or ""
  content:RemoveComponents(UICommonResItem)
  for item in string.gmatch(extra_items, "([^|]+)|?") do
    if item ~= nil and item ~= "" then
      local itemId, num = string.match(item, "(%d+)[,;](%d+)")
      if itemId ~= nil then
        goItem = self.theCellItem:GameObjectSpawn(content.transform)
        goItem.name = itemId
        goItem:SetActive(true)
        theItem = content:AddComponent(UICommonResItem, itemId)
        theItem:ReInit({
          count = tonumber(num),
          rewardType = RewardType.GOODS,
          itemId = itemId
        })
      end
    end
  end
end

return UIActivityLockhartDetailPopupView
