-- ╔══════════════════════════════════════════════╗
-- ║           Da7muUI  v2.0                      ║
-- ║   Lucide Icons · Rounded Shadow · Glass UI   ║
-- ╚══════════════════════════════════════════════╝

local Da7muUI   = {}
Da7muUI.__index = Da7muUI

-- ─── Services ──────────────────────────────────
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer

-- ══════════════════════════════════════════════
--  LUCIDE ICON MAP  (name → rbxassetid)
--  Add more IDs from your own uploads or packs.
-- ══════════════════════════════════════════════
local Icons = {
    -- General
    ["home"]          = "rbxassetid://11293981586",
    ["settings"]      = "rbxassetid://11293981580",
    ["search"]        = "rbxassetid://11293981578",
    ["menu"]          = "rbxassetid://11293981572",
    ["x"]             = "rbxassetid://11293981560",
    ["check"]         = "rbxassetid://11293981550",
    ["plus"]          = "rbxassetid://11293981544",
    ["minus"]         = "rbxassetid://11293981540",
    ["trash"]         = "rbxassetid://11293981530",
    ["edit"]          = "rbxassetid://11293981524",
    ["save"]          = "rbxassetid://11293981520",
    ["copy"]          = "rbxassetid://11293981514",
    ["download"]      = "rbxassetid://11293981508",
    ["upload"]        = "rbxassetid://11293981502",
    ["refresh"]       = "rbxassetid://11293981496",
    ["lock"]          = "rbxassetid://11293981490",
    ["unlock"]        = "rbxassetid://11293981484",
    ["eye"]           = "rbxassetid://11293981478",
    ["eye-off"]       = "rbxassetid://11293981472",
    -- People / Social
    ["user"]          = "rbxassetid://11293981460",
    ["users"]         = "rbxassetid://11293981454",
    ["user-plus"]     = "rbxassetid://11293981448",
    -- Navigation
    ["chevron-down"]  = "rbxassetid://11293981440",
    ["chevron-up"]    = "rbxassetid://11293981434",
    ["chevron-right"] = "rbxassetid://11293981428",
    ["arrow-left"]    = "rbxassetid://11293981420",
    ["arrow-right"]   = "rbxassetid://11293981414",
    -- Gameplay
    ["sword"]         = "rbxassetid://11293981400",
    ["shield"]        = "rbxassetid://11293981394",
    ["zap"]           = "rbxassetid://11293981388",
    ["star"]          = "rbxassetid://11293981382",
    ["heart"]         = "rbxassetid://11293981376",
    ["target"]        = "rbxassetid://11293981370",
    ["crosshair"]     = "rbxassetid://11293981364",
    ["activity"]      = "rbxassetid://11293981358",
    ["trending-up"]   = "rbxassetid://11293981352",
    ["cpu"]           = "rbxassetid://11293981346",
    ["layers"]        = "rbxassetid://11293981340",
    ["sliders"]       = "rbxassetid://11293981334",
    ["toggle-left"]   = "rbxassetid://11293981328",
    ["map"]           = "rbxassetid://11293981322",
    ["compass"]       = "rbxassetid://11293981316",
    ["globe"]         = "rbxassetid://11293981310",
    -- Info
    ["info"]          = "rbxassetid://11293981304",
    ["alert-circle"]  = "rbxassetid://11293981298",
    ["alert-triangle"]= "rbxassetid://11293981292",
    ["bell"]          = "rbxassetid://11293981286",
    -- Misc
    ["package"]       = "rbxassetid://11293981280",
    ["box"]           = "rbxassetid://11293981274",
    ["folder"]        = "rbxassetid://11293981268",
    ["terminal"]      = "rbxassetid://11293981262",
    ["code"]          = "rbxassetid://11293981256",
    ["wrench"]        = "rbxassetid://11293981250",
    ["hammer"]        = "rbxassetid://11293981244",
    ["flame"]         = "rbxassetid://11293981238",
    ["leaf"]          = "rbxassetid://11293981232",
    ["sun"]           = "rbxassetid://11293981226",
    ["moon"]          = "rbxassetid://11293981220",
    ["cloud"]         = "rbxassetid://11293981214",
    ["music"]         = "rbxassetid://11293981208",
    ["volume-2"]      = "rbxassetid://11293981202",
    ["layout"]        = "rbxassetid://11293981196",
    ["grid"]          = "rbxassetid://11293981190",
    ["list"]          = "rbxassetid://11293981184",
}

-- Returns an asset ID string: pass either an icon name like "settings"
-- or a direct "rbxassetid://XXXX". Falls back to a generic icon.
local function ResolveIcon(name)
    if not name or name == "" then return nil end
    if name:find("rbxassetid://") then return name end
    return Icons[name:lower()] or "rbxassetid://11293981580" -- fallback = settings cog
end

-- ══════════════════════════════════════════════
--  DEFAULT THEME
-- ══════════════════════════════════════════════
local Themes = {}

local function AddTheme(t) Themes[t.Name] = t end

AddTheme({
    Name        = "Default",
    -- Window
    Background  = Color3.fromRGB(13, 13, 17),
    WindowBg    = Color3.fromRGB(18, 18, 24),
    -- Sidebar
    Sidebar     = Color3.fromRGB(13, 13, 17),
    SidebarItem = Color3.fromRGB(255,255,255),
    SidebarActive = Color3.fromRGB(62, 133, 255),
    SidebarActiveBg = Color3.fromRGB(62, 133, 255),
    SidebarCategory = Color3.fromRGB(85, 85, 110),
    -- Content
    Dialog      = Color3.fromRGB(22, 22, 30),
    ItemBg      = Color3.fromRGB(28, 28, 38),
    -- Accent / Interactive
    Accent      = Color3.fromRGB(62, 133, 255),
    AccentHover = Color3.fromRGB(82, 153, 255),
    -- Text
    Text        = Color3.fromRGB(235, 235, 245),
    TextDim     = Color3.fromRGB(140, 140, 165),
    TextMuted   = Color3.fromRGB(80, 80, 105),
    -- Borders
    Border      = Color3.fromRGB(40, 40, 58),
    BorderLight = Color3.fromRGB(55, 55, 75),
    -- Elements
    Toggle      = Color3.fromRGB(45, 45, 62),
    ToggleOn    = Color3.fromRGB(62, 133, 255),
    SliderTrack = Color3.fromRGB(35, 35, 50),
    SliderFill  = Color3.fromRGB(62, 133, 255),
    Button      = Color3.fromRGB(35, 35, 50),
    ButtonHover = Color3.fromRGB(45, 45, 65),
    -- Notification
    NotifyBg    = Color3.fromRGB(22, 22, 30),
    NotifyAccent = Color3.fromRGB(62, 133, 255),
})

