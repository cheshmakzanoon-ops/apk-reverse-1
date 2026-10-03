local HelperItemType1 = BaseClass("HelperItemType1", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local BattleHelperUniversalItem = require("UI.UILWMail.UILWMailMain.Component.BattleAIHelperComs.BattleHelperUniversalItem")

function HelperItemType1:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HelperItemType1:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HelperItemType1:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "bg")
  self.state_txt = self:AddComponent(UITextMeshProUGUIEx, "state_txt")
  self.jump_btn = self:AddComponent(UIButton, "jump_btn")
  self.jump_btn:SetOnClick(function()
    if self.adviceInfo then
      self.adviceInfo.extraInfo.jumpFunc()
    end
  end)
  self.jump_btn_icon = self:AddComponent(UIImage, "jump_btn/btn_icon")
  self.slot1 = self:AddComponent(BattleHelperUniversalItem, "slot1")
  self.slot2 = self:AddComponent(BattleHelperUniversalItem, "slot2")
  self.slot3 = self:AddComponent(BattleHelperUniversalItem, "slot3")
  self.slots = {
    self.slot1,
    self.slot2,
    self.slot3
  }
  self.img1 = self:AddComponent(UIImage, "img1")
  self.img2 = self:AddComponent(UIImage, "img2")
  self.img3 = self:AddComponent(UIImage, "img3")
  self.img4 = self:AddComponent(UIImage, "img4")
  self.img5 = self:AddComponent(UIImage, "img5")
  self.img7 = self:AddComponent(UIImage, "img7")
end

function HelperItemType1:ComponentDestroy()
  self.bg = nil
  self.state_txt = nil
  self.jump_btn = nil
  self.jump_btn_icon = nil
  self.slot1 = nil
  self.slot2 = nil
  self.slot3 = nil
  self.slots = nil
  self.img1 = nil
  self.img2 = nil
  self.img3 = nil
  self.img4 = nil
  self.img5 = nil
  self.img7 = nil
end

function HelperItemType1:SetData(data)
end

function HelperItemType1:DataDefine()
end

function HelperItemType1:DataDestroy()
  self.adviceInfo = nil
end

function HelperItemType1:OnEnable()
  base.OnEnable(self)
end

function HelperItemType1:OnDisable()
  base.OnDisable(self)
end

function HelperItemType1:OnAddListener()
  base.OnAddListener(self)
end

function HelperItemType1:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HelperItemType1:SetData(adviceInfo)
  local template = adviceInfo.template
  local extraInfo = adviceInfo.extraInfo
  if extraInfo.displayData then
    for i = 1, #self.slots do
      if extraInfo.displayData and extraInfo.displayData[i] then
        self.slots[i]:SetActive(true)
        self.slots[i]:ReInit(extraInfo.displayData[i])
      else
        self.slots[i]:SetActive(false)
      end
    end
  end
  local standardScore = tonumber(template.typePara[1]) or 0
  if standardScore < adviceInfo.score then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_diban_01.png")
    self.state_txt:SetLocalText("report_helper_great", string.format("<color=#FFEA87>%s</color>", Localization:GetString(template.dialog_2)))
    self.state_txt:ChangeNewMaterial("Assets/Main/TMPFont/Main/TitleFontMat/Title-Outline_9D5133_31.mat")
    self.img1:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_huawen_01_01.png")
    self.img2:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_huawen_01_03.png")
    self.img3:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_huawen_01_03.png")
    self.img4:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_jiahao_01.png")
    self.img5:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_jiantou_01.png")
    self.img7:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_huawen_01_02.png")
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_diban_02.png")
    self.state_txt:SetLocalText("report_helper_mild", string.format("<color=#FFEA87>%s</color>", Localization:GetString(template.dialog_2)))
    self.state_txt:ChangeNewMaterial("Assets/Main/TMPFont/Main/TitleFontMat/Title-Outline_285985_31.mat")
    self.img1:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_huawen_02_01.png")
    self.img2:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_huawen_02_03.png")
    self.img3:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_huawen_02_03.png")
    self.img4:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_jiahao_02.png")
    self.img5:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_jiantou_02.png")
    self.img7:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_huawen_02_02.png")
  end
  self.jump_btn:SetActive(extraInfo ~= nil and extraInfo.jumpFunc ~= nil)
  self.adviceInfo = adviceInfo
end

return HelperItemType1
