GiftSystemConst = {}
local RootPath = "Assets/Main/Sprites/UI/LWUIGiftSystem/"
local SpriteRootPath = RootPath
local TextureRootPath = "Assets/Main/TextureEx/LWUIGiftSystem/"
local IconRootPath = SpriteRootPath .. "Icon/"
local UIConfig = {
  zhanshi_pinzhi = {
    "zxl_zhanshi_pinzhi_hui",
    "zyf_zhanshi_pinzhi_lv",
    "zyf_zhanshi_pinzhi_lan",
    "zyf_zhanshi_pinzhi_zi",
    "zxl_zhanshi_pinzhi_cheng",
    "zyf_zhanshi_pinzhi_hong"
  },
  liwu_pinzhi = {
    "zxl_liwu_pinzhi_hui",
    "zxl_liwu_pinzhi_lv",
    "zxl_liwu_pinzhi_lan",
    "zxl_liwu_pinzhi_zi",
    "zxl_liwu_pinzhi_cheng",
    "zxl_liwu_pinzhi_hong"
  },
  liwu_pinzhi_jiao = {
    "zxl_liwu_pinzhi_hui_jiao",
    "zxl_liwu_pinzhi_lv_jiao",
    "zxl_liwu_pinzhi_lan_jiao",
    "zxl_liwu_pinzhi_zi_jiao",
    "zxl_liwu_pinzhi_cheng_jiao",
    "zxl_liwu_pinzhi_hong_jiao"
  },
  liwu_di_bg = {
    "ljq_liwuzhanshi_di02",
    "ljq_liwuzhanshi_di02",
    "ljq_liwuzhanshi_di02",
    "ljq_liwuzhanshi_di02",
    "ljq_liwuzhanshi_di01",
    "ljq_liwuzhanshi_di01"
  },
  giftDiwenAlpha = {
    0.4,
    0.4,
    0.4,
    0.4,
    1,
    1
  },
  liwu_fenxiang_pic = {
    {
      di = "zyf_liwufenxiang_di_hui",
      xing = "zyf_liwufenxiang_aixin_hui"
    },
    {
      di = "zyf_liwufenxiang_di_lv",
      xing = "zyf_liwufenxiang_aixin_lv"
    },
    {
      di = "zyf_liwufenxiang_di_lan",
      xing = "zyf_liwufenxiang_aixin_lan"
    },
    {
      di = "zyf_liwufenxiang_di_zi",
      xing = "zyf_liwufenxiang_aixin_zi"
    },
    {
      di = "zyf_liwufenxiang_di_huang",
      xing = "zyf_liwufenxiang_aixin_cheng"
    },
    {
      di = "zyf_liwufenxiang_di_hong",
      xing = "zyf_liwufenxiang_aixin_hong"
    }
  },
  liwu_fenxiang_public_pic = {
    {
      bg = "zyf_songliwu_diban_zi",
      gift_bg = "zyf_songliwu_guangxiao_zi",
      txt_bg = "zyf_songliwu_qipao_zi",
      head_bg = "zyf_songliwu_touxiangdiban_zi",
      arrow = "zyf_songliwu_touxiangjiantou_zi",
      line = "zyf_songliwu_xian_zi"
    },
    {
      bg = "zyf_songliwu_diban_zi",
      gift_bg = "zyf_songliwu_guangxiao_zi",
      txt_bg = "zyf_songliwu_qipao_zi",
      head_bg = "zyf_songliwu_touxiangdiban_zi",
      arrow = "zyf_songliwu_touxiangjiantou_zi",
      line = "zyf_songliwu_xian_zi"
    },
    {
      bg = "zyf_songliwu_diban_zi",
      gift_bg = "zyf_songliwu_guangxiao_zi",
      txt_bg = "zyf_songliwu_qipao_zi",
      head_bg = "zyf_songliwu_touxiangdiban_zi",
      arrow = "zyf_songliwu_touxiangjiantou_zi",
      line = "zyf_songliwu_xian_zi"
    },
    {
      bg = "zyf_songliwu_diban_zi",
      gift_bg = "zyf_songliwu_guangxiao_zi",
      txt_bg = "zyf_songliwu_qipao_zi",
      head_bg = "zyf_songliwu_touxiangdiban_zi",
      arrow = "zyf_songliwu_touxiangjiantou_zi",
      line = "zyf_songliwu_xian_zi"
    },
    {
      bg = "zyf_songliwu_diban_huang",
      gift_bg = "zyf_songliwu_guangxiao_huang",
      txt_bg = "zyf_songliwu_qipao_huang",
      head_bg = "zyf_songliwu_touxiangdiban_huang",
      arrow = "zyf_songliwu_touxiangjiantou_huang",
      line = "zyf_songliwu_xian_huang"
    },
    {
      bg = "zyf_songliwu_diban_hong",
      gift_bg = "zyf_songliwu_guangxiao_hong",
      txt_bg = "zyf_songliwu_qipao_hong",
      head_bg = "zyf_songliwu_touxiangdiban_hong",
      arrow = "zyf_songliwu_touxiangjiantou_hong",
      line = "zyf_songliwu_xian_hong"
    }
  },
  GiftShowMsgBoardPic = {
    {
      bg = "ljq_liwuzhanshi_01",
      arrow = "ljq_liwuzhanshi_qipao_xia01",
      nameColor = "#f4e6ff"
    },
    {
      bg = "ljq_liwuzhanshi_01",
      arrow = "ljq_liwuzhanshi_qipao_xia01",
      nameColor = "#f4e6ff"
    },
    {
      bg = "ljq_liwuzhanshi_01",
      arrow = "ljq_liwuzhanshi_qipao_xia01",
      nameColor = "#f4e6ff"
    },
    {
      bg = "ljq_liwuzhanshi_01",
      arrow = "ljq_liwuzhanshi_qipao_xia01",
      nameColor = "#f4e6ff"
    },
    {
      bg = "ljq_liwuzhanshi_02",
      arrow = "ljq_liwuzhanshi_qipao_xia02",
      nameColor = "#fff8bd"
    },
    {
      bg = "ljq_liwuzhanshi_02",
      arrow = "ljq_liwuzhanshi_qipao_xia02",
      nameColor = "#fff8bd"
    }
  },
  GiftDetailShowPic = {
    {
      bg = "zyf_lwxq_zi_bg",
      giftBg = "zyf_lwxq_cheng_zi",
      txtColor = "#eb86fe",
      infoBg = "zyf_lwxq_zi_di"
    },
    {
      bg = "zyf_lwxq_zi_bg",
      giftBg = "zyf_lwxq_cheng_zi",
      txtColor = "#eb86fe",
      infoBg = "zyf_lwxq_zi_di"
    },
    {
      bg = "zyf_lwxq_zi_bg",
      giftBg = "zyf_lwxq_cheng_zi",
      txtColor = "#eb86fe",
      infoBg = "zyf_lwxq_zi_di"
    },
    {
      bg = "zyf_lwxq_zi_bg",
      giftBg = "zyf_lwxq_cheng_zi",
      txtColor = "#eb86fe",
      infoBg = "zyf_lwxq_zi_di"
    },
    {
      bg = "zyf_lwxq_cheng_bg",
      giftBg = "zyf_lwxq_cheng_guang",
      txtColor = "#ffe059",
      infoBg = "zyf_lwxq_cheng_di"
    },
    {
      bg = "zyf_lwxq_cheng_bg",
      giftBg = "zyf_lwxq_cheng_guang",
      txtColor = "#ffe059",
      infoBg = "zyf_lwxq_cheng_di"
    }
  }
}
local Size = {
  Small = 1,
  Mid = 2,
  Big = 3
}
local GiftOperationWindowType = {Send = 1, Show = 2}
local PrivilegeUIType = {
  Level = 1,
  Title = 2,
  Content = 3
}
local EmptyIconPath = {
  [GiftShowType.Basics] = "lrb_liwuwei_kong.png",
  [GiftShowType.Edit] = "zxl_kong_tianjia.png"
}