function Da7muUI:AddTheme(t) AddTheme(t) end

-- ══════════════════════════════════════════════
--  UTILITIES
-- ══════════════════════════════════════════════
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.22, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function New(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do pcall(function() o[k] = v end) end
    if parent then o.Parent = parent end
    return o
end

local function Corner(p, r)
    New("UICorner", {CornerRadius = UDim.new(0, r or 8)}, p)
end

local function Padding(p, t, b, l, r)
    New("UIPadding", {
        PaddingTop    = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft   = UDim.new(0, l or 0),
        PaddingRight  = UDim.new(0, r or 0),
    }, p)
end

local function Divider(parent, zIndex)
    New("Frame", {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 58),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = zIndex or 13,
    }, parent)
end

-- ─── Rounded layered shadow (no square edges) ──
local function RoundedShadow(parent, radius)
    local r = radius or 14
    -- Three expanding shadow layers, same border radius as window
    local offsets = {
        {size = 20, trans = 0.80, offset = 4},
        {size = 34, trans = 0.88, offset = 7},
        {size = 52, trans = 0.93, offset = 10},
    }
    for _, s in ipairs(offsets) do
        local f = New("Frame", {
            AnchorPoint            = Vector2.new(0.5, 0.5),
            Position               = UDim2.new(0.5, 0, 0.5, s.offset),
            Size                   = UDim2.new(1, s.size, 1, s.size),
            BackgroundColor3       = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = s.trans,
            BorderSizePixel        = 0,
            ZIndex                 = parent.ZIndex - 1,
        }, parent)
        Corner(f, r + math.floor(s.size / 3))
    end
end

-- ─── Frosted glass layer (local, no BlurEffect) ─
local function FrostedGlass(parent, zIndex)
    -- Dark semi-transparent fill
    local glass = New("Frame", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundColor3       = Color3.fromRGB(8, 8, 12),
        BackgroundTransparency = 0.12,
        BorderSizePixel        = 0,
        ZIndex                 = zIndex or (parent.ZIndex),
    }, parent)
    Corner(glass, 14)
    -- Subtle bright top sheen
    local sheen = New("Frame", {
        Size                   = UDim2.new(1, 0, 0, 1),
        Position               = UDim2.new(0, 0, 0, 0),
        BackgroundColor3       = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.88,
        BorderSizePixel        = 0,
        ZIndex                 = (zIndex or parent.ZIndex) + 1,
    }, parent)
    Corner(sheen, 14)
    return glass
end

-- ─── Draggable ─────────────────────────────────
local function Draggable(handle, target)
    local drag, sPos, sObjPos = false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; sPos = i.Position; sObjPos = target.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - sPos
            target.Position = UDim2.new(sObjPos.X.Scale, sObjPos.X.Offset + d.X, sObjPos.Y.Scale, sObjPos.Y.Offset + d.Y)
        end
    end)
end

-- ─── Icon Image ────────────────────────────────
local function IconImg(iconName, size, parent, zIndex, color)
    local id = ResolveIcon(iconName)
    if not id then return end
    return New("ImageLabel", {
        Size                   = UDim2.new(0, size or 16, 0, size or 16),
        BackgroundTransparency = 1,
        Image                  = id,
        ImageColor3            = color or Color3.fromRGB(255,255,255),
        ScaleType              = Enum.ScaleType.Fit,
        ZIndex                 = zIndex or 12,
    }, parent)
end

