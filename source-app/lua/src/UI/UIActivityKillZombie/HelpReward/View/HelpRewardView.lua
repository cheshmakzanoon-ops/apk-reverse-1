local UIActivityKillZombieHelpRewardView = BaseClass("UIActivityKillZombieHelpRewardView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local reward_item_path = "PopUpTitle/Common_bg_orange2/RewardItem"
local desc_path = "PopUpTitle/Common_bg_orange2/Content/Desc"
local sub_title11_path = "PopUpTitle/Common_bg_orange2/Content/List1/SubTitle11"
local sub_title12_path = "PopUpTitle/Common_bg_orange2/Content/List1/SubTitle12"
local content1_path = "PopUpTitle/Common_bg_orange2/Content/List1/Scroll View/Viewport/Content1"
local sub_title21_path = "PopUpTitle/Common_bg_orange2/Content/List2/SubTitle21"
local sub_title22_path = "PopUpTitle/Common_bg_orange2/Content/List2/SubTitle22"
local content2_path = "PopUpTitle/Common_bg_orange2/Content/List2/Scroll View/Viewport/Content2"

function UIActivityKillZombieHelpRewardView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function UIActivityKillZombieHelpRewardView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActivityKillZombieHelpRewardView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, panel_path)
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.titleText:SetLocalText(self.param.title or 2000047)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.desc = self:AddComponent(UIText, desc_path)
  self.sub_title11 = self:AddComponent(UIText, sub_title11_path)
  self.sub_title12 = self:AddComponent(UIText, sub_title12_path)
  self.sub_title21 = self:AddComponent(UIText, sub_title21_path)
  self.sub_title22 = self:AddComponent(UIText, sub_title22_path)
  self.content1 = self:AddComponent(UIBaseContainer, content1_path)
  self.content2 = self:AddComponent(UIBaseContainer, content2_path)
  self.theCellItem = self.transform:Find(reward_item_path).gameObject
  self.theCellItem:GameObjectCreatePool()
  self.sub_title11:SetLocalText("2010106")
  self.sub_title12:SetText("\229\143\145\232\181\183\233\155\134\231\187\147: 0 / 20")
  self.sub_title21:SetLocalText("2010107")
  self.sub_title22:SetText("\229\143\130\228\184\142\233\155\134\231\187\147: 0 / 50")
  self.desc:SetText("\230\136\145\230\152\175\230\143\143\232\191\176\n\230\136\145\230\152\175\230\143\143\232\191\176\n\230\136\145\230\152\175\230\143\143\232\191\176\n\230\136\145\230\152\175\230\143\143\232\191\176")
  if self.param ~= nil then
    self:parseGift(self.content1, "15;5;100|230006;7;2|200201;7;20|8001;27;138000|400303;7;17")
    self:parseGift(self.content2, "15;5;100|230006;7;2|200201;7;20|8001;27;138000|400303;7;17")
  end
end

function UIActivityKillZombieHelpRewardView:ComponentDestroy()
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
  self.desc = nil
  self.sub_title11 = nil
  self.sub_title12 = nil
  self.sub_title21 = nil
  self.sub_title22 = nil
  self.content1 = nil
  self.content2 = nil
  self.btnPanel = nil
  self.titleText = nil
  self.closeBtn = nil
end

function UIActivityKillZombieHelpRewardView:parseGift(content, rewardList)
  local goItem, theItem
  local extra_items = rewardList or ""
  content:RemoveComponents(UICommonResItem)
  local extraRewards = DataCenter.RewardManager:ParseRewardsStr(extra_items)
  if extraRewards ~= nil then
    for i, item in ipairs(extraRewards) do
      local levelName = "item_" .. i
      goItem = self.theCellItem:GameObjectSpawn(content.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      theItem = content:AddComponent(UICommonResItem, levelName)
      theItem:ReInit({
        value = item,
        type = item.rewardType
      })
    end
  end
end

return UIActivityKillZombieHelpRewardView