function GiftSystemConst.GetGiftDetailQualityIcon(quality)
  if quality < 1 or quality > #UIConfig.liwu_pinzhi_jiao then
    quality = 1
  end
  return SpriteRootPath .. UIConfig.liwu_pinzhi_jiao[quality]
end

function GiftSystemConst.GetGiftDiwenAlpha(quality)
  if quality < 1 or quality > #UIConfig.liwu_pinzhi_jiao then
    quality = 1
  end
  return UIConfig.giftDiwenAlpha[quality]
end

function GiftSystemConst.GetGiftPostQualityPic(quality)
  if quality < 1 or quality > #UIConfig.liwu_fenxiang_public_pic then
    quality = 1
  end
  local bg = UIConfig.liwu_fenxiang_public_pic[quality].bg
  local gift_bg = UIConfig.liwu_fenxiang_public_pic[quality].gift_bg
  local txt_bg = UIConfig.liwu_fenxiang_public_pic[quality].txt_bg
  local head_bg = UIConfig.liwu_fenxiang_public_pic[quality].head_bg
  local arrow = UIConfig.liwu_fenxiang_public_pic[quality].arrow
  local line = UIConfig.liwu_fenxiang_public_pic[quality].line
  return SpriteRootPath .. bg, SpriteRootPath .. gift_bg, SpriteRootPath .. txt_bg, SpriteRootPath .. head_bg, SpriteRootPath .. arrow, SpriteRootPath .. line