-- ══════════════════════════════════════════════
--  CREATE WINDOW
-- ══════════════════════════════════════════════
function Da7muUI:CreateWindow(cfg)
    local theme  = Themes[cfg.Theme or "Default"] or Themes["Default"]
    local W      = cfg.Size and cfg.Size.X.Offset or 580
    local H      = cfg.Size and cfg.Size.Y.Offset or 460
    local sideW  = cfg.SideBarWidth or 190
    local title  = cfg.Title or "Da7muUI"
    local TOPBAR = 50

    -- ── ScreenGui ─────────────────────────────
    local Gui = New("ScreenGui", {
        Name           = "Da7muUI_" .. title,
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 999,
    })
    pcall(function() Gui.Parent = game:GetService("CoreGui") end)
    if not Gui.Parent then Gui.Parent = LocalPlayer.PlayerGui end

    -- ── Window (NO full-screen blur — frosted glass only) ──
    local Main = New("Frame", {
        Name                   = "Window",
        AnchorPoint            = Vector2.new(0.5, 0.5),
        Position               = UDim2.new(0.5, 0, 0.5, 0),
        Size                   = UDim2.new(0, W, 0, H),
        BackgroundColor3       = theme.Background,
        BackgroundTransparency = 0,
        BorderSizePixel        = 0,
        ZIndex                 = 10,
        ClipsDescendants       = true,
    }, Gui)
    Corner(Main, 14)
    RoundedShadow(Main, 14)
    FrostedGlass(Main, 9) -- behind everything inside

    -- Thin border
    New("UIStroke", {
        Color        = theme.Border,
        Thickness    = 1,
        Transparency = 0,
    }, Main)

    -- ── Top Bar ───────────────────────────────
    local TopBar = New("Frame", {
        Name                   = "TopBar",
        Size                   = UDim2.new(1, 0, 0, TOPBAR),
        BackgroundColor3       = theme.Background,
        BackgroundTransparency = 0,
        BorderSizePixel        = 0,
        ZIndex                 = 11,
    }, Main)

    -- Title / Icon group
    local TitleGroup = New("Frame", {
        Position               = UDim2.new(0, 14, 0, 0),
        Size                   = UDim2.new(0, 220, 1, 0),
        BackgroundTransparency = 1,
        ZIndex                 = 12,
    }, TopBar)

    if cfg.Icon and cfg.Icon ~= "" then
        local iconId = ResolveIcon(cfg.Icon) or cfg.Icon
        New("ImageLabel", {
            Size                   = UDim2.new(0, cfg.IconSize or 22, 0, cfg.IconSize or 22),
            AnchorPoint            = Vector2.new(0, 0.5),
            Position               = UDim2.new(0, 0, 0.5, 0),
            BackgroundTransparency = 1,
            Image                  = iconId,
            ZIndex                 = 13,
        }, TitleGroup)
    end

    local iconOff = cfg.Icon and ((cfg.IconSize or 22) + 10) or 0
    New("TextLabel", {
        Text               = title,
        Font               = Enum.Font.GothamBold,
        TextSize           = 14,
        TextColor3         = theme.Text,
        BackgroundTransparency = 1,
        Position           = UDim2.new(0, iconOff, 0, 0),
        Size               = UDim2.new(1, -iconOff, 0.6, 0),
        TextXAlignment     = Enum.TextXAlignment.Left,
        ZIndex             = 13,
    }, TitleGroup)

    if cfg.Author then
        New("TextLabel", {
            Text               = cfg.Author,
            Font               = Enum.Font.Gotham,
            TextSize           = 10,
            TextColor3         = theme.TextMuted,
            BackgroundTransparency = 1,
            Position           = UDim2.new(0, iconOff, 0.55, 0),
            Size               = UDim2.new(1, -iconOff, 0.45, 0),
            TextXAlignment     = Enum.TextXAlignment.Left,
            ZIndex             = 13,
        }, TitleGroup)
    end

    -- Window controls (top right)
    local function CtrlBtn(text, xOffset, textColor, hoverColor)
        local b = New("TextButton", {
            Text               = text,
            Font               = Enum.Font.GothamBold,
            TextSize           = 12,
            TextColor3         = textColor or theme.TextDim,
            BackgroundTransparency = 1,
            Position           = UDim2.new(1, xOffset, 0.5, 0),
            AnchorPoint        = Vector2.new(0, 0.5),
            Size               = UDim2.new(0, 28, 0, 28),
            ZIndex             = 13,
        }, TopBar)
        b.MouseEnter:Connect(function() Tween(b,{TextColor3 = hoverColor or theme.Text},0.1) end)
        b.MouseLeave:Connect(function() Tween(b,{TextColor3 = textColor or theme.TextDim},0.1) end)
        return b
    end

    local CloseBtn = CtrlBtn("✕", -32, Color3.fromRGB(220,70,70), Color3.fromRGB(255,100,100))
    local MinBtn   = CtrlBtn("—", -62, theme.TextDim, theme.Text)

    -- Bottom border of topbar
    New("Frame", {
        Position               = UDim2.new(0, 0, 1, -1),
        Size                   = UDim2.new(1, 0, 0, 1),
        BackgroundColor3       = theme.Border,
        BackgroundTransparency = 0,
        BorderSizePixel        = 0,
        ZIndex                 = 12,
    }, TopBar)

    Draggable(TopBar, Main)

    -- Close / Minimise logic
    local minimised = false
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {BackgroundTransparency = 1, Size = UDim2.new(0,W,0,0)}, 0.3, Enum.EasingStyle.Quart)
        task.delay(0.32, function() Gui:Destroy() end)
    end)
    MinBtn.MouseButton1Click:Connect(function()
        minimised = not minimised
        Tween(Main, {Size = minimised and UDim2.new(0,W,0,TOPBAR) or UDim2.new(0,W,0,H)}, 0.28)
    end)

    -- ── Sidebar ───────────────────────────────
    local Sidebar = New("Frame", {
        Name                   = "Sidebar",
        Position               = UDim2.new(0, 0, 0, TOPBAR),
        Size                   = UDim2.new(0, sideW, 1, -TOPBAR),
        BackgroundColor3       = theme.Sidebar,
        BackgroundTransparency = 0,
        BorderSizePixel        = 0,
        ZIndex                 = 11,
        ClipsDescendants       = true,
    }, Main)

    -- Right border of sidebar
    New("Frame", {
        Position           = UDim2.new(1, -1, 0, 0),
        Size               = UDim2.new(0, 1, 1, 0),
        BackgroundColor3   = theme.Border,
        BackgroundTransparency = 0,
        BorderSizePixel    = 0,
        ZIndex             = 12,
    }, Sidebar)

    local SidebarScroll = New("ScrollingFrame", {
        Size                   = UDim2.new(1, 0, 1, -50), -- leave room for user panel
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        ScrollBarThickness     = 0,
        ZIndex                 = 12,
        AutomaticCanvasSize    = Enum.AutomaticSize.Y,
        CanvasSize             = UDim2.new(0,0,0,0),
    }, Sidebar)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding       = UDim.new(0, 2),
        SortOrder     = Enum.SortOrder.LayoutOrder,
    }, SidebarScroll)
    Padding(SidebarScroll, 10, 0, 10, 10)

    -- ── User panel at bottom of sidebar ───────
    local UserPanel = New("Frame", {
        Position               = UDim2.new(0, 0, 1, -50),
        Size                   = UDim2.new(1, 0, 0, 50),
        BackgroundColor3       = Color3.fromRGB(11, 11, 15),
        BackgroundTransparency = 0,
        BorderSizePixel        = 0,
        ZIndex                 = 12,
    }, Sidebar)

    New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = theme.Border,
        BorderSizePixel = 0,
        ZIndex = 13,
    }, UserPanel)

    if cfg.User and cfg.User.Enabled then
        local player = LocalPlayer
        local usrAvatar = New("ImageLabel", {
            Size               = UDim2.new(0, 32, 0, 32),
            Position           = UDim2.new(0, 12, 0.5, 0),
            AnchorPoint        = Vector2.new(0, 0.5),
            BackgroundColor3   = theme.Border,
            Image              = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=48&height=48&format=png",
            ZIndex             = 13,
        }, UserPanel)
        Corner(usrAvatar, 16)

        local usrName = cfg.User.Anonymous and "Anonymous" or player.DisplayName
        New("TextLabel", {
            Text           = usrName,
            Font           = Enum.Font.GothamBold,
            TextSize       = 12,
            TextColor3     = theme.Text,
            BackgroundTransparency = 1,
            Position       = UDim2.new(0, 52, 0, 8),
            Size           = UDim2.new(1, -64, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex         = 13,
        }, UserPanel)
        New("TextLabel", {
            Text           = cfg.User.Anonymous and "Hidden" or "@"..player.Name,
            Font           = Enum.Font.Gotham,
            TextSize       = 10,
            TextColor3     = theme.TextMuted,
            BackgroundTransparency = 1,
            Position       = UDim2.new(0, 52, 0, 26),
            Size           = UDim2.new(1, -64, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex         = 13,
        }, UserPanel)

        if cfg.User.Callback then
            New("TextButton", {
                Text = "", BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0), ZIndex = 14
            }, UserPanel).MouseButton1Click:Connect(cfg.User.Callback)
        end
    end

    -- ── Content Area ──────────────────────────
    local ContentArea = New("Frame", {
        Name                   = "Content",
        Position               = UDim2.new(0, sideW, 0, TOPBAR),
        Size                   = UDim2.new(1, -sideW, 1, -TOPBAR),
        BackgroundColor3       = theme.WindowBg,
        BackgroundTransparency = 0,
        BorderSizePixel        = 0,
        ZIndex                 = 11,
    }, Main)

    -- ── Animate in ────────────────────────────
    Main.Size     = UDim2.new(0, W, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.52, 0)
    Tween(Main, {
        Size     = UDim2.new(0, W, 0, H),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- ════════════════════════════════════════
    --  Window Object
    -- ════════════════════════════════════════
    local WindowObj = {}
    local Tabs      = {}
    local ActiveTab = nil

    -- ── Add sidebar category label ────────────
    function WindowObj:AddCategory(name)
        New("TextLabel", {
            Text               = name:upper(),
            Font               = Enum.Font.GothamBold,
            TextSize           = 9,
            TextColor3         = theme.SidebarCategory,
            BackgroundTransparency = 1,
            Size               = UDim2.new(1, -10, 0, 22),
            TextXAlignment     = Enum.TextXAlignment.Left,
            ZIndex             = 12,
            LayoutOrder        = #Tabs * 100 + 1,
        }, SidebarScroll)
    end

    -- ── AddTab ────────────────────────────────
    function WindowObj:AddTab(tabCfg)
        local tabName = tabCfg.Name or "Tab"
        local iconId  = ResolveIcon(tabCfg.Icon)

        -- Page
        local Page = New("ScrollingFrame", {
            Name                   = "Page_"..tabName,
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            ScrollBarThickness     = 3,
            ScrollBarImageColor3   = theme.Accent,
            Visible                = false,
            ZIndex                 = 12,
            AutomaticCanvasSize    = Enum.AutomaticSize.Y,
            CanvasSize             = UDim2.new(0,0,0,0),
        }, ContentArea)
        New("UIListLayout", {FillDirection=Enum.FillDirection.Vertical, Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder}, Page)
        Padding(Page, 14, 14, 14, 14)

        -- Sidebar button
        local TabBtn = New("Frame", {
            Name               = "Tab_"..tabName,
            Size               = UDim2.new(1, -10, 0, 34),
            BackgroundColor3   = theme.SidebarActiveBg,
            BackgroundTransparency = 1,
            BorderSizePixel    = 0,
            ZIndex             = 12,
            LayoutOrder        = #Tabs + 1,
        }, SidebarScroll)
        Corner(TabBtn, 7)

        -- Left accent pill (hidden by default)
        local AccentPill = New("Frame", {
            Size               = UDim2.new(0, 3, 0.5, 0),
            Position           = UDim2.new(0, 0, 0.25, 0),
            BackgroundColor3   = theme.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel    = 0,
            ZIndex             = 14,
        }, TabBtn)
        Corner(AccentPill, 2)

        -- Icon
        if iconId then
            New("ImageLabel", {
                Size               = UDim2.new(0, 15, 0, 15),
                Position           = UDim2.new(0, 13, 0.5, 0),
                AnchorPoint        = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Image              = iconId,
                ImageColor3        = theme.TextDim,
                ZIndex             = 13,
            }, TabBtn)
        end

        local labelX = iconId and 34 or 13
        local TabLabel = New("TextLabel", {
            Text               = tabName,
            Font               = Enum.Font.Gotham,
            TextSize           = 13,
            TextColor3         = theme.TextDim,
            BackgroundTransparency = 1,
            Position           = UDim2.new(0, labelX, 0, 0),
            Size               = UDim2.new(1, -labelX-4, 1, 0),
            TextXAlignment     = Enum.TextXAlignment.Left,
            ZIndex             = 13,
        }, TabBtn)

        -- Invisible click area
        local ClickArea = New("TextButton", {
            Text = "", BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0), ZIndex=15
        }, TabBtn)

        local function SelectTab()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                Tween(t.Btn, {BackgroundTransparency = 1}, 0.15)
                Tween(t.Label, {TextColor3 = theme.TextDim, Font = Enum.Font.Gotham}, 0.15)
                Tween(t.Pill, {BackgroundTransparency = 1}, 0.15)
                if t.Icon then Tween(t.Icon, {ImageColor3 = theme.TextDim}, 0.15) end
            end
            Page.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0.88}, 0.15)
            Tween(TabLabel, {TextColor3 = theme.Text, Font = Enum.Font.GothamBold}, 0.15)
            Tween(AccentPill, {BackgroundTransparency = 0}, 0.15)
            local iconImg = TabBtn:FindFirstChildOfClass("ImageLabel")
            if iconImg then Tween(iconImg, {ImageColor3 = theme.Accent}, 0.15) end
            ActiveTab = tabName
        end

        ClickArea.MouseButton1Click:Connect(SelectTab)
        ClickArea.MouseEnter:Connect(function()
            if ActiveTab ~= tabName then Tween(TabBtn, {BackgroundTransparency = 0.94}, 0.1) end
        end)
        ClickArea.MouseLeave:Connect(function()
            if ActiveTab ~= tabName then Tween(TabBtn, {BackgroundTransparency = 1}, 0.1) end
        end)

        local iconImg = TabBtn:FindFirstChildOfClass("ImageLabel")
        table.insert(Tabs, {Page=Page, Btn=TabBtn, Label=TabLabel, Pill=AccentPill, Icon=iconImg})
        if #Tabs == 1 then SelectTab() end

        -- ── Tab Object ──────────────────────────
        local TabObj = {}

        -- ── AddSection ──────────────────────────
        function TabObj:AddSection(secCfg)
            local secName = secCfg.Name

            if secName and secName ~= "" then
                New("TextLabel", {
                    Text               = secName:upper(),
                    Font               = Enum.Font.GothamBold,
                    TextSize           = 9,
                    TextColor3         = theme.TextMuted,
                    BackgroundTransparency = 1,
                    Size               = UDim2.new(1, 0, 0, 18),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    ZIndex             = 13,
                }, Page)
            end

            local SecFrame = New("Frame", {
                Size               = UDim2.new(1, 0, 0, 0),
                AutomaticSize      = Enum.AutomaticSize.Y,
                BackgroundColor3   = theme.Dialog,
                BackgroundTransparency = 0,
                BorderSizePixel    = 0,
                ZIndex             = 12,
            }, Page)
            Corner(SecFrame, 8)
            New("UIStroke", {Color=theme.Border, Thickness=1, Transparency=0}, SecFrame)
            New("UIListLayout", {FillDirection=Enum.FillDirection.Vertical, Padding=UDim.new(0,0), SortOrder=Enum.SortOrder.LayoutOrder}, SecFrame)

            -- helper to add a standard row container
            local rowCount = 0
            local function Row(h)
                rowCount = rowCount + 1
                local r = New("Frame", {
                    Size               = UDim2.new(1, 0, 0, h or 42),
                    BackgroundTransparency = 1,
                    BorderSizePixel    = 0,
                    ZIndex             = 13,
                    LayoutOrder        = rowCount,
                }, SecFrame)
                Padding(r, 0, 0, 16, 16)
                -- separator line (not on first row)
                if rowCount > 1 then
                    local sep = New("Frame", {
                        Size               = UDim2.new(1, -32, 0, 1),
                        Position           = UDim2.new(0, 16, 0, 0),
                        BackgroundColor3   = theme.Border,
                        BackgroundTransparency = 0,
                        BorderSizePixel    = 0,
                        ZIndex             = 13,
                    }, r)
                end
                return r
            end

            local SectionObj = {}

            -- ── AddToggle ────────────────────────
            function SectionObj:AddToggle(cfg2)
                local state = cfg2.Default or false
                local r = Row(42)

                -- Label + description
                New("TextLabel", {
                    Text               = cfg2.Name or "Toggle",
                    Font               = Enum.Font.Gotham,
                    TextSize           = 13,
                    TextColor3         = theme.Text,
                    BackgroundTransparency = 1,
                    Position           = UDim2.new(0, 0, 0, cfg2.Description and 7 or 0),
                    Size               = UDim2.new(1, -58, 0, cfg2.Description and 17 or 42),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    ZIndex             = 14,
                }, r)
                if cfg2.Description then
                    New("TextLabel", {
                        Text               = cfg2.Description,
                        Font               = Enum.Font.Gotham,
                        TextSize           = 10,
                        TextColor3         = theme.TextMuted,
                        BackgroundTransparency = 1,
                        Position           = UDim2.new(0, 0, 0, 26),
                        Size               = UDim2.new(1, -58, 0, 14),
                        TextXAlignment     = Enum.TextXAlignment.Left,
                        ZIndex             = 14,
                    }, r)
                end

                -- Track
                local Track = New("Frame", {
                    Position           = UDim2.new(1, -44, 0.5, 0),
                    AnchorPoint        = Vector2.new(0, 0.5),
                    Size               = UDim2.new(0, 36, 0, 20),
                    BackgroundColor3   = state and theme.ToggleOn or theme.Toggle,
                    BorderSizePixel    = 0,
                    ZIndex             = 14,
                }, r)
                Corner(Track, 10)
                New("UIStroke",{Color=theme.Border,Thickness=1,Transparency=0},Track)

                local Knob = New("Frame", {
                    Position           = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    AnchorPoint        = Vector2.new(0, 0.5),
                    Size               = UDim2.new(0, 16, 0, 16),
                    BackgroundColor3   = Color3.fromRGB(255,255,255),
                    BorderSizePixel    = 0,
                    ZIndex             = 15,
                }, Track)
                Corner(Knob, 8)

                New("TextButton", {
                    Text="", BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), ZIndex=16
                }, r).MouseButton1Click:Connect(function()
                    state = not state
                    Tween(Track, {BackgroundColor3 = state and theme.ToggleOn or theme.Toggle}, 0.2)
                    Tween(Knob, {Position = state and UDim2.new(1,-18,0.5,0) or UDim2.new(0,2,0.5,0)}, 0.2)
                    if cfg2.Callback then cfg2.Callback(state) end
                end)

                local obj = {}
                function obj:Set(v)
                    state = v
                    Tween(Track,{BackgroundColor3=v and theme.ToggleOn or theme.Toggle},0.2)
                    Tween(Knob,{Position=v and UDim2.new(1,-18,0.5,0) or UDim2.new(0,2,0.5,0)},0.2)
                    if cfg2.Callback then cfg2.Callback(v) end
                end
                function obj:Get() return state end
                return obj
            end

            -- ── AddSlider ────────────────────────
            function SectionObj:AddSlider(cfg2)
                local min  = cfg2.Min or 0
                local max  = cfg2.Max or 100
                local step = cfg2.Step or 1
                local val  = math.clamp(cfg2.Default or min, min, max)
                local r    = Row(48)

                New("TextLabel", {
                    Text               = cfg2.Name or "Slider",
                    Font               = Enum.Font.Gotham,
                    TextSize           = 13,
                    TextColor3         = theme.Text,
                    BackgroundTransparency = 1,
                    Position           = UDim2.new(0,0,0,6),
                    Size               = UDim2.new(0.7,0,0,16),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    ZIndex             = 14,
                }, r)

                local ValLbl = New("TextLabel", {
                    Text               = tostring(val),
                    Font               = Enum.Font.GothamBold,
                    TextSize           = 12,
                    TextColor3         = theme.TextDim,
                    BackgroundTransparency = 1,
                    Position           = UDim2.new(0.7,0,0,6),
                    Size               = UDim2.new(0.3,0,0,16),
                    TextXAlignment     = Enum.TextXAlignment.Right,
                    ZIndex             = 14,
                }, r)

                local Track = New("Frame", {
                    Position           = UDim2.new(0,0,0,28),
                    Size               = UDim2.new(1,0,0,6),
                    BackgroundColor3   = theme.SliderTrack,
                    BorderSizePixel    = 0,
                    ZIndex             = 14,
                }, r)
                Corner(Track, 3)

                local pct0 = (val-min)/(max-min)
                local Fill = New("Frame", {
                    Size               = UDim2.new(pct0, 0, 1, 0),
                    BackgroundColor3   = theme.SliderFill,
                    BorderSizePixel    = 0,
                    ZIndex             = 15,
                }, Track)
                Corner(Fill, 3)

                local Knob = New("Frame", {
                    Position           = UDim2.new(pct0, 0, 0.5, 0),
                    AnchorPoint        = Vector2.new(0.5, 0.5),
                    Size               = UDim2.new(0, 14, 0, 14),
                    BackgroundColor3   = Color3.fromRGB(255,255,255),
                    BorderSizePixel    = 0,
                    ZIndex             = 16,
                }, Track)
                Corner(Knob, 7)

                local sliding = false
                local function Update(input)
                    local rx = math.clamp((input.Position.X - Track.AbsolutePosition.X)/Track.AbsoluteSize.X, 0, 1)
                    val = math.clamp(math.round((min + rx*(max-min))/step)*step, min, max)
                    local p = (val-min)/(max-min)
                    Fill.Size = UDim2.new(p,0,1,0)
                    Knob.Position = UDim2.new(p,0,0.5,0)
                    ValLbl.Text = tostring(val)
                    if cfg2.Callback then cfg2.Callback(val) end
                end

                Track.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true; Update(i) end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then Update(i) end
                end)

                local obj = {}
                function obj:Set(v)
                    val=math.clamp(math.round(v/step)*step,min,max)
                    local p=(val-min)/(max-min)
                    Fill.Size=UDim2.new(p,0,1,0)
                    Knob.Position=UDim2.new(p,0,0.5,0)
                    ValLbl.Text=tostring(val)
                end
                function obj:Get() return val end
                return obj
            end

            -- ── AddButton ────────────────────────
            function SectionObj:AddButton(cfg2)
                local r = Row(38)

                local Btn = New("TextButton", {
                    Text               = cfg2.Name or "Button",
                    Font               = Enum.Font.GothamBold,
                    TextSize           = 13,
                    TextColor3         = theme.Text,
                    BackgroundColor3   = theme.Button,
                    BackgroundTransparency = 0,
                    Size               = UDim2.new(1, 0, 0, 28),
                    Position           = UDim2.new(0,0,0.5,0),
                    AnchorPoint        = Vector2.new(0,0.5),
                    BorderSizePixel    = 0,
                    ZIndex             = 14,
                }, r)
                Corner(Btn, 6)
                New("UIStroke",{Color=theme.Border,Thickness=1,Transparency=0},Btn)

                Btn.MouseButton1Click:Connect(function()
                    Tween(Btn,{BackgroundColor3=theme.Accent},0.08)
                    Tween(Btn,{TextColor3=Color3.fromRGB(255,255,255)},0.08)
                    task.delay(0.15,function()
                        Tween(Btn,{BackgroundColor3=theme.Button},0.2)
                        Tween(Btn,{TextColor3=theme.Text},0.2)
                    end)
                    if cfg2.Callback then cfg2.Callback() end
                end)
                Btn.MouseEnter:Connect(function() Tween(Btn,{BackgroundColor3=theme.ButtonHover},0.1) end)
                Btn.MouseLeave:Connect(function() Tween(Btn,{BackgroundColor3=theme.Button},0.1) end)

                local obj = {}
                function obj:SetText(t) Btn.Text=t end
                return obj
            end

            -- ── AddDropdown ──────────────────────
            function SectionObj:AddDropdown(cfg2)
                local opts     = cfg2.Options or {}
                local selected = cfg2.Default
                local open     = false
                local r        = Row(42)

                New("TextLabel", {
                    Text               = cfg2.Name or "Dropdown",
                    Font               = Enum.Font.Gotham,
                    TextSize           = 13,
                    TextColor3         = theme.Text,
                    BackgroundTransparency = 1,
                    Position           = UDim2.new(0,0,0,0),
                    Size               = UDim2.new(0.5,0,1,0),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    ZIndex             = 14,
                }, r)

                local HFrame = New("Frame", {
                    Position           = UDim2.new(0.5,0,0.5,0),
                    AnchorPoint        = Vector2.new(0,0.5),
                    Size               = UDim2.new(0.5,0,0,28),
                    BackgroundColor3   = theme.ItemBg,
                    BorderSizePixel    = 0,
                    ZIndex             = 14,
                }, r)
                Corner(HFrame,6)
                New("UIStroke",{Color=theme.Border,Thickness=1,Transparency=0},HFrame)

                local SelLbl = New("TextLabel", {
                    Text               = selected or cfg2.Placeholder or "Select...",
                    Font               = Enum.Font.Gotham,
                    TextSize           = 12,
                    TextColor3         = selected and theme.Text or theme.TextMuted,
                    BackgroundTransparency = 1,
                    Position           = UDim2.new(0,8,0,0),
                    Size               = UDim2.new(1,-26,1,0),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    ZIndex             = 15,
                }, HFrame)

                local ChevronImg = IconImg("chevron-down", 12, HFrame, 15, theme.TextMuted)
                if ChevronImg then
                    ChevronImg.Position = UDim2.new(1,-20,0.5,0)
                    ChevronImg.AnchorPoint = Vector2.new(0,0.5)
                end

                -- Dropdown list (lives in the Page, positioned absolutely)
                local ListFrame = New("Frame", {
                    Size               = UDim2.new(0, 0, 0, math.min(#opts,5)*30+8),
                    BackgroundColor3   = theme.Dialog,
                    BorderSizePixel    = 0,
                    Visible            = false,
                    ZIndex             = 50,
                    ClipsDescendants   = true,
                }, Gui) -- attach to ScreenGui for proper z-ordering
                Corner(ListFrame,7)
                New("UIStroke",{Color=theme.Border,Thickness=1,Transparency=0},ListFrame)
                New("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},ListFrame)
                Padding(ListFrame,4,4,4,4)

                for _, opt in ipairs(opts) do
                    local OBtn = New("TextButton", {
                        Text               = opt,
                        Font               = Enum.Font.Gotham,
                        TextSize           = 12,
                        TextColor3         = theme.Text,
                        BackgroundTransparency = 1,
                        Size               = UDim2.new(1,0,0,26),
                        TextXAlignment     = Enum.TextXAlignment.Left,
                        ZIndex             = 51,
                    }, ListFrame)
                    Corner(OBtn,5)
                    Padding(OBtn,0,0,10,0)
                    OBtn.MouseEnter:Connect(function() Tween(OBtn,{BackgroundTransparency=0.7,BackgroundColor3=theme.ItemBg},0.1) end)
                    OBtn.MouseLeave:Connect(function() Tween(OBtn,{BackgroundTransparency=1},0.1) end)
                    OBtn.MouseButton1Click:Connect(function()
                        selected=opt; SelLbl.Text=opt; SelLbl.TextColor3=theme.Text
                        open=false; ListFrame.Visible=false
                        if ChevronImg then Tween(ChevronImg,{Rotation=0},0.15) end
                        if cfg2.Callback then cfg2.Callback(opt) end
                    end)
                end

                New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=16},HFrame)
                    .MouseButton1Click:Connect(function()
                        open=not open
                        if open then
                            local absPos = HFrame.AbsolutePosition
                            local absSize = HFrame.AbsoluteSize
                            ListFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
                            ListFrame.Size     = UDim2.new(0, absSize.X, 0, math.min(#opts,5)*30+8)
                        end
                        ListFrame.Visible = open
                        if ChevronImg then Tween(ChevronImg,{Rotation=open and 180 or 0},0.15) end
                    end)

                local obj={}
                function obj:Set(v) selected=v; SelLbl.Text=v; SelLbl.TextColor3=theme.Text end
                function obj:Get() return selected end
                return obj
            end

            -- ── AddTextBox ───────────────────────
            function SectionObj:AddTextBox(cfg2)
                local r = Row(42)
                New("TextLabel", {
                    Text               = cfg2.Name or "Input",
                    Font               = Enum.Font.Gotham,
                    TextSize           = 13,
                    TextColor3         = theme.Text,
                    BackgroundTransparency = 1,
                    Position           = UDim2.new(0,0,0,0),
                    Size               = UDim2.new(0.45,0,1,0),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    ZIndex             = 14,
                }, r)
                local Box = New("TextBox", {
                    PlaceholderText    = cfg2.Placeholder or "",
                    Text               = cfg2.Default or "",
                    Font               = Enum.Font.Gotham,
                    TextSize           = 12,
                    TextColor3         = theme.Text,
                    PlaceholderColor3  = theme.TextMuted,
                    BackgroundColor3   = theme.ItemBg,
                    BackgroundTransparency = 0,
                    Position           = UDim2.new(0.45,0,0.5,0),
                    AnchorPoint        = Vector2.new(0,0.5),
                    Size               = UDim2.new(0.55,0,0,26),
                    ClearTextOnFocus   = cfg2.ClearOnFocus~=false,
                    BorderSizePixel    = 0,
                    ZIndex             = 14,
                }, r)
                Corner(Box,6)
                New("UIStroke",{Color=theme.Border,Thickness=1,Transparency=0},Box)
                Padding(Box,0,0,8,0)
                Box.Focused:Connect(function() Tween(Box:FindFirstChildWhichIsA("UIStroke"),{Color=theme.Accent},0.15) end)
                Box.FocusLost:Connect(function(enter)
                    Tween(Box:FindFirstChildWhichIsA("UIStroke"),{Color=theme.Border},0.15)
                    if cfg2.Callback then cfg2.Callback(Box.Text, enter) end
                end)
                local obj={} function obj:Get() return Box.Text end function obj:Set(v) Box.Text=v end
                return obj
            end

            -- ── AddLabel ─────────────────────────
            function SectionObj:AddLabel(cfg2)
                local r = Row(32)
                New("TextLabel", {
                    Text               = cfg2.Text or "",
                    Font               = Enum.Font.Gotham,
                    TextSize           = 12,
                    TextColor3         = cfg2.Color or theme.TextDim,
                    BackgroundTransparency = 1,
                    Size               = UDim2.new(1,0,1,0),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    TextWrapped        = true,
                    ZIndex             = 14,
                }, r)
            end

            -- ── AddKeybind ───────────────────────
            function SectionObj:AddKeybind(cfg2)
                local key = cfg2.Default or Enum.KeyCode.Unknown
                local listening = false
                local r = Row(42)

                New("TextLabel", {
                    Text               = cfg2.Name or "Keybind",
                    Font               = Enum.Font.Gotham,
                    TextSize           = 13,
                    TextColor3         = theme.Text,
                    BackgroundTransparency = 1,
                    Size               = UDim2.new(0.6,0,1,0),
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    ZIndex             = 14,
                }, r)

                local KeyBtn = New("TextButton", {
                    Text               = "["..key.Name.."]",
                    Font               = Enum.Font.GothamBold,
                    TextSize           = 11,
                    TextColor3         = theme.Accent,
                    BackgroundColor3   = theme.ItemBg,
                    BackgroundTransparency = 0,
                    Position           = UDim2.new(0.6,0,0.5,0),
                    AnchorPoint        = Vector2.new(0,0.5),
                    Size               = UDim2.new(0.4,0,0,24),
                    ZIndex             = 14,
                }, r)
                Corner(KeyBtn,6)
                New("UIStroke",{Color=theme.Border,Thickness=1,Transparency=0},KeyBtn)

                KeyBtn.MouseButton1Click:Connect(function()
                    listening=true; KeyBtn.Text="..."; KeyBtn.TextColor3=theme.TextMuted
                end)
                UserInputService.InputBegan:Connect(function(i,gpe)
                    if listening and i.UserInputType==Enum.UserInputType.Keyboard then
                        key=i.KeyCode; KeyBtn.Text="["..key.Name.."]"; KeyBtn.TextColor3=theme.Accent
                        listening=false
                        if cfg2.Callback then cfg2.Callback(key) end
                    end
                end)

                local obj={} function obj:Get() return key end
                return obj
            end

            return SectionObj
        end -- AddSection

        return TabObj
    end -- AddTab

    -- ── Notify ──────────────────────────────
    function WindowObj:Notify(cfg2)
        local dur = cfg2.Duration or 4
        local NFrame = New("Frame", {
            Name                   = "Notif",
            AnchorPoint            = Vector2.new(1,1),
            Position               = UDim2.new(1, 20, 1, -16),
            Size                   = UDim2.new(0, 280, 0, 72),
            BackgroundColor3       = theme.NotifyBg,
            BackgroundTransparency = 0,
            BorderSizePixel        = 0,
            ZIndex                 = 200,
        }, Gui)
        Corner(NFrame,10)
        New("UIStroke",{Color=theme.Border,Thickness=1,Transparency=0},NFrame)
        RoundedShadow(NFrame, 10)

        -- Accent top border
        New("Frame", {
            Size=UDim2.new(0,3,0.6,0), Position=UDim2.new(0,0,0.2,0),
            BackgroundColor3=theme.NotifyAccent, BorderSizePixel=0, ZIndex=201
        }, NFrame)

        -- Icon
        local iconId = ResolveIcon(cfg2.Icon or "bell")
        if iconId then
            New("ImageLabel",{
                Size=UDim2.new(0,18,0,18), Position=UDim2.new(0,14,0,10),
                BackgroundTransparency=1, Image=iconId,
                ImageColor3=theme.NotifyAccent, ZIndex=201
            },NFrame)
        end

        New("TextLabel",{
            Text=cfg2.Title or "Notice",
            Font=Enum.Font.GothamBold, TextSize=13,
            TextColor3=theme.Text, BackgroundTransparency=1,
            Position=UDim2.new(0,38,0,8), Size=UDim2.new(1,-50,0,18),
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=201
        },NFrame)
        New("TextLabel",{
            Text=cfg2.Message or "",
            Font=Enum.Font.Gotham, TextSize=11,
            TextColor3=theme.TextDim, BackgroundTransparency=1,
            Position=UDim2.new(0,14,0,30), Size=UDim2.new(1,-28,0,34),
            TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, ZIndex=201
        },NFrame)

        -- Progress bar
        local PBar = New("Frame",{
            Position=UDim2.new(0,0,1,-3), Size=UDim2.new(1,0,0,3),
            BackgroundColor3=theme.NotifyAccent, BackgroundTransparency=0,
            BorderSizePixel=0, ZIndex=202
        },NFrame)
        Corner(PBar,2)
        Tween(PBar,{Size=UDim2.new(0,0,0,3)},dur,Enum.EasingStyle.Linear)

        Tween(NFrame,{Position=UDim2.new(1,-16,1,-16)},0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        task.delay(dur,function()
            Tween(NFrame,{Position=UDim2.new(1,300,1,-16),BackgroundTransparency=1},0.3)
            task.delay(0.35,function() NFrame:Destroy() end)
        end)
    end

    function WindowObj:Destroy()
        Tween(Main,{Size=UDim2.new(0,W,0,0),BackgroundTransparency=1},0.3)
        task.delay(0.32,function() Gui:Destroy() end)
    end

    return WindowObj
end

return Da7muUI