end

function GiftSystemConst.GetChatQualityPicPrivate(quality)
  if quality < 1 or quality > #UIConfig.liwu_fenxiang_pic then
    quality = 1
  end
  return SpriteRootPath .. UIConfig.liwu_fenxiang_pic[quality].di, SpriteRootPath .. UIConfig.liwu_fenxiang_pic[quality].xing
end

function GiftSystemConst.GetGiftDetailShowQualityPic(quality)
  if quality < 1 or quality > #UIConfig.GiftDetailShowPic then
    quality = 1
  end
  local bg = UIConfig.GiftDetailShowPic[quality].bg
  local giftBg = UIConfig.GiftDetailShowPic[quality].giftBg
  local txtColor = UIConfig.GiftDetailShowPic[quality].txtColor
  local infoBg = UIConfig.GiftDetailShowPic[quality].infoBg
  return TextureRootPath .. bg, TextureRootPath .. giftBg, txtColor, SpriteRootPath .. infoBg
end

function GiftSystemConst.GetGiftShowMsgBoardPic(quality)
  if quality < 1 or quality > #UIConfig.GiftShowMsgBoardPic then
    quality = 1
  end
  local bg = UIConfig.GiftShowMsgBoardPic[quality].bg
  local giftBg = UIConfig.GiftShowMsgBoardPic[quality].arrow
  local nameColor = UIConfig.GiftShowMsgBoardPic[quality].nameColor
  return SpriteRootPath .. bg, SpriteRootPath .. giftBg, nameColor
end

function GiftSystemConst.GetPlayerInfoQualityIcon(quality)
  if quality < 1 or quality > #UIConfig.liwu_pinzhi then
    quality = 1
  end
  return SpriteRootPath .. UIConfig.liwu_pinzhi[quality]
end

function GiftSystemConst.GetPlayerInfoQualityBottomBg(quality)
  if quality < 1 or quality > #UIConfig.liwu_di_bg then
    quality = 1
  end
  return SpriteRootPath .. UIConfig.liwu_di_bg[quality]
end

function GiftSystemConst.GetSendGiftQualityIcon(quality)
  if quality < 1 or quality > #UIConfig.zhanshi_pinzhi then
    quality = 1
  end
  return TextureRootPath .. UIConfig.zhanshi_pinzhi[quality]
end

function GiftSystemConst.GetIconPath(iconName)
  return IconRootPath .. tostring(iconName)
end

function GiftSystemConst.GetIconPathNew(iconName)
  return "Assets/Main/Sprites/UI/GiftBigIcon/" .. tostring(iconName)
end

function GiftSystemConst.GetDefaultGiftShowNum()
  return 6
end

local function ParseShowGift(showGift)
  local list = {}
  local t = string.split(showGift, "|")
  for _, v in pairs(t) do
    table.insert(list, string.split(v, ";"))
  end
  return list
end

local function GetEmptyIconPath(showType)
  if EmptyIconPath[showType] == nil then
    return ""
  end
  return SpriteRootPath .. EmptyIconPath[showType]
end

local AnimConfig = {
  qingrenjiehuojian_timeline = {
    Normal = {DisappearDelay = 1.8, DoFadeTime = 0.74},
    Preview = {ResultDelay = 0},
    CameraPath = "camera",
    TimeLinePath = ""
  },
  paocheliwu_timeline = {
    Normal = {DisappearDelay = 1.8, DoFadeTime = 0.74},
    Preview = {ResultDelay = 0},
    CameraPath = "camera",
    TimeLinePath = ""
  },
  liwuxiaohua_01_timeline = {
    Normal = {DisappearDelay = 1.8, DoFadeTime = 0.74},
    Preview = {ResultDelay = 0},
    CameraPath = "camera",
    TimeLinePath = ""
  },
  liwuxiaohua_02_timeline = {
    Normal = {DisappearDelay = 1.8, DoFadeTime = 0.74},
    Preview = {ResultDelay = 0},
    CameraPath = "camera",
    TimeLinePath = ""
  },
  liwuxiaohua_03_timeline = {
    Normal = {DisappearDelay = 1.8, DoFadeTime = 0.74},
    Preview = {ResultDelay = 0},
    CameraPath = "camera",
    TimeLinePath = ""
  },
  liwuxiaohua_04_timeline = {
    Normal = {DisappearDelay = 1.8, DoFadeTime = 0.74},
    Preview = {ResultDelay = 0},
    CameraPath = "camera",
    TimeLinePath = ""
  },
  chengbao_timeline = {
    CameraPath = "A_build_chengbao_camera/cam"
  },
  liwufeiting_timeline = {
    CameraPath = "A_build_yunduanwangzuo_camera/cam"
  },
  kejingduishou_05_Timeline = {CameraPath = "camera05"}
}
local fromType = {
  Default = 0,
  StageFeatureShare = 1,
  LLGroupInvitation = 2
}
GiftSystemConst.GiftSendPanelType = {
  Desert = 1,
  WarZone = 2,
  Canyon = 3,
  Winter = 4
}
GiftSystemConst.CheerEffectConfig = {
  moveDuration = 1.1,
  moveDelay = 0.1,
  scale = 1,
  targetOffsetSmall = 20,
  startOffsetX = 35,
  startOffsetY = 100
}
GiftSystemConst.GiftSendPanelDirection = {
  Up = 1,
  Down = 2,
  Left = 3,
  Right = 4
}
GiftSystemConst.AnimConfig = AnimConfig
GiftSystemConst.WindowType = GiftOperationWindowType
GiftSystemConst.RootPath = RootPath
GiftSystemConst.IconRootPath = IconRootPath
GiftSystemConst.UIConfig = UIConfig
GiftSystemConst.Size = Size
GiftSystemConst.PrivilegeUIType = PrivilegeUIType
GiftSystemConst.ParseShowGift = ParseShowGift
GiftSystemConst.GetEmptyIconPath = GetEmptyIconPath
GiftSystemConst.ShopItemId = 999900
GiftSystemConst.ShopGroupId = 9999001
GiftSystemConst.fromType = fromType
